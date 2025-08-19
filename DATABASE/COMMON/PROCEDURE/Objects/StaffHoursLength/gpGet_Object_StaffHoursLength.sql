-- Function: gpGet_Object_StaffHoursLength()

DROP FUNCTION IF EXISTS gpGet_Object_StaffHoursLength(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StaffHoursLength(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StaffHoursLength());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StaffHoursLength()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_StaffHoursLength.Id                 AS Id 
         , Object_StaffHoursLength.ObjectCode         AS Code
         , Object_StaffHoursLength.ValueData          AS Name
         , ObjectString_Comment.ValueData    AS Comment
         , Object_StaffHoursLength.isErased           AS isErased
     FROM OBJECT AS Object_StaffHoursLength
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffHoursLength.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffHoursLength_Comment()   
       WHERE Object_StaffHoursLength.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.08.25         *
*/

-- тест
-- SELECT * FROM gpGet_Object_StaffHoursLength(0, '2')