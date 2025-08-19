-- Function: gpSelect_Object_StaffHoursDay()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffHoursDay(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffHoursDay(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffHoursDay());

     RETURN QUERY 
     SELECT 
           Object_StaffHoursDay.Id              AS Id
         , Object_StaffHoursDay.ObjectCode      AS Code
         , Object_StaffHoursDay.ValueData       AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_StaffHoursDay.isErased        AS isErased
     FROM Object AS Object_StaffHoursDay
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffHoursDay.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffHoursDay_Comment()  
     WHERE Object_StaffHoursDay.DescId = zc_Object_StaffHoursDay()

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
         , '<ПУСТО>' :: TVarChar AS Name
         , ''        :: TVarChar AS Comment
         , FALSE                 AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.08.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StaffHoursDay (zfCalc_UserAdmin())