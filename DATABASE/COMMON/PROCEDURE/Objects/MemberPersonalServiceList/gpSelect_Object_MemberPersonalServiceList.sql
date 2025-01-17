-- Function: gpSelect_Object_MemberPersonalServiceList()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberPersonalServiceList(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberPersonalServiceList(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalServiceListId Integer, PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , UnitCode_Personal Integer, UnitName_Personal TVarChar
             , BranchName_Personal TVarChar
             , PositionName_Personal TVarChar
             , Comment TVarChar
             , isAll Boolean
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberPersonalServiceList());
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
        , tmpMemberPersonalServiceList AS (SELECT Object_MemberPersonalServiceList.Id                                     AS Id
                                                , ObjectLink_MemberPersonalServiceList_PersonalServiceList.ChildObjectId  AS PersonalServiceListId
                                                , ObjectLink_MemberPersonalServiceList_Member.ChildObjectId               AS MemberId
                                                , Object_MemberPersonalServiceList.isErased                               AS isErased

                                                FROM Object AS Object_MemberPersonalServiceList
                                          
                                                     LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_PersonalServiceList
                                                                          ON ObjectLink_MemberPersonalServiceList_PersonalServiceList.ObjectId = Object_MemberPersonalServiceList.Id
                                                                         AND ObjectLink_MemberPersonalServiceList_PersonalServiceList.DescId = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                          
                                                     LEFT JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList_Member
                                                                          ON ObjectLink_MemberPersonalServiceList_Member.ObjectId = Object_MemberPersonalServiceList.Id
                                                                         AND ObjectLink_MemberPersonalServiceList_Member.DescId = zc_ObjectLink_MemberPersonalServiceList_Member()
                                                      
                                                WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
                                               )

      SELECT Object_MemberPersonalServiceList.Id         AS Id
           , Object_PersonalServiceList.Id               AS PersonalServiceListId
           , Object_PersonalServiceList.ObjectCode       AS PersonalServiceListCode
           , Object_PersonalServiceList.ValueData        AS PersonalServiceListName
           , Object_Member.Id                            AS MemberId
           , Object_Member.ObjectCode                    AS MemberCode
           , Object_Member.ValueData                     AS MemberName 

           , Object_Unit_Personal.ObjectCode             AS UnitCode_Personal
           , Object_Unit_Personal.ValueData              AS UnitName_Personal
           , Object_Branch.ValueData                     AS BranchName_Personal
           , Object_Position.ValueData                   AS PositionName_Personal
                   
           , (COALESCE (ObjectString_Comment.ValueData, '') || CASE WHEN Object_MemberPersonalServiceList.Id = 4153674 THEN '*' ELSE '' END) :: TVarChar AS Comment
           , ObjectBoolean_All.ValueData                 AS isAll
           , Object_MemberPersonalServiceList.isErased   AS isErased

      FROM tmpMemberPersonalServiceList AS Object_MemberPersonalServiceList
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_MemberPersonalServiceList.Id
                                 AND ObjectString_Comment.DescId  = zc_ObjectString_MemberPersonalServiceList_Comment()
 
           LEFT JOIN ObjectBoolean AS ObjectBoolean_All
                                   ON ObjectBoolean_All.ObjectId = Object_MemberPersonalServiceList.Id
                                  AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberPersonalServiceList_All()

           LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = Object_MemberPersonalServiceList.PersonalServiceListId
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = Object_MemberPersonalServiceList.MemberId

           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
           LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = tmpPersonal.UnitId
           LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
            
  -- WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList()
  UNION
   SELECT -1 AS Id
           , Object_PersonalServiceList.Id               AS PersonalServiceListId
           , Object_PersonalServiceList.ObjectCode       AS PersonalServiceListCode
           , Object_PersonalServiceList.ValueData        AS PersonalServiceListName
           , Object_Member.Id                            AS MemberId
           , Object_Member.ObjectCode                    AS MemberCode
           , Object_Member.ValueData                     AS MemberName 

           , Object_Unit_Personal.ObjectCode             AS UnitCode_Personal
           , Object_Unit_Personal.ValueData              AS UnitName_Personal
           , Object_Branch.ValueData                     AS BranchName_Personal
           , Object_Position.ValueData                   AS PositionName_Personal
                   
           , ''                              :: TVarChar AS Comment
           , FALSE                                       AS isAll
           , FALSE                                       AS isErased           
   FROM ObjectLink AS OL_PersonalServiceList_Member
        LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = OL_PersonalServiceList_Member.ObjectId
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = OL_PersonalServiceList_Member.ChildObjectId

        LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.MemberId = Object_Member.Id
                                              AND tmpMemberPersonalServiceList.PersonalServiceListId = Object_PersonalServiceList.Id

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = tmpPersonal.UnitId
        LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId

   WHERE OL_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
     AND COALESCE (OL_PersonalServiceList_Member.ObjectId,0) <> 0
     AND COALESCE (OL_PersonalServiceList_Member.ChildObjectId,0) <> 0
     AND tmpMemberPersonalServiceList.Id IS NULL
     
   ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 05.07.18         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberPersonalServiceList ('2')
