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
             , MeasureId    Integer
             , MeasureCode  Integer
             , MeasureName  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


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
                             FROM (SELECT inBarCode :: Integer AS ObjectCode WHERE CHAR_LENGTH (inBarCode) BETWEEN 1 AND 12) AS tmp
                                  LEFT JOIN Object ON Object.ObjectCode = tmp.ObjectCode
                                                  AND Object.DescId = zc_Object_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object.Id
                                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                             WHERE ((inIsGoodsComplete = TRUE AND tmp.ObjectCode BETWEEN 1 AND 4000 - 1)
                                 OR (inIsGoodsComplete = FALSE AND tmp.ObjectCode >= 4000)
                                 OR Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                                   , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                                    )
                                   )
                                AND tmp.ObjectCode > 0
                            )

       SELECT Object_Goods.GoodsId
            , Object_Goods.GoodsCode
            , Object_Goods.GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ObjectCode   AS MeasureCode
            , Object_Measure.ValueData    AS MeasureName

       FROM Object_Goods
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_Goods.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
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
