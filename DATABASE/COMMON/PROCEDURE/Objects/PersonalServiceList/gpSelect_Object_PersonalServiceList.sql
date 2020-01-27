-- Function: gpSelect_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalServiceList(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalServiceList(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , JuridicalId Integer, JuridicalName TVarChar 
             , PaidKindId Integer, PaidKindName TVarChar 
             , BranchId Integer, BranchName TVarChar 
             , BankId Integer, BankName TVarChar 
             , MemberId Integer, MemberName TVarChar
             , MemberHeadManagerId Integer, MemberHeadManagerName TVarChar
             , MemberManagerId Integer, MemberManagerName TVarChar
             , MemberBookkeeperId Integer, MemberBookkeeperName TVarChar
             , Compensation TFloat
             , isSecond Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_PersonalServiceList());
   vbUserId:= lpGetUserBySession (inSession);

   -- ������������ ������� �������
   vbBranchId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId NOT IN (0, zc_Branch_Basis()) GROUP BY Object_RoleAccessKeyGuide_View.BranchId);

   -- ���������
   RETURN QUERY 
       SELECT 
             Object_PersonalServiceList.Id         AS Id
           , Object_PersonalServiceList.ObjectCode AS Code
           , Object_PersonalServiceList.ValueData  AS NAME
           , Object_Juridical.Id                   AS JuridicalId
           , Object_Juridical.ValueData            AS JuridicalName

           , Object_PaidKind.Id                   AS PaidKindId
           , Object_PaidKind.ValueData            AS PaidKindName
           , Object_Branch.Id                     AS BranchId
           , Object_Branch.ValueData              AS BranchName
           , Object_Bank.Id                       AS BankId
           , Object_Bank.ValueData                AS BankName

           , Object_Member.Id                     AS MemberId
           , Object_Member.ValueData              AS MemberName

           , Object_MemberHeadManager.Id          AS MemberHeadManagerId
           , Object_MemberHeadManager.ValueData   AS MemberHeadManagerName
           , Object_MemberManager.Id              AS MemberManagerId
           , Object_MemberManager.ValueData       AS MemberManagerName
           , Object_MemberBookkeeper.Id           AS MemberBookkeeperId
           , Object_MemberBookkeeper.ValueData    AS MemberBookkeeperName
           
           , COALESCE (ObjectFloat_Compensation.ValueData, 0) :: TFloat AS Compensation

           , COALESCE (ObjectBoolean_Second.ValueData,FALSE)  ::Boolean AS isSecond

           , Object_PersonalServiceList.isErased  AS isErased

       FROM Object AS Object_PersonalServiceList
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Second 
                                   ON ObjectBoolean_Second.ObjectId = Object_PersonalServiceList.Id 
                                  AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_PersonalServiceList_Second()

           LEFT JOIN ObjectFloat AS ObjectFloat_Compensation
                                 ON ObjectFloat_Compensation.ObjectId = Object_PersonalServiceList.Id 
                                AND ObjectFloat_Compensation.DescId = zc_ObjectFloat_PersonalServiceList_Compensation()

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Juridical
                                ON ObjectLink_PersonalServiceList_Juridical.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PersonalServiceList_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PersonalServiceList_PaidKind.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                ON ObjectLink_PersonalServiceList_Branch.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_PersonalServiceList_Branch.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                ON ObjectLink_PersonalServiceList_Bank.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_PersonalServiceList_Bank.ChildObjectId
          
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                ON ObjectLink_PersonalServiceList_Member.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_PersonalServiceList_Member.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberHeadManager
                                ON ObjectLink_PersonalServiceList_MemberHeadManager.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_MemberHeadManager.DescId = zc_ObjectLink_PersonalServiceList_MemberHeadManager()
           LEFT JOIN Object AS Object_MemberHeadManager ON Object_MemberHeadManager.Id = ObjectLink_PersonalServiceList_MemberHeadManager.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberManager
                                ON ObjectLink_PersonalServiceList_MemberManager.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_MemberManager.DescId = zc_ObjectLink_PersonalServiceList_MemberManager()
           LEFT JOIN Object AS Object_MemberManager ON Object_MemberManager.Id = ObjectLink_PersonalServiceList_MemberManager.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_MemberBookkeeper
                                ON ObjectLink_PersonalServiceList_MemberBookkeeper.ObjectId = Object_PersonalServiceList.Id 
                               AND ObjectLink_PersonalServiceList_MemberBookkeeper.DescId = zc_ObjectLink_PersonalServiceList_MemberBookkeeper()
           LEFT JOIN Object AS Object_MemberBookkeeper ON Object_MemberBookkeeper.Id = ObjectLink_PersonalServiceList_MemberBookkeeper.ChildObjectId

   WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
      AND (ObjectLink_PersonalServiceList_Branch.ChildObjectId = vbBranchId_Constraint
           OR vbBranchId_Constraint IS NULL)
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.20          * add Compensation
 16.12.15          * add MemberHeadManager, MemberManager, MemberBookkeeper
 26.08.15          * add Member
 15.04.15          * add PaidKind, Branch, Bank
 30.09.14          * add Juridical
 12.09.14          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_PersonalServiceList('2')