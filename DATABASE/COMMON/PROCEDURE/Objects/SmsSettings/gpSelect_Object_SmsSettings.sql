-- 

DROP FUNCTION IF EXISTS gpSelect_Object_SmsSettings (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SmsSettings(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, DescId Integer
             , Nom Integer
             , Name TVarChar
             , Value TVarChar
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
   WITH
       tmpSMSSettings AS (SELECT *
                      FROM Object AS Object_SmsSettings
                      WHERE Object_SmsSettings.DescId = zc_Object_SmsSettings()
                      )

       SELECT Object_SmsSettings.Id        AS Id
            , zc_Object_SmsSettings()      AS DescId
            , 1              ::Integer     AS Nom
            , 'Host'         ::TVarChar    AS Name
            , Object_SmsSettings.ValueData AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_Login() AS DescId
            , 2              ::Integer     AS Nom
            , 'Login'        ::TVarChar    AS Name
            , ObjectString_Login.ValueData ::TVarChar AS Value 
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
            LEFT JOIN ObjectString AS ObjectString_Login
                                   ON ObjectString_Login.ObjectId = Object_SmsSettings.Id
                                  AND ObjectString_Login.DescId = zc_ObjectString_SmsSettings_Login()  
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_Password() AS DescId
            , 3              ::Integer     AS Nom
            , 'Password'     ::TVarChar    AS Name
            , ObjectString_Password.ValueData ::TVarChar AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
          LEFT JOIN ObjectString AS ObjectString_Password
                                 ON ObjectString_Password.ObjectId = Object_SmsSettings.Id
                                AND ObjectString_Password.DescId = zc_ObjectString_SmsSettings_Password()  
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_Message() AS DescId
            , 4              ::Integer     AS Nom
            , 'Message'      ::TVarChar    AS Name
            , ObjectString_Message.ValueData ::TVarChar AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
          LEFT JOIN ObjectString AS ObjectString_Message
                                 ON ObjectString_Message.ObjectId = Object_SmsSettings.Id
                                AND ObjectString_Message.DescId = zc_ObjectString_SmsSettings_Message() 
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_AlphaName() AS DescId
            , 5              ::Integer     AS Nom
            , 'AlphaName'    ::TVarChar    AS Name
            , ObjectString_AlphaName.ValueData ::TVarChar AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
            LEFT JOIN ObjectString AS ObjectString_AlphaName
                                   ON ObjectString_AlphaName.ObjectId = Object_SmsSettings.Id
                                  AND ObjectString_AlphaName.DescId = zc_ObjectString_SmsSettings_AlphaName()  
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_ClientId() AS DescId
            , 6              ::Integer     AS Nom
            , 'ClientId'     ::TVarChar    AS Name
            , ObjectString_ClientId.ValueData ::TVarChar AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
            LEFT JOIN ObjectString AS ObjectString_ClientId
                                   ON ObjectString_ClientId.ObjectId = Object_SmsSettings.Id
                                  AND ObjectString_ClientId.DescId = zc_ObjectString_SmsSettings_ClientId()   

      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_ClientSecret() AS DescId
            , 7              ::Integer     AS Nom
            , 'ClientSecret' ::TVarChar    AS Name
            , ObjectString_ClientSecret.ValueData ::TVarChar AS Value 
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
            LEFT JOIN ObjectString AS ObjectString_ClientSecret
                                   ON ObjectString_ClientSecret.ObjectId = Object_SmsSettings.Id
                                  AND ObjectString_ClientSecret.DescId = zc_ObjectString_SmsSettings_ClientSecret()   
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_Version() AS DescId
            , 8              ::Integer     AS Nom
            , 'Version'      ::TVarChar    AS Name
            , ObjectString_Version.ValueData ::TVarChar AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
            LEFT JOIN ObjectString AS ObjectString_Version
                                   ON ObjectString_Version.ObjectId = Object_SmsSettings.Id
                                  AND ObjectString_Version.DescId = zc_ObjectString_SmsSettings_Version()   
      UNION
       SELECT Object_SmsSettings.Id        AS Id
            , zc_ObjectString_SmsSettings_Comment() AS DescId
            , 9              ::Integer     AS Nom
            , 'Примечание'   ::TVarChar    AS Name
            , ObjectString_Comment.ValueData ::TVarChar AS Value
            , Object_SmsSettings.isErased     AS isErased
       FROM tmpSMSSettings AS Object_SmsSettings
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_SmsSettings.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_SmsSettings_Comment()    
ORDER BY 3 
 
     /*  SELECT
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
         AND (Object_SmsSettings.isErased = FALSE OR inIsShowAll = TRUE) */
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