-- Function: gpSelect_Object_UnitSheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitSheetWorkTime (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitSheetWorkTime(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentName TVarChar,
               BranchId Integer, BranchName TVarChar,
               SheetWorkTimeName TVarChar,
               isLeaf Boolean, isErased Boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
   -- DECLARE vbAccessKeyAll Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbMemberId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
    vbUserId:= lpGetUserBySession (inSession);

    -- ����� ���������
    IF EXISTS (SELECT UserId 
               FROM ObjectLink_UserRole_View 
               WHERE UserId = vbUserId 
                 AND RoleId IN (zc_Enum_Role_Admin()
                              , 14473   -- �������� ���� ������������
                              , 6879542 -- �������� - ������ ����� �. ������� (������ ������)
                              , 447972  -- �������� ��
                               ))
    THEN
        vbMemberId:= 0;
    ELSE
        vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId
                      FROM ObjectLink AS ObjectLink_User_Member
                      WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                        AND ObjectLink_User_Member.ObjectId = vbUserId
                     );
                   /*(SELECT ObjectLink_User_Member.ChildObjectId
                      FROM ObjectLink AS ObjectLink_User_Member
                      WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                        AND ObjectLink_User_Member.ObjectId = vbUserId
                         AND vbUserId NOT IN (439994 -- ������ �.�.
                                            , 300527 -- ����������� �.�.
                                            , 439923 -- ��������� �.�.
                                            , 439925 -- ������� �.�.
                                             )
                     UNION
                      SELECT ObjectLink_User_Member.ChildObjectId
                      FROM ObjectLink AS ObjectLink_User_Member
                      WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                        AND ObjectLink_User_Member.ObjectId = CASE WHEN vbUserId = 439994 -- ������ �.�.
                                                                        THEN 439613 -- ��������� �.�.
                                                                   WHEN vbUserId = 300527 -- ����������� �.�.
                                                                        THEN 300523 -- ������� �.�.
                                                                   WHEN vbUserId IN (439923, 439925) -- ��������� �.�. + ������� �.�.
                                                                        THEN 439917 -- ��������� �.�.
                                                              END
                        AND vbUserId IN (439994 -- ������ �.�.
                                       , 300527 -- ����������� �.�.
                                       , 439923 -- ��������� �.�.
                                       , 439925 -- ������� �.�.
                                        )
                     )*/
                      ;
    END IF;

    RETURN QUERY
        WITH tmpList AS (
                         /*SELECT DISTINCT 
                                ObjectLink.ObjectId AS UnitId
                         FROM ObjectLink
                              LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = ObjectLink.ChildObjectId
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                         WHERE ObjectLink.DescId = zc_ObjectLink_Unit_PersonalSheetWorkTime()
                           AND ( ObjectLink_Personal_Member.ChildObjectId = vbMemberId 
                              OR vbMemberId = 0)*/
                         SELECT DISTINCT ObjectLink_Unit.ChildObjectId AS UnitId
                         FROM ObjectLink
                              INNER JOIN ObjectLink AS ObjectLink_Unit
                                                    ON ObjectLink_Unit.ObjectId = ObjectLink.ObjectId
                                                   AND ObjectLink_Unit.DescId   = zc_ObjectLink_MemberSheetWorkTime_Unit()
                              INNER JOIN Object ON Object.Id       = ObjectLink.ObjectId
                                               AND Object.isErased = FALSE
                         WHERE ObjectLink.DescId        = zc_ObjectLink_MemberSheetWorkTime_Member()
                           AND (ObjectLink.ChildObjectId = vbMemberId
                             OR vbMemberId = 0)
                        )
        SELECT
            Object_Unit.Id                     AS UnitId
          , Object_Unit.Code                   AS UnitCode
          , Object_Unit.Name                   AS UnitName
          , COALESCE (Object_Unit.ParentId, 0) AS ParentId
          , Object_Unit.ParentName             AS ParentName
          , Object_Unit.BranchId               AS BranchId
          , Object_Unit.BranchName             AS BranchName
          , Object_SheetWorkTime.ValueData     AS SheetWorkTimeName
          , Object_Unit.isLeaf
          , Object_Unit.isErased
        FROM (SELECT DISTINCT 
                  ChildObjectId AS UnitId 
              FROM ObjectLink 
              WHERE DescId = zc_ObjectLink_StaffList_Unit() 
                AND ChildObjectId > 0 
                AND vbMemberId = 0

             UNION
              SELECT tmpList.UnitId FROM tmpList

             ) AS ObjectLink_StaffList_Unit

            LEFT JOIN Object_Unit_View AS Object_Unit 
                                       ON Object_Unit.Id = ObjectLink_StaffList_Unit.UnitId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                                 ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
            LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId
            ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 16.11.16         * add SheetWorkTimeName
 27.11.15                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_UnitSheetWorkTime (zfCalc_UserAdmin())
