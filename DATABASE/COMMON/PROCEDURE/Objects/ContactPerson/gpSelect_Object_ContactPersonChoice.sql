-- Function: gpSelect_Object_ContactPersonChoice (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContactPersonChoice ( Integer , Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContactPersonChoice(
    IN inPartnerId              Integer ,
    IN inContactPersonKindId    Integer ,
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar, Mail TVarChar, Comment TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , ContactPersonKindId Integer, ContactPersonKindName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContactPersonChoice());
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
         

           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Partner() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS PartnerId
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Partner() THEN ContactPerson_Object.ValueData                   
                 ELSE ''::TVarChar
             END                                 AS PartnerName

           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Juridical() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS JuridicalId
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Juridical() THEN ContactPerson_Object.ValueData                   
                 ELSE ''::TVarChar
             END                                 AS JuridicalName

           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Contract() THEN ContactPerson_Object.Id                   
                 ELSE 0
             END                                 AS ContractId
           , CASE ContactPerson_Object.DescId
                 WHEN zc_Object_Contract() THEN ContactPerson_Object.ValueData                   
                 ELSE ''::TVarChar
             END                                 AS ContractName

           , Object_ContactPersonKind.Id         AS ContactPersonKindId
           , Object_ContactPersonKind.ValueData  AS ContactPersonKindName

           
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
                                                             
            JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                 ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
            JOIN Object AS ContactPerson_Object ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                                    AND ContactPerson_Object.DescId = zc_Object_Partner()
                                                    AND (ContactPerson_Object.Id = inPartnerId OR inPartnerId = 0)
            
            JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND (ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = inContactPersonKindId OR inContactPersonKindId = 0)
            LEFT JOIN Object AS Object_ContactPersonKind ON Object_ContactPersonKind.Id = ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId
            
     WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
       --AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_ContactPersonChoice(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.14         * 
        
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContactPersonChoice (258836, 153273 , zfCalc_UserAdmin())