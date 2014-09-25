-- Function: lpReport_Account ()

DROP FUNCTION IF EXISTS lpReport_Account (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpReport_Account (
    IN inStartDate              TDateTime ,  
    IN inEndDate                TDateTime ,
    IN inAccountGroupId         Integer , 
    IN inAccountDirectionId     Integer , 
    IN inInfoMoneyId            Integer , 
    IN inAccountId              Integer ,
    IN inBusinessId             Integer ,
    IN inProfitLossGroupId      Integer ,
    IN inProfitLossDirectionId  Integer , 
    IN inProfitLossId           Integer ,
    IN inBranchId               Integer ,
    IN inUserId                 Integer ,
    IN inIsMovement             Boolean Default false   -- ������ ������������
)
RETURNS TABLE  (InvNumber Integer, MovementId Integer, OperDate TDateTime, MovementDescName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
              , PersonalCode Integer, PersonalName TVarChar
              , JuridicalCode Integer, JuridicalName TVarChar
              , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
              , BusinessCode Integer, BusinessName TVarChar
              , PaidKindName TVarChar, ContractName TVarChar
              , CarModelName TVarChar, CarCode Integer, CarName TVarChar
              , ObjectId_Direction Integer, ObjectCode_Direction Integer, ObjectName_Direction TVarChar
              , ObjectCode_Destination Integer, ObjectName_Destination TVarChar
              , DescName_Direction TVarChar
              , DescName_Destination TVarChar

              , PersonalCode_inf Integer, PersonalName_inf TVarChar
              , CarModelName_inf TVarChar, CarCode_inf Integer, CarName_inf TVarChar
              , RouteCode_inf Integer, RouteName_inf TVarChar
              , UnitCode_inf Integer, UnitName_inf TVarChar
              , BranchCode_inf Integer, BranchName_inf TVarChar
              , BusinessCode_inf Integer, BusinessName_inf TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat, OperPrice TFloat
              , AccountGroupCode Integer, AccountGroupName TVarChar
              , AccountDirectionCode Integer, AccountDirectionName TVarChar
              , AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
              , AccountGroupCode_inf Integer, AccountGroupName_inf TVarChar
              , AccountDirectionCode_inf Integer, AccountDirectionName_inf TVarChar
              , AccountCode_inf Integer, AccountName_inf TVarChar, AccountName_All_inf TVarChar
              , ProfitLossName_All_inf TVarChar
              )  
AS
$BODY$
   DECLARE vbIsMovement Boolean;
BEGIN

    -- !!!������������ - ����� �� ��������������� �� ���������� ��� ������� �������� �������
    -- 
    vbIsMovement:= (((zc_Enum_Account_100301() NOT IN (SELECT AccountId FROM Object_Account_View WHERE (AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                                                                                                  OR (AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                                                                                                  OR AccountId = COALESCE (inAccountId, 0))
                     AND (COALESCE (inAccountId, 0) <> 0 OR COALESCE (inAccountDirectionId, 0) <> 0))
                 OR (zc_Enum_Account_100301() IN (SELECT AccountId FROM Object_Account_View WHERE (AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                                                                                               OR (AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                                                                                               OR AccountId = COALESCE (inAccountId, 0))
                     AND COALESCE (inProfitLossId, 0) <> 0)
                   )
               AND inStartDate = inEndDate) OR inIsMovement
                  ;

    --
    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS AccountId, Container.Amount
                           FROM (SELECT AccountId FROM Object_Account_View WHERE Object_Account_View.AccountDirectionId <> zc_Enum_AccountDirection_70500() -- ��������� + ����������
                                                                             AND Object_Account_View.AccountCode NOT IN (100101 -- ����������� ������� + �������������� ������� + �������������� �������
                                                                                                                       , 100201 -- ����������� ������� + �������������� ������� + �������������� �������
                                                                                                                       , 100401 -- ����������� ������� + ������� � ����������� + ������� � �����������
                                                                                                                       , 100501 -- ����������� ������� + ������� ����������� + ������� �����������
                                                                                                                        )
                                 AND (
                                   -- !!!ONLY!!! inAccountId OR inAccountGroupId OR inAccountDirectionId
                                  /*((Object_Account_View.AccountGroupId = COALESCE (inAccountGroupId, 0) OR COALESCE (inAccountGroupId, 0) = 0) 
                               AND (Object_Account_View.AccountDirectionId = COALESCE (inAccountDirectionId, 0) OR COALESCE (inAccountDirectionId, 0) = 0)
                               AND (Object_Account_View.AccountId = COALESCE (inAccountId, 0) OR COALESCE (inAccountGroupId, 0) <> 0 OR COALESCE (inAccountDirectionId, 0) <> 0) -- OR COALESCE (inAccountId, 0) = 0
                                  )*/
                                  ((Object_Account_View.AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                                OR (Object_Account_View.AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                                OR Object_Account_View.AccountId = COALESCE (inAccountId, 0)
                                  )
                               OR (EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
                               AND COALESCE (inAccountGroupId, 0) = 0 AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0
                                  ))
                                ) AS tmpAccount -- ����
                                JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                              AND Container.DescId = zc_Container_Summ()
                         )
    SELECT -- 0 :: Integer AS InvNumber
           zfConvert_StringToNumber (tmpReport.InvNumber) AS InvNumber
         , tmpReport.MovementId
         , tmpReport.OperDate
         , MovementDesc.ItemName AS MovementDescName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyName
         , 0 :: Integer   AS PersonalCode -- Object_Member.ObjectCode 
         , '' :: TVarChar AS PersonalName -- Object_Member.ValueData 
         , 0 :: Integer   AS JuridicalCode -- Object_Juridical.ObjectCode
         , '' :: TVarChar AS JuridicalName -- Object_Juridical.ValueData
         , Object_JuridicalBasis.ObjectCode  AS JuridicalBasisCode
         , Object_JuridicalBasis.ValueData   AS JuridicalBasisName
         , Object_Business.ObjectCode        AS BusinessCode
         , Object_Business.ValueData         AS BusinessName
         , Object_PaidKind.ValueData         AS PaidKindName
         , View_Contract_InvNumber.InvNumber AS ContractName
         , '' :: TVarChar AS CarModelName -- Object_CarModel.ValueData
         , 0 :: Integer   AS CarCode -- Object_Car.ObjectCode
         , '' :: TVarChar AS CarName -- Object_Car.ValueData

         , Object_Direction.Id             AS ObjectId_Direction
         , Object_Direction.ObjectCode     AS ObjectCode_Direction
         , (COALESCE (Object_Bank.ValueData || ' * ', '') || Object_Direction.ValueData) :: TVarChar AS ObjectName_Direction
         , Object_Destination.ObjectCode   AS ObjectCode_Destination
         , Object_Destination.ValueData    AS ObjectName_Destination
         , ObjectDesc_Direction.ItemName   AS DescName_Direction
         , ObjectDesc_Destination.ItemName AS DescName_Destination

         , 0 :: Integer   AS PersonalCode_inf -- Object_Member_inf.ObjectCode
         , '' :: TVarChar AS PersonalName_inf -- Object_Member_inf.ValueData
         , '' :: TVarChar AS CarModelName_inf -- Object_CarModel_inf.ValueData
         , 0 :: Integer   AS CarCode_inf -- Object_Car_inf.ObjectCode
         , '' :: TVarChar AS CarName_inf -- Object_Car_inf.ValueData
         , Object_Route_inf.ObjectCode    AS RouteCode_inf
         , Object_Route_inf.ValueData     AS RouteName_inf

         , Object_Unit_inf.ObjectCode     AS UnitCode_inf
         , Object_Unit_inf.ValueData      AS UnitName_inf
         , Object_Branch_inf.ObjectCode   AS BranchCode_inf
         , Object_Branch_inf.ValueData    AS BranchName_inf
         , Object_Business_inf.ObjectCode AS BusinessCode_inf
         , Object_Business_inf.ValueData  AS BusinessName_inf

         , tmpReport.SummStart :: TFloat AS SummStart
         , tmpReport.SummIn    :: TFloat AS SummIn
         , tmpReport.SummOut   :: TFloat AS SummOut
         , tmpReport.SummEnd   :: TFloat AS SummEnd
         , tmpReport.OperPrice :: TFloat AS OperPrice

         , View_Account.AccountGroupCode, View_Account.AccountGroupName
         , View_Account.AccountDirectionCode, View_Account.AccountDirectionName
         , View_Account.AccountCode, View_Account.AccountName
         , View_Account.AccountName_all AS AccountName_All

         , View_Account_inf.AccountGroupCode AS AccountGroupCode_inf, View_Account_inf.AccountGroupName AS AccountGroupName_inf
         , View_Account_inf.AccountDirectionCode AS AccountDirectionCode_inf, View_Account_inf.AccountDirectionName AS AccountDirectionName_inf
         , View_Account_inf.AccountCode AS AccountCode_inf, View_Account_inf.AccountName AS AccountName_inf
         , View_Account_inf.AccountName_all AS AccountName_All_inf

         , View_ProfitLoss_inf.ProfitLossName_all AS ProfitLossName_All_inf

   FROM      
       (SELECT ContainerLO_JuridicalBasis.ObjectId AS JuridicalBasisId
             , ContainerLO_Business.ObjectId AS BusinessId
             , COALESCE (ContainerLO_InfoMoney.ObjectId, ContainerLO_InfoMoney_inf.ObjectId) AS InfoMoneyId
             , ContainerLO_PaidKind.ObjectId  AS PaidKindId
             , ContainerLO_Contract.ObjectId  AS ContractId
             , COALESCE (ContainerLO_Cash.ObjectId, COALESCE (ContainerLO_BankAccount.ObjectId, COALESCE (ContainerLO_Juridical.ObjectId, COALESCE (ContainerLO_Unit.ObjectId, COALESCE (ContainerLO_Car.ObjectId, COALESCE (ContainerLO_Member.ObjectId
                       , COALESCE (ContainerLO_Juridical_inf.ObjectId, COALESCE (ContainerLO_Unit_inf.ObjectId, COALESCE (ContainerLO_Car_inf.ObjectId, ContainerLO_Member_inf.ObjectId))))))))) AS ObjectId_Direction
             , COALESCE (ContainerLO_Goods.ObjectId, ContainerLO_Goods_inf.ObjectId) AS ObjectId_Destination

             , SUM (tmpReport_All.SummStart)  AS SummStart
             , SUM (tmpReport_All.SummIn)     AS SummIn
             , SUM (tmpReport_All.SummOut)    AS SummOut
             , SUM (tmpReport_All.SummEnd)    AS SummEnd

             , tmpReport_All.MovementDescId
             , tmpReport_All.InvNumber
             , tmpReport_All.MovementId
             , tmpReport_All.OperDate

             , tmpReport_All.AccountId
             , tmpReport_All.AccountId_inf
             , ContainerLO_ProfitLoss_inf.ObjectId AS ProfitLossId_inf
             , ContainerLO_Business_inf.ObjectId AS BusinessId_inf

             , tmpReport_All.BranchId_inf
             , tmpReport_All.UnitId_inf
             , tmpReport_All.RouteId_inf

             , tmpReport_All.OperPrice
        FROM
            (SELECT tmpContainer.ContainerId
                  , tmpContainer.AccountId
                  , 0 AS ContainerId_inf
                  , 0 AS AccountId_inf
                  , 0 AS ContainerId_ProfitLoss
                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS MovementDescId
                  , ''   :: TVarChar  AS InvNumber
                  , 0 AS MovementId
                  , NULL :: TDateTime AS OperDate
                  , 0 AS RouteId_inf
                  , 0 AS UnitId_inf
                  , 0 AS BranchId_inf
                  , 0 AS OperPrice
             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                AND MIContainer.OperDate >= inStartDate
             GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.Amount
             HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
            UNION ALL
             SELECT tmpMIReport.ContainerId
                  , tmpMIReport.AccountId
                  , tmpMIReport.ContainerId_inf
                  , tmpMIReport.AccountId_inf
                  , tmpMIReport.ContainerId_ProfitLoss
                  , 0 AS SummStart
                  , 0 AS SummEnd
                  , SUM (CASE WHEN tmpMIReport.MovementDescId = zc_Movement_Sale() THEN tmpMIReport.SummIn - tmpMIReport.SummOut ELSE tmpMIReport.SummIn END)  AS SummIn
                  , SUM (CASE WHEN tmpMIReport.MovementDescId = zc_Movement_Sale() THEN 0 ELSE tmpMIReport.SummOut END) AS SummOut
                  , tmpMIReport.MovementDescId
                  , tmpMIReport.InvNumber
                  , tmpMIReport.MovementId
                  , tmpMIReport.OperDate

                  , tmpMIReport.RouteId_inf
                  , tmpMIReport.UnitId_inf
                  , tmpMIReport.BranchId_inf

                  , tmpMIReport.OperPrice

               FROM (SELECT tmpContainer.ContainerId
                          , tmpContainer.AccountId
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()
                                      THEN MIReport.PassiveContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_inf
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()
                                      THEN MIReport.PassiveAccountId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                      THEN MIReport.ActiveAccountId
                            END AS AccountId_inf
                          , CASE WHEN tmpContainer.AccountId = zc_Enum_Account_100301() -- ������� �������� �������
                                      THEN tmpContainer.ContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()
                                      THEN MIReport.PassiveContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_ProfitLoss
                          , SUM (CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.ActiveAccountId <> zc_Enum_Account_100301() -- ������� �������� �������
                                           THEN MIReport.Amount
                                      ELSE 0
                                 END) AS SummIn
                          , SUM (CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                           THEN MIReport.Amount
                                      WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- ������� �������� �������
                                           THEN -1 * MIReport.Amount
                                      ELSE 0
                                 END) AS SummOut
                          , Movement.DescId   AS MovementDescId
                          , CASE WHEN vbIsMovement THEN Movement.Id        ELSE 0    END :: Integer   AS MovementId
                          , CASE WHEN vbIsMovement THEN Movement.InvNumber ELSE ''   END :: TVarChar  AS InvNumber
                          , CASE WHEN vbIsMovement THEN MIReport.OperDate  ELSE NULL END :: TDateTime AS OperDate

                          , MILinkObject_Route.ObjectId  AS RouteId_inf
                          , MILinkObject_Unit.ObjectId   AS UnitId_inf
                          , MILinkObject_Branch.ObjectId AS BranchId_inf

                          , CASE WHEN COALESCE (MIContainer_Count.Amount, 0) <> 0 THEN MIReport.Amount / ABS (MIContainer_Count.Amount) ELSE 0 END AS OperPrice

                     FROM tmpContainer
                          JOIN ReportContainerLink ON ReportContainerLink.ContainerId = tmpContainer.ContainerId
                          JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = ReportContainerLink.ReportContainerId
                                                             AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                           ON MILinkObject_Route.MovementItemId = MIReport.MovementItemId
                                                          AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MIReport.MovementItemId
                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                           ON MILinkObject_Branch.MovementItemId = MIReport.MovementItemId
                                                          AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                          LEFT JOIN Movement ON Movement.Id = MIReport.MovementId
                          LEFT JOIN MovementItemContainer AS MIContainer_Count ON MIContainer_Count.MovementItemId = MIReport.MovementItemId
                                                                              AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                                                              AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_Income())


                      WHERE (MILinkObject_Branch.ObjectId = inBranchId OR inBranchId = 0)
                     GROUP BY tmpContainer.ContainerId
                            , tmpContainer.AccountId
                            , ReportContainerLink.AccountKindId
                            , MIReport.PassiveContainerId
                            , MIReport.ActiveContainerId
                            , MIReport.PassiveAccountId
                            , MIReport.ActiveAccountId
                            , Movement.DescId
                            , CASE WHEN vbIsMovement THEN Movement.Id        ELSE 0    END
                            , CASE WHEN vbIsMovement THEN Movement.InvNumber ELSE ''   END
                            , CASE WHEN vbIsMovement THEN MIReport.OperDate  ELSE NULL END

                            , MILinkObject_Route.ObjectId
                            , MILinkObject_Unit.ObjectId
                            , MILinkObject_Branch.ObjectId

                            , CASE WHEN COALESCE (MIContainer_Count.Amount, 0) <> 0 THEN MIReport.Amount / ABS (MIContainer_Count.Amount) ELSE 0 END

                     ) AS tmpMIReport
             GROUP BY tmpMIReport.ContainerId
                    , tmpMIReport.AccountId
                    , tmpMIReport.ContainerId_inf
                    , tmpMIReport.AccountId_inf
                    , tmpMIReport.ContainerId_ProfitLoss
                    , tmpMIReport.MovementDescId
                    , tmpMIReport.OperDate
                    , tmpMIReport.InvNumber
                    , tmpMIReport.MovementId
                    , tmpMIReport.RouteId_inf
                    , tmpMIReport.UnitId_inf
                    , tmpMIReport.BranchId_inf
                    , tmpMIReport.OperPrice

            ) AS tmpReport_All
            LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis ON ContainerLO_JuridicalBasis.ContainerId = tmpReport_All.ContainerId
                                                                       AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                                       AND ContainerLO_JuridicalBasis.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Business ON ContainerLO_Business.ContainerId = tmpReport_All.ContainerId
                                                                AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                                AND ContainerLO_Business.ObjectId > 0

            LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                  AND ContainerLO_Juridical.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Unit ON ContainerLO_Unit.ContainerId = tmpReport_All.ContainerId
                                                             AND ContainerLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                             AND ContainerLO_Unit.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpReport_All.ContainerId
                                                            AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                            AND ContainerLO_Car.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Member ON ContainerLO_Member.ContainerId = tmpReport_All.ContainerId
                                                               AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                               AND ContainerLO_Member.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Cash ON ContainerLO_Cash.ContainerId = tmpReport_All.ContainerId
                                                             AND ContainerLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                                                             AND ContainerLO_Cash.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_BankAccount ON ContainerLO_BankAccount.ContainerId = tmpReport_All.ContainerId
                                                                    AND ContainerLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
                                                                    AND ContainerLO_BankAccount.ObjectId > 0

            LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                 AND ContainerLO_PaidKind.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                                 AND ContainerLO_Contract.ObjectId > 0

            LEFT JOIN ContainerLinkObject AS ContainerLO_ProfitLoss_inf ON ContainerLO_ProfitLoss_inf.ContainerId = tmpReport_All.ContainerId_ProfitLoss -- ContainerId_inf
                                                                       AND ContainerLO_ProfitLoss_inf.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                                       AND ContainerLO_ProfitLoss_inf.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Business_inf ON ContainerLO_Business_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                     AND ContainerLO_Business_inf.DescId = zc_ContainerLinkObject_Business()
                                                                     AND ContainerLO_Business_inf.ObjectId > 0

            LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical_inf ON ContainerLO_Juridical_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                      AND ContainerLO_Juridical_inf.DescId = zc_ContainerLinkObject_Juridical()
                                                                      AND ContainerLO_Juridical_inf.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Unit_inf ON ContainerLO_Unit_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                 AND ContainerLO_Unit_inf.DescId = zc_ContainerLinkObject_Unit()
                                                                 AND ContainerLO_Unit_inf.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Car_inf ON ContainerLO_Car_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                AND ContainerLO_Car_inf.DescId = zc_ContainerLinkObject_Car()
                                                                AND ContainerLO_Car_inf.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Member_inf ON ContainerLO_Member_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                   AND ContainerLO_Member_inf.DescId = zc_ContainerLinkObject_Member()
                                                                   AND ContainerLO_Member_inf.ObjectId > 0

            LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                  AND ContainerLO_InfoMoney.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney_inf ON ContainerLO_InfoMoney_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                      AND ContainerLO_InfoMoney_inf.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                      AND ContainerLO_InfoMoney_inf.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Goods ON ContainerLO_Goods.ContainerId = tmpReport_All.ContainerId
                                                              AND ContainerLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                              AND ContainerLO_Goods.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Goods_inf ON ContainerLO_Goods_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                  AND ContainerLO_Goods_inf.DescId = zc_ContainerLinkObject_Goods()
                                                                  AND ContainerLO_Goods_inf.ObjectId > 0
        GROUP BY ContainerLO_JuridicalBasis.ObjectId
               , ContainerLO_Business.ObjectId
               , COALESCE (ContainerLO_InfoMoney.ObjectId, ContainerLO_InfoMoney_inf.ObjectId)
               , ContainerLO_PaidKind.ObjectId
               , ContainerLO_Contract.ObjectId
               , COALESCE (ContainerLO_Cash.ObjectId, COALESCE (ContainerLO_BankAccount.ObjectId, COALESCE (ContainerLO_Juridical.ObjectId, COALESCE (ContainerLO_Unit.ObjectId, COALESCE (ContainerLO_Car.ObjectId, COALESCE (ContainerLO_Member.ObjectId
                         , COALESCE (ContainerLO_Juridical_inf.ObjectId, COALESCE (ContainerLO_Unit_inf.ObjectId, COALESCE (ContainerLO_Car_inf.ObjectId, ContainerLO_Member_inf.ObjectId)))))))))
               , COALESCE (ContainerLO_Goods.ObjectId, ContainerLO_Goods_inf.ObjectId)

               , tmpReport_All.MovementDescId
               , tmpReport_All.OperDate
               , tmpReport_All.MovementId  
               , tmpReport_All.InvNumber

               , tmpReport_All.AccountId
               , tmpReport_All.AccountId_inf
               , ContainerLO_ProfitLoss_inf.ObjectId
               , ContainerLO_Business_inf.ObjectId

               , tmpReport_All.BranchId_inf
               , tmpReport_All.UnitId_inf
               , tmpReport_All.RouteId_inf

               , tmpReport_All.OperPrice

       ) AS tmpReport

       LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpReport.JuridicalBasisId
       LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpReport.BusinessId
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpReport.PaidKindId
       LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpReport.ContractId

       LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId

       LEFT JOIN Object AS Object_Business_inf ON Object_Business_inf.Id = tmpReport.BusinessId_inf
       LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = tmpReport.BranchId_inf
       LEFT JOIN Object AS Object_Unit_inf ON Object_Unit_inf.Id = tmpReport.UnitId_inf
       LEFT JOIN Object AS Object_Route_inf ON Object_Route_inf.Id = tmpReport.RouteId_inf

       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

       LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpReport.AccountId
       LEFT JOIN Object_Account_View AS View_Account_inf ON View_Account_inf.AccountId = tmpReport.AccountId_inf

       LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss_inf ON View_ProfitLoss_inf.ProfitLossId = tmpReport.ProfitLossId_inf

       LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmpReport.ObjectId_Direction
       LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpReport.ObjectId_Destination

       LEFT JOIN ObjectDesc AS ObjectDesc_Direction ON ObjectDesc_Direction.Id = Object_Direction.DescId
       LEFT JOIN ObjectDesc AS ObjectDesc_Destination ON ObjectDesc_Destination.Id = Object_Destination.DescId

       LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                            ON ObjectLink_BankAccount_Bank.ObjectId = tmpReport.ObjectId_Direction
                           AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
       LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

    WHERE (View_ProfitLoss_inf.ProfitLossGroupId = inProfitLossGroupId OR 0 = inProfitLossGroupId)
      AND (View_ProfitLoss_inf.ProfitLossDirectionId = inProfitLossDirectionId OR 0 = inProfitLossDirectionId)
      AND (View_ProfitLoss_inf.ProfitLossId = inProfitLossId OR 0 = inProfitLossId)
      AND View_InfoMoney.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_60000() -- ���������� �����
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpReport_Account (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.09.14                                        * add zc_Enum_AccountDirection_70500
 16.09.14                          * 
*/

-- ����
-- SELECT * FROM gpReport_Account (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013', inAccountGroupId:= 0, inAccountDirectionId:= 0, inInfoMoneyId:= 0, inAccountId:= 0, inBusinessId:= 0, inProfitLossGroupId:= 0,  inProfitLossDirectionId:= 0,  inProfitLossId:= 0,  inBranchId:= 0, inSession:= zfCalc_UserAdmin());
