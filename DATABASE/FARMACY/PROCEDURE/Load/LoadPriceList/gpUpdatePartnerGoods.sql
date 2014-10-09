-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpUpdatePartnerGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdatePartnerGoods(
    IN inId                  Integer   , -- Прайс-лист
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);

     -- Получаем параметры прайсЛиста
     SELECT 
           LoadPriceList.OperDate	 
         , LoadPriceList.JuridicalId INTO vbOperDate, vbJuridicalId
      FROM LoadPriceList WHERE LoadPriceList.Id = inId;

     -- Создаем общие коды, которых еще нет

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), lpInsertUpdate_Object(0, zc_Object_Goods(), CommonCode, ''), zc_Enum_GlobalConst_Marion())
            FROM LoadPriceListItem WHERE LoadPriceListItem.LoadPriceListId = inId
             AND CommonCode NOT IN (SELECT GoodsCodeInt FROM Object_Goods_View WHERE ObjectId = zc_Enum_GlobalConst_Marion())
             AND CommonCode > 0;

     -- Тут мы меняем или добавляем товары в справочник товаров прайс-листа

     PERFORM lpInsertUpdate_Object_Goods(
                     Object_Goods.Id  ,    -- ключ объекта <Товар>
         LoadPriceListItem.GoodsCode  ,    -- Код объекта <Товар>
         LoadPriceListItem.GoodsName  ,    -- Название объекта <Товар>
                                   0  ,    -- группы товаров
                                   0  ,    -- ссылка на единицу измерения
                                   0  ,    -- НДС
                        vbJuridicalId ,    -- Юр лицо или торговая сеть
                             vbUserId , 
                                false )
        FROM LoadPriceListItem
                LEFT JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode, Object_Goods_View.GoodsName 
                            FROM Object_Goods_View 
                           WHERE ObjectId = vbJuridicalId
                        ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
         WHERE LoadPriceListItem.GoodsId <> 0 
           AND LoadPriceListItem.LoadPriceListId  = inId 
           AND COALESCE(Object_Goods.GoodsName, '') <> LoadPriceListItem.GoodsName;

     -- Тут устанавливаем связь между товарами покупателей и главным товаром

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ключ объекта <Условия договора>
                    LoadPriceListItem.GoodsId , -- Главный товар
                              Object_Goods.Id , -- товар из группы
                                    inSession )
       FROM LoadPriceListItem
               JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                FROM Object_Goods_View 
                               WHERE ObjectId = vbJuridicalId
                    ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
          WHERE GoodsId <> 0 AND LoadPriceListItem.LoadPriceListId = inId
           AND (LoadPriceListItem.GoodsId, Object_Goods.Id) NOT IN 
               (SELECT GoodsMainId, GoodsId FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId);
   
      -- Выбираем коды Мориона, у которых нет стыковки с главным 

      PERFORM gpInsertUpdate_Object_LinkGoods(
              0 
            , MainGoodsId -- Главный товар
            , GoodsId      -- Товар для замены
            , inSession                 -- сессия пользователя
            )  
        FROM(
        SELECT DISTINCT 
            LoadPriceListItem.GoodsId AS MainGoodsId 
          , Object_Goods_View.Id AS GoodsId 
        FROM Object_Goods_View 
          JOIN LoadPriceListItem ON LoadPriceListItem.CommonCode = Object_Goods_View.goodscodeInt
                                AND LoadPriceListItem.LoadPriceListId = inId
      
      WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND LoadPriceListItem.GoodsId <> 0
                     
      AND Object_Goods_View.id NOT IN (SELECT goodsid FROM Object_LinkGoods_View WHERE ObjectId = zc_Enum_GlobalConst_Marion())) AS DDD;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.10.14                        *  
 18.09.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
