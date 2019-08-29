-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPriceListLink(Integer, TVarChar);
                        
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPriceListLink(
    IN inPriceListItemId     Integer   ,    -- ключ объекта <Строка загрузки Прайс-Листа>
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserName TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbMainGoodsId Integer;
   DECLARE vbJuridicalId Integer;
   
   DECLARE vbMarionGoodsId Integer;
   DECLARE vbBarCodeGoodsId Integer;
   DECLARE vbPartnerGoodsId Integer;

   DECLARE vbMarionCode Integer;
   DECLARE vbBarCode TVarChar;
   DECLARE vbBarCodeOld TVarChar;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbGoodsCode TVarChar;
   DECLARE vbGoodsId Integer;
   DECLARE vbProducerName TVarChar;
   --DECLARE vbPartnerGoodsId Integer;

   DECLARE vbAreaId_find Integer;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   IF COALESCE(vbObjectId, 0) = 0 THEN
      SELECT ValueData INTO vbUserName FROM Object WHERE Id = vbUserId;
      RAISE EXCEPTION 'У пользователя "%" не установлена торговая сеть', vbUserName;
   END IF;


     -- определяются параметры из прайсЛиста
     WITH tmpArea AS
             (SELECT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                   , ObjectLink_JuridicalArea_Area.ChildObjectId      AS AreaId
              FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                   INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                            AND Object_JuridicalArea.isErased = FALSE
                   INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                         ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                        AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                   -- Уникальный код поставщика ТОЛЬКО для Региона
                   INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                            ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                           AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                           AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
              WHERE ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
             )
     -- Результат             
     SELECT CommonCode, BarCode, GoodsName, GoodsCode, GoodsId, LoadPriceList.JuridicalId, ProducerName, COALESCE (tmpArea.AreaId, 0)
          INTO vbMarionCode, vbBarCode, vbGoodsName, vbGoodsCode, vbMainGoodsId, vbJuridicalId, vbProducerName, vbAreaId_find
     FROM LoadPriceListItem 
          JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
          LEFT JOIN tmpArea ON tmpArea.JuridicalId = LoadPriceList.JuridicalId
                           AND tmpArea.AreaId      = LoadPriceList.AreaId
     WHERE LoadPriceListItem.Id = inPriceListItemId;

    
      -- определяется
      SELECT Object_Goods_View.Id INTO vbGoodsId
      FROM Object_Goods_View 
      WHERE ObjectId = vbJuridicalId AND GoodsCode = vbGoodsCode
        AND (-- если Регион соответсвует
             COALESCE (Object_Goods_View.AreaId, 0) = vbAreaId_find
             -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
          OR (vbAreaId_find = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
             -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
          OR (vbAreaId_find = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
            )
       ;
     
     -- Устанавливаем связь с кодом поставщика
     vbGoodsId:= lpInsertUpdate_Object_Goods(
                           vbGoodsId  ,    -- ключ объекта <Товар>
                         vbGoodsCode  ,    -- Код объекта <Товар>
                         vbGoodsName  ,    -- Название объекта <Товар>
                                   0  ,    -- группы товаров
                                   0  ,    -- ссылка на единицу измерения
                                   0  ,    -- НДС
                        vbJuridicalId ,    -- Юр лицо или торговая сеть
                             vbUserId , 
                                   0  ,
                       vbProducerName ,     
                                FALSE );
     -- еще и Регион
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Area(), vbGoodsId, vbAreaId_find);
    

    IF (SELECT COUNT(*) FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId AND vbMainGoodsId = GoodsMainId AND vbGoodsId = GoodsId) = 0 THEN
        PERFORM
            gpInsertUpdate_Object_LinkGoods(0 , -- ключ объекта 
                                vbMainGoodsId , -- Главный товар
                                    vbGoodsId , -- товар из группы
                                    inSession );
    END IF;                   	 

    IF vbMarionCode > 0 THEN
       -- Устанавливаем связь с кодом Мариона

       SELECT Id INTO vbMarionGoodsId
           FROM Object_Goods_View 
          WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsCodeInt = vbMarionCode;

       IF COALESCE(vbMarionGoodsId, 0) = 0 THEN
           -- Создаем общие коды, которых еще нет
          vbMarionGoodsId := lpInsertUpdate_Object(0, zc_Object_Goods(), CommonCode, vbGoodsName);
          PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbMarionGoodsId, zc_Enum_GlobalConst_Marion());
       END IF;       
             
       IF (SELECT COUNT(*) FROM Object_LinkGoods_View 
               WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsId = vbMarionGoodsId AND GoodsMainId = vbMainGoodsId) = 0 THEN
           PERFORM gpInsertUpdate_Object_LinkGoods(
                0 
              , vbMainGoodsId -- Главный товар
              , vbMarionGoodsId      -- Товар для замены
              , inSession                 -- сессия пользователя
            );
       END IF;     
    END IF;          

    IF vbBarCode <> '' THEN
       SELECT BarCode INTO vbBarCodeOld FROM gpGet_Object_Goods_BarCode (0, vbMainGoodsId, inSession);
       
       IF COALESCE (vbBarCodeOld, '') = ''
       THEN
         
         -- Устанавливаем связь со штрих-кодом
    
         SELECT Id INTO vbBarCodeGoodsId
             FROM Object_Goods_View 
            WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsName = vbBarCode;

         IF COALESCE(vbBarCodeGoodsId, 0) = 0 THEN
            -- Создаем штрих коды, которых еще нет
            vbBarCodeGoodsId := lpInsertUpdate_Object(0, zc_Object_Goods(), 0, vbBarCode);
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbBarCodeGoodsId, zc_Enum_GlobalConst_BarCode());
         END IF;       

         IF (SELECT COUNT(*) FROM Object_LinkGoods_View 
                 WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsId = vbBarCodeGoodsId AND GoodsMainId = vbMainGoodsId) = 0 THEN
             PERFORM gpInsertUpdate_Object_LinkGoods(
                  0 
                , vbMainGoodsId         -- Главный товар
                , vbBarCodeGoodsId      -- Товар для замены
                , inSession             -- сессия пользователя
              );
         END IF;     
       END IF;     
    END IF;          
 
   -- Переносим данные в прайс-лист
   
     PERFORM gpInsertUpdate_MovementItem_PriceList(
             PriceListItem.Id , -- Ключ объекта <Элемент документа>
             LastPriceList_View.MovementId , -- Ключ объекта <Документ>
             vbMainGoodsId , -- Товары
             vbGoodsId , -- Товар прайс-листа
             CASE LoadPriceList.NDSinPrice 
                   WHEN True THEN Price 
                   ELSE Price * (100 + ObjectFloat_NDSKind_NDS.ValueData) / 100 
             END:: TFloat  , -- Цена
             ExpirationDate , -- Партия товара
             inSession )
       
      FROM LoadPriceListItem 
          JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
          JOIN LastPriceList_View ON LastPriceList_View.JuridicalId = LoadPriceList.JuridicalId
                            AND COALESCE(LastPriceList_View.ContractId, 0) = COALESCE(LoadPriceList.ContractId, 0)
          LEFT JOIN MovementItem AS PriceListItem ON PriceListItem.movementid = LastPriceList_View.MovementId  
                                            AND PriceListItem.ObjectId = LoadPriceListItem.GoodsId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = LoadPriceListItem.GoodsId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
               
          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.Childobjectid
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
     WHERE LoadPriceListItem.Id = inPriceListItemId; --CommonCode = 225244 OR BarCode = '8435001020030'


    -- 
    REFRESH MATERIALIZED VIEW MovementItemLastPriceList_View;

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsPriceListLink(Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.14                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
