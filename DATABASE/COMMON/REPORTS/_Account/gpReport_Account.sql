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
              , CarModelName TVarChar, CarCode Integer, CarName TVarChar
              , PersonalCode_inf Integer, PersonalName_inf TVarChar
              , CarModelName_inf TVarChar, CarCode_inf Integer, CarName_inf TVarChar
              , RouteCode_inf Integer, RouteName_inf TVarChar
              , UnitCode_inf Integer, UnitName_inf TVarChar
              , BranchCode_inf Integer, BranchName_inf TVarChar
              , BusinesCode_inf Integer, BusinesName_inf TVarChar
              , SummStart TFloat, SummIn TFloat, SummOut TFloat, SummEnd TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id AS ContainerId, Container.Amount
                          FROM (SELECT AccountId FROM Object_Account_View WHERE AccountDirectionCode IN (30500)) AS tmpAccount -- счет 
                               JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                             AND Container.DescId = zc_Container_Summ()
                         )
    SELECT zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
         , Movement.OperDate
         , MovementDesc.ItemName AS MovementDescName
         , View_InfoMoney.InfoMoneyCode
         , View_InfoMoney.InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyName
         , View_Personal.PersonalCode
         , View_Personal.PersonalName
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
   FROM      
       (SELECT ContainerLO_InfoMoney.ObjectId AS InfoMoneyId
             , ContainerLO_Personal.ObjectId  AS PersonalId
             , ContainerLO_Car.ObjectId       AS CarId
             , SUM (tmpReport_All.SummStart)  AS SummStart
             , SUM (tmpReport_All.SummIn)     AS SummIn
             , SUM (tmpReport_All.SummOut)    AS SummOut
             , SUM (tmpReport_All.SummEnd)    AS SummEnd
             , tmpReport_All.MovementId
             , tmpReport_All.PersonalId_inf
             , tmpReport_All.CarId_inf
             , tmpReport_All.RouteId_inf
             , tmpReport_All.UnitId_inf
             , tmpReport_All.BranchId_inf
             , tmpReport_All.BusinesId_inf
        FROM
            (SELECT tmpContainer.ContainerId
                  , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummStart
                  , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) AS SummEnd
                  , 0 AS SummIn
                  , 0 AS SummOut
                  , 0 AS MovementId
                  , 0 AS PersonalId_inf
                  , 0 AS CarId_inf
                  , 0 AS RouteId_inf
                  , 0 AS UnitId_inf
                  , 0 AS BranchId_inf
                  , 0 AS BusinesId_inf
             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                AND MIContainer.OperDate >= inStartDate
             GROUP BY tmpContainer.ContainerId, tmpContainer.Amount
             HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                 OR (tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN  MIContainer.Amount ELSE 0 END), 0) <> 0)
            UNION ALL
             SELECT tmpMIReport.ContainerId
                  , 0 AS SummStart
                  , 0 AS SummEnd
                  , SUM (tmpMIReport.SummIn)  AS SummIn
                  , SUM (tmpMIReport.SummOut) AS SummOut
                  , tmpMIReport.MovementId
                  , COALESCE (ContainerLO_Personal.ObjectId, MI.ObjectId)          AS PersonalId_inf
                  , COALESCE (ContainerLO_Car.ObjectId, MILinkObject_Car.ObjectId) AS CarId_inf
                  , tmpMIReport.RouteId_inf
                  , tmpMIReport.UnitId_inf
                  , tmpMIReport.BranchId_inf
                  , ContainerLO_Busines.ObjectId AS BusinesId_inf
               FROM (SELECT tmpContainer.ContainerId
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active()  THEN MIReport.Amount ELSE 0 END AS SummIn
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() THEN MIReport.Amount ELSE 0 END AS SummOut
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.PassiveAccountId <> zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.PassiveContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() AND MIReport.ActiveAccountId <> zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_inf
                          , CASE WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Active() AND MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.PassiveContainerId
                                 WHEN ReportContainerLink.AccountKindId = zc_Enum_AccountKind_Passive() AND MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                      THEN MIReport.ActiveContainerId
                                 ELSE 0
                            END AS ContainerId_ProfitLoss
                          , MIReport.MovementId
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
                     ) AS tmpMIReport
                     LEFT JOIN MovementItem AS MI ON MI.Id = tmpMIReport.MovementItemId
                                                 AND tmpMIReport.ContainerId_inf = 0 -- если это прибыль текущего периода, тогда нужные аналитики берем у элемента
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                      ON MILinkObject_Car.MovementItemId = MI.Id
                                                     AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Personal ON ContainerLO_Personal.ContainerId = tmpMIReport.ContainerId_inf
                                                                          AND ContainerLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpMIReport.ContainerId_inf
                                                                     AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                     LEFT JOIN ContainerLinkObject AS ContainerLO_Busines ON ContainerLO_Busines.ContainerId = tmpMIReport.ContainerId_ProfitLoss
                                                                         AND ContainerLO_Busines.DescId = zc_ContainerLinkObject_Personal()
             GROUP BY tmpMIReport.ContainerId
                    , tmpMIReport.MovementId
                    , ContainerLO_Personal.ObjectId
                    , ContainerLO_Car.ObjectId
                    , MI.ObjectId
                    , MILinkObject_Car.ObjectId
                    , tmpMIReport.RouteId_inf
                    , tmpMIReport.UnitId_inf
                    , tmpMIReport.BranchId_inf
                    , ContainerLO_Busines.ObjectId

            ) AS tmpReport_All
            LEFT JOIN ContainerLinkObject AS ContainerLO_Personal ON ContainerLO_Personal.ContainerId = tmpReport_All.ContainerId
                                                                 AND ContainerLO_Personal.DescId = zc_ContainerLinkObject_Personal()
            LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = tmpReport_All.ContainerId
                                                                  AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
            LEFT JOIN ContainerLinkObject AS ContainerLO_Car ON ContainerLO_Car.ContainerId = tmpReport_All.ContainerId
                                                            AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
        GROUP BY ContainerLO_Personal.ObjectId
               , ContainerLO_InfoMoney.ObjectId
               , ContainerLO_Car.ObjectId
               , tmpReport_All.MovementId
               , tmpReport_All.PersonalId_inf
               , tmpReport_All.CarId_inf
               , tmpReport_All.RouteId_inf
               , tmpReport_All.UnitId_inf
               , tmpReport_All.BranchId_inf
               , tmpReport_All.BusinesId_inf
       ) AS tmpReport 

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

       LEFT JOIN Movement ON Movement.Id = tmpReport.MovementId
       LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

    ;
    
        
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Account (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.13                                        * all
 29.10.13                                        * err InfoManey
 07.10.13         *  
*/

-- тест
-- SELECT * FROM gpReport_Account (inStartDate:= '01.10.2013', inEndDate:= '31.10.2013', inAccountId:= null, inSession:= zfCalc_UserAdmin());
