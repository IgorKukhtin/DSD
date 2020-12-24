-- Function: lpInsertUpdate_Movement_LoadPriceList_Contract()

/*
select *
, gpInsertUpdate_Object_ImportSettingsItems (ioId := Id, inName := '%EXTERNALPARAM%' , inImportSettingsId := ImportSettingsId, inImportTypeItemsId := ImportTypeItemsId , inDefaultValue := '' ,  inSession := '3')
from gpSelect_Object_ImportSettingsItems(inImportSettingsId := 0 ,  inSession := '3')
where ParamName = 'inAreaId'
*/

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LoadPriceList_Contract (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LoadPriceList_Contract (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LoadPriceList_Contract (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_LoadPriceList_Contract(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inContractId          Integer   , -- Договор
    IN inAreaId              Integer   , -- Регион
    IN inCommonCode          Integer   ,
    IN inBarCode             TVarChar  ,
    IN inCodeUKTZED          TVarChar  ,
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
    DECLARE vbAreaId_find Integer;

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


    -- Проверка что передано таки Регион а не другое ...
    IF COALESCE (inAreaId, 0) <> 0 THEN
       IF (SELECT DescId FROM Object WHERE Id = inAreaId) <> zc_Object_Area() THEN
          RAISE EXCEPTION 'Не правильно передается значение параметра Регион (AreaId)';
       END IF;
    END IF;

    -- Проверка что Регион соответствует Юр лицу
    IF (COALESCE (inAreaId, 0) = 0 AND EXISTS (SELECT 1
                                               FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                    INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                             AND Object_JuridicalArea.isErased = FALSE
                                                    -- INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                    --                       ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                    --                      AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                    --                      AND ObjectLink_JuridicalArea_Area.ChildObjectId > 0

                                               WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                                 AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                              ))
              OR (inAreaId > 0 AND NOT EXISTS (SELECT 1
                                               FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                    INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                             AND Object_JuridicalArea.isErased = FALSE
                                                    INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                                          ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                                         AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                                         AND ObjectLink_JuridicalArea_Area.ChildObjectId = inAreaId

                                               WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                                 AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                              ))
    THEN
        RAISE EXCEPTION 'Ошибка.Для <%>%не правильно передается значение параметра Регион = <%>%Значение должно быть из списка: <%>'
                      , lfGet_Object_ValueData (inJuridicalId)
                      , CHR (13)
                      , lfGet_Object_ValueData (inAreaId)
                      , CHR (13)
                      , (SELECT STRING_AGG (tmp.AreaName, ';')
                         FROM (SELECT COALESCE (Object_Area.ValueData, '') AS AreaName
                               FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                    INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                             AND Object_JuridicalArea.isErased = FALSE
                                    LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                         ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                        AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                    LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_JuridicalArea_Area.ChildObjectId
                               WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                 AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                              ) AS tmp
                        )
                       ;
    END IF;


    -- определяется AreaId - для поиска товара только для Региона
    vbAreaId_find:= CASE WHEN EXISTS (SELECT 1
                                      FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                           INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                                    AND Object_JuridicalArea.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                                 ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id
                                                                AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                                AND ObjectLink_JuridicalArea_Area.ChildObjectId = inAreaId
                                           -- Уникальный код поставщика ТОЛЬКО для Региона
                                           INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                                    ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id
                                                                   AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                                   AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                      WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId
                                        AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                     )
                    THEN inAreaId
                    ELSE 0
               END;

    -- Поиск "шапки" за "сегодня"
    SELECT Id INTO vbLoadPriceListId
    FROM LoadPriceList
    WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE AND COALESCE (ContractId, 0) = inContractId AND COALESCE (AreaId, 0) = COALESCE (inAreaId, 0);

    -- если нет "шапки" - создадим
    IF COALESCE (vbLoadPriceListId, 0) = 0
    THEN
         INSERT INTO LoadPriceList (JuridicalId, ContractId, AreaId, OperDate, NDSinPrice/*, UserId_Insert*/, Date_Insert)
         VALUES (inJuridicalId, inContractId, inAreaId, CURRENT_DATE, inNDSinPrice/*, inUserId*/, CURRENT_TIMESTAMP)
         RETURNING Id INTO vbLoadPriceListId;
    ELSE
         -- иначе запишем что его надо перенести
         UPDATE LoadPriceList SET isMoved = FALSE, Date_Update = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId;
         /*-- иначе в протокол запишем что типа Insert
         UPDATE LoadPriceList SET UserId_Insert = inUserId, Date_Insert = CURRENT_TIMESTAMP WHERE Id = vbLoadPriceListId;*/
    END IF;


    -- Поиск "элемента"
    SELECT Id INTO vbLoadPriceListItemsId FROM LoadPriceListItem WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode;

/*
    -- Ищем по общему коду
    IF COALESCE (vbGoodsId, 0) = 0 AND inCommonCode > 0
    THEN
        SELECT tmpGoods.GoodsId
             , tmpGoods.isSpecCondition
               INTO vbGoodsId, vbIsSpecCondition
        FROM (WITH tmp AS (SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
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
                          )
              SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsId
                   , tmp.isSpecCondition
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
                   LEFT JOIN tmp ON tmp.GoodsId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
              WHERE Object_Goods.ObjectCode = inCommonCode
                AND Object_Goods.DescId = zc_Object_Goods()
             ) AS tmpGoods
             ;

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
*/
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

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                ON ObjectLink_Goods_Area.ObjectId = ObjectString.ObjectId
                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()

      WHERE ObjectString.ValueData = inGoodsCode
        AND ObjectString.DescId    = zc_ObjectString_Goods_Code()
        AND (-- если Регион соответсвует
             COALESCE (ObjectLink_Goods_Area.ChildObjectId, 0) = vbAreaId_find
             -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
          OR (vbAreaId_find = zc_Area_Basis() AND ObjectLink_Goods_Area.ChildObjectId IS NULL)
             -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
          OR (vbAreaId_find = 0 AND ObjectLink_Goods_Area.ChildObjectId = zc_Area_Basis())
            )
      ;
    END IF;
/*
if (inUserId = 3) and inGoodsCode = '664809'
then
RAISE EXCEPTION '<%>', vbGoodsId;
end if;
*/
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
            INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, CodeUKTZED, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, PriceOriginal, ExpirationDate, PackCount, ProducerName)
                                   VALUES (vbLoadPriceListId, inCommonCode, inBarCode, inCodeUKTZED, inGoodsCode, inGoodsName, inGoodsNDS, vbGoodsId, inPrice, vbPriceOriginal, inExpirationDate, inPackCount, inProducerName);
        ELSE
            UPDATE LoadPriceListItem
             SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = inBarCode, CodeUKTZED = inCodeUKTZED, GoodsNDS = inGoodsNDS, GoodsId = vbGoodsId,
                 Price = inPrice, PriceOriginal = vbPriceOriginal, ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
            WHERE Id = vbLoadPriceListItemsId;
        END IF;
    END IF;

   -- Временно обновляем название и поставщика в верхнем регистре
   UPDATE LoadPriceListItem SET GoodsNameUpper = zfCalc_TVarChar_Upper(GoodsName), ProducerNameUpper = zfCalc_TVarChar_Upper(ProducerName)
   WHERE LoadPriceListItem.Id = vbLoadPriceListItemsId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Воробкало А.А.
 11.12.17         * add inCodeUKTZED
 28.03.2017                                                       *
 10.12.2016                                      *
*/
