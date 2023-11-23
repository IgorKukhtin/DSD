-- Function: gpGet_Object_SubjectDoc()

DROP FUNCTION IF EXISTS gpGet_Object_SubjectDoc(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SubjectDoc(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Short TVarChar
             , ReasonId Integer, ReasonName TVarChar
             , MovementDesc TVarChar
             , Comment TVarChar
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_SubjectDoc()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Short
           , CAST (0 as Integer)    AS ReasonId
           , CAST ('' as TVarChar)  AS ReasonName 
           , CAST ('' as TVarChar)  AS MovementDesc
           , CAST ('' as TVarChar)  AS Comment
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_SubjectDoc.Id         AS Id
           , Object_SubjectDoc.ObjectCode AS Code
           , Object_SubjectDoc.ValueData  AS Name
           , ObjectString_Short.ValueData ::TVarChar AS Short
           , Object_Reason.Id             AS ReasonId
           , Object_Reason.ValueData      AS ReasonName
           , ObjectString_MovementDesc.ValueData ::TVarChar AS MovementDesc
           , ObjectString_Comment.ValueData      ::TVarChar AS Comment
       FROM Object AS Object_SubjectDoc
           LEFT JOIN ObjectString AS ObjectString_Short
                                  ON ObjectString_Short.ObjectId = Object_SubjectDoc.Id 
                                 AND ObjectString_Short.DescId = zc_ObjectString_SubjectDoc_Short() 
           LEFT JOIN ObjectString AS ObjectString_MovementDesc
                                  ON ObjectString_MovementDesc.ObjectId = Object_SubjectDoc.Id 
                                 AND ObjectString_MovementDesc.DescId = zc_ObjectString_SubjectDoc_MovementDesc()
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_SubjectDoc.Id 
                                 AND ObjectString_Comment.DescId = zc_ObjectString_SubjectDoc_Comment()

           LEFT JOIN ObjectLink AS ObjectLink_Reason
                                ON ObjectLink_Reason.ObjectId = Object_SubjectDoc.Id 
                               AND ObjectLink_Reason.DescId = zc_ObjectLink_SubjectDoc_Reason()
           LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = ObjectLink_Reason.ChildObjectId
       WHERE Object_SubjectDoc.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.23         *
 06.02.20         *

*/

-- тест
-- SELECT * FROM gpGet_Object_SubjectDoc (0, '2')