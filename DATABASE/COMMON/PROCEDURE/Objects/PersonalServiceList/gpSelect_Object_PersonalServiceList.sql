-- Function: gpSelect_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalServiceList(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalServiceList(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList()());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_PersonalServiceList();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PersonalServiceList(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PersonalServiceList('2')