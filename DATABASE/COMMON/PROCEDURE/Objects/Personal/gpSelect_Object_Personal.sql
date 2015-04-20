-- Function: gpSelect_Object_Personal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsPeriod    Boolean   , --
    IN inIsShowAll   Boolean,    --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, MemberCode Integer, MemberName TVarChar, DriverCertificate TVarChar,
               PositionId Integer, PositionCode Integer, PositionName TVarChar,
               PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar,
               InfoMoneyId Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               DateIn TDateTime, DateOut TDateTime, isDateOut Boolean, isMain Boolean, isOfficial Boolean, isErased Boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
   DECLARE vbIsAllUnit Boolean;
   DECLARE vbObjectId_Constraint Integer;

   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   vbIsAllUnit:= NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId);

   -- ������������ ������� �������
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);


   -- ������������ ������
   SELECT View_InfoMoney.InfoMoneyId, View_InfoMoney.InfoMoneyName, View_InfoMoney.InfoMoneyName_all
          INTO vbInfoMoneyId, vbInfoMoneyName, vbInfoMoneyName_all
   FROM Object_InfoMoney_View AS View_InfoMoney
   WHERE View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101(); -- 60101 ���������� ����� + ���������� �����


   -- ���������
   RETURN QUERY 
     SELECT 
           Object_Personal_View.PersonalId   AS Id
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , ObjectString_DriverCertificate.ValueData AS DriverCertificate

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

         , vbInfoMoneyId       AS InfoMoneyId
         , vbInfoMoneyName     AS InfoMoneyName
         , vbInfoMoneyName_all AS InfoMoneyName_all
 
         , Object_Personal_View.DateIn
         , Object_Personal_View.DateOut_user AS DateOut
         , Object_Personal_View.isDateOut
         , Object_Personal_View.isMain
         , Object_Personal_View.isOfficial
         
         , Object_Personal_View.isErased
     FROM Object_Personal_View
          LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Object_Personal_View.AccessKeyId
          LEFT JOIN Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide ON View_RoleAccessKeyGuide.UserId = vbUserId AND View_RoleAccessKeyGuide.UnitId_PersonalService = Object_Personal_View.UnitId AND vbIsAllUnit = FALSE

          LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                 ON ObjectString_DriverCertificate.ObjectId = Object_Personal_View.MemberId 
                                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

     WHERE (tmpRoleAccessKey.AccessKeyId IS NOT NULL
         OR vbAccessKeyAll = TRUE
         OR Object_Personal_View.BranchId = vbObjectId_Constraint
         OR Object_Personal_View.UnitId = 8429 -- ����� ���������
         OR Object_Personal_View.PositionId = 81178 -- ����������
         OR Object_Personal_View.PositionId = 8466  -- ��������
           )
       AND (View_RoleAccessKeyGuide.UnitId_PersonalService > 0
            OR vbIsAllUnit = TRUE
            OR Object_Personal_View.BranchId = vbObjectId_Constraint
           )
       AND (Object_Personal_View.isErased = FALSE
            OR (Object_Personal_View.isErased = TRUE AND inIsShowAll = TRUE OR inIsPeriod = TRUE)
           )
       AND (inIsPeriod = FALSE
            OR (inIsPeriod = TRUE AND ((Object_Personal_View.DateIn BETWEEN inStartDate AND inEndDate)
                                    OR (Object_Personal_View.DateOut BETWEEN inStartDate AND inEndDate)
                                    OR (Object_Personal_View.DateIn < inStartDate
                                    AND Object_Personal_View.DateOut > inEndDate)
                                      )
               )
           )
    ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.09.13                                        * add vbIsAllUnit
 12.09.13                                        * add inIsShowAll
 30.08.14                                        * add InfoMoney...
 11.08.14                                        * add 8429 -- ����� ���������
 21.05.14                         * add Official
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
-- ������
UPDATE Object SET AccessKeyId = COALESCE (Object_Branch.AccessKeyId, (SELECT zc_Enum_Process_AccessKey_TrasportDnepr() WHERE EXISTS (SELECT 1 FROM ObjectLink as ObjectLink_ch WHERE ObjectLink_ch.DescId = zc_ObjectLink_Car_Unit() AND ObjectLink_ch.ChildObjectId = ObjectLink.ChildObjectId)))
FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink2 ON ObjectLink2.ObjectId = ObjectLink.ChildObjectId AND ObjectLink2.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink2.ChildObjectId WHERE ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Personal_Unit() AND Object.DescId = zc_Object_Personal();
-- �������������� ���������
update object set  isErased =  TRUE
where id in (select PersonalId 
FROM Object_Personal_View
     left join Object on Object.Id = Object_Personal_View.MemberId
WHERE Object_Personal_View.isErased <> COALESCE (Object.isErased, TRUE)
    and COALESCE (Object.isErased, TRUE) = TRUE);
*/
-- ����
-- SELECT * FROM gpSelect_Object_Personal (inStartDate:= null, inEndDate:= null, inIsPeriod:= FALSE, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
