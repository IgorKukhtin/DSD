-- Function: gpGet_Object_ContactPerson (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContactPerson (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContactPerson(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar, Mail TVarChar, Comment TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContactId Integer, ContactCode Integer, ContacttName TVarChar
             , ContactPersonKindId Integer, ContactPersonKindCode Integer, ContactPersonKindName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContactPerson());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_ContactPerson.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS Phone
           , CAST ('' as TVarChar)  AS Mail
           , CAST ('' as TVarChar)  AS Comment

           , CAST (0 as Integer)    AS PartnerId
           , CAST (0 as Integer)    AS PartnerCode
           , CAST ('' as TVarChar)  AS PartnerName
  
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (0 as Integer)    AS ObjectId
           , CAST (0 as Integer)    AS ObjectCode
           , CAST ('' as TVarChar)  AS ObjectName
        
           , CAST (0 as Integer)    AS ContactPersonKindId
           , CAST (0 as Integer)    AS ContactPersonKindCode
           , CAST ('' as TVarChar)  AS ContactPersonKindName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_ContactPerson
       WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContactPerson.Id          AS Id
           , Object_ContactPerson.ObjectCode  AS Code
           , Object_ContactPerson.ValueData   AS Name
           
           , ObjectString_Phone.ValueData     AS Phone
           , ObjectString_Mail.ValueData      AS Mail
           , ObjectString_Comment.ValueData   AS Comment 
         
           , Object_Partner.Id                   AS PartnerId
           , Object_Partner.ObjectCode           AS PartnerCode
           , Object_Partner.ValueData            AS PartnerName

           , Object_Juridical.Id                   AS JuridicalId
           , Object_Juridical.ObjectCode           AS JuridicalCode
           , Object_Juridical.ValueData            AS JuridicalName

           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ObjectCode           AS ContractCode
           , Object_Contract.ValueData            AS ContractName

           , Object_ContactPersonKind.Id         AS ContactPersonKindId
           , Object_ContactPersonKind.ObjectCode AS ContactPersonKindCode
           , Object_ContactPersonKind.ValueData  AS ContactPersonKindName

           , View_ContactPersonKind.PersonalId   AS ContactPersonKindId
           , View_ContactPersonKind.PersonalCode AS ContactPersonKindCode
           , View_ContactPersonKind.PersonalName AS ContactPersonKindName
           
           , Object_ContactPerson.isErased AS isErased
           
       FROM Object AS Object_ContactPerson
       
            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                  AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
            LEFT JOIN ObjectString AS ObjectString_Mail
                                   ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                  AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_ContactPerson.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ContactPerson_Comment()
                                                             
            LEFT JOIN ObjectLink AS ContactPerson_Partner 
                                 ON ContactPerson_Partner.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_Partner.DescId = zc_ObjectLink_ContactPerson_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ContactPerson_Partner.ChildObjectId

            LEFT JOIN ObjectLink AS ContactPerson_Contract 
                                 ON ContactPerson_Contract.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_Contract.DescId = zc_ObjectLink_ContactPerson_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ContactPerson_Contract.ChildObjectId         
            
            LEFT JOIN ObjectLink AS ContactPerson_Juridical 
                                 ON ContactPerson_Juridical.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_Juridical.DescId = zc_ObjectLink_ContactPerson_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ContactPerson_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
            LEFT JOIN Object AS Object_ContactPersonKind ON Object_ContactPersonKind.Id = ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId
                               
       WHERE Object_ContactPerson.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ContactPerson (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_ContactPerson (2, '')
