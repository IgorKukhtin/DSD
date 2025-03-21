-- Function: gpGet_Scale_Goods_gk()

DROP FUNCTION IF EXISTS gpGet_Scale_Goods_gk (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Goods_gk(
    IN inGoodsId         Integer      ,
    IN inGoodsKindId     Integer      ,
    IN inBranchCode      Integer      , --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsKindId    Integer
             , GoodsKindCode  Integer
             , GoodsKindName  TVarChar
             , MeasureId      Integer
             , MeasureName    TVarChar
             , WeightTare_0   TFloat
             , WeightTare_gd  TFloat
             , Weight_gd      TFloat
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH -- список
          tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                           AS GoodsId
                                       , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId                       AS GoodsKindId
                                         --
                                       , CASE WHEN ObjectFloat_GoodsByGoodsKind_WeightPackageKorob.ValueData > 0
                                                   THEN ObjectFloat_GoodsByGoodsKind_WeightPackageKorob.ValueData
                                              ELSE COALESCE (ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ValueData, 0)
                                         END AS WeightPackageSticker

                                  FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                                       INNER JOIN Object AS Object_GoodsByGoodsKind
                                                         ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND Object_GoodsByGoodsKind.isErased = FALSE
                                       LEFT JOIN ObjectFloat AS ObjectFloat_GoodsByGoodsKind_WeightPackageSticker
                                                             ON ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.ObjectId  = Object_GoodsByGoodsKind.Id
                                                            AND ObjectFloat_GoodsByGoodsKind_WeightPackageSticker.DescId    = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()
                                       LEFT JOIN ObjectFloat AS ObjectFloat_GoodsByGoodsKind_WeightPackageKorob
                                                             ON ObjectFloat_GoodsByGoodsKind_WeightPackageKorob.ObjectId  = Object_GoodsByGoodsKind.Id
                                                            AND ObjectFloat_GoodsByGoodsKind_WeightPackageKorob.DescId    = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob()
                                  WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                                    AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                 )
       -- Результат
       SELECT Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode

            , CASE WHEN Object_Goods.ObjectCode IN (585,129,889,224,119
                                                  , 66,67,779,901,142,221,222 
                                                   )
                   AND Object_GoodsKind.Id IN (8349    -- Флоу-пак
                                             , 7462698 -- нар. 180
                                             , 6899005 -- нар. 200
                                              )
                        THEN Object_GoodsKind.ValueData
                   ELSE ''
              END :: TVarChar AS GoodsKindName

            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ValueData    AS MeasureName

            , CASE WHEN Object_Goods.ObjectCode IN (585,129,889,224,119
                                                  , 66,67,779,901,142,221,222 
                                                   )
                   AND Object_GoodsKind.Id IN (8349    -- Флоу-пак
                                             , 7462698 -- нар. 180
                                             , 6899005 -- нар. 200
                                              )
                        THEN tmpGoodsByGoodsKind.WeightPackageSticker
                   ELSE 0
              END :: TFloat AS WeightTare_0

            , tmpGoodsByGoodsKind.WeightPackageSticker :: TFloat AS WeightTare_gd
            , ObjectFloat_Weight.ValueData AS Weight_gd

       FROM tmpGoodsByGoodsKind
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpGoodsByGoodsKind.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoodsByGoodsKind.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpGoodsByGoodsKind.GoodsId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
           ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.03.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Goods_gk (2894, 8349, 115, zfCalc_UserAdmin())
