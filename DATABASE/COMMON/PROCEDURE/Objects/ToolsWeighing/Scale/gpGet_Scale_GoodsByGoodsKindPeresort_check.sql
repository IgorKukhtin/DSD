-- Function: gpGet_Scale_GoodsByGoodsKindPeresort_check()

DROP FUNCTION IF EXISTS gpGet_Scale_GoodsByGoodsKindPeresort_check (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_GoodsByGoodsKindPeresort_check(
    IN inGoodsId_in       Integer,
    IN inGoodsKindId_in   Integer,
    IN inBranchCode       Integer,      --
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (Key_str         TVarChar
             , GoodsId         Integer
             , GoodsCode       Integer
             , GoodsName       TVarChar
             , GoodsKindId     Integer
             , GoodsKindCode   Integer
             , GoodsKindName   TVarChar
             , MeasureId       Integer
             , MeasureName     TVarChar
             , Weight_gd       TFloat
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT DISTINCT
              (Object_Goods_out.Id :: TVarChar || '_' || COALESCE (Object_GoodsKind_out.Id :: TVarChar, '')) :: TVarChar AS Key_str
            , Object_Goods_out.Id             AS GoodsId
            , Object_Goods_out.ObjectCode     AS GoodsCode
            , Object_Goods_out.ValueData      AS GoodsName
            , Object_GoodsKind_out.Id         AS GoodsKindId
            , Object_GoodsKind_out.ObjectCode AS GoodsKindCode
            , Object_GoodsKind_out.ValueData  AS GoodsKindName
            , Object_Measure_out.Id           AS MeasureId
            , Object_Measure_out.ValueData    AS MeasureName
            , COALESCE (ObjectFloat_Weight.ValueData, 0) :: TFloat AS Weight_gd

       FROM ObjectLink AS OL_GoodsByGoodsKindPeresort_Goods_in
            INNER JOIN Object AS Object_GoodsByGoodsKindPeresort ON Object_GoodsByGoodsKindPeresort.Id       = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                                                AND Object_GoodsByGoodsKindPeresort.isErased = FALSE
            LEFT JOIN ObjectLink AS OL_GoodsByGoodsKindPeresort_GoodsKind_in
                                 ON OL_GoodsByGoodsKindPeresort_GoodsKind_in.ObjectId = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                AND OL_GoodsByGoodsKindPeresort_GoodsKind_in.DescId   = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_in()

            LEFT JOIN ObjectLink AS OL_GoodsByGoodsKindPeresort_Goods_out
                                 ON OL_GoodsByGoodsKindPeresort_Goods_out.ObjectId = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                AND OL_GoodsByGoodsKindPeresort_Goods_out.DescId   = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_out()
            LEFT JOIN ObjectLink AS OL_GoodsByGoodsKindPeresort_GoodsKind_out
                                 ON OL_GoodsByGoodsKindPeresort_GoodsKind_out.ObjectId = OL_GoodsByGoodsKindPeresort_Goods_in.ObjectId
                                AND OL_GoodsByGoodsKindPeresort_GoodsKind_out.DescId   = zc_ObjectLink_GoodsByGoodsKindPeresort_GoodsKind_out()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = OL_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = OL_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

            LEFT JOIN Object AS Object_Goods_out     ON Object_Goods_out.Id     = OL_GoodsByGoodsKindPeresort_Goods_out.ChildObjectId
            LEFT JOIN Object AS Object_GoodsKind_out ON Object_GoodsKind_out.Id = OL_GoodsByGoodsKindPeresort_GoodsKind_out.ChildObjectId
            LEFT JOIN Object AS Object_Measure_out   ON Object_Measure_out.Id   = ObjectLink_Goods_Measure.ChildObjectId

       WHERE OL_GoodsByGoodsKindPeresort_Goods_in.DescId = zc_ObjectLink_GoodsByGoodsKindPeresort_Goods_in()
         AND (OL_GoodsByGoodsKindPeresort_Goods_in.ChildObjectId     = inGoodsId_in     OR inGoodsId_in     = 0)
         AND (OL_GoodsByGoodsKindPeresort_GoodsKind_in.ChildObjectId = inGoodsKindId_in OR inGoodsKindId_in = 0)

      UNION
       SELECT DISTINCT
              (Object_Goods.Id :: TVarChar || '_' || COALESCE (Object_GoodsKind.Id :: TVarChar, '')) :: TVarChar AS Key_str
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ValueData    AS MeasureName
            , COALESCE (ObjectFloat_Weight.ValueData, 0) :: TFloat AS Weight_gd
       FROM ObjectBoolean AS ObjectBoolean_ScaleCeh
            INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id       = ObjectBoolean_ScaleCeh.ObjectId
                                                        AND Object_GoodsByGoodsKind.isErased = FALSE
            INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                  ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
            INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectBoolean_ScaleCeh.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

            INNER JOIN Object AS Object_Goods     ON Object_Goods.Id     = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
            INNER JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
            LEFT JOIN Object  AS Object_Measure   ON Object_Measure.Id   = ObjectLink_Goods_Measure.ChildObjectId

       WHERE ObjectBoolean_ScaleCeh.DescId    IN (zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh(), zc_ObjectBoolean_GoodsByGoodsKind_Order())
         AND ObjectBoolean_ScaleCeh.ValueData = TRUE
         AND inGoodsId_in = 0

       ORDER BY 3, 6
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_GoodsByGoodsKindPeresort_check (inGoodsId_in:= 0, inGoodsKindId_in:= 0, inBranchCode:= 0, inSession:=zfCalc_UserAdmin())
