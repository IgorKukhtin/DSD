-- Function: gpSelect_Object_ContactPerson (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContactPerson (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContactPerson(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar, Mail TVarChar, Comment TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , ContactPersonKindId Integer, ContactPersonKindCode Integer, ContactPersonKindName TVarChar
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
       SELECT 
             Object_ContactPerson.Id          AS Id
           , Object_ContactPerson.ObjectCode  AS Code
           , Object_ContactPerson.ValueData   AS Name
           
           , ObjectString_Phone.ValueData     AS Phone
           , ObjectString_Mail.ValueData      AS Mail
           , ObjectString_Comment.ValueData   AS Comment 
         
           , Object_Object.Id                    AS ObjectId
           , Object_Object.ObjectCode            AS ObjectCode
           , Object_Object.ValueData             AS ObjectName
         
           , Object_ContactPersonKind.Id         AS ContactPersonKindId
           , Object_ContactPersonKind.ObjectCode AS ContactPersonKindCode
           , Object_ContactPersonKind.ValueData  AS ContactPersonKindName

           , View_ContactPersonKind.PersonalId   AS ContactPersonKindId
           , View_ContactPersonKind.PersonalCode AS ContactPersonKindCode
           , View_ContactPersonKind.PersonalName AS ContactPersonKindName
           
           , Object_ContactPerson.isErased    AS isErased
           
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
                                                             
            LEFT JOIN ObjectLink AS ContactPerson_Object 
                                 ON ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
            LEFT JOIN Object AS Object_Object ON Object_Object.Id = ContactPerson_Object.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
            LEFT JOIN Object AS Object_ContactPersonKind ON Object_ContactPersonKind.Id = ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId
            
     WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
       --AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContactPerson(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14          * 
        
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContactPerson (zfCalc_UserAdmin())