-- Function: gpSelect_Object_RouteSorting (TVarChar)

-- DROP FUNCTION gpSelect_Object_RouteSorting (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteSorting(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_RouteSorting());

   RETURN QUERY 
   SELECT
     Object.Id
   , Object.ObjectCode AS Code
   , Object.ValueData AS Name
   , Object.isErased
   FROM Object
   WHERE Object.DescId = zc_Object_RouteSorting()

      UNION ALL
       SELECT 
             0 AS Id
           , NULL :: Integer AS Code
           , 'УДАЛИТЬ' :: TVarChar AS Name
           , FALSE AS isErased
    ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RouteSorting (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_RouteSorting('2')
