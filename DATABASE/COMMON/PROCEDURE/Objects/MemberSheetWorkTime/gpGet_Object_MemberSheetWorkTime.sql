-- Function: gpGet_Object_MemberSheetWorkTime()

DROP FUNCTION IF EXISTS gpGet_Object_MemberSheetWorkTime (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberSheetWorkTime(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitName TVarChar
             , MemberId Integer, MemberName TVarChar
             , Comment TVarChar)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberSheetWorkTime());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
          SELECT CAST (0 AS Integer)    AS Id
               , CAST (0 AS Integer)    AS UnitIdId
               , CAST ('' AS TVarChar)  AS UnitName
               , CAST (0 AS Integer)    AS MemberId
               , CAST ('' AS TVarChar)  AS MemberName
               , CAST ('' AS TVarChar)  AS Comment;
   ELSE
       RETURN QUERY
          SELECT Object_MemberSheetWorkTime.Id         AS Id
               , Object_Unit.Id                        AS UnitId
               , Object_Unit.ValueData                 AS UnitName
               , Object_Member.Id                      AS MemberId
               , Object_Member.ValueData               AS MemberName         
               , ObjectString_Comment.ValueData        AS Comment
          FROM Object AS Object_MemberSheetWorkTime
               LEFT JOIN ObjectString AS ObjectString_Comment
                                      ON ObjectString_Comment.ObjectId = Object_MemberSheetWorkTime.Id
                                     AND ObjectString_Comment.DescId  = zc_ObjectString_MemberSheetWorkTime_Comment()
    
               LEFT JOIN ObjectLink AS ObjectLink_MemberSheetWorkTime_Unit
                                    ON ObjectLink_MemberSheetWorkTime_Unit.ObjectId = Object_MemberSheetWorkTime.Id
                                   AND ObjectLink_MemberSheetWorkTime_Unit.DescId = zc_ObjectLink_MemberSheetWorkTime_Unit()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_MemberSheetWorkTime_Unit.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_MemberSheetWorkTime_Member
                                    ON ObjectLink_MemberSheetWorkTime_Member.ObjectId = Object_MemberSheetWorkTime.Id
                                   AND ObjectLink_MemberSheetWorkTime_Member.DescId = zc_ObjectLink_MemberSheetWorkTime_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberSheetWorkTime_Member.ChildObjectId
    
           WHERE Object_MemberSheetWorkTime.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.04.18         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberSheetWorkTime (0, '2')
