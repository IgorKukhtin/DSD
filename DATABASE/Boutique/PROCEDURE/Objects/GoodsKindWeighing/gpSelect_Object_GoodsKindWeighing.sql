-- Function: gpSelect_Object_GoodsKindWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsKindWeighing(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKindWeighing(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());

   RETURN QUERY
/*
   SELECT
         Object.Id                  AS Id
       , Object.ObjectCode          AS Code
       , Object.ValueData           AS Name
       , Object.isErased            AS isErased
       , Object_GoodsKind.Id        AS GoodsKindId
       , Object_GoodsKind.ValueData AS GoodsKindName

   FROM Object

   LEFT JOIN ObjectLink AS ObjectLink_GoodsKindWeighing_GoodsKind
                        ON ObjectLink_GoodsKindWeighing_GoodsKind.ObjectId = Object.Id
                       AND ObjectLink_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()
   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Goods_Measure.ChildObjectId
                                     AND Object_GoodsKind.DescId = zc_Object_GoodsKind()
   WHERE Object.DescId = zc_Object_GoodsKindWeighing();
 */
   SELECT
         GoodsKindWeighing.Id                  AS Id
       , GoodsKindWeighing.ObjectCode          AS Code
       , Object_GoodsKind.ValueData            AS Name
       , GoodsKindWeighing.isErased            AS isErased
       , COALESCE(OL_GoodsKindWeighing_GoodsKindWeighingGroup.ChildObjectId, 0) AS ParentId


   FROM Object AS GoodsKindWeighing

   LEFT JOIN ObjectLink AS OL_GoodsKindWeighing_GoodsKind
                        ON OL_GoodsKindWeighing_GoodsKind.ObjectId = GoodsKindWeighing.Id
                       AND OL_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()

   LEFT JOIN ObjectLink AS OL_GoodsKindWeighing_GoodsKindWeighingGroup
                        ON OL_GoodsKindWeighing_GoodsKindWeighingGroup.ObjectId = GoodsKindWeighing.Id
                       AND OL_GoodsKindWeighing_GoodsKindWeighingGroup.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup()

   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = OL_GoodsKindWeighing_GoodsKind.ChildObjectId

   WHERE GoodsKindWeighing.DescId = zc_Object_GoodsKindWeighing()
   ;



END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsKindWeighing(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.14                                                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsKindWeighing('2')