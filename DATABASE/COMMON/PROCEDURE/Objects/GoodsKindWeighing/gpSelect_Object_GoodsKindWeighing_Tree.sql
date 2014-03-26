-- Function: gpSelect_Object_GoodsKindWeighing_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsKindWeighing_Tree(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKindWeighing_Tree(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());

   RETURN QUERY
/*
   SELECT
         Object_GoodsKind.Id                  AS Id
       , Object_GoodsKind.ObjectCode          AS Code
       , Object_GoodsKind.ValueData           AS Name
       , Object_GoodsKind.isErased            AS isErased
       , COALESCE(OL_GoodsKindWeighing_GoodsKind.ObjectId, 0) AS ParentId

   FROM ObjectLink AS OL_GoodsKindWeighing_GoodsKind
   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = OL_GoodsKindWeighing_GoodsKind.ChildObjectId
   WHERE OL_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()
*/
   SELECT
             0 AS Id,
             0 AS Code,
             CAST('ВСЕ' AS TVarChar) AS Name,
             false AS isErased,
             0 AS ParentId

   UNION

   SELECT
         Object_GoodsKindWeighingGroup.Id                 AS Id
       , Object_GoodsKindWeighingGroup.ObjectCode         AS Code
       , Object_GoodsKindWeighingGroup.ValueData          AS Name
       , Object_GoodsKindWeighingGroup.isErased           AS isErased
       , CAST(0 AS Integer)                               AS ParentId

   FROM Object AS Object_GoodsKindWeighingGroup
   WHERE Object_GoodsKindWeighingGroup.DescId = zc_Object_GoodsKindWeighingGroup()

   ;



END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsKindWeighing_Tree(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.03.14                                                         *
 25.03.14                                                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsKindWeighing_Tree('2')