-- Function: gpSelect_Object_MemberSheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberSheetWorkTime(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberSheetWorkTime(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , UnitCode_Personal Integer, UnitName_Personal TVarChar
             , BranchName_Personal TVarChar
             , PositionName_Personal TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberSheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
      WITH
          tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.UnitId
                               , lfSelect.PositionId
                               , lfSelect.BranchId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )

      SELECT Object_MemberSheetWorkTime.Id         AS Id
           , Object_Unit.Id                        AS UnitId
           , Object_Unit.ObjectCode                AS UnitCode
           , Object_Unit.ValueData                 AS UnitName
           , Object_Member.Id                      AS MemberId
           , Object_Member.ObjectCode              AS MemberCode
           , Object_Member.ValueData               AS MemberName 

           , Object_Unit_Personal.ObjectCode       AS UnitCode_Personal
           , Object_Unit_Personal.ValueData        AS UnitName_Personal
           , Object_Branch.ValueData               AS BranchName_Personal
           , Object_Position.ValueData             AS PositionName_Personal
                   
           , ObjectString_Comment.ValueData        AS Comment
           , Object_MemberSheetWorkTime.isErased   AS isErased
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

           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
           LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = tmpPersonal.UnitId
           LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
            
   WHERE Object_MemberSheetWorkTime.DescId = zc_Object_MemberSheetWorkTime();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 18.04.18         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberSheetWorkTime ('2')
