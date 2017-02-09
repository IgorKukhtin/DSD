-- Function: gpSelect_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_EmailSettings(Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_EmailSettings(
    IN inEmailKindId   Integer   ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Value TVarChar,
               EmailKindId Integer, EmailKindName TVarChar,
               EmailToolsId Integer, EmailToolsName TVarChar
               ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_EmailSettings());

   RETURN QUERY 
    WITH 
    tmpEmailKind AS (SELECT Object_EmailKind.Id           AS EmailKindId
                          , Object_EmailKind.ValueData    AS EmailKindName
                          , Object_EmailTools.Id          AS EmailToolsId
                          , Object_EmailTools.ValueData   AS EmailToolsName 
                     FROM Object AS Object_EmailKind
                         LEFT JOIN Object AS Object_EmailTools ON Object_EmailTools.DescId = zc_Object_EmailTools()
                     WHERE Object_EmailKind.DEscId = zc_Object_EmailKind()
                     )
  , tmpObject AS (SELECT Object_EmailSettings.Id             AS EmailSettingsId
                       , Object_EmailSettings.ObjectCode     AS EmailSettingsCode
                       , Object_EmailSettings.ValueData      AS EmailSettingsValue
                       , Object_EmailKind.Id                 AS EmailKindId
                       , Object_EmailKind.ValueData          AS EmailKindName
                       , Object_EmailTools.Id                AS EmailToolsId
                       , Object_EmailTools.ValueData         AS EmailToolsName 
                  FROM Object AS Object_EmailSettings
                    LEFT JOIN ObjectLink AS ObjectLink_EmailKind
                                         ON ObjectLink_EmailKind.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_EmailKind.DescId = zc_ObjectLink_EmailSettings_EmailKind()
                    LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_EmailKind.ChildObjectId

                    LEFT JOIN ObjectLink AS ObjectLink_EmailTools
                                         ON ObjectLink_EmailTools.ObjectId = Object_EmailSettings.Id
                                        AND ObjectLink_EmailTools.DescId = zc_ObjectLink_EmailSettings_EmailTools()
                    LEFT JOIN Object AS Object_EmailTools ON Object_EmailTools.Id = ObjectLink_EmailTools.ChildObjectId
                  WHERE Object_EmailSettings.DescId = zc_Object_EmailSettings()
                  )

       SELECT tmpObject.EmailSettingsId AS Id
            , tmpObject.EmailSettingsCode AS Code
            , tmpObject.EmailSettingsValue AS Value
            , tmpEmailKind.EmailKindId
            , tmpEmailKind.EmailKindName
            , tmpEmailKind.EmailToolsId
            , tmpEmailKind.EmailToolsName
             
       FROM tmpEmailKind
         LEFT JOIN tmpObject ON tmpObject.EmailKindId = tmpEmailKind.EmailKindId
                            AND tmpObject.EmailToolsId = tmpEmailKind.EmailToolsId
       WHERE tmpEmailKind.EmailKindId = inEmailKindId OR inEmailKindId = 0
;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= 0, inSession:= '5')
