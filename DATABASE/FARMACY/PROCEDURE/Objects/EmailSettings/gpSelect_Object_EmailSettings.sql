-- Function: gpSelect_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_EmailSettings(Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_EmailSettings(
    IN inEmailId   Integer   ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Value TVarChar,
               EmailId Integer, EmailName TVarChar,
               EmailKindId Integer, EmailKindName TVarChar,
               EmailToolsId Integer, EmailToolsName TVarChar
               ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_EmailSettings());

   RETURN QUERY 
    WITH 
    tmpEnum AS (SELECT Object_EmailKind.Id           AS EmailKindId
                     , Object_EmailKind.ValueData    AS EmailKindName
                     , Object_EmailTools.Id          AS EmailToolsId
                     , Object_EmailTools.ValueData   AS EmailToolsName 
                FROM Object AS Object_EmailKind
                    LEFT JOIN Object AS Object_EmailTools ON Object_EmailTools.DescId = zc_Object_EmailTools()
                WHERE Object_EmailKind.DEscId = zc_Object_EmailKind()
                )
   ,tmpEmail AS (SELECT Object_Email.Id                    AS EmailId
                     , Object_Email.ValueData             AS EmailName
                     , ObjectLink_EmailKind.ChildObjectId AS EmailKindId
                FROM Object AS Object_Email
                   LEFT JOIN ObjectLink AS ObjectLink_EmailKind
                                        ON ObjectLink_EmailKind.ObjectId = Object_Email.Id
                                       AND ObjectLink_EmailKind.DescId = zc_ObjectLink_Email_EmailKind()
                WHERE Object_Email.DescId = zc_Object_Email()
                )
 , tmpEnumEmail AS (SELECT tmpEnum.*
                         , tmpEmail.EmailId
                         , tmpEmail.EmailName
                     FROM tmpEnum
                         LEFT JOIN tmpEmail ON tmpEmail.EmailKindId = tmpEnum.EmailKindId
                    )
  , tmpObject AS (SELECT Object_EmailSettings.Id             AS EmailSettingsId
                       , Object_EmailSettings.ObjectCode     AS EmailSettingsCode
                       , Object_EmailSettings.ValueData      AS EmailSettingsValue
                       , Object_Email.Id                     AS EmailId
                       , Object_Email.ValueData              AS EmailName
                       , Object_EmailTools.Id                AS EmailToolsId
                       , Object_EmailTools.ValueData         AS EmailToolsName 
                  FROM Object AS Object_EmailSettings
                    LEFT JOIN ObjectLink AS ObjectLink_Email
                                         ON ObjectLink_Email.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_Email.DescId = zc_ObjectLink_EmailSettings_Email()
                    LEFT JOIN Object AS Object_Email ON Object_Email.Id = ObjectLink_Email.ChildObjectId

                    LEFT JOIN ObjectLink AS ObjectLink_EmailTools
                                         ON ObjectLink_EmailTools.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_EmailTools.DescId = zc_ObjectLink_EmailSettings_EmailTools()
                    LEFT JOIN Object AS Object_EmailTools ON Object_EmailTools.Id = ObjectLink_EmailTools.ChildObjectId
                  WHERE Object_EmailSettings.DescId = zc_Object_EmailSettings()
                  )

       SELECT tmpObject.EmailSettingsId AS Id
            , tmpObject.EmailSettingsCode AS Code
            , tmpObject.EmailSettingsValue AS Value
            , tmpEnumEmail.EmailId
            , tmpEnumEmail.EmailName
            , tmpEnumEmail.EmailKindId
            , tmpEnumEmail.EmailKindName
            , tmpEnumEmail.EmailToolsId
            , tmpEnumEmail.EmailToolsName
             
       FROM tmpEnumEmail
         LEFT JOIN tmpObject ON tmpObject.EmailId = tmpEnumEmail.EmailId
                            AND tmpObject.EmailToolsId = tmpEnumEmail.EmailToolsId
       WHERE tmpEnumEmail.EmailId = inEmailId OR inEmailId = 0


;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.16         *
 03.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmailSettings (0, '2')
