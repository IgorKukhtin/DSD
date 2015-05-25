-- Function: gpGet_Scale_Goods()

DROP FUNCTION IF EXISTS gpGet_Scale_Goods (TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Goods (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Goods(
    IN inBarCode   TVarChar     ,
    IN inSession   TVarChar      -- сессия пользователя
)
RETURNS TABLE (GoodsId    Integer
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , GoodsKindId    Integer
             , GoodsKindCode  Integer
             , GoodsKindName  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH Object_Goods AS (SELECT COALESCE (View_GoodsByGoodsKind.GoodsId, Object.Id) :: Integer AS GoodsId
                                  , COALESCE (View_GoodsByGoodsKind.GoodsCode, Object.ObjectCode) :: Integer AS GoodsCode
                                  , COALESCE (View_GoodsByGoodsKind.GoodsName, Object.ValueData) :: TVarChar AS GoodsName
                                  , COALESCE (View_GoodsByGoodsKind.GoodsKindId, zc_Enum_GoodsKind_Main()) AS GoodsKindId
                             FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS ObjectId WHERE CHAR_LENGTH (inBarCode) >= 13) AS tmp
                                  LEFT JOIN Object ON Object.Id = tmp.ObjectId
                                                  AND Object.DescId IN (zc_Object_Goods(), zc_Object_GoodsByGoodsKind())
                                  LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.Id = Object.Id
                            )

       SELECT Object_Goods.GoodsId
            , Object_Goods.GoodsCode
            , Object_Goods.GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName

       FROM Object_Goods
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_Goods.GoodsKindId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Goods (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Goods ('2010001532224', zfCalc_UserAdmin())
