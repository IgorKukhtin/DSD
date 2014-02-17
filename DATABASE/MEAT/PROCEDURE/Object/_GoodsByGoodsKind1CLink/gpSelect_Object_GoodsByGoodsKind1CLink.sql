-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, 
               Id Integer, Code Integer, Name TVarChar, BranchId Integer, BranchName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- Результат
     RETURN QUERY 
       SELECT 
           GoodsByGoodsKind.GoodsId
        ,  GoodsByGoodsKind.GoodsCode
        ,  GoodsByGoodsKind.GoodsName
        ,  GoodsByGoodsKind.GoodsKindId
        ,  GoodsByGoodsKind.GoodsKindName
        ,  GoodsByGoodsKind1CLink.Id
        ,  GoodsByGoodsKind1CLink.Code
        ,  GoodsByGoodsKind1CLink.Name
        ,  GoodsByGoodsKind1CLink.BranchId
        ,  GoodsByGoodsKind1CLink.BranchName
       FROM (SELECT
             Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , (COALESCE (Object_GoodsByGoodsKind_View.GoodsId, 0) :: TVarChar || '_' || COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) :: TVarChar) :: TVarChar AS MasterId
           , Object_GoodsByGoodsKind_View.GoodsKindId
           , Object_GoodsByGoodsKind_View.GoodsKindName

       FROM Object_GoodsByGoodsKind_View
      UNION ALL
       SELECT
             Object.Id AS GoodsId
           , Object.ObjectCode AS GoodsCode
           , Object.ValueData AS GoodsName
            , (COALESCE (Object.Id, 0) :: TVarChar || '_'|| '0') :: TVarChar AS MasterId
           , 0 ::Integer AS GoodsKindId
           , '' ::TVarChar AS GoodsKindName
       FROM Object
       WHERE Object.DescId = zc_Object_Goods()
         AND Object.Id IN (7645, 7601, 6779, 6816) -- ТУШЕНКА
      ) AS GoodsByGoodsKind
       LEFT JOIN 
       (SELECT
              Object_GoodsByGoodsKind1CLink.Id               AS Id 
            , Object_GoodsByGoodsKind1CLink.ObjectCode       AS Code
            , Object_GoodsByGoodsKind1CLink.ValueData        AS Name
            , (COALESCE (ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId, 0) :: TVarChar || '_' || COALESCE (ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId, 0) :: TVarChar) :: TVarChar AS MasterId
            , Object_Branch.Id                               AS BranchId
            , Object_Branch.ValueData                        AS BranchName

       FROM Object AS Object_GoodsByGoodsKind1CLink
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                 ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                 ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                 ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId   
       WHERE Object_GoodsByGoodsKind1CLink.DescId = zc_Object_GoodsByGoodsKind1CLink())  AS GoodsByGoodsKind1CLink
          ON GoodsByGoodsKind1CLink.MasterId = GoodsByGoodsKind.MasterId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.02.14                        * 
 15.02.14                                        * all
 28.01.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink (zfCalc_UserAdmin()) WHERE Code = 