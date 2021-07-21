-- 
DROP FUNCTION IF EXISTS gpGet_Object_SmsSettings (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SmsSettings(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Login TVarChar
             , Password TVarChar
             , Message TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SmsSettings());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_SmsSettings())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Login
           , '' :: TVarChar           AS Password
           , '' :: TVarChar           AS Message
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_SmsSettings.Id           AS Id
           , Object_SmsSettings.ObjectCode   AS Code
           , Object_SmsSettings.ValueData    AS Name
           , ObjectString_Login.ValueData    AS Login
           , ObjectString_Password.ValueData AS Password
           , ObjectString_Message.ValueData  AS Message
       FROM Object AS Object_SmsSettings
          LEFT JOIN ObjectString AS ObjectString_Login
                                 ON ObjectString_Login.ObjectId = Object_SmsSettings.Id
                                AND ObjectString_Login.DescId = zc_ObjectString_SmsSettings_Login()  

          LEFT JOIN ObjectString AS ObjectString_Password
                                 ON ObjectString_Password.ObjectId = Object_SmsSettings.Id
                                AND ObjectString_Password.DescId = zc_ObjectString_SmsSettings_Password()  

          LEFT JOIN ObjectString AS ObjectString_Message
                                 ON ObjectString_Message.ObjectId = Object_SmsSettings.Id
                                AND ObjectString_Message.DescId = zc_ObjectString_SmsSettings_Message() 
       WHERE Object_SmsSettings.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_SmsSettings (1 ::integer,'2'::TVarChar)
