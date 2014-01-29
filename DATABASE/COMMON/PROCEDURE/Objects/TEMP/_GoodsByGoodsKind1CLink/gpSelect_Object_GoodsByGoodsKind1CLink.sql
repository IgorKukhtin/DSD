-- Function: gpSelect_Object_GoodsByGoodsKind1CLink(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, GoodsByGoodsKindId Integer, BranchId Integer, BranchName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     RETURN QUERY 
       SELECT
             Object_GoodsByGoodsKind1CLink.Id               AS Id
           , Object_GoodsByGoodsKind1CLink.ObjectCode       AS Code
           , Object_GoodsByGoodsKind1CLink.ValueData        AS Name
           , ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ChildObjectId
           , Object_Branch.Id
           , Object_Branch.ValueData

       FROM Object AS Object_GoodsByGoodsKind1CLink
       JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind
         ON ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ObjectId = Object_GoodsByGoodsKind1CLink.Id
        AND ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind()
  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
         ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
        AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
  LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId   

       WHERE Object_GoodsByGoodsKind1CLink.DescId = zc_Object_GoodsByGoodsKind1CLink();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink (zfCalc_UserAdmin())