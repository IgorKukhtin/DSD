-- Function: gpSelect_Object_MemberPersonalServiceList()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberPersonalServiceList(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberPersonalServiceList(
    IN inSession     TVarChar       -- ������ ������������
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
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberPersonalServiceList());
     vbUserId:= lpGetUserBySession (inSession);

   -- ���������
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
                   
           , ObjectString_Comment.ValueData              AS Comment
           , ObjectBoolean_All.ValueData                 AS isAll
           , Object_MemberPersonalServiceList.isErased   AS isErased

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

           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
           LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = tmpPersonal.UnitId
           LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
            
   WHERE Object_MemberPersonalServiceList.DescId = zc_Object_MemberPersonalServiceList();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 05.07.18         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_MemberPersonalServiceList ('2')
