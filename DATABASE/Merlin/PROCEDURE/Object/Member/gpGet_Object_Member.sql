-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,       --  
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , EMail TVarChar
               ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Member()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Comment
           , CAST ('' as TVarChar)  AS EMail
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Member.Id               AS Id
           , Object_Member.ObjectCode       AS Code
           , Object_Member.ValueData        AS Name
           , ObjectString_Comment.ValueData AS Comment
           , ObjectString_EMail.ValueData   AS EMail       
       FROM Object AS Object_Member
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Member.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()
        LEFT JOIN ObjectString AS ObjectString_EMail
                               ON ObjectString_EMail.ObjectId = Object_Member.Id
                              AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()                      
       WHERE Object_Member.Id = inId;
   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.22         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Member (1, zfCalc_UserAdmin())
