-- Function: gpGet_Object_CFO()

DROP FUNCTION IF EXISTS gpGet_Object_CFO(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CFO(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MemberId Integer, MemberName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_CFO());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_CFO()) AS Code
           , CAST ('' as TVarChar)  AS Name  
           , NULL      ::Integer    AS MemberId
           , CAST ('' as TVarChar)  AS MemberName
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_CFO.Id                 AS Id 
         , Object_CFO.ObjectCode         AS Code
         , Object_CFO.ValueData          AS Name 
         , Object_Member.Id         ::Integer  AS MemberId
         , Object_Member.ValueData  ::TVarChar AS MemberName
         , ObjectString_Comment.ValueData      AS Comment
         , Object_CFO.isErased           AS isErased
     FROM OBJECT AS Object_CFO
          LEFT JOIN ObjectLink AS ObjectLink_CFO_Member
                               ON ObjectLink_CFO_Member.ObjectId = Object_CFO.Id
                              AND ObjectLink_CFO_Member.DescId = zc_ObjectLink_CFO_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_CFO_Member.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_CFO.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_CFO_Comment()   
       WHERE Object_CFO.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.25         *
*/

-- тест
-- SELECT * FROM gpGet_Object_CFO(0, '2')