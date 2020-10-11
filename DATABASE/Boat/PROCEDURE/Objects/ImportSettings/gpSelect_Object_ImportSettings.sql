-- Function: gpSelect_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               FileTypeId Integer, FileTypeName TVarChar,
               ImportTypeId Integer, ImportTypeName TVarChar,
               StartRow Integer, HDR Boolean, 
               Directory TVarChar, Query TBlob,
               StartTime TVarChar, EndTime TVarChar, CheckTime TFloat,
               ContactPersonId Integer, ContactPersonName TVarChar,
               ContactPersonMail TVarChar,
               EmailId Integer, EmailName TVarChar,
               EmailKindId Integer, EmailKindName TVarChar,
               isMultiLoad Boolean,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportSettings());

   RETURN QUERY 
       SELECT 
             Object_ImportSettings_View.Id
           , Object_ImportSettings_View.Code
           , Object_ImportSettings_View.Name
         
           , Object_ImportSettings_View.JuridicalId
           , Object_ImportSettings_View.JuridicalName 
                     
           , Object_ImportSettings_View.ContractId
           , Object_ImportSettings_View.ContractName 
           
           , Object_ImportSettings_View.FileTypeId
           , Object_ImportSettings_View.FileTypeName 
           
           , Object_ImportSettings_View.ImportTypeId
           , Object_ImportSettings_View.ImportTypeName 

           , Object_ImportSettings_View.StartRow
           , Object_ImportSettings_View.HDR
           , Object_ImportSettings_View.Directory
           , Object_ImportSettings_View.Query 

           , (CASE WHEN COALESCE(ObjectDate_StartTime.ValueData, zc_DateStart()) <> zc_DateStart() THEN (ObjectDate_StartTime.ValueData:: Time) END)   ::TVarChar  AS StartTime
           , (CASE WHEN COALESCE(ObjectDate_EndTime.ValueData, zc_DateStart()) <> zc_DateStart() THEN (ObjectDate_EndTime.ValueData:: Time) END)   ::TVarChar  AS EndTime
           , ObjectFloat_Time.ValueData         AS CheckTime
           , Object_ContactPerson.Id            AS ContactPersonId
           , Object_ContactPerson.ValueData     AS ContactPersonName
           , COALESCE(ObjectString_Mail.ValueData,'')::TVarChar  AS ContactPersonMail

           , Object_Email.Id             AS EmailId
           , Object_Email.ValueData      AS EmailName
           , Object_EmailKind.Id         AS EmailKindId
           , Object_EmailKind.ValueData  AS EmailKindName

           , COALESCE (ObjectBoolean_MultiLoad.ValueData, FALSE) :: Boolean AS isMultiLoad

           , Object_ImportSettings_View.isErased
           
       FROM Object_ImportSettings_View
           LEFT JOIN ObjectBoolean AS ObjectBoolean_MultiLoad
                                   ON ObjectBoolean_MultiLoad.ObjectId = Object_ImportSettings_View.Id
                                  AND ObjectBoolean_MultiLoad.DescId   = zc_ObjectBoolean_ImportSettings_MultiLoad()

           LEFT JOIN ObjectDate AS ObjectDate_StartTime 
                                ON ObjectDate_StartTime.ObjectId = Object_ImportSettings_View.Id
                               AND ObjectDate_StartTime.DescId = zc_ObjectDate_ImportSettings_StartTime()
           LEFT JOIN ObjectDate AS ObjectDate_EndTime 
                                ON ObjectDate_EndTime.ObjectId = Object_ImportSettings_View.Id
                               AND ObjectDate_EndTime.DescId = zc_ObjectDate_ImportSettings_EndTime()
           LEFT JOIN ObjectFloat AS ObjectFloat_Time
                                 ON ObjectFloat_Time.ObjectId = Object_ImportSettings_View.Id
                                AND ObjectFloat_Time.DescId = zc_ObjectFloat_ImportSettings_Time()
           
           LEFT JOIN ObjectLink AS ObjectLink_ImportSettings_ContactPerson
                                ON ObjectLink_ImportSettings_ContactPerson.ObjectId = Object_ImportSettings_View.Id
                               AND ObjectLink_ImportSettings_ContactPerson.DescId = zc_ObjectLink_ImportSettings_ContactPerson()
           LEFT JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = ObjectLink_ImportSettings_ContactPerson.ChildObjectId   
           LEFT JOIN ObjectString AS ObjectString_Mail
                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()

           LEFT JOIN ObjectLink AS ObjectLink_ImportSettings_Email
                                ON ObjectLink_ImportSettings_Email.ObjectId = Object_ImportSettings_View.Id
                               AND ObjectLink_ImportSettings_Email.DescId = zc_ObjectLink_ImportSettings_Email()
           LEFT JOIN Object AS Object_Email ON Object_Email.Id = ObjectLink_ImportSettings_Email.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Email_EmailKind
                                ON ObjectLink_Email_EmailKind.ObjectId = Object_Email.Id
                               AND ObjectLink_Email_EmailKind.DescId = zc_ObjectLink_Email_EmailKind()
           LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_Email_EmailKind.ChildObjectId
          ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportSettings (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.03.16         *
 02.07.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportSettings ('2')
