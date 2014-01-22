-- Function: gpReport_Account ()

DROP FUNCTION IF EXISTS gpReport_Account (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Account (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inAccountId    Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (InvNumber Integer, OperDate TDateTime, MovementDescName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
              , PersonalCode Integer, PersonalName TVarChar
              , JuridicalCode Integer, JuridicalName TVarChar
              , PaidKindName TVarChar, ContractName TVarChar
              , CarModelName TVarChar, CarCode Integer, CarName TVarChar
              , ObjectCode_Direction Integer, ObjectName_Direction TVarChar
              , ObjectCode_Destination Integer, ObjectName_Destination TVarChar

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
BEGIN

    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS AccountId, Container.Amount
                           FROM (SELECT AccountId FROM Object_Account_View /*WHERE Object_Account_View.AccountDirectionCode IN (20500, 30500, 70100, 100300, 110000)*/) AS tmpAccount -- счет 
                          -- FROM (SELECT Id AS AccountId FROM Object WHERE DescId = zc_Object_Account() AND ObjectCode IN (20503 /*30505, 30508, 70105, 100301, 110101*/)  /*WHERE Object_Account_View.AccountDirectionCode IN (20500, 30500, 70100, 100300, 110000)*/) AS tmpAccount -- счет 
                               JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                             AND Container.DescId = zc_Container_Summ()
                         )
    SELECT zfConvert_StringToNumber (tmpReport.InvNumber) AS InvNumber
         , tmpReport.OperDate
         , MovementDesc.ItemName AS MovementDescName
         , View_InfoMoney.ObjectCode             AS InfoMoneyCode
         , Object_InfoMoneyGroup.ValueData       AS InfoMoneyGroupName
         , Object_InfoMoneyDestination.ValueData AS InfoMoneyDestinationName
         , View_InfoMoney.ValueData              AS InfoMoneyName
         , Object_Member.ObjectCode AS PersonalCode
         , Object_Member.ValueData  AS PersonalName
         , Object_Juridical.ObjectCode     AS JuridicalCode
         , Object_Juridical.ValueData      AS JuridicalName
         , Object_PaidKind.ValueData       AS PaidKindName
         , Object_Contract.ValueData       AS ContractName
         , Object_CarModel.ValueData AS CarModelName
         , Object_Car.ObjectCode     AS CarCode
         , Object_Car.ValueData      AS CarName

         , Object_Direction.ObjectCode   AS ObjectCode_Direction
         , Object_Direction.ValueData    AS ObjectName_Direction
         , Object_Destination.ObjectCode AS ObjectCode_Destination
         , Object_Destination.ValueData  AS ObjectName_Destination

         , Object_Member_inf.ObjectCode   AS PersonalCode_inf
         , Object_Member_inf.ValueData    AS PersonalName_inf
         , Object_CarModel_inf.ValueData  AS CarModelName_inf
         , Object_Car_inf.ObjectCode      AS CarCode_inf
         , Object_Car_inf.ValueData       AS CarName_inf
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

         , Object_AccountGroup.ObjectCode AS AccountGroupCode, Object_AccountGroup.ValueData AS AccountGroupName
         , Object_AccountDirection.ObjectCode AS AccountDirectionCode, Object_AccountDirection.ValueData AS AccountDirectionName
         , View_Account.ObjectCode AS AccountCode, View_Account.ValueData AS AccountName
         , ('(' || CASE WHEN Object_AccountGroup.ObjectCode < 100000 THEN '0' ELSE '' END || View_Account.ObjectCode :: TVarChar || ') '
                || Object_AccountGroup.ValueData
                || CASE WHEN Object_AccountDirection.ValueData <> Object_AccountGroup.ValueData THEN ' ' || Object_AccountDirection.ValueData ELSE '' END
                || CASE WHEN View_Account.ValueData <> Object_AccountDirection.ValueData THEN ' ' || View_Account.ValueData ELSE '' END
           ) :: TVarChar AS AccountName_All

         , Object_AccountGroup_inf.ObjectCode AS AccountGroupCode_inf, Object_AccountGroup_inf.ValueData AS AccountGroupName_inf
         , Object_AccountDirection_inf.ObjectCode AS AccountDirectionCode_inf, Object_AccountDirection_inf.ValueData AS AccountDirectionName_inf
         , View_Account_inf.ObjectCode AS AccountCode_inf, View_Account_inf.ValueData AS AccountName_inf
         , ('(' || CASE WHEN Object_AccountGroup_inf.ObjectCode < 100000 THEN '0' ELSE '' END || View_Account_inf.ObjectCode :: TVarChar || ') '
                || Object_AccountGroup_inf.ValueData
                || CASE WHEN Object_AccountDirection_inf.ValueData <> Object_AccountGroup_inf.ValueData THEN ' ' || Object_AccountDirection_inf.ValueData ELSE '' END
                || CASE WHEN View_Account_inf.ValueData <> Object_AccountDirection_inf.ValueData THEN ' ' || View_Account_inf.ValueData ELSE '' END
           ) :: TVarChar AS AccountName_All_inf

         , ('(' || View_ProfitLoss_inf.ObjectCode :: TVarChar || ') '
                || Object_ProfitLossGroup_inf.ValueData
                || CASE WHEN Object_ProfitLossDirection_inf.ValueData <> Object_ProfitLossGroup_inf.ValueData THEN ' ' || Object_ProfitLossDirection_inf.ValueData ELSE '' END
                || CASE WHEN View_ProfitLoss_inf.ValueData <> Object_ProfitLossDirection_inf.ValueData THEN ' ' || View_ProfitLoss_inf.ValueData ELSE '' END
           ) :: TVarChar AS ProfitLossName_All_inf

   FROM      
       (SELECT COALESCE (ContainerLO_InfoMoney.ObjectId, tmpReport_All.InfoMoneyId_inf) AS InfoMoneyId
             , ContainerLO_Member.ObjectId    AS MemberId
             , ContainerLO_Car.ObjectId       AS CarId
             , ContainerLO_Juridical.ObjectId AS JuridicalId
             , ContainerLO_PaidKind.ObjectId  AS PaidKindId
             , ContainerLO_Contract.ObjectId  AS ContractId
             , COALESCE (ContainerLO_ProfitLoss.ObjectId, COALESCE (ContainerLO_Cash.ObjectId, COALESCE (ContainerLO_BankAccount.ObjectId, COALESCE (ContainerLO_Juridical.ObjectId, COALESCE (ContainerLO_Member.ObjectId, COALESCE (ContainerLO_Car.ObjectId, ContainerLO_Unit.ObjectId)))))) AS ObjectId_Direction
             , COALESCE (ContainerLO_Goods.ObjectId, tmpReport_All.GoodsId_inf) AS ObjectId_Destination

             , SUM (tmpReport_All.SummStart)  AS SummStart
             , SUM (tmpReport_All.SummIn)     AS SummIn
             , SUM (tmpReport_All.SummOut)    AS SummOut
             , SUM (tmpReport_All.SummEnd)    AS SummEnd
             , tmpReport_All.OperPrice
             , tmpReport_All.MovementDescId
             , tmpReport_All.MovementId
             , tmpReport_All.OperDate
             , tmpReport_All.InvNumber
             , tmpReport_All.AccountId
             , tmpReport_All.AccountId_inf
             , tmpReport_All.MemberId_inf
             , tmpReport_All.CarId_inf
             , tmpReport_All.RouteId_inf
             , tmpReport_All.UnitId_inf
             , tmpReport_All.BranchId_inf
             , ContainerLO_Business.ObjectId AS BusinessId_inf -- tmpReport_All.BusinessId_inf
             , tmpReport_All.ProfitLossId_inf
        FROM
            (SELECT tmpContainer.ContainerId
                  , tmpContainer.AccountId
                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS OperPrice
                  , 0 AS MovementDescId
                  , 0 AS MovementId
                  , NULL :: TDateTime AS OperDate
                  , '' AS InvNumber
                  , 0 AS MemberId_inf
                  , 0 AS CarId_inf
                  , 0 AS AccountId_inf
                  , 0 AS RouteId_inf
                  , 0 AS UnitId_inf
                  , 0 AS BranchId_inf
                  , 0 AS BusinessId_inf
                  , 0 AS ProfitLossId_inf
                  , 0 AS InfoMoneyId_inf
                  , 0 AS GoodsId_inf
             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                AND MIContainer.OperDate >= inStartDate
             GROUP BY tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.Amount
             HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
            UNION ALL
             SELECT tmpMIReport.ContainerId
                  , tmpMIReport.AccountId
                  , 0 AS SummStart
                  , 0 AS SummEnd
                  , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN tmpMIReport.SummIn - tmpMIReport.SummOut ELSE tmpMIReport.SummIn END)  AS SummIn
                  , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 0 ELSE tmpMIReport.SummOut END) AS SummOut
                  , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 0 ELSE tmpMIReport.OperPrice END AS OperPrice
                  , Movement.DescId AS MovementDescId
                  , tmpMIReport.MovementId
                  , tmpMIReport.OperDate
                  , Movement.InvNumber
                  , COALESCE (ContainerLO_Member.ObjectId, MovementLO_PersonalDriver.ObjectId /*COALESCE (MI_Personal.ObjectId, MovementLO_PersonalDriver.ObjectId)*/) AS MemberId_inf
                  , COALESCE (ContainerLO_Car.ObjectId, 0 /*MILinkObject_Car.ObjectId*/) AS CarId_inf
                  , tmpMIReport.AccountId_inf
                  , COALESCE (/*MI_Route.ObjectId,*/tmpMIReport.RouteId_inf, tmpMIReport.RouteId_inf) AS RouteId_inf
                  , tmpMIReport.UnitId_inf
                  , tmpMIReport.BranchId_inf
                  , ContainerLO_Business.ObjectId AS BusinessId_inf
                  , ContainerLO_ProfitLoss.ObjectId AS ProfitLossId_inf
                  , ContainerLO_InfoMoney.ObjectId AS InfoMoneyId_inf
                  , ContainerLO_Goods.ObjectId     AS GoodsId_inf
               FROM (SELECT tmpContainer.ContainerId
                          , tmpContainer.AccountId
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.ActiveAccountId <> zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.Amount
                                 ELSE 0
                            END AS SummIn
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                      THEN MIReport.Amount
                                 WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN -1 * MIReport.Amount
                                 ELSE 0
                            END AS SummOut
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.PassiveAccountId <> zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.PassiveContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() AND MIReport.ActiveAccountId <> zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_inf
                          , CASE WHEN MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      -- ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.PassiveContainerId
                                 WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      -- ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() AND MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_ProfitLoss
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()
                                      THEN MIReport.PassiveAccountId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                      THEN MIReport.ActiveAccountId
                            END AS AccountId_inf
                          , CASE WHEN MIContainer_Count.Amount <> 0 THEN MIReport.Amount / ABS (MIContainer_Count.Amount) ELSE 0 END AS OperPrice
                          , MIReport.MovementId
                          , MIReport.OperDate
                          , MIReport.MovementItemId
                          , MILinkObject_Route.ObjectId  AS RouteId_inf
                          , MILinkObject_Unit.ObjectId   AS UnitId_inf
                          , MILinkObject_Branch.ObjectId AS BranchId_inf
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
                          LEFT JOIN MovementItemContainer AS MIContainer_Count ON MIContainer_Count.MovementItemId = MIReport.MovementItemId
                                                                              AND MIContainer_Count.DescId = zc_MIContainer_Count()

                     ) AS tmpMIReport
                     LEFT JOIN Movement ON Movement.Id = tmpMIReport.MovementId
/*                     LEFT JOIN MovementItem AS MI_Transport ON MI_Transport.Id = tmpMIReport.MovementItemId
                                                           AND Movement.DescId = zc_Movement_Transport()
                     LEFT JOIN MovementItem AS MI_Route ON MI_Route.Id = MI_Transport.ParentId
*/

                     LEFT JOIN MovementLinkObject AS MovementLO_PersonalDriver
                                                  ON MovementLO_PersonalDriver.MovementId = Movement.Id
                                                 AND MovementLO_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                                                 AND MovementLO_PersonalDriver.ObjectId > 0
/*
                     LEFT JOIN MovementItem AS MI_Personal ON MI_Personal.Id = tmpMIReport.MovementItemId
                                                          AND Movement.DescId = zc_Movement_PersonalSendCash()
                                                          -- AND tmpMIReport.ContainerId_inf = 0 -- если это прибыль текущего периода, тогда нужные аналитики берем у элемента
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                      ON MILinkObject_Car.MovementItemId = MI_Personal.Id
                                                     AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
*/
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Member ON ContainerLO_Member.ContainerId = tmpMIReport.ContainerId_inf
                                                                        AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                        AND ContainerLO_Member.ObjectId > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpMIReport.ContainerId_inf
                                                                     AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                                     AND ContainerLO_Car.ObjectId > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Business ON ContainerLO_Business.ContainerId = tmpMIReport.ContainerId_ProfitLoss
                                                                         AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                                         AND ContainerLO_Business.ObjectId > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_ProfitLoss ON ContainerLO_ProfitLoss.ContainerId = tmpMIReport.ContainerId_ProfitLoss
                                                                            AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                                            AND ContainerLO_ProfitLoss.ObjectId > 0

                     LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = tmpMIReport.ContainerId_inf
                                                                           AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                           AND ContainerLO_InfoMoney.ObjectId > 0
                                                                           AND tmpMIReport.ContainerId_ProfitLoss > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Goods ON ContainerLO_Goods.ContainerId = tmpMIReport.ContainerId_inf
                                                                       AND ContainerLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                                       AND ContainerLO_Goods.ObjectId > 0
                                                                       AND tmpMIReport.ContainerId_ProfitLoss > 0
             GROUP BY tmpMIReport.ContainerId
                    , tmpMIReport.AccountId
                    , Movement.DescId
                    , tmpMIReport.MovementId
                    , tmpMIReport.OperDate
                    , Movement.InvNumber
                    , tmpMIReport.OperPrice
                    , ContainerLO_Member.ObjectId
--                    , MI_Personal.ObjectId
                    , MovementLO_PersonalDriver.ObjectId
                    , ContainerLO_Car.ObjectId
                    , tmpMIReport.AccountId_inf
--                    , MILinkObject_Car.ObjectId
--                    , MI_Route.ObjectId
                    , tmpMIReport.RouteId_inf
                    , tmpMIReport.UnitId_inf
                    , tmpMIReport.BranchId_inf
                    , ContainerLO_Business.ObjectId
                    , ContainerLO_ProfitLoss.ObjectId
                    , ContainerLO_InfoMoney.ObjectId
                    , ContainerLO_Goods.ObjectId

            ) AS tmpReport_All
            LEFT JOIN ContainerLinkObject AS ContainerLO_Business ON ContainerLO_Business.ContainerId = tmpReport_All.ContainerId
                                                                AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                                AND ContainerLO_Business.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                  AND ContainerLO_Juridical.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                 AND ContainerLO_PaidKind.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                                 AND ContainerLO_Contract.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Member ON ContainerLO_Member.ContainerId = tmpReport_All.ContainerId
                                                               AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                               AND ContainerLO_Member.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpReport_All.ContainerId
                                                            AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                            AND ContainerLO_Car.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Unit
                                          ON ContainerLO_Unit.ContainerId = tmpReport_All.ContainerId
                                         AND ContainerLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                         AND ContainerLO_Unit.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                          ON ContainerLO_ProfitLoss.ContainerId = tmpReport_All.ContainerId
                                         AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                         AND ContainerLO_ProfitLoss.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Cash
                                          ON ContainerLO_Cash.ContainerId = tmpReport_All.ContainerId
                                         AND ContainerLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                                         AND ContainerLO_Cash.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_BankAccount
                                          ON ContainerLO_BankAccount.ContainerId = tmpReport_All.ContainerId
                                         AND ContainerLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
                                         AND ContainerLO_BankAccount.ObjectId > 0

            LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                  AND ContainerLO_InfoMoney.ObjectId > 0
            LEFT JOIN ContainerLinkObject AS ContainerLO_Goods ON ContainerLO_Goods.ContainerId = tmpReport_All.ContainerId
                                                              AND ContainerLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                              AND ContainerLO_Goods.ObjectId > 0
        GROUP BY ContainerLO_Member.ObjectId
               , ContainerLO_InfoMoney.ObjectId
               , ContainerLO_Car.ObjectId
               , ContainerLO_Business.ObjectId
               , ContainerLO_Juridical.ObjectId
               , ContainerLO_PaidKind.ObjectId
               , ContainerLO_Contract.ObjectId
               , ContainerLO_Goods.ObjectId
               , ContainerLO_Unit.ObjectId
               , ContainerLO_ProfitLoss.ObjectId
               , ContainerLO_Cash.ObjectId
               , ContainerLO_BankAccount.ObjectId
               , tmpReport_All.MovementDescId
               , tmpReport_All.MovementId
               , tmpReport_All.OperDate
               , tmpReport_All.InvNumber
               , tmpReport_All.OperPrice
               , tmpReport_All.AccountId
               , tmpReport_All.AccountId_inf
               , tmpReport_All.MemberId_inf
               , tmpReport_All.CarId_inf
               , tmpReport_All.RouteId_inf
               , tmpReport_All.UnitId_inf
               , tmpReport_All.BranchId_inf
               , tmpReport_All.BusinessId_inf
               , tmpReport_All.ProfitLossId_inf
               , tmpReport_All.InfoMoneyId_inf
               , tmpReport_All.GoodsId_inf
       ) AS tmpReport

       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpReport.JuridicalId
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpReport.PaidKindId
       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpReport.ContractId

       -- LEFT JOIN Object_Personal_View AS Object_Member_inf ON Object_Member_inf.PersonalId = tmpReport.PersonalId_inf
       -- LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_inf
       --                      ON ObjectLink_Personal_Member_inf.ObjectId = tmpReport.MemberId_inf
       --                     AND ObjectLink_Personal_Member_inf.DescId = zc_ObjectLink_Personal_Member()
       LEFT JOIN Object AS Object_Member_inf ON Object_Member_inf.Id = tmpReport.MemberId_inf -- ObjectLink_Personal_Member_inf.ChildObjectId

       LEFT JOIN Object AS Object_Car_inf ON Object_Car_inf.Id = tmpReport.CarId_inf
       LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel_inf ON ObjectLink_Car_CarModel_inf.ObjectId = Object_Car_inf.Id
                                                      AND ObjectLink_Car_CarModel_inf.DescId = zc_ObjectLink_Car_CarModel()
       LEFT JOIN Object AS Object_CarModel_inf ON Object_CarModel_inf.Id = ObjectLink_Car_CarModel_inf.ChildObjectId
       LEFT JOIN Object AS Object_Route_inf ON Object_Route_inf.Id = tmpReport.RouteId_inf

       -- LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
       LEFT JOIN Object AS View_InfoMoney ON View_InfoMoney.Id = tmpReport.InfoMoneyId
       LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                            ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = tmpReport.InfoMoneyId
                           AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
       LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
       LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                            ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = tmpReport.InfoMoneyId
                           AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
       LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

       -- LEFT JOIN Object_Personal_View AS Object_Member ON Object_Member.PersonalId = tmpReport.PersonalId
       -- LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
       --                      ON ObjectLink_Personal_Member.ObjectId = tmpReport.MemberId
       --                     AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
       LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpReport.MemberId -- ObjectLink_Personal_Member.ChildObjectId

       LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpReport.CarId
       LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                      AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
       LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

       LEFT JOIN Object AS Object_Unit_inf ON Object_Unit_inf.Id = tmpReport.UnitId_inf
       LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = tmpReport.BranchId_inf
       LEFT JOIN Object AS Object_Business_inf ON Object_Business_inf.Id = tmpReport.BusinessId_inf

       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

       -- LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpReport.AccountId
       LEFT JOIN Object AS View_Account ON View_Account.Id = tmpReport.AccountId
       LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                            ON ObjectLink_Account_AccountGroup.ObjectId = tmpReport.AccountId
                           AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
       LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId
       LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                            ON ObjectLink_Account_AccountDirection.ObjectId = tmpReport.AccountId
                           AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
       LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId

       -- LEFT JOIN Object_Account_View AS View_Account_inf ON View_Account_inf.AccountId = tmpReport.AccountId_inf
       LEFT JOIN Object AS View_Account_inf ON View_Account_inf.Id = tmpReport.AccountId_inf
       LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup_inf
                            ON ObjectLink_Account_AccountGroup_inf.ObjectId = tmpReport.AccountId_inf
                           AND ObjectLink_Account_AccountGroup_inf.DescId = zc_ObjectLink_Account_AccountGroup()
       LEFT JOIN Object AS Object_AccountGroup_inf ON Object_AccountGroup_inf.Id = ObjectLink_Account_AccountGroup_inf.ChildObjectId
       LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection_inf
                            ON ObjectLink_Account_AccountDirection_inf.ObjectId = tmpReport.AccountId_inf
                           AND ObjectLink_Account_AccountDirection_inf.DescId = zc_ObjectLink_Account_AccountDirection()
       LEFT JOIN Object AS Object_AccountDirection_inf ON Object_AccountDirection_inf.Id = ObjectLink_Account_AccountDirection_inf.ChildObjectId

       -- LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss_inf ON View_ProfitLoss_inf.ProfitLossId = tmpReport.ProfitLossId_inf
       LEFT JOIN Object AS View_ProfitLoss_inf ON View_ProfitLoss_inf.Id = tmpReport.ProfitLossId_inf
       LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossGroup_inf
                            ON ObjectLink_ProfitLoss_ProfitLossGroup_inf.ObjectId = tmpReport.ProfitLossId_inf
                           AND ObjectLink_ProfitLoss_ProfitLossGroup_inf.DescId = zc_ObjectLink_ProfitLoss_ProfitLossGroup()
       LEFT JOIN Object AS Object_ProfitLossGroup_inf ON Object_ProfitLossGroup_inf.Id = ObjectLink_ProfitLoss_ProfitLossGroup_inf.ChildObjectId
       LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossDirection_inf
                            ON ObjectLink_ProfitLoss_ProfitLossDirection_inf.ObjectId = tmpReport.ProfitLossId_inf
                           AND ObjectLink_ProfitLoss_ProfitLossDirection_inf.DescId = zc_ObjectLink_ProfitLoss_ProfitLossDirection()
       LEFT JOIN Object AS Object_ProfitLossDirection_inf ON Object_ProfitLossDirection_inf.Id = ObjectLink_ProfitLoss_ProfitLossDirection_inf.ChildObjectId

       LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmpReport.ObjectId_Direction
       LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpReport.ObjectId_Destination
    ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Account (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.14                                        * add CarId
 21.12.13                                        * Personal -> Member
 02.11.13                                        * add Account...
 01.11.13                                        * all
 29.10.13                                        * err InfoManey
 07.10.13         *  
*/

-- тест
-- SELECT * FROM gpReport_Account (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013', inAccountId:= null, inSession:= zfCalc_UserAdmin());
