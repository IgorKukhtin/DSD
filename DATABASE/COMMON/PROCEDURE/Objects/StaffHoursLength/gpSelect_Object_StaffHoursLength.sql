-- Function: gpSelect_Object_StaffHoursLength()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffHoursLength(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffHoursLength(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffHoursLength());

     RETURN QUERY 
     SELECT 
           Object_StaffHoursLength.Id              AS Id
         , Object_StaffHoursLength.ObjectCode      AS Code
         , Object_StaffHoursLength.ValueData       AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_StaffHoursLength.isErased        AS isErased
     FROM Object AS Object_StaffHoursLength
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffHoursLength.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffHoursLength_Comment()  
     WHERE Object_StaffHoursLength.DescId = zc_Object_StaffHoursLength()

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
-- SELECT * FROM gpSelect_Object_StaffHoursLength (zfCalc_UserAdmin())