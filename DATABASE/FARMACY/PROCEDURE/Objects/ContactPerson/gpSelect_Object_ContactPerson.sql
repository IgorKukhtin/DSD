-- Function: gpSelect_Object_ContactPerson (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContactPerson (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContactPerson(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar, Mail TVarChar, Comment TVarChar
             , Partner_ObjectId Integer, Partner_ObjectName TVarChar
             , Juridical_ObjectId Integer, Juridical_ObjectName TVarChar
             , Contract_ObjectId Integer, Contract_ObjectName TVarChar
             , Unit_ObjectId Integer, Unit_ObjectName TVarChar
             , ContactPersonKindId Integer, ContactPersonKindName TVarChar
             , EmailId Integer, EmailName TVarChar
             , EmailKindId Integer, EmailKindName TVarChar
             , RetailId Integer, RetailName TVarChar
             , AreaId Integer, AreaName TVarChar, AreaName_Mail TVarChar
             , UnitId Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContactPerson());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       WITH tmpImportSettings AS (SELECT ObjectLink_ImportSettings_ContactPerson.ChildObjectId AS ContactPersonId
                                       , ObjectLink_ImportSettings_Email.ChildObjectId         AS EmailId
                                  FROM ObjectLink AS ObjectLink_ImportSettings_ContactPerson
                                       INNER JOIN Object AS Object_ImportSettings ON Object_ImportSettings.Id = ObjectLink_ImportSettings_ContactPerson.ObjectId AND Object_ImportSettings.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_ImportSettings_Email
                                                             ON ObjectLink_ImportSettings_Email.ObjectId = ObjectLink_ImportSettings_ContactPerson.ObjectId
                                                            AND ObjectLink_ImportSettings_Email.DescId = zc_ObjectLink_ImportSettings_Email()
                                  WHERE ObjectLink_ImportSettings_ContactPerson.ChildObjectId > 0
                                    AND ObjectLink_ImportSettings_ContactPerson.DescId = zc_ObjectLink_ImportSettings_ContactPerson()
                                 )
       SELECT 
             Object_ContactPerson.Id          AS Id
           , Object_ContactPerson.ObjectCode  AS Code
           , Object_ContactPerson.ValueData   AS Name
           
           , ObjectString_Phone.ValueData     AS Phone
           , ObjectString_Mail.ValueData      AS Mail
           , ObjectString_Comment.ValueData   AS Comment 
         

           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Partner() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS Partner_ObjectId
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Partner() THEN ContactPerson_Object.ValueData                   
                 ELSE ''::TVarChar
             END                                 AS Partner_ObjectName

           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Juridical() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS Juridical_ObjectId
           , CASE WHEN COALESCE (Object_Juridical.Id, 0) <> 0 
                  THEN Object_Juridical.ValueData
                  ELSE
                      CASE ContactPerson_Object.DescId
                          WHEN zc_Object_Juridical() THEN ContactPerson_Object.ValueData                   
                          ELSE ''::TVarChar
                      END
             END                                 AS Juridical_ObjectName
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Contract() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS Contract_ObjectId
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Contract() THEN ContactPerson_Object.ValueData                   
                 ELSE ''::TVarChar
             END                                 AS Contract_ObjectName

           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Unit() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS Unit_ObjectId
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Unit() THEN ContactPerson_Object.ValueData                   
                 ELSE ''::TVarChar
             END                                 AS Unit_ObjectName

           , Object_ContactPersonKind.Id         AS ContactPersonKindId
           , Object_ContactPersonKind.ValueData  AS ContactPersonKindName

           , Object_Email.Id             AS EmailId
           , (CASE WHEN tmpImportSettings.EmailId > 0 THEN '***' ELSE '' END || Object_Email.ValueData) :: TVarChar AS EmailName
           , Object_EmailKind.Id         AS EmailKindId
           , (CASE WHEN tmpImportSettings.EmailId > 0 THEN '***' ELSE '' END || Object_EmailKind.ValueData) :: TVarChar AS EmailKindName

           , Object_Retail.Id                    AS RetailId
           , Object_Retail.ValueData             AS RetailName 
           
           , Object_Area.Id                      AS AreaId
           , Object_Area.ValueData               AS AreaName 
           , Object_Area_Email.ValueData         AS AreaName_Mail
           
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName 

           , Object_ContactPerson.isErased       AS isErased
           
       FROM Object AS Object_ContactPerson
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_ContactPerson.AccessKeyId
       
            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                  AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
            LEFT JOIN ObjectString AS ObjectString_Mail
                                   ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                  AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_ContactPerson.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ContactPerson_Comment()
                                                             
            LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                 ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
            LEFT JOIN Object AS ContactPerson_Object ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
            LEFT JOIN Object AS Object_ContactPersonKind ON Object_ContactPersonKind.Id = ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_Email
                                 ON ObjectLink_ContactPerson_Email.ObjectId = Object_ContactPerson.Id
                                AND ObjectLink_ContactPerson_Email.DescId = zc_ObjectLink_ContactPerson_Email()
            LEFT JOIN tmpImportSettings ON tmpImportSettings.ContactPersonId = Object_ContactPerson.Id
                                       AND ObjectLink_ContactPerson_Email.ChildObjectId IS NULL
            LEFT JOIN Object AS Object_Email ON Object_Email.Id = COALESCE (ObjectLink_ContactPerson_Email.ChildObjectId, tmpImportSettings.EmailId)

            LEFT JOIN ObjectLink AS ObjectLink_Email_EmailKind
                                 ON ObjectLink_Email_EmailKind.ObjectId = Object_Email.Id
                                AND ObjectLink_Email_EmailKind.DescId = zc_ObjectLink_Email_EmailKind()
            LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_Email_EmailKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_Retail
                                 ON ObjectLink_ContactPerson_Retail.ObjectId = Object_ContactPerson.Id 
                                AND ObjectLink_ContactPerson_Retail.DescId = zc_ObjectLink_ContactPerson_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_ContactPerson_Retail.ChildObjectId
      
            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_Area
                                 ON ObjectLink_ContactPerson_Area.ObjectId = Object_ContactPerson.Id 
                                AND ObjectLink_ContactPerson_Area.DescId = zc_ObjectLink_ContactPerson_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_ContactPerson_Area.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Email_Area
                                 ON ObjectLink_Email_Area.ObjectId = Object_Email.Id 
                                AND ObjectLink_Email_Area.DescId = zc_ObjectLink_Email_Area()
            LEFT JOIN Object AS Object_Area_Email ON Object_Area_Email.Id = ObjectLink_Email_Area.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                 ON ObjectLink_Contract_Juridical.ObjectId = ContactPerson_Object.Id
                                AND ContactPerson_Object.DescId = zc_Object_Contract()
                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId 
                 
            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_Unit
                                 ON ObjectLink_ContactPerson_Unit.ObjectId = Object_ContactPerson.Id 
                                AND ObjectLink_ContactPerson_Unit.DescId = zc_ObjectLink_ContactPerson_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ContactPerson_Unit.ChildObjectId                           

     WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
       -- AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContactPerson(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.16         * add Object_Retail
 18.14.16         *
 31.05.14         * 
       
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContactPerson (zfCalc_UserAdmin())