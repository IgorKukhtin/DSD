-- Function: gpGet_Object_GoodsKindWeighingGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsKindWeighingGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsKindWeighingGroup(
    IN inId          Integer,       -- Группа товаров
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ParentId Integer, ParentName TVarChar)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighingGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)                            AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsKindWeighingGroup()) AS Code
           , CAST ('' as TVarChar)                          AS Name
           , CAST (0 as Integer)                            AS ParentId
           , CAST ('' as TVarChar)                          AS ParentName;
   ELSE
       RETURN QUERY
       SELECT
             Object_GoodsKindWeighingGroup.Id               AS Id
           , Object_GoodsKindWeighingGroup.ObjectCode       AS Code
           , Object_GoodsKindWeighingGroup.ValueData        AS Name
           , CAST (0 as Integer)                            AS ParentId
           , CAST ('' as TVarChar)                          AS ParentName
/*
           , GoodsKindWeighingGroup.Id                      AS ParentId
           , GoodsKindWeighingGroup.ValueData               AS ParentName
*/
       FROM OBJECT AS Object_GoodsKindWeighingGroup
/*
           LEFT JOIN ObjectLink AS ObjectLink_GoodsKindWeighingGroup
                                ON ObjectLink_GoodsKindWeighingGroup.ObjectId = Object_GoodsKindWeighingGroup.Id
                               AND ObjectLink_GoodsKindWeighingGroup.DescId = zc_ObjectLink_GoodsKindWeighingGroup_Parent()

           LEFT JOIN Object AS GoodsKindWeighingGroup ON GoodsKindWeighingGroup.Id = ObjectLink_GoodsKindWeighingGroup.ChildObjectId
*/
       WHERE Object_GoodsKindWeighingGroup.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsKindWeighingGroup (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.14                                                         *


*/

-- тест
-- SELECT * FROM gpSelect_GoodsKindWeighingGroup('2')