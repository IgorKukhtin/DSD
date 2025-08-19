-- Function: gpSelect_Object_StaffHours()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffHours(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffHours(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffHours());

     RETURN QUERY 
     SELECT 
           Object_StaffHours.Id              AS Id
         , Object_StaffHours.ObjectCode      AS Code
         , Object_StaffHours.ValueData       AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_StaffHours.isErased        AS isErased
     FROM Object AS Object_StaffHours
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffHours.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffHours_Comment()  
     WHERE Object_StaffHours.DescId = zc_Object_StaffHours()

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
-- SELECT * FROM gpSelect_Object_StaffHours (zfCalc_UserAdmin())