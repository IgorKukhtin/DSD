-- Function: gpSelect_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_EmailSettings (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_EmailSettings (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmailSettings(
    IN inEmailId       Integer   ,
    IN inIsShowAll     Boolean, 
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Value TVarChar
             , EmailId Integer, EmailName TVarChar
             , EmailKindId Integer, EmailKindName TVarChar
             , EmailToolsId Integer, EmailToolsName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
               )
AS
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
                         , COALESCE (tmpEmail.EmailId, 0) AS EmailId
                         , tmpEmail.EmailName
                     FROM tmpEnum
                          LEFT JOIN tmpEmail ON tmpEmail.EmailKindId = tmpEnum.EmailKindId
                    )
  , tmpObject1 AS (SELECT Object_EmailSettings.Id            AS EmailSettingsId
                       , Object_EmailSettings.ObjectCode     AS EmailSettingsCode
                       , Object_EmailSettings.ValueData      AS EmailSettingsValue
                       , COALESCE (ObjectLink_Email.ChildObjectId, 0)       AS EmailId
                       , ObjectLink_EmailTools.ChildObjectId                AS EmailToolsId
                       , COALESCE( ObjectLink_Juridical.ChildObjectId, 0)   AS JuridicalId

                  FROM Object AS Object_EmailSettings
                    LEFT JOIN ObjectLink AS ObjectLink_Email
                                         ON ObjectLink_Email.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_Email.DescId = zc_ObjectLink_EmailSettings_Email()
                    
                    LEFT JOIN ObjectLink AS ObjectLink_EmailTools
                                         ON ObjectLink_EmailTools.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_EmailTools.DescId = zc_ObjectLink_EmailSettings_EmailTools()
           
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                         ON ObjectLink_Juridical.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_Juridical.DescId = zc_ObjectLink_EmailSettings_Juridical()

                  WHERE Object_EmailSettings.DescId = zc_Object_EmailSettings()
                  )

  , tmpObject2 AS (SELECT tmpEnumEmail.EmailKindId
                        , tmpEnumEmail.EmailKindName
                        , tmpEnumEmail.EmailToolsId
                        , tmpEnumEmail.EmailToolsName 
                        , tmpEnumEmail.EmailId
                        , tmpEnumEmail.EmailName
                        , ObjectBoolean_isCorporate.ObjectId AS JuridicalId
                  FROM tmpEnumEmail
                       INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                   ON ObjectBoolean_isCorporate.DescId    = zc_ObjectBoolean_Juridical_isCorporate()
                                  AND ObjectBoolean_isCorporate.ValueData = TRUE
                  WHERE inIsShowAll = TRUE
                 )

  , tmpObject AS (SELECT tmpObject1.EmailSettingsId
                       , tmpObject1.EmailSettingsCode
                       , tmpObject1.EmailSettingsValue
                       , COALESCE (tmpObject1.EmailId, tmpObject2.EmailId)           AS EmailId
                       , COALESCE (tmpObject1.EmailToolsId, tmpObject2.EmailToolsId) AS EmailToolsId
                       , COALESCE (tmpObject1.JuridicalId, tmpObject2.JuridicalId)   AS JuridicalId

                  FROM tmpObject1
                       FULL JOIN tmpObject2 ON tmpObject2.EmailId      = tmpObject1.EmailId
                                           AND tmpObject2.EmailToolsId = tmpObject1.EmailToolsId
                                           AND tmpObject2.JuridicalId  = tmpObject1.JuridicalId
                   )
  , tmpObjectEmail AS (SELECT Object.*
                       FROM Object
                       WHERE Object.DescId in (zc_Object_Juridical(), zc_Object_EmailTools(), zc_Object_Email())
                       )

       SELECT tmpObject.EmailSettingsId    AS Id
            , tmpObject.EmailSettingsCode  AS Code
            , tmpObject.EmailSettingsValue AS Value
            , COALESCE (Object_Email.Id, 0)       AS EmailId
            , Object_Email.ValueData              AS EmailName
            , tmpEnumEmail.EmailKindId
            , tmpEnumEmail.EmailKindName
            , Object_EmailTools.Id                AS EmailToolsId
            , Object_EmailTools.ValueData         AS EmailToolsName
            , COALESCE(Object_Juridical.Id,0)     AS JuridicalId
            , Object_Juridical.ValueData          AS JuridicalName            
       FROM tmpEnumEmail
            LEFT JOIN tmpObject ON tmpObject.EmailId      = tmpEnumEmail.EmailId
                               AND tmpObject.EmailToolsId = tmpEnumEmail.EmailToolsId

            LEFT JOIN tmpObjectEmail AS Object_Email ON Object_Email.Id = tmpEnumEmail.EmailId
            LEFT JOIN tmpObjectEmail AS Object_EmailTools ON Object_EmailTools.Id = tmpEnumEmail.EmailToolsId
            LEFT JOIN tmpObjectEmail AS Object_Juridical ON Object_Juridical.Id = tmpObject.JuridicalId
                                    
       WHERE (tmpEnumEmail.EmailId = inEmailId OR inEmailId = 0)
         AND (Object_Email.isErased = False OR inIsShowAll = TRUE)
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.16         * add zc_ObjectLink_EmailSettings_Juridical, inIsShowAll
 28.06.16         *
 03.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmailSettings (0, FALSE, '2')




select * from gpSelect_Object_EmailSettings(inEmailId := 0 , inisShowAll := 'False' ,  inSession := '3');