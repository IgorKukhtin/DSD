-- Function: gpGet_Object_MemberPersonalServiceList()

DROP FUNCTION IF EXISTS gpGet_Object_MemberPersonalServiceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberPersonalServiceList(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , MemberId Integer, MemberName TVarChar
             , Comment TVarChar
             , isAll Boolean)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberPersonalServiceList());
   IF COALESCE (inId,0) = -1
   THEN
        RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
          SELECT CAST (0 AS Integer)     AS Id
               , CAST (0 AS Integer)     AS PersonalServiceListIdId
               , CAST ('' AS TVarChar)   AS PersonalServiceListName
               , CAST (0 AS Integer)     AS MemberId
               , CAST ('' AS TVarChar)   AS MemberName
               , CAST ('' AS TVarChar)   AS Comment
               , CAST (FALSE AS Boolean) AS isAll;
   ELSE
       RETURN QUERY
          SELECT Object_MemberPersonalServiceList.Id         AS Id
               , Object_PersonalServiceList.Id                        AS PersonalServiceListId
               , Object_PersonalServiceList.ValueData                 AS PersonalServiceListName
               , Object_Member.Id                      AS MemberId
               , Object_Member.ValueData               AS MemberName         
               , ObjectString_Comment.ValueData        AS Comment
               , ObjectBoolean_All.ValueData           AS isAll
          FROM Object AS Object_MemberPersonalServiceList
               LEFT JOIN ObjectString AS ObjectString_Comment
                                      ON ObjectString_Comment.ObjectId = Object_MemberPersonalServiceList.Id
                                     AND ObjectString_Comment.DescId  = zc_ObjectString_MemberPersonalServiceList_Comment()

               LEFT JOIN ObjectBoolean AS ObjectBoolean_All
                                       ON ObjectBoolean_All.ObjectId = Object_MemberPersonalServiceList.Id
                                      AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberPersonalServiceList_All()

               LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                    ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                   AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                    ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                   AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
               LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberPersonalServiceList_Member.ChildObjectId
    
           WHERE Object_MemberPersonalServiceList.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.07.18         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberPersonalServiceList (0, '2')
