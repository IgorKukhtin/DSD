-- Function: lpReport_AccountMotion_noBalance ()

DROP FUNCTION IF EXISTS lpReport_AccountMotion_noBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpReport_AccountMotion_noBalance (
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
    IN inMovementDescId         Integer ,
    IN inUserId                 Integer ,
    IN inIsMovement             Boolean ,
    IN inIsGoods                Boolean ,
    IN inIsGoodsKind            Boolean ,
    IN inIsDetail               Boolean
)
RETURNS TABLE  (InvNumber Integer, MovementId Integer, OperDate TDateTime, OperDatePartner TDateTime, MovementDescName TVarChar
              , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
              , JuridicalBasisCode Integer, JuridicalBasisName TVarChar
              , BusinessCode Integer, BusinessName TVarChar
              , PaidKindName TVarChar, ContractName TVarChar
              , ObjectId_Direction Integer, ObjectCode_Direction Integer, ObjectName_Direction TVarChar
              , ObjectCode_Destination Integer, ObjectName_Destination TVarChar
              , DescName_Direction TVarChar
              , DescName_Destination TVarChar
              , GoodsKindName TVarChar
              , RouteCode_inf Integer, RouteName_inf TVarChar
              , UnitCode_inf Integer, UnitName_inf TVarChar
              , BranchCode_inf Integer, BranchName_inf TVarChar
              , BusinessCode_inf Integer, BusinessName_inf TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat--, OperPrice TFloat
              , AccountGroupCode Integer, AccountGroupName TVarChar
              , AccountDirectionCode Integer, AccountDirectionName TVarChar
              , AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
              , AccountGroupCode_inf Integer, AccountGroupName_inf TVarChar
              , AccountDirectionCode_inf Integer, AccountDirectionName_inf TVarChar
              , AccountCode_inf Integer, AccountName_inf TVarChar, AccountName_All_inf TVarChar
              , ProfitLossName_All_inf TVarChar

              , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer
              , InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar
              , InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar
              )
AS
$BODY$
   DECLARE vbIsMovement Boolean;
   DECLARE vbIsAll Boolean;
BEGIN
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, inUserId);


     -- Ограниченние - нет доступа к Отчету по счету
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = 10657333)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав к отчету По счету.';
     END IF;


     -- Блокируем ему просмотр
     IF inUserId = 9457 -- Климентьев К.И.
     THEN
         inUserId:= NULL;
         RETURN;
     END IF;

     -- !!!
     vbIsAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId);


    -- оптимизация
    CREATE TEMP TABLE tmpContainer ON COMMIT DROP
      AS (SELECT Container.Id                  AS ContainerId
               , Container.ObjectId            AS AccountId
               , Container.Amount              AS Amount
               , ContainerLO_Business.ObjectId AS BusinessId
          FROM (SELECT AccountId FROM Object_Account_View
                WHERE -- !!!ONLY!!! inAccountId OR inAccountGroupId OR inAccountDirectionId
                     ((Object_Account_View.AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                   OR (Object_Account_View.AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                   OR Object_Account_View.AccountId = COALESCE (inAccountId, 0)
                     )
                  OR (vbIsAll = TRUE
                  AND COALESCE (inAccountGroupId, 0) = 0 AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0
                     )
                ) AS tmpAccount -- счет
  
               INNER JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                   AND Container.DescId   = zc_Container_SummAsset()
               LEFT JOIN ContainerLinkObject AS ContainerLO_Business
                                             ON ContainerLO_Business.ContainerId = Container.Id
                                            AND ContainerLO_Business.DescId      = zc_ContainerLinkObject_Business()
                                            AND ContainerLO_Business.ObjectId    > 0
          WHERE ContainerLO_Business.ObjectId = inBusinessId OR COALESCE (inBusinessId, 0) = 0
         );

    -- оптимизация
    ANALYZE tmpContainer;

    -- Результат
    RETURN QUERY
    WITH tmpContainer_Remains AS (SELECT tmpContainer.BusinessId
                                       , tmpContainer.AccountId
                                       , tmpContainer.ContainerId
                                       , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                                       , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                                  FROM tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY tmpContainer.BusinessId, tmpContainer.ContainerId, tmpContainer.AccountId, tmpContainer.Amount
                                  HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                                      OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) <> 0)
                                 )
    , tmpContainer_Motion AS (SELECT tmpContainer.BusinessId
                                   , tmpContainer.ContainerId
                                   , tmpContainer.AccountId
                                   , MIContainer.MovementDescId
                                   , CASE WHEN inIsMovement = TRUE THEN MIContainer.MovementId ELSE 0 END :: Integer AS MovementId
                                   , MIContainer.MovementItemId
                                   , MIContainer.ContainerId_Analyzer
                                   , CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Currency()) THEN MIContainer.ObjectIntId_Analyzer ELSE 0 END AS ObjectIntId_Analyzer
                                   , CASE WHEN tmpContainer.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                               THEN tmpContainer.ContainerId
                                          ELSE 0
                                     END AS ContainerId_ProfitLoss

                                   , CASE WHEN inIsGoodsKind = TRUE AND inIsGoods = TRUE AND MIContainer.MovementDescId NOT IN (zc_Movement_Currency()) THEN MIContainer.ObjectIntId_Analyzer ELSE 0 END AS GoodsKindId

                                   , CASE WHEN inIsMovement = TRUE THEN MIContainer.ObjectId_Analyzer ELSE 0 END :: Integer AS ObjectId_inf

                                   ,  (CASE WHEN MIContainer.isActive = TRUE AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                                            -- WHEN MIContainer.Amount > 0 AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                                                    THEN MIContainer.Amount
                                               ELSE 0
                                          END) AS SummIn

                                   ,  (CASE WHEN MIContainer.isActive = FALSE OR MIContainer.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                            -- WHEN MIContainer.Amount < 0 OR MIContainer.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS SummOut

                              FROM tmpContainer
                                   LEFT JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                  AND MIContainer.DescId      = zc_MIContainer_SummAsset()
                                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              )
    , tmpAnalyzer AS (SELECT Container.Id
                           , Container.ObjectId
                      FROM Container
                      WHERE Container.Id IN (SELECT DISTINCT tmpContainer_Motion.ContainerId_Analyzer FROM tmpContainer_Motion WHERE ContainerId_Analyzer > 0)
                     )
    , tmpMovement AS (SELECT Movement.Id
                           , Movement.InvNumber
                           , Movement.OperDate
                      FROM Movement
                      WHERE Movement.Id IN (SELECT DISTINCT tmpContainer_Motion.MovementId FROM tmpContainer_Motion)
                     )
    , tmpMD_OperDatePartner AS (SELECT MovementDate_OperDatePartner.*
                                FROM MovementDate AS MovementDate_OperDatePartner
                                WHERE MovementDate_OperDatePartner.MovementId IN (SELECT DISTINCT tmpContainer_Motion.MovementId FROM tmpContainer_Motion)
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                               )
    /*, tmpMIContainer AS (SELECT MovementItemContainer.MovementItemId
                              , MovementItemContainer.Amount
                              , MovementItemContainer.MovementDescId
                         FROM MovementItemContainer
                         WHERE MovementItemContainer.MovementItemId IN (SELECT DISTINCT tmpContainer_Motion.MovementItemId FROM tmpContainer_Motion)
                           AND MovementItemContainer.DescId = zc_MIContainer_CountAsset()
                         )*/
    , tmpMotion AS (SELECT tmpContainer.BusinessId             AS BusinessId
                         , tmpContainer.ContainerId            AS ContainerId
                         , tmpContainer.AccountId              AS AccountId
                         , tmpContainer.ContainerId_Analyzer   AS ContainerId_inf
                         , tmpContainer.ObjectIntId_Analyzer   AS ObjectIntId_inf
                         , tmpAnalyzer.ObjectId                AS AccountId_inf
                         , tmpContainer.GoodsKindId

                         , tmpContainer.ObjectId_inf
                         , tmpContainer.MovementItemId         AS MovementItemId

                         , tmpContainer.MovementDescId
                         , Movement.Id AS MovementId
                         , Movement.InvNumber
                         -- , tmpContainer.OperDate
                         , Movement.OperDate

                         , tmpContainer.ContainerId_ProfitLoss
                         , SUM (tmpContainer.SummIn)                          AS SummIn
                         , SUM (tmpContainer.SummOut)                          AS SummOut

                         --, CASE WHEN COALESCE (MIContainer_Count.Amount, 0) <> 0 THEN ABS (tmpContainer.Amount) / ABS (MIContainer_Count.Amount) ELSE 0 END AS OperPrice

                    FROM tmpContainer_Motion AS tmpContainer

                         LEFT JOIN tmpAnalyzer ON tmpAnalyzer.Id = tmpContainer.ContainerId_Analyzer
                         LEFT JOIN tmpMovement AS Movement ON Movement.Id = tmpContainer.MovementId

                         -- LEFT JOIN tmpMIContainer AS MIContainer_Count ON MIContainer_Count.MovementItemId = tmpContainer.MovementItemId
                         --                                              AND MIContainer_Count.MovementDescId IN (zc_Movement_Transport(), zc_Movement_Income())
                    WHERE tmpContainer.SummIn <> 0 OR tmpContainer.SummOut <> 0
                    GROUP BY tmpContainer.BusinessId
                           , tmpContainer.ContainerId
                           , tmpContainer.AccountId

                           , tmpContainer.ContainerId_Analyzer
                           , tmpContainer.ObjectIntId_Analyzer
                           , tmpAnalyzer.ObjectId
                           , tmpContainer.ObjectId_inf
                           , tmpContainer.MovementDescId
                           , Movement.Id
                           , Movement.InvNumber
                           , Movement.OperDate
                           , tmpContainer.MovementItemId
                           , tmpContainer.ContainerId_ProfitLoss
                           , tmpContainer.GoodsKindId
                    )

    , tmpMILO AS (SELECT *
                  FROM MovementItemLinkObject AS MILO
                  WHERE MILO.MovementItemId IN (SELECT DISTINCT tmpMotion.MovementItemId FROM tmpMotion)
                 )
      , tmpMI AS (SELECT *
                  FROM MovementItem AS MI
                  WHERE MI.Id IN (SELECT DISTINCT tmpMotion.MovementItemId
                                  FROM tmpMotion
                                  WHERE tmpMotion.MovementDescId = zc_Movement_Cash()
                                    AND tmpMotion.AccountId      = zc_Enum_Account_100301() -- прибыль текущего периода
                                 )
                    AND MI.DescId         = zc_MI_Master()
                 )
    , tmpData AS (SELECT tmp.BusinessId
                       , tmp.ContainerId
                       , tmp.AccountId
                       , tmp.ContainerId_inf
                       , tmp.ObjectIntId_inf
                       , tmp.AccountId_inf
                       , tmp.ContainerId_ProfitLoss
                       , tmp.ObjectId_inf
                       , tmp.GoodsKindId
                       , tmp.MovementId
                       , tmp.MovementDescId
                       , tmp.InvNumber
                       , tmp.OperDate
                       , 0 AS SummStart
                       , 0 AS SummEnd
                       , tmp.SummIn
                       , tmp.SummOut
                       --, tmp.OperPrice

                       , CASE WHEN inIsMovement = TRUE THEN MILinkObject_MoneyPlace.ObjectId ELSE 0 END :: Integer AS MoneyPlaceId_inf
                       , CASE WHEN inIsMovement = TRUE THEN MILinkObject_InfoMoney.ObjectId  ELSE 0 END :: Integer AS InfoMoneyId_inf
                       , CASE WHEN inIsMovement = TRUE THEN tmpMI.ObjectId                   ELSE 0 END :: Integer AS CashId_inf
                       , MILinkObject_Route.ObjectId  AS RouteId_inf
                       , MILinkObject_Unit.ObjectId   AS UnitId_inf
                       , MILinkObject_Branch.ObjectId AS BranchId_inf

                  FROM tmpMotion AS tmp
                       LEFT JOIN tmpMI AS tmpMI
                                       ON tmpMI.Id     = tmp.MovementItemId
                                      AND tmpMI.DescId = zc_MI_Master()
                       LEFT JOIN tmpMILO AS MILinkObject_Route
                                         ON MILinkObject_Route.MovementItemId = tmp.MovementItemId
                                        AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                       LEFT JOIN tmpMILO AS MILinkObject_Unit
                                         ON MILinkObject_Unit.MovementItemId = tmp.MovementItemId
                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                       LEFT JOIN tmpMILO AS MILinkObject_Branch
                                         ON MILinkObject_Branch.MovementItemId = tmp.MovementItemId
                                        AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                       LEFT JOIN tmpMILO AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = tmp.MovementItemId
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                       LEFT JOIN tmpMILO AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = tmp.MovementItemId
                                        AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                        
                  WHERE MILinkObject_Branch.ObjectId = inBranchId OR inBranchId = 0
                  )

    , tmpReport_All AS (-- остатки нач. и конечн.
                        SELECT tmp.BusinessId
                             , tmp.ContainerId
                             , tmp.AccountId
                             , 0 AS ContainerId_inf
                             , 0 AS ObjectIntId_inf
                             , 0 AS AccountId_inf
                             , 0 AS ContainerId_ProfitLoss
                             , 0 AS ObjectId_inf
                             , 0 AS GoodsKindId
                             , 0 AS MovementId
                             , 0 AS MovementDescId
                             , ''   :: TVarChar  AS InvNumber
                             , NULL :: TDateTime AS OperDate
                             , tmp.SummStart
                             , tmp.SummEnd
                             , 0 AS SummIn
                             , 0 AS SummOut
                             , 0 AS MoneyPlaceId_inf
                             , 0 AS InfoMoneyId_inf
                             , 0 AS CashId_inf
                             , 0 AS RouteId_inf
                             , 0 AS UnitId_inf
                             , 0 AS BranchId_inf
                        FROM tmpContainer_Remains AS tmp
                       UNION ALL
                        --движение
                        SELECT tmp.BusinessId
                             , tmp.ContainerId
                             , tmp.AccountId
                             , tmp.ContainerId_inf
                             , tmp.ObjectIntId_inf
                             , tmp.AccountId_inf
                             , tmp.ContainerId_ProfitLoss
                             , tmp.ObjectId_inf
                             , tmp.GoodsKindId
                             , tmp.MovementId
                             , tmp.MovementDescId
                             , tmp.InvNumber
                             , tmp.OperDate
                             , 0 AS SummStart
                             , 0 AS SummEnd
                             , tmp.SummIn
                             , tmp.SummOut
                             , tmp.MoneyPlaceId_inf
                             , tmp.InfoMoneyId_inf
                             , tmp.CashId_inf
                             , tmp.RouteId_inf
                             , tmp.UnitId_inf
                             , tmp.BranchId_inf
                        FROM tmpData AS tmp
                        )
    , tmpCLO_Conainer AS (SELECT DISTINCT tmpReport_All.ContainerId FROM tmpReport_All WHERE tmpReport_All.ContainerId > 0
                         UNION
                          SELECT DISTINCT tmpReport_All.ContainerId_inf FROM tmpReport_All WHERE tmpReport_All.ContainerId_inf > 0
                         )
    , tmpCLO AS (SELECT ContainerLinkObject.*
                 FROM ContainerLinkObject
                 WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpCLO_Conainer.ContainerId FROM tmpCLO_Conainer)
                    -- AND 1=0
                   /*AND ContainerLinkObject.ObjectId > 0
                   AND ContainerLinkObject.DescId IN (zc_ContainerLinkObject_JuridicalBasis()
                                                    , zc_ContainerLinkObject_Juridical()
                                                    , zc_ContainerLinkObject_Unit()
                                                    , zc_ContainerLinkObject_Car()
                                                    , zc_ContainerLinkObject_Member()
                                                    , zc_ContainerLinkObject_Cash()
                                                    , zc_ContainerLinkObject_BankAccount()
                                                    , zc_ContainerLinkObject_PaidKind()
                                                    , zc_ContainerLinkObject_Contract()
                                                    , zc_ContainerLinkObject_InfoMoney()
                                                    , zc_ContainerLinkObject_Goods()
                                                    , zc_ContainerLinkObject_Business()
                                                    , zc_ContainerLinkObject_Branch()
                                                      --
                                                    , zc_ContainerLinkObject_ProfitLoss()
                                                    , zc_ContainerLinkObject_InfoMoneyDetail()
                                                     )*/

                 )
    , tmpReport AS (SELECT ContainerLO_JuridicalBasis.ObjectId AS JuridicalBasisId
                         , tmpReport_All.BusinessId
                         , CASE WHEN tmpReport_All.MovementDescId IN (zc_Movement_Cash(), zc_Movement_Service()) AND tmpReport_All.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                     THEN tmpReport_All.InfoMoneyId_inf
                                     ELSE COALESCE (ContainerLO_InfoMoney.ObjectId, ContainerLO_InfoMoney_inf.ObjectId)
                           END AS InfoMoneyId
                         , ContainerLO_PaidKind.ObjectId  AS PaidKindId
                         , ContainerLO_Contract.ObjectId  AS ContractId
                         , ContainerLO_Currency.ObjectId  AS CurrencyId
                         , tmpReport_All.GoodsKindId
                         , CASE WHEN 1=0 AND tmpReport_All.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                     THEN tmpReport_All.ObjectId_inf
                                WHEN tmpReport_All.MovementDescId IN (zc_Movement_Currency())
                                     THEN tmpReport_All.ObjectIntId_inf -- COALESCE (ContainerLO_Cash_inf.ObjectId, COALESCE (ContainerLO_BankAccount_inf.ObjectId, ContainerLO_Juridical_inf.ObjectId))
                                ELSE COALESCE (ContainerLO_Cash.ObjectId, COALESCE (ContainerLO_BankAccount.ObjectId, COALESCE (ContainerLO_Juridical.ObjectId, COALESCE (ContainerLO_Unit.ObjectId, COALESCE (ContainerLO_Car.ObjectId, COALESCE (ContainerLO_Member.ObjectId
                                             , COALESCE (ContainerLO_Juridical_inf.ObjectId, COALESCE (ContainerLO_Unit_inf.ObjectId, COALESCE (ContainerLO_Car_inf.ObjectId, ContainerLO_Member_inf.ObjectId)))))))))
                           END AS ObjectId_Direction
                         , CASE WHEN 1=1 AND tmpReport_All.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                     THEN COALESCE (ContainerLO_Cash_inf.ObjectId, ContainerLO_BankAccount_inf.ObjectId)
                                WHEN tmpReport_All.MovementDescId IN (zc_Movement_Currency())
                                     THEN COALESCE (ContainerLO_Cash_inf.ObjectId, COALESCE (ContainerLO_BankAccount_inf.ObjectId, ContainerLO_Juridical_inf.ObjectId))
                                ELSE COALESCE (ContainerLO_Goods.ObjectId, COALESCE (ContainerLO_Goods_inf.ObjectId, tmpReport_All.ObjectId_inf))
                           END AS ObjectId_Destination

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
                         , COALESCE (ContainerLO_ProfitLoss_inf.ObjectId, ContainerLO_ProfitLoss_inf_two.ObjectId) AS ProfitLossId_inf
                         , ContainerLO_Business_inf.ObjectId AS BusinessId_inf
                         , COALESCE (ContainerLO_Branch_inf.ObjectId, tmpReport_All.BranchId_inf) AS BranchId_inf

                         , tmpReport_All.ObjectId_inf
                         , tmpReport_All.MoneyPlaceId_inf
                         , tmpReport_All.CashId_inf
                         , tmpReport_All.UnitId_inf
                         , tmpReport_All.RouteId_inf
                         , tmpReport_All.ContainerId_inf

                         , CLO_InfoMoneyDetail.ObjectId AS ObjectId_Detail

                    FROM tmpReport_All
                        LEFT JOIN tmpCLO AS ContainerLO_JuridicalBasis ON ContainerLO_JuridicalBasis.ContainerId = tmpReport_All.ContainerId
                                                                                   AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                                                   AND ContainerLO_JuridicalBasis.ObjectId > 0

                        LEFT JOIN tmpCLO AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = tmpReport_All.ContainerId
                                                                              AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                              AND ContainerLO_Juridical.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Unit ON ContainerLO_Unit.ContainerId = tmpReport_All.ContainerId
                                                                         AND ContainerLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                         AND ContainerLO_Unit.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpReport_All.ContainerId
                                                                        AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                                        AND ContainerLO_Car.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Member ON ContainerLO_Member.ContainerId = tmpReport_All.ContainerId
                                                                           AND ContainerLO_Member.DescId = zc_ContainerLinkObject_Member()
                                                                           AND ContainerLO_Member.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Currency ON ContainerLO_Currency.ContainerId = tmpReport_All.ContainerId
                                                                AND ContainerLO_Currency.DescId      = zc_ContainerLinkObject_Currency()
                        LEFT JOIN tmpCLO AS ContainerLO_Cash ON ContainerLO_Cash.ContainerId = tmpReport_All.ContainerId
                                                                         AND ContainerLO_Cash.DescId = zc_ContainerLinkObject_Cash()
                                                                         AND ContainerLO_Cash.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_BankAccount ON ContainerLO_BankAccount.ContainerId = tmpReport_All.ContainerId
                                                                                AND ContainerLO_BankAccount.DescId = zc_ContainerLinkObject_BankAccount()
                                                                                AND ContainerLO_BankAccount.ObjectId > 0

                        LEFT JOIN tmpCLO AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = tmpReport_All.ContainerId
                                                                             AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                             AND ContainerLO_PaidKind.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = tmpReport_All.ContainerId
                                                                             AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                                             AND ContainerLO_Contract.ObjectId > 0

                        LEFT JOIN tmpCLO AS ContainerLO_ProfitLoss_inf ON ContainerLO_ProfitLoss_inf.ContainerId = tmpReport_All.ContainerId_ProfitLoss
                                                                      AND ContainerLO_ProfitLoss_inf.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                                      AND ContainerLO_ProfitLoss_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_ProfitLoss_inf_two ON ContainerLO_ProfitLoss_inf_two.ContainerId = tmpReport_All.ContainerId_inf
                                                                          AND ContainerLO_ProfitLoss_inf_two.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                                          AND ContainerLO_ProfitLoss_inf_two.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Business_inf ON ContainerLO_Business_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                                 AND ContainerLO_Business_inf.DescId = zc_ContainerLinkObject_Business()
                                                                                 AND ContainerLO_Business_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Branch_inf ON ContainerLO_Branch_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                               AND ContainerLO_Branch_inf.DescId = zc_ContainerLinkObject_Branch()
                                                                               AND ContainerLO_Branch_inf.ObjectId > 0

                        LEFT JOIN tmpCLO AS ContainerLO_Juridical_inf ON ContainerLO_Juridical_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                     AND ContainerLO_Juridical_inf.DescId = zc_ContainerLinkObject_Juridical()
                                                                     AND ContainerLO_Juridical_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Unit_inf ON ContainerLO_Unit_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                AND ContainerLO_Unit_inf.DescId = zc_ContainerLinkObject_Unit()
                                                                AND ContainerLO_Unit_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Car_inf ON ContainerLO_Car_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                               AND ContainerLO_Car_inf.DescId = zc_ContainerLinkObject_Car()
                                                               AND ContainerLO_Car_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Member_inf ON ContainerLO_Member_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                  AND ContainerLO_Member_inf.DescId = zc_ContainerLinkObject_Member()
                                                                  AND ContainerLO_Member_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Cash_inf ON ContainerLO_Cash_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                AND ContainerLO_Cash_inf.DescId = zc_ContainerLinkObject_Cash()
                                                                AND ContainerLO_Cash_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_BankAccount_inf ON ContainerLO_BankAccount_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                       AND ContainerLO_BankAccount_inf.DescId = zc_ContainerLinkObject_BankAccount()
                                                                       AND ContainerLO_BankAccount_inf.ObjectId > 0

                        LEFT JOIN tmpCLO AS ContainerLO_InfoMoney_inf ON ContainerLO_InfoMoney_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                                  AND ContainerLO_InfoMoney_inf.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                                  AND ContainerLO_InfoMoney_inf.ObjectId > 0
                        LEFT JOIN tmpCLO AS ContainerLO_Goods_inf ON ContainerLO_Goods_inf.ContainerId = tmpReport_All.ContainerId_inf
                                                                              AND ContainerLO_Goods_inf.DescId = zc_ContainerLinkObject_Goods()
                                                                              AND ContainerLO_Goods_inf.ObjectId > 0
                                                                              AND inIsGoods = TRUE
                        LEFT JOIN tmpCLO AS ContainerLO_Goods ON ContainerLO_Goods.ContainerId           = tmpReport_All.ContainerId
                                                                          AND ContainerLO_Goods.DescId   = zc_ContainerLinkObject_Goods()
                                                                          AND ContainerLO_Goods.ObjectId > 0
                                                                          AND inIsGoods                  = TRUE
                        LEFT JOIN tmpCLO AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId           = tmpReport_All.ContainerId
                                                                              AND ContainerLO_InfoMoney.DescId   = zc_ContainerLinkObject_InfoMoney()
                                                                              AND ContainerLO_InfoMoney.ObjectId > 0
                        LEFT JOIN tmpCLO AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId         = tmpReport_All.ContainerId
                                                                          AND CLO_InfoMoneyDetail.DescId   = zc_ContainerLinkObject_InfoMoneyDetail()
                                                                          AND CLO_InfoMoneyDetail.ObjectId > 0
                                                                          AND inIsDetail                   = TRUE
                    GROUP BY ContainerLO_JuridicalBasis.ObjectId
                           , tmpReport_All.BusinessId
                           , COALESCE (ContainerLO_InfoMoney.ObjectId, ContainerLO_InfoMoney_inf.ObjectId)
                           , ContainerLO_PaidKind.ObjectId
                           , ContainerLO_Contract.ObjectId
                           , ContainerLO_Currency.ObjectId
                           , CASE WHEN 1=0 AND tmpReport_All.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                       THEN tmpReport_All.ObjectId_inf
                                WHEN tmpReport_All.MovementDescId IN (zc_Movement_Currency())
                                     THEN tmpReport_All.ObjectIntId_inf -- COALESCE (ContainerLO_Cash_inf.ObjectId, COALESCE (ContainerLO_BankAccount_inf.ObjectId, ContainerLO_Juridical_inf.ObjectId))
                                  ELSE COALESCE (ContainerLO_Cash.ObjectId, COALESCE (ContainerLO_BankAccount.ObjectId, COALESCE (ContainerLO_Juridical.ObjectId, COALESCE (ContainerLO_Unit.ObjectId, COALESCE (ContainerLO_Car.ObjectId, COALESCE (ContainerLO_Member.ObjectId
                                               , COALESCE (ContainerLO_Juridical_inf.ObjectId, COALESCE (ContainerLO_Unit_inf.ObjectId, COALESCE (ContainerLO_Car_inf.ObjectId, ContainerLO_Member_inf.ObjectId)))))))))
                             END
                           , CASE WHEN 1=1 AND tmpReport_All.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                       THEN COALESCE (ContainerLO_Cash_inf.ObjectId, ContainerLO_BankAccount_inf.ObjectId)
                                  WHEN tmpReport_All.MovementDescId IN (zc_Movement_Currency())
                                       THEN COALESCE (ContainerLO_Cash_inf.ObjectId, COALESCE (ContainerLO_BankAccount_inf.ObjectId, ContainerLO_Juridical_inf.ObjectId))
                                  ELSE COALESCE (ContainerLO_Goods.ObjectId, COALESCE (ContainerLO_Goods_inf.ObjectId, tmpReport_All.ObjectId_inf))
                             END

                           , tmpReport_All.MovementDescId
                           , tmpReport_All.OperDate
                           , tmpReport_All.MovementId
                           , tmpReport_All.InvNumber

                           , tmpReport_All.AccountId
                           , tmpReport_All.AccountId_inf
                           , COALESCE (ContainerLO_ProfitLoss_inf.ObjectId, ContainerLO_ProfitLoss_inf_two.ObjectId)
                           , ContainerLO_Business_inf.ObjectId
                           , ContainerLO_Branch_inf.ObjectId

                           , tmpReport_All.ObjectId_inf
                           , tmpReport_All.MoneyPlaceId_inf
                           , tmpReport_All.InfoMoneyId_inf
                           , tmpReport_All.CashId_inf
                           , tmpReport_All.BranchId_inf
                           , tmpReport_All.UnitId_inf
                           , tmpReport_All.RouteId_inf
                           , tmpReport_All.ContainerId_inf

                           , CLO_InfoMoneyDetail.ObjectId
                           , tmpReport_All.GoodsKindId
                    )


    -- Результат
    SELECT zfConvert_StringToNumber (tmpReport.InvNumber) AS InvNumber
         , tmpReport.MovementId
         , tmpReport.OperDate
         , COALESCE (MovementDate_OperDatePartner.ValueData, tmpReport.OperDate) :: TDateTime AS OperDatePartner
         , MovementDesc.ItemName             AS MovementDescName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyName
         , Object_JuridicalBasis.ObjectCode  AS JuridicalBasisCode
         , Object_JuridicalBasis.ValueData   AS JuridicalBasisName
         , Object_Business.ObjectCode        AS BusinessCode
         , Object_Business.ValueData         AS BusinessName
         , Object_PaidKind.ValueData         AS PaidKindName
         , View_Contract_InvNumber.InvNumber AS ContractName

         , Object_Direction.Id             AS ObjectId_Direction
         , Object_Direction.ObjectCode     AS ObjectCode_Direction
       --, tmpReport.ContainerId_inf :: Integer AS ObjectCode_Direction
         , (COALESCE (Object_Bank.ValueData || ' * ', '') || Object_Direction.ValueData || COALESCE (' * ' || Object_Currency.ValueData, '')) :: TVarChar AS ObjectName_Direction
         , Object_Destination.ObjectCode   AS ObjectCode_Destination
         , Object_Destination.ValueData    AS ObjectName_Destination
         , ObjectDesc_Direction.ItemName   AS DescName_Direction
         , ObjectDesc_Destination.ItemName AS DescName_Destination
         , Object_GoodsKind.ValueData      AS GoodsKindName

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

         , View_Account.AccountGroupCode
         , View_Account.AccountGroupName
         , View_Account.AccountDirectionCode
         , View_Account.AccountDirectionName
         , View_Account.AccountCode
         , View_Account.AccountName
         , View_Account.AccountName_All

         , View_Account_inf.AccountGroupCode      AS AccountGroupCode_inf
         , View_Account_inf.AccountGroupName      AS AccountGroupName_inf
         , View_Account_inf.AccountDirectionCode  AS AccountDirectionCode_inf
         , View_Account_inf.AccountDirectionName  AS AccountDirectionName_inf
         , View_Account_inf.AccountCode           AS AccountCode_inf
         , View_Account_inf.AccountName           AS AccountName_inf
         , View_Account_inf.AccountName_all       AS AccountName_All_inf

         , View_ProfitLoss_inf.ProfitLossName_all AS ProfitLossName_All_inf

         , View_InfoMoneyDetail.InfoMoneyId              AS InfoMoneyId_Detail
         , View_InfoMoneyDetail.InfoMoneyCode            AS InfoMoneyCode_Detail
         , View_InfoMoneyDetail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
         , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
         , View_InfoMoneyDetail.InfoMoneyName            AS InfoMoneyName_Detail
         , View_InfoMoneyDetail.InfoMoneyName_all        AS InfoMoneyName_all_Detail

   FROM tmpReport

       LEFT JOIN tmpMD_OperDatePartner AS MovementDate_OperDatePartner ON MovementDate_OperDatePartner.MovementId = tmpReport.MovementId

       LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = tmpReport.JuridicalBasisId
       LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpReport.BusinessId
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpReport.PaidKindId
       LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpReport.ContractId
       LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpReport.CurrencyId


       LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
       LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = tmpReport.ObjectId_Detail

       LEFT JOIN Object AS Object_Business_inf ON Object_Business_inf.Id = tmpReport.BusinessId_inf
       LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = tmpReport.BranchId_inf
       LEFT JOIN Object AS Object_Unit_inf ON Object_Unit_inf.Id = tmpReport.UnitId_inf
       LEFT JOIN Object AS Object_Route_inf ON Object_Route_inf.Id = tmpReport.RouteId_inf
       LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpReport.GoodsKindId

       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

       LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpReport.AccountId
       LEFT JOIN Object_Account_View AS View_Account_inf ON View_Account_inf.AccountId = tmpReport.AccountId_inf

       LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss_inf ON View_ProfitLoss_inf.ProfitLossId = tmpReport.ProfitLossId_inf

       LEFT JOIN Object AS Object_Direction
                        ON Object_Direction.Id = CASE WHEN tmpReport.MovementDescId = zc_Movement_Cash() AND tmpReport.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                           THEN tmpReport.CashId_inf
                                                      WHEN tmpReport.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                                           THEN CASE WHEN tmpReport.SummIn > 0 THEN tmpReport.ObjectId_Direction ELSE tmpReport.ObjectId_Destination END
                                                      ELSE COALESCE (tmpReport.ObjectId_Direction
                                                                   , CASE WHEN tmpReport.SummIn > 0 THEN tmpReport.ObjectId_inf ELSE tmpReport.MoneyPlaceId_inf END)
                                                 END
       LEFT JOIN Object AS Object_Destination
                        ON Object_Destination.Id = CASE WHEN tmpReport.MovementDescId = zc_Movement_Cash() AND tmpReport.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                                             THEN tmpReport.MoneyPlaceId_inf
                                                        WHEN tmpReport.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                                             THEN CASE WHEN tmpReport.SummIn > 0 THEN tmpReport.ObjectId_Destination ELSE tmpReport.ObjectId_Direction END
                                                        ELSE COALESCE (tmpReport.ObjectId_Destination
                                                                     , CASE WHEN tmpReport.SummIn > 0 THEN tmpReport.MoneyPlaceId_inf ELSE tmpReport.ObjectId_inf END)
                                                   END

       LEFT JOIN ObjectDesc AS ObjectDesc_Direction   ON ObjectDesc_Direction.Id   = Object_Direction.DescId
       LEFT JOIN ObjectDesc AS ObjectDesc_Destination ON ObjectDesc_Destination.Id = Object_Destination.DescId

       LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                            ON ObjectLink_BankAccount_Bank.ObjectId = tmpReport.ObjectId_Direction
                           AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
       LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

    WHERE (View_ProfitLoss_inf.ProfitLossGroupId = inProfitLossGroupId OR 0 = inProfitLossGroupId)
      AND (View_ProfitLoss_inf.ProfitLossDirectionId = inProfitLossDirectionId OR 0 = inProfitLossDirectionId)
      AND (View_ProfitLoss_inf.ProfitLossId = inProfitLossId OR 0 = inProfitLossId)
      AND (COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) <> zc_Enum_InfoMoneyGroup_60000() -- Заработная плата
        OR View_Account.AccountGroupId = zc_Enum_AccountGroup_110000 () -- Транзит
        OR vbIsAll = TRUE
          )
      AND (tmpReport.MovementDescId = inMovementDescId OR inMovementDescId = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.02.21                                        *
*/

-- тест
-- SELECT * FROM lpReport_AccountMotion_noBalance (inStartDate := ('01.11.2024')::TDateTime , inEndDate := ('01.11.2024')::TDateTime , inAccountGroupId := 9015 , inAccountDirectionId := 9034 , inInfoMoneyId := 0 , inAccountId := 0 , inBusinessId := 0 , inProfitLossGroupId := 0 , inProfitLossDirectionId := 0 , inProfitLossId := 0 , inBranchId := 0 , inMovementDescId := 0 , inIsMovement := 'False' , inIsGoods := 'False' , inIsGoodsKind := 'False' , inIsDetail := 'False', inUserId:= zfCalc_UserAdmin() :: Integer);
