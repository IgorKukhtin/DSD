-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer
             , GoodsKindName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT
             Object_GoodsByGoodsKind_View.Id 
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , Object_GoodsByGoodsKind_View.GoodsKindId
           , Object_GoodsByGoodsKind_View.GoodsKindName

       FROM Object_GoodsByGoodsKind_View;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Account (zfCalc_UserAdmin())