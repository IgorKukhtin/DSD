-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_JuridicalSettings(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalSettings(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Bonus TFloat) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalSettings());
   vbUserId:= inSession;

   RETURN QUERY 
       SELECT 
             Object_JuridicalSettings.Id
           , ObjectFloat_Bonus.ValueData
       FROM  Object AS Object_JuridicalSettings

                LEFT JOIN ObjectFloat AS ObjectFloat_Bonus 
                                      ON ObjectFloat_Bonus.ObjectId = Object_JuridicalSettings.Id
                                     AND ObjectFloat_Bonus.DescId = zc_ObjectFloat_JuridicalSettings_Bonus()

       WHERE Object_JuridicalSettings.Id = inId;
  
END;
$BODY$
  
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_JuridicalSettings (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')