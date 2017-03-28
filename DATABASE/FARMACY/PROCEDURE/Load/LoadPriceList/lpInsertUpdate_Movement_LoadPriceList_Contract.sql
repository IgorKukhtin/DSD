-- Function: lpInsertUpdate_Movement_LoadPriceList_Contract()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LoadPriceList_Contract
          (Integer, Integer, Integer,
           TVarChar, TVarChar, TVarChar, TVarChar,
           TFloat, TFloat,
           TDateTime,
           TVarChar, TVarChar,
           Boolean,
           Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_LoadPriceList_Contract(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inContractId          Integer   , -- Договор
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice               TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbLoadPriceListId Integer;
    DECLARE vbLoadPriceListItemsId Integer;

    DECLARE vbGoodsId Integer;
    DECLARE vbPriceOriginal TFloat;
    DECLARE vbIsSpecCondition Boolean;
BEGIN
    -- такое не загружаем
    IF COALESCE (inPrice, 0) = 0 THEN 
        RETURN;
    END IF;

  
    -- Проверка что передано таки Договор а не Юр лицо 
    IF COALESCE (inContractId, 0) <> 0 THEN 
       IF (SELECT DescId FROM Object WHERE Id = inContractId) <> zc_Object_Contract() THEN
          RAISE EXCEPTION 'Не правильно передается значение параметра Договор (ContractId)';
       END IF;
    END IF;
  

    -- Поиск "шапки" за "сегодня"
    SELECT Id INTO vbLoadPriceListId
    FROM LoadPriceList
    WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE AND COALESCE (ContractId, 0) = inContractId;

    -- если нет "шапки" - создадим
    IF COALESCE (vbLoadPriceListId, 0) = 0 
    THEN
         INSERT INTO LoadPriceList (JuridicalId, ContractId, OperDate, NDSinPrice/*, UserId_Insert*/, Date_Insert)
         VALUES (inJuridicalId, inContractId, CURRENT_DATE, inNDSinPrice/*, inUserId*/, CURRENT_TIMESTAMP)
         RETURNING Id INTO vbLoadPriceListId;
    ELSE
         -- иначе запишем что его надо перенести
         UPDATE LoadPriceList SET isMoved = FALSE WHERE Id = vbLoadPriceListId;
         /*-- иначе в протокол запишем что типа Insert
         UPDATE LoadPriceList SET UserId_Insert = inUserId, Date_Insert = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId;*/
    END IF;

    -- Поиск "элемента"
    SELECT Id INTO vbLoadPriceListItemsId FROM LoadPriceListItem  WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode;


    -- Ищем по общему коду 
    IF COALESCE (vbGoodsId, 0) = 0 AND inCommonCode > 0
    THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
           , tmp.isSpecCondition
             INTO vbGoodsId, vbIsSpecCondition
      FROM Object AS Object_Goods
           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId      = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_Marion()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                 ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                 ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
             LEFT JOIN (SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
                             , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
                        FROM ObjectLink AS ObjectLink_Goods_Object
                             JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                             ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                            AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                             JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                             ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                            AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                                     ON ObjectBoolean_Goods_SpecCondition.ObjectId = ObjectLink_Goods_Object.ObjectId
                                                    AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
                        WHERE ObjectLink_Goods_Object.ChildObjectId = inJuridicalId
                          AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                       ) AS tmp ON tmp.GoodsId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId

      WHERE Object_Goods.ObjectCode = inCommonCode
        AND Object_Goods.DescId = zc_Object_Goods();

    END IF;
   
    -- Ищем по штрих-коду 
    IF COALESCE (vbGoodsId, 0) = 0 AND inBarCode <> ''
    THEN
      SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
           , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
             INTO vbGoodsId, vbIsSpecCondition
      FROM Object AS Object_Goods
           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId      = Object_Goods.Id
                                AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                 ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                 AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                 ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                     ON ObjectBoolean_Goods_SpecCondition.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
      WHERE Object_Goods.ValueData = inBarCode
        AND Object_Goods.DescId = zc_Object_Goods();
    END IF;

    -- Ищем по коду и inJuridicalId
    IF (COALESCE(vbGoodsId, 0) = 0) THEN
        SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
             , ObjectBoolean_Goods_SpecCondition.ValueData  AS isSpecCondition
               INTO vbGoodsId, vbIsSpecCondition
      FROM ObjectString
           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                 ON ObjectLink_Goods_Object.ObjectId      = ObjectString.ObjectId
                                AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                AND ObjectLink_Goods_Object.ChildObjectId = inJuridicalId
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                 ON ObjectLink_LinkGoods_Goods.ChildObjectId = ObjectString.ObjectId
                                AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
           INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                 ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                AND ObjectLink_LinkGoods_GoodsMain.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                     ON ObjectBoolean_Goods_SpecCondition.ObjectId = ObjectString.ObjectId
                                    AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
      WHERE ObjectString.ValueData = inGoodsCode
        AND ObjectString.DescId = zc_ObjectString_Goods_Code();
    END IF;


    -- !!!замена параметра!!!
    IF inExpirationDate IS NULL OR inExpirationDate = CURRENT_DATE
    THEN 
        inExpirationDate := zc_DateEnd();
    END IF;	

    --!!!проверка!!!
    IF 1 < (SELECT COUNT (*) FROM (SELECT DISTINCT CASE WHEN vbIsSpecCondition = TRUE
                             AND ObjectFloat_ConditionalPercent.ValueData <> 0
                                 THEN CAST (tmp.Price * (1 + ObjectFloat_ConditionalPercent.ValueData / 100) AS NUMERIC (16, 2))
                            ELSE tmp.Price
                       END
                FROM (SELECT inPrice AS Price) AS tmp
                     LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                           ON ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId 
                                          AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()
               ) AS tmp)
    THEN
        RAISE EXCEPTION 'Ошибка с параметрами inJuridicalId = <%> + vbGoodsId = <%>', inJuridicalId, vbGoodsId;
    END IF;

    --!!!важно - запомнили!!!
    vbPriceOriginal:= inPrice;
    --!!!важно - замена!!!
    inPrice:= (SELECT CASE WHEN vbIsSpecCondition = TRUE
                             AND ObjectFloat_ConditionalPercent.ValueData <> 0
                                 THEN CAST (tmp.Price * (1 + ObjectFloat_ConditionalPercent.ValueData / 100) AS NUMERIC (16, 2))
                            ELSE tmp.Price
                       END
                FROM (SELECT inPrice AS Price) AS tmp
                     LEFT JOIN ObjectFloat AS ObjectFloat_ConditionalPercent 
                                           ON ObjectFloat_ConditionalPercent.ObjectId = inJuridicalId 
                                          AND ObjectFloat_ConditionalPercent.DescId = zc_ObjectFloat_Juridical_ConditionalPercent()
               );

    -- для "всех"
    IF COALESCE (inPrice, 0) <> 0 THEN
        -- сохранение "элемента"
        IF COALESCE(vbLoadPriceListItemsId, 0) = 0 THEN
            INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, PriceOriginal, ExpirationDate, PackCount, ProducerName)
                                   VALUES (vbLoadPriceListId, inCommonCode, inBarCode, inGoodsCode, inGoodsName, inGoodsNDS, vbGoodsId, inPrice, vbPriceOriginal, inExpirationDate, inPackCount, inProducerName);
        ELSE
            UPDATE LoadPriceListItem 
             SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = inBarCode, GoodsNDS = inGoodsNDS, GoodsId = vbGoodsId, 
                 Price = inPrice, PriceOriginal = vbPriceOriginal, ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
            WHERE Id = vbLoadPriceListItemsId;
        END IF;
    END IF; 


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Воробкало А.А.
 28.03.2017                                                       *
 10.12.2016                                      *
*/
