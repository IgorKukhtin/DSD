-- Function: gpGet_Object_StaffHoursDay()

DROP FUNCTION IF EXISTS gpGet_Object_StaffHoursDay(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StaffHoursDay(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StaffHoursDay());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StaffHoursDay()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_StaffHoursDay.Id                 AS Id 
         , Object_StaffHoursDay.ObjectCode         AS Code
         , Object_StaffHoursDay.ValueData          AS Name
         , ObjectString_Comment.ValueData    AS Comment
         , Object_StaffHoursDay.isErased           AS isErased
     FROM OBJECT AS Object_StaffHoursDay
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffHoursDay.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffHoursDay_Comment()   
       WHERE Object_StaffHoursDay.Id = inId;
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
-- SELECT * FROM gpGet_Object_StaffHoursDay(0, '2')