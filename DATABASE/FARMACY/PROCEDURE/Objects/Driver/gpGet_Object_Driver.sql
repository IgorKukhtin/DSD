-- Function: gpGet_Object_Driver()

DROP FUNCTION IF EXISTS gpGet_Object_Driver(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Driver(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Email TVarChar, isAllLetters boolean
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Driver()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Email
           , CAST (FALSE AS Boolean) AS isAllLetters
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_Driver.Id                     AS Id
            , Object_Driver.ObjectCode             AS Code
            , Object_Driver.ValueData              AS Name
            , ObjectString_Driver_E_Mail.ValueData  AS Email
            , COALESCE(ObjectBoolean_Driver_AllLetters.ValueData, FALSE)  AS isAllLetters
            , Object_Driver.isErased               AS isErased
       FROM Object AS Object_Driver
            LEFT JOIN ObjectString AS ObjectString_Driver_E_Mail
                                   ON ObjectString_Driver_E_Mail.ObjectId = Object_Driver.Id 
                                  AND ObjectString_Driver_E_Mail.DescId = zc_ObjectString_Driver_E_Mail()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Driver_AllLetters
                                    ON ObjectBoolean_Driver_AllLetters.ObjectId = Object_Driver.Id 
                                   AND ObjectBoolean_Driver_AllLetters.DescId = zc_ObjectBoolean_Driver_AllLetters()
       WHERE Object_Driver.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Driver(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.08.19                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_Driver (0, '3')