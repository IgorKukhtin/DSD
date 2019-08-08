-- Function: gpSelect_Object_Driver()

DROP FUNCTION IF EXISTS gpSelect_Object_Driver(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Driver(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Email TVarChar, isAllLetters boolean
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_Driver.Id                      AS Id 
        , Object_Driver.ObjectCode              AS Code
        , Object_Driver.ValueData               AS Name
        , ObjectString_Driver_E_Mail.ValueData  AS Email
        , COALESCE(ObjectBoolean_Driver_AllLetters.ValueData, FALSE)  AS isAllLetters
        , Object_Driver.isErased                AS isErased
   FROM Object AS Object_Driver
        LEFT JOIN ObjectString AS ObjectString_Driver_E_Mail
                               ON ObjectString_Driver_E_Mail.ObjectId = Object_Driver.Id 
                              AND ObjectString_Driver_E_Mail.DescId = zc_ObjectString_Driver_E_Mail()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Driver_AllLetters
                                ON ObjectBoolean_Driver_AllLetters.ObjectId = Object_Driver.Id 
                               AND ObjectBoolean_Driver_AllLetters.DescId = zc_ObjectBoolean_Driver_AllLetters()
   WHERE Object_Driver.DescId = zc_Object_Driver();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Driver(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.08.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Driver('3')