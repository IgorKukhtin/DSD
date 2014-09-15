-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadPriceList(
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
                     JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId 
                LEFT JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode 
                            FROM Object_Goods_View 
                           WHERE ObjectId = vbJuridicalId
                        ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
         WHERE LoadPriceListItem.GoodsId <> 0 AND LoadPriceList.Id = inId;

     -- Тут устанавливаем связь между товарами покупателей и главным товаром

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ключ объекта <Условия договора>
                    LoadPriceListItem.GoodsId , -- Главный товар
                              Object_Goods.Id , -- Товар для замены
                                    inSession )
       FROM LoadPriceListItem
               JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
               JOIN (SELECT Object_Goods_View.Id, Object_Goods_View.GoodsCode
                                FROM Object_Goods_View 
                               WHERE ObjectId = vbJuridicalId
                    ) AS Object_Goods ON Object_Goods.goodscode = LoadPriceListItem.GoodsCode
          WHERE GoodsId <> 0 AND LoadPriceList.Id = inId
           AND (LoadPriceListItem.GoodsId, Object_Goods.Id) NOT IN 
               (SELECT GoodsMainId, GoodsId FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId AND ObjectMainId IS NULL);


     -- Если прайс за этот день и по юрлицу не найден, то находим. А если найден, то сохраняем ИД
     SELECT
            Movement.Id INTO vbPriceListId
       FROM Movement 
            JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                    ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                   AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
      WHERE Movement.OperDate = vbOperDate AND Movement.DescId = zc_Movement_PriceList()
        AND MovementLinkObject_Juridical.ObjectId = vbJuridicalId;

      IF COALESCE(vbPriceListId, 0) = 0 THEN 
         vbPriceListId := gpInsertUpdate_Movement_PriceList(0, '', vbOperDate, vbJuridicalId, inSession);
      END IF;

     -- Перенос элементов прайса
     PERFORM gpInsertUpdate_MovementItem_PriceList(
                      0 , -- Ключ объекта <Элемент документа>
          vbPriceListId , -- Ключ объекта <Документ>
                GoodsId , -- Товары
                  Price , -- Цена
         ExpirationDate , -- Партия товара
              inSession )
       FROM LoadPriceListItem 
      WHERE GoodsId <> 0 AND LoadPriceListId = inId
        AND GoodsId NOT IN (SELECT ObjectId FROM MovementItem WHERE MovementId = vbPriceListId);

    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.09.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
