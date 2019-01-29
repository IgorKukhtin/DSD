-- Function: gpSelect_Object_SettingsService()

DROP FUNCTION IF EXISTS gpSelect_Object_SettingsService(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SettingsService(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SettingsService());

   RETURN QUERY 
       SELECT 
             Object_SettingsService.Id         AS Id
           , Object_SettingsService.ObjectCode AS Code
           , Object_SettingsService.ValueData  AS Name
         
           , Object_SettingsService.isErased   AS isErased
           
       FROM Object AS Object_SettingsService
       WHERE Object_SettingsService.DescId = zc_Object_SettingsService()
          ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_SettingsService ('2')
