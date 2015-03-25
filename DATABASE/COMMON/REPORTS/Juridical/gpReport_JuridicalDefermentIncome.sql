-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentIncome (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentIncome(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inJuridicalGroupId Integer   , --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (AccountId Integer, AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, RetailName_main TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar
             , ContractTagGroupName TVarChar, ContractTagName TVarChar, ContractStateKindCode Integer
             , PersonalName TVarChar
             , PersonalTradeName TVarChar
             , PersonalCollationName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLenght Integer;

   DECLARE vbIsBranch Boolean;
   DECLARE vbIsJuridicalGroup Boolean;
   DECLARE vbObjectId_Constraint_Branch Integer;
   DECLARE vbObjectId_Constraint_JuridicalGroup Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������ ...
     vbIsBranch:= COALESCE (inBranchId, 0) > 0;
     vbIsJuridicalGroup:= COALESCE (inJuridicalGroupId, 0) > 0;

     -- ������������ ������� �������
     vbObjectId_Constraint_Branch:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
     vbObjectId_Constraint_JuridicalGroup:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0);
     -- !!!�������� ��������!!!
     IF vbObjectId_Constraint_Branch > 0 THEN inBranchId:= vbObjectId_Constraint_Branch; END IF;
     IF vbObjectId_Constraint_JuridicalGroup > 0 THEN inJuridicalGroupId:= vbObjectId_Constraint_JuridicalGroup; END IF;


     -- �������� ������� �� ���� �� ��. ����� � ������� ���������. 
     -- ��� �� �������� ������� � �������� �� ������ 
      vbLenght := 7;


     -- ���������
     RETURN QUERY
     WITH tmpAccount AS (SELECT inAccountId AS AccountId
                   UNION SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20700() AND AccountDirectionId = zc_Enum_AccountDirection_70100() AND EXISTS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountId = inAccountId AND AccountDirectionId = zc_Enum_AccountDirection_70100() AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20700()) -- ��������� + ���������� AND <> ������ + ������ ������
                   UNION SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE COALESCE (inAccountId, 0) = 0 AND AccountGroupId = zc_Enum_AccountGroup_70000() -- ���������
                        )
        , tmpListBranch_Constraint AS (SELECT ObjectLink_Contract_Personal.ObjectId AS ContractId
                                       FROM ObjectLink AS ObjectLink_Unit_Branch
                                            INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                  ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                            INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                  ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                                 AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                       WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       GROUP BY ObjectLink_Contract_Personal.ObjectId
                                      )

     SELECT a.AccountId, a.AccountName, a.JuridicalId, a.JuridicalName, a.RetailName, a.RetailName_main, a.OKPO, a.JuridicalGroupName
             , a.PartnerId, a.PartnerCode, a.PartnerName TVarChar
             , a.BranchId, a.BranchCode, a.BranchName
             , a.PaidKindId, a.PaidKindName
             , a.ContractId, a.ContractCode, a.ContractNumber
             , a.ContractTagGroupName, a.ContractTagName, a.ContractStateKindCode
             , a.PersonalName
             , a.PersonalTradeName
             , a.PersonalCollationName
             , a.StartDate, a.EndDate
             , a.DebetRemains, a.KreditRemains
             , a.SaleSumm, a.DefermentPaymentRemains
             , a.SaleSumm1, a.SaleSumm2, a.SaleSumm3, a.SaleSumm4, a.SaleSumm5
             , a.Condition, a.StartContractDate, a.Remains
             , a.InfoMoneyGroupName, a.InfoMoneyDestinationName, a.InfoMoneyCode, a.InfoMoneyName
             , a.AreaName
from (
  SELECT 
     Object_Account_View.AccountId
   , Object_Account_View.AccountName_all AS AccountName
   , Object_Juridical.Id        AS JuridicalId
   , Object_Juridical.Valuedata AS JuridicalName
   , COALESCE (Object_RetailReport.ValueData, '������') :: TVarChar AS RetailName
   , COALESCE (Object_Retail.ValueData, '������') :: TVarChar AS RetailName_main
   , ObjectHistory_JuridicalDetails_View.OKPO
   , Object_JuridicalGroup.ValueData AS JuridicalGroupName
   , Object_Partner.Id          AS PartnerId
   , Object_Partner.ObjectCode  AS PartnerCode
   , Object_Partner.ValueData   AS PartnerName
   , Object_Branch.Id           AS BranchId
   , Object_Branch.ObjectCode   AS BranchCode
   , Object_Branch.ValueData    AS BranchName
   , Object_PaidKind.Id         AS PaidKindId
   , Object_PaidKind.ValueData  AS PaidKindName
   , View_Contract.ContractId
   , View_Contract.ContractCode
   , View_Contract.InvNumber AS ContractNumber
   , View_Contract.ContractTagGroupName
   , View_Contract.ContractTagName
   , View_Contract.ContractStateKindCode
   , Object_Personal_View.PersonalName      AS PersonalName
   , Object_PersonalTrade.PersonalName      AS PersonalTradeName
   , Object_PersonalCollation.PersonalName  AS PersonalCollationName
   , View_Contract.StartDate
   , View_Contract.EndDate

   , (CASE WHEN -1 * RESULT.Remains > 0 THEN -1 * RESULT.Remains ELSE 0 END) :: TFloat AS DebetRemains
   , (CASE WHEN -1 * RESULT.Remains > 0 THEN 0 ELSE 1 * RESULT.Remains END) :: TFloat AS KreditRemains
   , RESULT.SaleSumm :: TFloat AS SaleSumm

   , (CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > 0
                THEN RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm
           ELSE RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm -- 0
      END)::TFloat AS DefermentPaymentRemains

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > 0 AND RESULT.SaleSumm1 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > RESULT.SaleSumm1
                          THEN RESULT.SaleSumm1
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm)
                     END
           ELSE 0
      END)::TFloat AS SaleSumm1

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1) > 0 AND RESULT.SaleSumm2 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1) > RESULT.SaleSumm2
                          THEN RESULT.SaleSumm2
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1)
                     END
      ELSE 0 END)::TFloat AS SaleSumm2

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > 0 AND RESULT.SaleSumm3 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > RESULT.SaleSumm3
                          THEN RESULT.SaleSumm3
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2)
                     END
           ELSE 0
      END)::TFloat AS SaleSumm3

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > 0 AND RESULT.SaleSumm4 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > RESULT.SaleSumm4
                          THEN RESULT.SaleSumm4
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3)
                     END
            ELSE 0
      END)::TFloat AS SaleSumm4

   , (CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) > 0
                THEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4)
                ELSE 0
      END )::TFloat AS SaleSumm5

   , (RESULT.DayCount||' '|| CASE WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                       THEN '�.��.'
                                  -- WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendarSale()
                                  --      THEN '�.�.��.'
                                  WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                       THEN '�.��.'
                                  -- WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBankSale()
                                  --     THEN '�.�.��.'
                                  ELSE ''
                             END
                     ||' '|| CASE WHEN RESULT.DelayCreditLimit <> 0
                                       THEN '+ ' || TRIM (to_char (RESULT.DelayCreditLimit, '999 999 999 999 999D99')) || '���.'
                                  ELSE ''
                             END
      )::TVarChar AS Condition -- Object_ContractConditionKind.ValueData
   , RESULT.ContractDate :: TDateTime AS StartContractDate
   , (-1 * RESULT.Remains) :: TFloat AS Remains

      , Object_InfoMoney_View.InfoMoneyGroupName
      , Object_InfoMoney_View.InfoMoneyDestinationName
      , Object_InfoMoney_View.InfoMoneyCode
      , Object_InfoMoney_View.InfoMoneyName

      , Object_Area.ValueData AS AreaName

  FROM (SELECT RESULT_all.AccountId
             , RESULT_all.ContractId
             , RESULT_all.JuridicalId 
             , -1 * SUM (RESULT_all.Remains)   AS Remains
             , SUM (RESULT_all.SaleSumm)  AS SaleSumm
             , SUM (RESULT_all.SaleSumm1) AS SaleSumm1
             , SUM (RESULT_all.SaleSumm2) AS SaleSumm2
             , SUM (RESULT_all.SaleSumm3) AS SaleSumm3
             , SUM (RESULT_all.SaleSumm4) AS SaleSumm4
             , RESULT_all.ContractConditionKindId
             , RESULT_all.DayCount
             , RESULT_all.DelayCreditLimit
             , RESULT_all.ContractDate
             , CLO_InfoMoney.ObjectId AS InfoMoneyId
             , CLO_PaidKind.ObjectId  AS PaidKindId
             , CLO_Partner.ObjectId   AS PartnerId
             , CLO_Branch.ObjectId    AS BranchId
             , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
        FROM
       (SELECT Container.Id
             , Container.ObjectId     AS AccountId
             , View_Contract_ContractKey.ContractId_Key AS ContractId -- CLO_Contract.ObjectId AS ContractId
             , CLO_Juridical.ObjectId AS JuridicalId 
             , Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate >= inOperDate THEN MIContainer.Amount ELSE 0 END), 0) AS Remains
             , SUM (CASE WHEN (MIContainer.OperDate < inOperDate)                 AND (MIContainer.OperDate >= ContractDate)               AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate                AND MIContainer.OperDate >= ContractDate - vbLenght)     AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm1
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - vbLenght     AND MIContainer.OperDate >= ContractDate - 2 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm2
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 2 * vbLenght AND MIContainer.OperDate >= ContractDate - 3 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm3
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 3 * vbLenght AND MIContainer.OperDate >= ContractDate - 4 * vbLenght) AND Movement.DescId IN (zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SaleSumm4
             , ContractCondition_DefermentPayment.ContractConditionKindId
             , COALESCE (ContractCondition_DefermentPayment.DayCount, 0) AS DayCount
             , COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) AS DelayCreditLimit
             , COALESCE (ContractCondition_DefermentPayment.ContractDate, inOperDate) AS ContractDate
         FROM ContainerLinkObject AS CLO_Juridical
              INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
              INNER JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
              LEFT JOIN ContainerLinkObject AS CLO_Contract
                                            ON CLO_Contract.ContainerId = Container.Id
                                           AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
              -- !!!���������� ��������!!!
              LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

              LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                              , zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), Object_ContractCondition_View.Value :: Integer, inOperDate) :: Date AS ContractDate
                              , Object_ContractCondition_View.ContractConditionKindId
                              , Object_ContractCondition_View.Value :: Integer AS DayCount
                         FROM (SELECT Object_ContractCondition_View.ContractId
                                    , Object_ContractCondition_View.ContractConditionKindId
                                    , MAX (Object_ContractCondition_View.Value) AS Value
                               FROM Object_ContractCondition_DefermentPaymentView
                                    INNER JOIN Object_ContractCondition_View
                                            ON Object_ContractCondition_View.ContractConditionKindId = Object_ContractCondition_DefermentPaymentView.ConditionKindId
                               WHERE Object_ContractCondition_View.Value <> 0
                               GROUP BY Object_ContractCondition_View.ContractId
                                      , Object_ContractCondition_View.ContractConditionKindId
                              ) AS Object_ContractCondition_View
                        ) AS ContractCondition_DefermentPayment
                          ON ContractCondition_DefermentPayment.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId

              LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                              , Value AS DelayCreditLimit
                         FROM Object_ContractCondition_View
                         WHERE Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                        ) AS ContractCondition_CreditLimit
                          ON ContractCondition_CreditLimit.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId
                              
              LEFT JOIN MovementItemContainer AS MIContainer 
                                              ON MIContainer.Containerid = Container.Id
                                             AND MIContainer.OperDate >= COALESCE (ContractCondition_DefermentPayment.ContractDate :: Date - 4 * vbLenght, inOperDate)
             LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
         WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            -- AND (Container.ObjectId = inAccountId OR inAccountId = 0)
            AND (tmpAccount.AccountId > 0 OR inAccountId = 0)
         GROUP BY Container.Id
                , Container.ObjectId
                , Container.Amount
                , View_Contract_ContractKey.ContractId_Key
                , CLO_Juridical.ObjectId  
                , ContractConditionKindId
                , DayCount
                , DelayCreditLimit
                , ContractDate
       ) AS RESULT_all

           LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                         ON CLO_PaidKind.ContainerId = RESULT_all.Id
                                        AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
           LEFT JOIN ContainerLinkObject AS CLO_Branch
                                         ON CLO_Branch.ContainerId = RESULT_all.Id
                                        AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                         ON CLO_InfoMoney.ContainerId = RESULT_all.Id
                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
           LEFT JOIN ContainerLinkObject AS CLO_Partner
                                         ON CLO_Partner.ContainerId = RESULT_all.Id
                                        AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                ON ObjectLink_Juridical_JuridicalGroup.ObjectId = RESULT_all.JuridicalId
                               AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.ContractId = RESULT_all.ContractId
         WHERE (CLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
           AND (CLO_Branch.ObjectId = inBranchId OR COALESCE (inBranchId, 0) = 0
                OR ((ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR tmpListBranch_Constraint.ContractId > 0) AND vbIsBranch = FALSE)) -- !!!��������!!
           AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId OR COALESCE (inJuridicalGroupId, 0) = 0
                OR tmpListBranch_Constraint.ContractId > 0
                OR (CLO_Branch.ObjectId = inBranchId AND vbIsJuridicalGroup = FALSE)) -- !!!��������!!
         GROUP BY RESULT_all.AccountId
                , RESULT_all.ContractId
                , RESULT_all.JuridicalId 
                , RESULT_all.ContractConditionKindId
                , RESULT_all.DayCount
                , RESULT_all.DelayCreditLimit
                , RESULT_all.ContractDate
                , CLO_InfoMoney.ObjectId
                , CLO_PaidKind.ObjectId
                , CLO_Partner.ObjectId
                , CLO_Branch.ObjectId
                , ObjectLink_Juridical_JuridicalGroup.ChildObjectId
       ) AS RESULT

       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = RESULT.JuridicalId
       LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = RESULT.AccountId
       LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = RESULT.ContractId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                               ON ObjectLink_Contract_Personal.ObjectId = RESULT.ContractId
                              AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                ON ObjectLink_Contract_PersonalTrade.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
           LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Contract_PersonalTrade.ChildObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                ON ObjectLink_Contract_PersonalCollation.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
           LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        

           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = RESULT.InfoMoneyId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                                ON ObjectLink_Contract_Area.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_AreaContract()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
           LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = RESULT.JuridicalGroupId

           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = RESULT.BranchId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = RESULT.PaidKindId
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = RESULT.PartnerId

) as a
where a.DebetRemains <> 0 or a.KreditRemains <> 0
             or  a.SaleSumm <> 0 or a.DefermentPaymentRemains <> 0
             or  a.SaleSumm1 <> 0 or a.SaleSumm2 <> 0 or a.SaleSumm3 <> 0 or a.SaleSumm4 <> 0 or a.SaleSumm5 <> 0
             or  a.Remains <> 0 
    ;
    -- �����. �������� ��������� ������. 
    -- ����� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentIncome (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.09.14                                        * add inJuridicalGroupId
 07.09.14                                        * add Branch...
 24.08.14                                        * add Partner...
 11.07.14                                        * add RetailName
 05.07.14                                        * add zc_Movement_TransferDebtOut
 02.06.14                                        * change DefermentPaymentRemains
 20.05.14                                        * add Object_Contract_View
 12.05.14                                        * add RESULT.DelayCreditLimit
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 15.04.14                                        * add StartDate and EndDate
 10.04.14                                        * add AreaName
 09.04.14                                        * add !!!
 31.03.14                                        * add Object_Contract_View and Object_InfoMoney_View and ObjectHistory_JuridicalDetails_View and Object_PaidKind
 30.03.14                          * 
 06.02.14                          * 
*/

/*
!!!err!!!
with Object_ContractCondition_View2 as (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
             , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
             , ObjectFloat_Value.ValueData AS Value
             , ObjectLink_ContractCondition_Contract.ObjectId
         FROM ObjectLink AS ObjectLink_ContractCondition_Contract
              INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
              INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                     ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                    AND ObjectFloat_Value.ValueData <> 0
              LEFT JOIN Object AS ContractCondition ON  ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.objectid 
         WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
           AND ContractCondition.isErased = FALSE)

SELECT * from Object_Contract_View where Contractid in (

SELECT Object_ContractCondition_View.ContractId
                                   --  , Object_ContractCondition_View.ContractConditionKindId
                               FROM Object_ContractCondition_View2 as Object_ContractCondition_View
left join ObjectLink on ObjectLink.ObjectId = Object_ContractCondition_View.ObjectId
and ObjectLink.descId = zc_ObjectLink_ContractCondition_BonusKind()

                               WHERE Object_ContractCondition_View.Value <> 0
and ObjectLink.ChildObjectId  is null
 and coalesce (ContractConditionKindId, 0)  not in (zc_Enum_ContractConditionKind_BonusPercentSale(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn())
                               GROUP BY Object_ContractCondition_View.ContractId
                                      , Object_ContractCondition_View.ContractConditionKindId
having count (*) >1)
*/
-- ����
-- SELECT * FROM gpReport_JuridicalDefermentIncome (inOperDate:= '01.06.2014', inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentIncome (inOperDate:= '01.06.2014', inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inJuridicalGroupId:= null, inSession:= zfCalc_UserAdmin());
