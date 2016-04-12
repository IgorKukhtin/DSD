-- Function: gpReport_Account_Print ()

DROP FUNCTION IF EXISTS gpReport_Account_Print (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Account_Print (
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
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbIsMovement Boolean;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Account());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


    -- !!!криво!!!
    inAccountGroupId = zc_Enum_AccountGroup_40000(); -- Денежные средства
    inAccountDirectionId = zc_Enum_AccountDirection_40300(); -- рассчетный счет

     OPEN Cursor1 FOR
       SELECT
             inStartDate                                AS StartDate
           , inEndDate                                  AS EndDate

      ;
    RETURN NEXT Cursor1;


    -- !!!определяется - будет ли разворачиваться по документам для Прибыль текущего периода
    --
    vbIsMovement:= (zc_Enum_Account_100301() NOT IN (SELECT AccountId FROM Object_Account_View WHERE (AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                                                                                                  OR (AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                                                                                                  OR AccountId = COALESCE (inAccountId, 0)
                                                    )
                AND (COALESCE (inAccountId, 0) <> 0 OR COALESCE (inAccountDirectionId, 0) <> 0)
                   )
                OR (zc_Enum_Account_100301() IN (SELECT AccountId FROM Object_Account_View WHERE (AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                                                                                              OR (AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                                                                                              OR AccountId = COALESCE (inAccountId, 0)
                                                )
                AND COALESCE (inProfitLossId, 0) <> 0
                   );

    --
    OPEN Cursor2 FOR
    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS AccountId, Container.Amount
                           FROM (SELECT AccountId FROM Object_Account_View WHERE
                                   -- !!!ONLY!!! inAccountId OR inAccountGroupId OR inAccountDirectionId
                                  /*((Object_Account_View.AccountGroupId = COALESCE (inAccountGroupId, 0) OR COALESCE (inAccountGroupId, 0) = 0)
                               AND (Object_Account_View.AccountDirectionId = COALESCE (inAccountDirectionId, 0) OR COALESCE (inAccountDirectionId, 0) = 0)
                               AND (Object_Account_View.AccountId = COALESCE (inAccountId, 0) OR COALESCE (inAccountGroupId, 0) <> 0 OR COALESCE (inAccountDirectionId, 0) <> 0) -- OR COALESCE (inAccountId, 0) = 0
                                  )*/
                                  ((Object_Account_View.AccountGroupId = COALESCE (inAccountGroupId, 0) AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0)
                                OR (Object_Account_View.AccountDirectionId = COALESCE (inAccountDirectionId, 0) AND COALESCE (inAccountId, 0) = 0)
                                OR Object_Account_View.AccountId = COALESCE (inAccountId, 0)
                                  )
                               OR (EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
                               AND COALESCE (inAccountGroupId, 0) = 0 AND COALESCE (inAccountDirectionId, 0) = 0 AND COALESCE (inAccountId, 0) = 0
                                  )
                                ) AS tmpAccount -- счет
                                JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                              AND Container.DescId = zc_Container_Summ()
                         )
    SELECT -- 0 :: Integer AS InvNumber
           (COALESCE (Object_Bank.ValueData || ' * ', '') || Object_Direction.ValueData) :: TVarChar AS ObjectName_Direction
         , SUM(tmpReport.SummStart) :: TFloat AS SummStart
         , SUM(tmpReport.SummIn)    :: TFloat AS SummIn
         , SUM(tmpReport.SummOut)   :: TFloat AS SummOut
         , SUM(tmpReport.SummEnd)   :: TFloat AS SummEnd

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
                          , CASE WHEN tmpContainer.AccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN tmpContainer.ContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()
                                      THEN MIReport.PassiveContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_ProfitLoss
                          , SUM (CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.ActiveAccountId <> zc_Enum_Account_100301() -- прибыль текущего периода
                                           THEN MIReport.Amount
                                      ELSE 0
                                 END) AS SummIn
                          , SUM (CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive()
                                           THEN MIReport.Amount
                                      WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
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
                          JOIN MovementItem Report AS MIReport ON MIReport.ReportContainerId = ReportContainerLink.ReportContainerId
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


       LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss_inf ON View_ProfitLoss_inf.ProfitLossId = tmpReport.ProfitLossId_inf

       LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmpReport.ObjectId_Direction


       LEFT JOIN ObjectDesc AS ObjectDesc_Direction ON ObjectDesc_Direction.Id = Object_Direction.DescId

       LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                            ON ObjectLink_BankAccount_Bank.ObjectId = tmpReport.ObjectId_Direction
                           AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
       LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

    WHERE (View_ProfitLoss_inf.ProfitLossGroupId = inProfitLossGroupId OR 0 = inProfitLossGroupId)
      AND (View_ProfitLoss_inf.ProfitLossDirectionId = inProfitLossDirectionId OR 0 = inProfitLossDirectionId)
      AND (View_ProfitLoss_inf.ProfitLossId = inProfitLossId OR 0 = inProfitLossId)
    GROUP BY (COALESCE (Object_Bank.ValueData || ' * ', '') || Object_Direction.ValueData) :: TVarChar
    ORDER BY ObjectName_Direction
    ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Account_Print (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.06.14                                                       * from gpReport_Account
*/

-- тест

/*
BEGIN;
select * from gpReport_Account_Print(inStartDate := '01.01.2014', inEndDate := '01.06.2014', inAccountGroupId := 9017 , inAccountDirectionId := 0 , inInfoMoneyId := 0 , inAccountId := 0 , inBusinessId := 0 , inProfitLossGroupId := 0 , inProfitLossDirectionId := 0 , inProfitLossId := 0 , inBranchId := 0 ,  inSession := '5');
COMMIT;
*/