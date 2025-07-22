-- Function: gpGet_Scale_Goods_gofro()

DROP FUNCTION IF EXISTS gpGet_Scale_Goods_gofro (TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Goods_gofro (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Goods_gofro(
    IN inGoodsCode       Integer      ,
    IN inBranchCode      Integer      , --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId      Integer
             , GoodsCode    Integer
             , GoodsName    TVarChar
             , MeasureId    Integer
             , MeasureName  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   

    -- Результат
    RETURN QUERY
       WITH Object_Goods AS (SELECT gpSelect.GuideId
                                  , gpSelect.GuideCode
                                  , gpSelect.GuideName
                                  , gpSelect.MeasureId
                                  , gpSelect.MeasureName
                             FROM gpSelect_Scale_Gofro (inBranchCode, inSession) AS gpSelect
                             WHERE gpSelect.GuideCode = inGoodsCode
                               AND inGoodsCode > 0
                            )
       -- Результат
       SELECT Object_Goods.GuideId     AS GoodsId
            , Object_Goods.GuideCode   AS GoodsCode
            , Object_Goods.GuideName   AS GoodsName
            , Object_Goods.MeasureId   AS MeasureId
            , Object_Goods.MeasureName AS MeasureName

       FROM Object_Goods
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.07.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Goods_gofro (12, 1, zfCalc_UserAdmin())
