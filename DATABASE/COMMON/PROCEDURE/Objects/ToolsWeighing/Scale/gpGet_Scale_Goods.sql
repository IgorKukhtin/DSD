-- Function: gpGet_Scale_Goods()

DROP FUNCTION IF EXISTS gpGet_Scale_Goods (TDateTime, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Scale_Goods (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Goods (Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Goods(
    IN inIsGoodsComplete Boolean      , -- склад ГП/производство/упаковка or обвалка
    IN inBarCode         TVarChar     ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId    Integer
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , GoodsKindId    Integer
             , GoodsKindCode  Integer
             , GoodsKindName  TVarChar
             , GoodsKindId_list TVarChar, GoodsKindName_List TVarChar, GoodsKindId_max Integer, GoodsKindCode_max Integer, GoodsKindName_max TVarChar
             , MeasureId    Integer
             , MeasureCode  Integer
             , MeasureName  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
   -- сразу запомнили время начала выполнения Проц.
   vbOperDate_Begin1:= CLOCK_TIMESTAMP();

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

    --
    CREATE TEMP TABLE _tmpWord_Goods (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindId_max Integer, WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    -- Результат
    RETURN QUERY
       WITH Object_Goods AS (SELECT COALESCE (View_GoodsByGoodsKind.GoodsId, Object.Id)           :: Integer  AS GoodsId
                                  , COALESCE (View_GoodsByGoodsKind.GoodsCode, Object.ObjectCode) :: Integer  AS GoodsCode
                                  , COALESCE (View_GoodsByGoodsKind.GoodsName, Object.ValueData)  :: TVarChar AS GoodsName
                                  , COALESCE (View_GoodsByGoodsKind.GoodsKindId, zc_Enum_GoodsKind_Main())    AS GoodsKindId
                             FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13 - 4)) AS ObjectId WHERE CHAR_LENGTH (inBarCode) >= 13) AS tmp
                                  LEFT JOIN Object ON Object.Id = tmp.ObjectId
                                                  AND Object.DescId IN (zc_Object_Goods(), zc_Object_GoodsByGoodsKind())
                                  LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.Id = Object.Id
                            UNION
                             SELECT Object.Id         AS GoodsId
                                  , Object.ObjectCode AS GoodsCode
                                  , Object.ValueData  AS GoodsName
                                  , 0                 AS GoodsKindId
                             FROM (SELECT inBarCode :: BigInt AS ObjectCode WHERE CHAR_LENGTH (inBarCode) BETWEEN 1 AND 12) AS tmp
                                  LEFT JOIN Object ON Object.ObjectCode = tmp.ObjectCode
                                                  AND Object.DescId = zc_Object_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                             WHERE ((inIsGoodsComplete = TRUE AND tmp.ObjectCode BETWEEN 1 AND 4000 - 1)
                                 OR (inIsGoodsComplete = FALSE AND tmp.ObjectCode >= 4000)
                                 OR 1 = 1 -- !!!временно все!!!
                                 OR Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                                   , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                                    )
                                   )
                                AND tmp.ObjectCode > 0
                            )
    , tmpGoods_ScaleCeh AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                                                 AS GoodsId
                                 , STRING_AGG (COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) :: TVarChar, ',') AS GoodsKindId_List
                                 , STRING_AGG (COALESCE (Object_GoodsKind.ValueData, '') ::TVarChar, ',')                          AS GoodsKindName_List
                                 , ABS (MIN (COALESCE (CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = zc_GoodsKind_Basis() THEN -1 ELSE 1 END * ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0))) AS GoodsKindId_max
                            FROM Object_Goods
                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                      ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = Object_Goods.GoodsId
                                                     AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                 INNER JOIN ObjectBoolean AS ObjectBoolean_ScaleCeh
                                                          ON ObjectBoolean_ScaleCeh.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectBoolean_ScaleCeh.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh()
                                                         AND ObjectBoolean_ScaleCeh.ValueData = TRUE
                                 INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = ObjectBoolean_ScaleCeh.ObjectId AND Object_GoodsByGoodsKind.isErased = FALSE
                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                      ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                                     AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                            WHERE inIsGoodsComplete = TRUE
                            GROUP BY ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                           )
       -- Результат
       SELECT Object_Goods.GoodsId
            , Object_Goods.GoodsCode
            , Object_Goods.GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName

            , tmpGoods_ScaleCeh.GoodsKindId_list   :: TVarChar AS GoodsKindId_list
            , tmpGoods_ScaleCeh.GoodsKindName_List :: TVarChar AS GoodsKindName_List
            , Object_GoodsKind_max.Id                          AS GoodsKindId_max
            , Object_GoodsKind_max.ObjectCode                  AS GoodsKindCode_max
            , Object_GoodsKind_max.ValueData                   AS GoodsKindName_max

            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ObjectCode   AS MeasureCode
            , Object_Measure.ValueData    AS MeasureName

       FROM Object_Goods
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_Goods.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN tmpGoods_ScaleCeh ON tmpGoods_ScaleCeh.GoodsId = Object_Goods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind_max ON Object_GoodsKind_max.Id = tmpGoods_ScaleCeh.GoodsKindId_max
      ;


     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpGet_Scale_Goods'
               -- ProtocolData
             , inIsGoodsComplete :: TVarChar
    || ', ' || inBarCode
    || ', ' || inSession
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Goods (Boolean, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Goods (FALSE, '2010001532224', zfCalc_UserAdmin())
