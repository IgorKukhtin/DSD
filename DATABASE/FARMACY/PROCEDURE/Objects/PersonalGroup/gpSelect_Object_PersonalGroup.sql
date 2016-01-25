-- Function: gpSelect_Object_PersonalGroup(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PersonalGroup());

     RETURN QUERY 
       SELECT 
             Object_PersonalGroup.Id          AS Id
           , Object_PersonalGroup.ObjectCode  AS Code
           , Object_PersonalGroup.ValueData   AS Name
           
           , Object_PersonalGroup.isErased AS isErased
           
       FROM Object AS Object_PersonalGroup
       WHERE Object_PersonalGroup.DescId = zc_Object_PersonalGroup();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PersonalGroup(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.16         * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_PersonalGroup('2')