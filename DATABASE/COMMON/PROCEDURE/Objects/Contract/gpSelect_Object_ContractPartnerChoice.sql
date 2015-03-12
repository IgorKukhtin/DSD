-- Function: gpSelect_Object_ContractPartnerChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartnerChoice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartnerChoice(
    IN inShowAll        Boolean,       --
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, GLNCode TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractStateKindCode Integer
             , ContractComment TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , MemberTakeId Integer, MemberTakeName TVarChar
             , personalTakeId Integer, personalTakeName TVarChar
             , InfoMoneyId Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat
             , DelayDay TVarChar
             , PrepareDayCount TFloat, DocumentDayCount TFloat
             , AmountDebet TFloat
             , AmountKredit TFloat
             , BranchName TVarChar, ContainerId Integer
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractPartnerChoice());
   vbUserId:= lpGetUserBySession (inSession);


   -- ������������ ������� �������
   vbObjectId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0), 0);
   vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0), 0);
   vbIsConstraint:= vbObjectId_Constraint > 0 OR vbBranchId_Constraint > 0;


   IF inShowAll= TRUE THEN
   -- ��������� �����
   RETURN QUERY
   SELECT
         Object_Contract_View.ContractId      :: Integer   AS Id
       , Object_Contract_View.ContractCode    :: Integer   AS Code
       , Object_Contract_View.InvNumber       :: TVarChar  AS InvNumber
       , Object_Contract_View.StartDate       :: TDateTime AS StartDate
       , Object_Contract_View.EndDate         :: TDateTime AS EndDate
       , Object_Contract_View.ContractTagId   :: Integer   AS ContractTagId
       , Object_Contract_View.ContractTagName :: TVarChar  AS ContractTagName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Partner.Id             AS PartnerId
       , Object_Partner.ObjectCode     AS PartnerCode
       , Object_Partner.ValueData      AS PartnerName
       , ObjectString_GLNCode.ValueData AS GLNCode
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName
       , Object_Contract_View.ContractStateKindCode AS ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_Route.Id               AS RouteId
       , Object_Route.ValueData        AS RouteName
       , Object_RouteSorting.Id        AS RouteSortingId
       , Object_RouteSorting.ValueData AS RouteSortingName
       , Object_MemberTake.Id        AS PersonalTakeId
       , Object_MemberTake.ValueData AS PersonalTakeName

       , Object_MemberTake.Id        AS personalTakeId
       , Object_MemberTake.ValueData AS personalTakeName
 
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , View_ContractCondition_Value.ChangePercent
       , View_ContractCondition_Value.DelayDay
       , ObjectFloat_PrepareDayCount.ValueData  AS PrepareDayCount
       , ObjectFloat_DocumentDayCount.ValueData AS DocumentDayCount

       , Container_Partner_View.AmountDebet
       , Container_Partner_View.AmountKredit

       , Object_Branch.ValueData AS BranchName
       , Container_Partner_View.ContainerId

       , Object_Partner.isErased

   FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                              ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                             AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                              ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND Object_Contract_View.isErased = FALSE

         LEFT JOIN Container_Partner_View ON Container_Partner_View.PartnerId = Object_Partner.Id
                                         AND Container_Partner_View.ContractId = Object_Contract_View.ContractId

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (Container_Partner_View.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId)
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, Object_Contract_View.InfoMoneyId)
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (Container_Partner_View.PaidKindId, Object_Contract_View.PaidKindId)

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

 	LEFT JOIN /*(SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  )*/ Object_ContractCondition_ValueView AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = Object_Contract_View.ContractId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Container_Partner_View.BranchId

   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
           AND vbBranchId_Constraint > 0)
       OR (COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21400() -- ������ ����������
                                                                            , zc_Enum_InfoMoneyDestination_21500() -- ���������
                                                                            , zc_Enum_InfoMoneyDestination_30400() -- ������ ���������������
                                                                             )
           AND vbBranchId_Constraint = 0)
       OR Object_InfoMoney_View.InfoMoneyId = 8942 -- ������
       OR Object_Juridical.Id = 15222 -- ������ ���� ���
         )
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
          OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
          OR vbIsConstraint = FALSE
          OR Object_Partner.Id IN (17316 -- ����� 8221,���������,��.������,2*600400
                                 , 17344 -- ����� 9221,���������,��.������,2*500239
                                 , 79360 -- �� � 37 ���.���.,���������,��������,71
                                 , 268754 -- �� �37 ���������, ��������, 71 ���.���.���������
                                 , 79205 -- ��� "���" �����-10, ���������, ��.���.�����.����
                                 , 17795 -- ��� ���, �����-10, ��������� ����� ��
                                 , 132330 -- ������ ���� ����������,������,18/2
                                 , 128902 -- �����  ���, ��������� ������,147
                                 , 128903 -- �����  ���, ���������,��.�������,1�
                                  )
         )
  ;

   ELSE
   -- ��������� ������
   RETURN QUERY
   SELECT
         Object_Contract_View.ContractId      :: Integer   AS Id
       , Object_Contract_View.ContractCode    :: Integer   AS Code
       , Object_Contract_View.InvNumber       :: TVarChar  AS InvNumber
       , Object_Contract_View.StartDate       :: TDateTime AS StartDate
       , Object_Contract_View.EndDate         :: TDateTime AS EndDate
       , Object_Contract_View.ContractTagId   :: Integer   AS ContractTagId
       , Object_Contract_View.ContractTagName :: TVarChar  AS ContractTagName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Partner.Id             AS PartnerId
       , Object_Partner.ObjectCode     AS PartnerCode
       , Object_Partner.ValueData      AS PartnerName
       , ObjectString_GLNCode.ValueData AS GLNCode
       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName
       , Object_Contract_View.ContractStateKindCode AS ContractStateKindCode
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_Route.Id               AS RouteId
       , Object_Route.ValueData        AS RouteName
       , Object_RouteSorting.Id        AS RouteSortingId
       , Object_RouteSorting.ValueData AS RouteSortingName
       , Object_MemberTake.Id        AS PersonalTakeId
       , Object_MemberTake.ValueData AS PersonalTakeName


       , Object_MemberTake.Id        AS personalTakeId
       , Object_MemberTake.ValueData AS personalTakeName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.OKPO

       , View_ContractCondition_Value.ChangePercent
       , View_ContractCondition_Value.DelayDay
       , ObjectFloat_PrepareDayCount.ValueData  AS PrepareDayCount
       , ObjectFloat_DocumentDayCount.ValueData AS DocumentDayCount

       , Container_Partner_View.AmountDebet
       , Container_Partner_View.AmountKredit

       , Object_Branch.ValueData AS BranchName
       , Container_Partner_View.ContainerId

       , Object_Partner.isErased

   FROM Object AS Object_Partner
         LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                               AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()

         LEFT JOIN ObjectFloat AS ObjectFloat_PrepareDayCount
                               ON ObjectFloat_PrepareDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
         LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                               ON ObjectFloat_DocumentDayCount.ObjectId = Object_Partner.Id
                              AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                              ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
         LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_RouteSorting
                              ON ObjectLink_Partner_RouteSorting.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_RouteSorting.DescId = zc_ObjectLink_Partner_RouteSorting()
         LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Partner_RouteSorting.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                              ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
         LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                              ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                             AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                              ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_MemberTake
                              ON ObjectLink_Partner_MemberTake.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_MemberTake.DescId = zc_ObjectLink_Partner_MemberTake()
         LEFT JOIN Object AS Object_MemberTake ON Object_MemberTake.Id = ObjectLink_Partner_MemberTake.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                       AND Object_Contract_View.isErased = FALSE

         LEFT JOIN Container_Partner_View ON Container_Partner_View.PartnerId = Object_Partner.Id
                                         AND Container_Partner_View.ContractId = Object_Contract_View.ContractId

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (Container_Partner_View.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId)
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, Object_Contract_View.InfoMoneyId)
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (Container_Partner_View.PaidKindId, Object_Contract_View.PaidKindId)

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

 	LEFT JOIN /*(SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  )*/ Object_ContractCondition_ValueView AS View_ContractCondition_Value ON View_ContractCondition_Value.ContractId = Object_Contract_View.ContractId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Container_Partner_View.BranchId

   WHERE Object_Partner.DescId = zc_Object_Partner()
     AND Object_Partner.isErased = FALSE
     AND ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
           AND vbBranchId_Constraint > 0)
       OR (COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) NOT IN (zc_Enum_InfoMoneyDestination_21400() -- ������ ����������
                                                                            , zc_Enum_InfoMoneyDestination_21500() -- ���������
                                                                            , zc_Enum_InfoMoneyDestination_30400() -- ������ ���������������
                                                                             )
           AND vbBranchId_Constraint = 0)
       OR Object_InfoMoney_View.InfoMoneyId = 8942 -- ������
       OR Object_Juridical.Id = 15222 -- ������ ���� ���
         )
     AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
          OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
          OR vbIsConstraint = FALSE
          OR Object_Partner.Id IN (17316 -- ����� 8221,���������,��.������,2*600400
                                 , 17344 -- ����� 9221,���������,��.������,2*500239
                                 , 79360 -- �� � 37 ���.���.,���������,��������,71
                                 , 268754 -- �� �37 ���������, ��������, 71 ���.���.���������
                                 , 79205 -- ��� "���" �����-10, ���������, ��.���.�����.����
                                 , 17795 -- ��� ���, �����-10, ��������� ����� ��
                                 , 132330 -- ������ ���� ����������,������,18/2
                                 , 128902 -- �����  ���, ��������� ������,147
                                 , 128903 -- �����  ���, ���������,��.�������,1�
                                  )
         )
  ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartnerChoice (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 21.08.14                                        * add ContractComment
 25.04.14                                        * add ContractTagName
 28.02.14         * add inShowAll
 13.02.14                                        * add zc_Enum_ContractStateKind_Close
 24.01.14                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractPartnerChoice (inShowAll:= FALSE, inSession := zfCalc_UserAdmin())
