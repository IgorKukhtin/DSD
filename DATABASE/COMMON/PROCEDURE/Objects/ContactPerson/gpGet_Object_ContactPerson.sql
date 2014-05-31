-- Function: gpGet_Object_ContactPerson (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContactPerson (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContactPerson(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar, Mail TVarChar, Comment TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
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
         
           , Object_Object.Id                    AS ObjectId
           , Object_Object.ObjectCode            AS ObjectCode
           , Object_Object.ValueData             AS ObjectName
         
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
                                                             
            LEFT JOIN ObjectLink AS ContactPerson_Object 
                                 ON ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                AND ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
            LEFT JOIN Object AS Object_Object ON Object_Object.Id = ContactPerson_Object.ChildObjectId
            
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
