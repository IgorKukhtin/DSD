-- Function: gpSelect_Object_ToolsWeighing_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_Tree(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_Tree(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ParentId Integer, isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());

   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code
           , Object_ToolsWeighing_View.Name
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.isErased
       FROM Object_ToolsWeighing_View
       WHERE isLeaf = FALSE

      UNION
       SELECT
             0 AS Id,
             0 AS Code,
             CAST('ВСЕ' AS TVarChar) AS Name,
             0 AS ParentId,
             FALSE AS isErased
       ORDER BY 4, 3
      ;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing_Tree(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing_Tree ('2')
