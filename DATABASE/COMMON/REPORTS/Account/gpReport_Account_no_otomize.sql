-- Function: gpReport_Account_no_otomize ()
-- !!!удалена!!!

DROP FUNCTION IF EXISTS gpReport_Account_no_otomize (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Account_no_otomize (
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

              , PersonalCode_inf Integer, PersonalName_inf TVarChar
              , CarModelName_inf TVarChar, CarCode_inf Integer, CarName_inf TVarChar
              , RouteCode_inf Integer, RouteName_inf TVarChar
              , UnitCode_inf Integer, UnitName_inf TVarChar
              , BranchCode_inf Integer, BranchName_inf TVarChar
              , BusinesCode_inf Integer, BusinesName_inf TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
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
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Ограниченние - нет доступа к Движению по счету
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657332)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав к отчету Движению по счету.';
     END IF;


    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.ObjectId AS AccountId, Container.Amount
                          FROM (SELECT AccountId FROM Object_Account_View /*WHERE Object_Account_View.AccountDirectionCode IN (20500, 30500, 70100, 100300, 110000)*/) AS tmpAccount -- счет 
                               JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                             AND Container.DescId = zc_Container_Summ()
                         )
    SELECT zfConvert_StringToNumber (tmpReport.InvNumber) AS InvNumber
         , tmpReport.OperDate
         , MovementDesc.ItemName AS MovementDescName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyName
         , View_Personal.PersonalCode
         , View_Personal.PersonalName
         , Object_Juridical.ObjectCode     AS JuridicalCode
         , Object_Juridical.ValueData      AS JuridicalName
         , Object_PaidKind.ValueData       AS PaidKindName
         , Object_Contract.ValueData       AS ContractName
         , Object_CarModel.ValueData AS CarModelName
         , Object_Car.ObjectCode     AS CarCode
         , Object_Car.ValueData      AS CarName

         , View_Personal_inf.PersonalCode AS PersonalCode_inf
         , View_Personal_inf.PersonalName AS PersonalName_inf
         , Object_CarModel_inf.ValueData  AS CarModelName_inf
         , Object_Car_inf.ObjectCode      AS CarCode_inf
         , Object_Car_inf.ValueData       AS CarName_inf
         , Object_Route_inf.ObjectCode    AS RouteCode_inf
         , Object_Route_inf.ValueData     AS RouteName_inf

         , Object_Unit_inf.ObjectCode     AS UnitCode_inf
         , Object_Unit_inf.ValueData      AS UnitName_inf
         , Object_Branch_inf.ObjectCode   AS BranchCode_inf
         , Object_Branch_inf.ValueData    AS BranchName_inf
         , Object_Busines_inf.ObjectCode  AS BusinesCode_inf
         , Object_Busines_inf.ValueData   AS BusinesName_inf

         , tmpReport.SummStart :: TFloat AS SummStart
         , tmpReport.SummIn    :: TFloat AS SummIn
         , tmpReport.SummOut   :: TFloat AS SummOut
         , tmpReport.SummEnd   :: TFloat AS SummEnd

         , View_Account.AccountGroupCode, View_Account.AccountGroupName
         , View_Account.AccountDirectionCode, View_Account.AccountDirectionName
         , View_Account.AccountCode, View_Account.AccountName
         , ('(' || CASE WHEN View_Account.AccountCode < 100000 THEN '0' ELSE '' END || View_Account.AccountCode :: TVarChar || ') '
                || View_Account.AccountGroupName
                || CASE WHEN View_Account.AccountDirectionName <> View_Account.AccountGroupName THEN ' ' || View_Account.AccountDirectionName ELSE '' END
                || CASE WHEN View_Account.AccountName <> View_Account.AccountDirectionName THEN ' ' || View_Account.AccountName ELSE '' END
           ) :: TVarChar AS AccountName_All

         , View_Account_inf.AccountGroupCode AS AccountGroupCode_inf, View_Account_inf.AccountGroupName AS AccountGroupName_inf
         , View_Account_inf.AccountDirectionCode AS AccountDirectionCode_inf, View_Account_inf.AccountDirectionName AS AccountDirectionName_inf
         , View_Account_inf.AccountCode AS AccountCode_inf, View_Account_inf.AccountName AS AccountName_inf
         , ('(' || CASE WHEN View_Account_inf.AccountCode < 100000 THEN '0' ELSE '' END || View_Account_inf.AccountCode :: TVarChar || ') '
                || View_Account_inf.AccountGroupName
                || CASE WHEN View_Account_inf.AccountDirectionName <> View_Account_inf.AccountGroupName THEN ' ' || View_Account_inf.AccountDirectionName ELSE '' END
                || CASE WHEN View_Account_inf.AccountName <> View_Account_inf.AccountDirectionName THEN ' ' || View_Account_inf.AccountName ELSE '' END
           ) :: TVarChar AS AccountName_All_inf

         , ('(' || View_ProfitLoss_inf.ProfitLossCode :: TVarChar || ') '
                || View_ProfitLoss_inf.ProfitLossGroupName
                || CASE WHEN View_ProfitLoss_inf.ProfitLossDirectionName <> View_ProfitLoss_inf.ProfitLossGroupName THEN ' ' || View_ProfitLoss_inf.ProfitLossDirectionName ELSE '' END
                || CASE WHEN View_ProfitLoss_inf.ProfitLossName <> View_ProfitLoss_inf.ProfitLossDirectionName THEN ' ' || View_ProfitLoss_inf.ProfitLossName ELSE '' END
           ) :: TVarChar AS ProfitLossName_All_inf

   FROM      
       (SELECT ContainerLO_InfoMoney.ObjectId AS InfoMoneyId
             , ContainerLO_Personal.ObjectId  AS PersonalId
             , ContainerLO_Car.ObjectId       AS CarId
             , ContainerLO_Juridical.ObjectId AS JuridicalId
             , ContainerLO_PaidKind.ObjectId  AS PaidKindId
             , ContainerLO_Contract.ObjectId  AS ContractId

             , SUM (tmpReport_All.SummStart)  AS SummStart
             , SUM (tmpReport_All.SummIn)     AS SummIn
             , SUM (tmpReport_All.SummOut)    AS SummOut
             , SUM (tmpReport_All.SummEnd)    AS SummEnd
             , tmpReport_All.MovementDescId
             , tmpReport_All.MovementId
             , tmpReport_All.OperDate
             , tmpReport_All.InvNumber
             , tmpReport_All.AccountId
             , tmpReport_All.AccountId_inf
             , tmpReport_All.PersonalId_inf
             , tmpReport_All.CarId_inf
             , tmpReport_All.RouteId_inf
             , tmpReport_All.UnitId_inf
             , tmpReport_All.BranchId_inf
             , tmpReport_All.BusinesId_inf
             , tmpReport_All.ProfitLossId_inf
        FROM
            (SELECT tmpContainer.ContainerId
                  , tmpContainer.AccountId
                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS MovementDescId
                  , 0 AS MovementId
                  , NULL :: TDateTime AS OperDate
                  , '' AS InvNumber
                  , 0 AS PersonalId_inf
                  , 0 AS CarId_inf
                  , 0 AS AccountId_inf
                  , 0 AS RouteId_inf
                  , 0 AS UnitId_inf
                  , 0 AS BranchId_inf
                  , 0 AS BusinesId_inf
                  , 0 AS ProfitLossId_inf
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
                  , SUM (tmpMIReport.SummIn)  AS SummIn
                  , SUM (tmpMIReport.SummOut) AS SummOut
                  , Movement.DescId AS MovementDescId
                  , tmpMIReport.MovementId
                  , tmpMIReport.OperDate
                  , Movement.InvNumber
                  , COALESCE (ContainerLO_Personal.ObjectId, COALESCE (MI_Personal.ObjectId, MovementLO_PersonalDriver.ObjectId)) AS PersonalId_inf
                  , COALESCE (ContainerLO_Car.ObjectId, MILinkObject_Car.ObjectId) AS CarId_inf
                  , tmpMIReport.AccountId_inf
                  , COALESCE (MI_Route.ObjectId, tmpMIReport.RouteId_inf) AS RouteId_inf
                  , tmpMIReport.UnitId_inf
                  , tmpMIReport.BranchId_inf
                  , ContainerLO_Busines.ObjectId AS BusinesId_inf
                  , ContainerLO_ProfitLoss.ObjectId AS ProfitLossId_inf
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
                          , MIReport.MovementId
                          , MIReport.OperDate
                          , MIReport.MovementItemId
                          , MILinkObject_Route.ObjectId  AS RouteId_inf
                          , MILinkObject_Unit.ObjectId   AS UnitId_inf
                          , MILinkObject_Branch.ObjectId AS BranchId_inf
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
                     ) AS tmpMIReport
                     LEFT JOIN Movement ON Movement.Id = tmpMIReport.MovementId
                     LEFT JOIN MovementItem AS MI_Transport ON MI_Transport.Id = tmpMIReport.MovementItemId
                                                           AND Movement.DescId = zc_Movement_Transport()
                     LEFT JOIN MovementItem AS MI_Route ON MI_Route.Id = MI_Transport.ParentId
                     LEFT JOIN MovementLinkObject AS MovementLO_PersonalDriver
                                                  ON MovementLO_PersonalDriver.MovementId = Movement.Id
                                                 AND MovementLO_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                                                 AND MovementLO_PersonalDriver.ObjectId > 0

                     LEFT JOIN MovementItem AS MI_Personal ON MI_Personal.Id = tmpMIReport.MovementItemId
                                                          AND Movement.DescId = zc_Movement_PersonalSendCash()
                                                          -- AND tmpMIReport.ContainerId_inf = 0 -- если это прибыль текущего периода, тогда нужные аналитики берем у элемента
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                      ON MILinkObject_Car.MovementItemId = MI_Personal.Id
                                                     AND MILinkObject_Car.DescId = zc_MILinkObject_Car()

                     LEFT JOIN ContainerLinkObject AS ContainerLO_Personal ON ContainerLO_Personal.ContainerId = tmpMIReport.ContainerId_inf
                                                                          AND ContainerLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                          AND ContainerLO_Personal.ObjectId > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpMIReport.ContainerId_inf
                                                                     AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                                     AND ContainerLO_Car.ObjectId > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Busines ON ContainerLO_Busines.ContainerId = tmpMIReport.ContainerId_ProfitLoss
                                                                         AND ContainerLO_Busines.DescId = zc_ContainerLinkObject_Business()
                                                                         AND ContainerLO_Busines.ObjectId > 0
                     LEFT JOIN ContainerLinkObject AS ContainerLO_ProfitLoss ON ContainerLO_ProfitLoss.ContainerId = tmpMIReport.ContainerId_ProfitLoss
                                                                            AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                                                                            AND ContainerLO_ProfitLoss.ObjectId > 0
             GROUP BY tmpMIReport.ContainerId
                    , tmpMIReport.AccountId
                    , Movement.DescId
                    , tmpMIReport.MovementId
                    , tmpMIReport.OperDate
                    , Movement.InvNumber
                    , ContainerLO_Personal.ObjectId
                    , MI_Personal.ObjectId
                    , MovementLO_PersonalDriver.ObjectId
                    , ContainerLO_Car.ObjectId
                    , MILinkObject_Car.ObjectId
                    , tmpMIReport.AccountId_inf
                    , MI_Route.ObjectId
                    , tmpMIReport.RouteId_inf
                    , tmpMIReport.UnitId_inf
                    , tmpMIReport.BranchId_inf
                    , ContainerLO_Busines.ObjectId
                    , ContainerLO_ProfitLoss.ObjectId

            ) AS tmpReport_All
            LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
            LEFT JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
            LEFT JOIN ContainerLinkObject AS ContainerLO_Personal ON ContainerLO_Personal.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_Personal.DescId = zc_ContainerLinkObject_Personal()
            LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
            LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpReport_All.ContainerId
                                                            AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
        GROUP BY ContainerLO_Personal.ObjectId
               , ContainerLO_InfoMoney.ObjectId
               , ContainerLO_Car.ObjectId
               , ContainerLO_Juridical.ObjectId
               , ContainerLO_PaidKind.ObjectId
               , ContainerLO_Contract.ObjectId
               , tmpReport_All.MovementDescId
               , tmpReport_All.MovementId
               , tmpReport_All.OperDate
               , tmpReport_All.InvNumber
               , tmpReport_All.AccountId
               , tmpReport_All.AccountId_inf
               , tmpReport_All.PersonalId_inf
               , tmpReport_All.CarId_inf
               , tmpReport_All.RouteId_inf
               , tmpReport_All.UnitId_inf
               , tmpReport_All.BranchId_inf
               , tmpReport_All.BusinesId_inf
               , tmpReport_All.ProfitLossId_inf
       ) AS tmpReport

       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpReport.JuridicalId
       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpReport.PaidKindId
       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpReport.ContractId

       LEFT JOIN Object_Personal_View AS View_Personal_inf ON View_Personal_inf.PersonalId = tmpReport.PersonalId_inf
       LEFT JOIN Object AS Object_Car_inf ON Object_Car_inf.Id = tmpReport.CarId_inf
       LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel_inf ON ObjectLink_Car_CarModel_inf.ObjectId = Object_Car_inf.Id
                                                      AND ObjectLink_Car_CarModel_inf.DescId = zc_ObjectLink_Car_CarModel()
       LEFT JOIN Object AS Object_CarModel_inf ON Object_CarModel_inf.Id = ObjectLink_Car_CarModel_inf.ChildObjectId
       LEFT JOIN Object AS Object_Route_inf ON Object_Route_inf.Id = tmpReport.RouteId_inf

       LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
       LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpReport.PersonalId
       LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpReport.CarId
       LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                      AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
       LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

       LEFT JOIN Object AS Object_Unit_inf ON Object_Unit_inf.Id = tmpReport.UnitId_inf
       LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = tmpReport.BranchId_inf
       LEFT JOIN Object AS Object_Busines_inf ON Object_Busines_inf.Id = tmpReport.BusinesId_inf

       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

       LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpReport.AccountId
       LEFT JOIN Object_Account_View AS View_Account_inf ON View_Account_inf.AccountId = tmpReport.AccountId_inf
       LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss_inf ON View_ProfitLoss_inf.ProfitLossId = tmpReport.ProfitLossId_inf

    ;
    
        
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Account_no_otomize (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.13                                        * add Account...
 01.11.13                                        * all
 29.10.13                                        * err InfoManey
 07.10.13         *  
*/

-- тест
-- SELECT * FROM gpReport_Account_no_otomize (inStartDate:= '01.10.2024', inEndDate:= '31.10.2024', inAccountId:= null, inSession:= zfCalc_UserAdmin());
