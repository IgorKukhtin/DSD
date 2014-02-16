-- Function: gpSelect_Object_Personal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, MemberCode Integer, MemberName TVarChar,
               PositionId Integer, PositionCode Integer, PositionName TVarChar,
               PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar,
               DateIn TDateTime, DateOut TDateTime,
               isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- ���������
   RETURN QUERY 
     SELECT 
           Object_Personal_View.PersonalId   AS Id
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionCode
         , Object_Personal_View.PositionName

         , Object_Personal_View.PositionLevelId
         , Object_Personal_View.PositionLevelCode
         , Object_Personal_View.PositionLevelName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitCode
         , Object_Personal_View.UnitName

         , Object_Personal_View.PersonalGroupId
         , Object_Personal_View.PersonalGroupCode
         , Object_Personal_View.PersonalGroupName
 
         , Object_Personal_View.DateIn
         , Object_Personal_View.DateOut
         
         , Object_Personal_View.isErased
     FROM Object_Personal_View
          LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Object_Personal_View.AccessKeyId
     WHERE tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll
    ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Personal (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 21.11.13                                        * add PositionLevel...
 28.10.13                         * 
 30.09.13                                        * add Object_Personal_View
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business             
 19.07.13         *    rename zc_ObjectDate...               
 06.07.13                                        * error zc_ObjectLink_Personal_Juridical
 01.07.13         *              
*/
/*
UPDATE Object SET AccessKeyId = COALESCE (Object_Branch.AccessKeyId, (SELECT zc_Enum_Process_AccessKey_TrasportDnepr() WHERE EXISTS (SELECT 1 FROM ObjectLink as ObjectLink_ch WHERE ObjectLink_ch.DescId = zc_ObjectLink_Car_Unit() AND ObjectLink_ch.ChildObjectId = ObjectLink.ChildObjectId)))
FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink2 ON ObjectLink2.ObjectId = ObjectLink.ChildObjectId AND ObjectLink2.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink2.ChildObjectId WHERE ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Personal_Unit() AND Object.DescId = zc_Object_Personal();
*/
-- ����
-- SELECT * FROM gpSelect_Object_Personal (zfCalc_UserAdmin())