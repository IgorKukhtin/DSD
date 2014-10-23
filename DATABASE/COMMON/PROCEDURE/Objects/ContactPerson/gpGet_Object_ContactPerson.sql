-- Function: gpGet_Object_ContactPerson (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContactPerson (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_ContactPerson (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContactPerson(
    IN inId                     Integer,       -- ключ объекта <>
    IN inPartnerId              Integer ,
    IN inContactPersonKindId    Integer ,
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar, Mail TVarChar, Comment TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContactId Integer, ContacttName TVarChar
             , ContactPersonKindId Integer, ContactPersonKindName TVarChar
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

           , inPartnerId                           AS PartnerId
           , lfGet_Object_ValueData (inPartnerId)  AS PartnerName
          
  
           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName
    
           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName

           , inContactPersonKindId                           AS ContactPersonKindId
           , lfGet_Object_ValueData (inContactPersonKindId)  AS ContactPersonKindName

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
                                                             
            LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                 ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
            LEFT JOIN Object AS ContactPerson_Object ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
            LEFT JOIN Object AS Object_ContactPersonKind ON Object_ContactPersonKind.Id = ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId
                               
       WHERE Object_ContactPerson.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_ContactPerson (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_ContactPerson (0,  inPartnerId:= 83665 , inContactPersonKindId := 153273 ,  inSession := '5')
