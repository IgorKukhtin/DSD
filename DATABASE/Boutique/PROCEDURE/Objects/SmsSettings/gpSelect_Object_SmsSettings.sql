-- 

DROP FUNCTION IF EXISTS gpSelect_Object_SmsSettings (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SmsSettings(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Login TVarChar
             , Password TVarChar
             , Message TVarChar
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SmsSettings());
   vbUserId:= lpGetUserBySession (inSession);

   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_SmsSettings.Id           AS Id
           , Object_SmsSettings.ObjectCode   AS Code
           , Object_SmsSettings.ValueData    AS Name

           , ObjectString_Login.ValueData    AS Login
           , ObjectString_Password.ValueData AS Password
           , ObjectString_Message.ValueData  AS Message

           , Object_SmsSettings.isErased     AS isErased
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

       WHERE Object_SmsSettings.DescId = zc_Object_SmsSettings()
         AND (Object_SmsSettings.isErased = FALSE OR inIsShowAll = TRUE)
       ;

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
-- SELECT * FROM gpSelect_Object_SmsSettings (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())