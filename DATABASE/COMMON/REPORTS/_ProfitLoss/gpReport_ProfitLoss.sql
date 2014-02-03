-- Function: gpReport_ProfitLoss()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar
             , ProfitLossName  TVarChar, OnComplete Boolean
             , BusinessName TVarChar, JuridicalName_Basis TVarChar, BranchName_ProfitLoss TVarChar, UnitName_ProfitLoss TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , InfoMoneyGroupCode_Detail Integer, InfoMoneyDestinationCode_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , Amount TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());

     RETURN QUERY 
      SELECT
             (CASE WHEN View_ProfitLoss.ProfitLossGroupCode < 100000 THEN '' ELSE '' END || View_ProfitLoss.ProfitLossGroupCode || ' ' || View_ProfitLoss.ProfitLossGroupName):: TVarChar         AS ProfitLossGroupName
           , (CASE WHEN View_ProfitLoss.ProfitLossDirectionCode < 100000 THEN '' ELSE '' END || View_ProfitLoss.ProfitLossDirectionCode || ' ' || View_ProfitLoss.ProfitLossDirectionName):: TVarChar AS ProfitLossDirectionName
           , (CASE WHEN View_ProfitLoss.ProfitLossCode < 100000 THEN '' ELSE '' END || View_ProfitLoss.ProfitLossCode || ' ' || View_ProfitLoss.ProfitLossName):: TVarChar                   AS ProfitLossName
           , View_ProfitLoss.onComplete                                                                             AS OnComplete

           , Object_Business.ValueData          AS BusinessName
           , Object_JuridicalBasis.ValueData    AS JuridicalName_Basis
           , Object_Branch_ProfitLoss.ValueData AS BranchName_ProfitLoss
           , Object_Unit_ProfitLoss.ValueData   AS UnitName_ProfitLoss

           , View_InfoMoney.InfoMoneyGroupCode
           , View_InfoMoney.InfoMoneyDestinationCode
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyName

           , View_InfoMoney_Detail.InfoMoneyGroupCode       AS InfoMoneyGroupCode_Detail
           , View_InfoMoney_Detail.InfoMoneyDestinationCode AS InfoMoneyDestinationCode_Detail
           , View_InfoMoney_Detail.InfoMoneyCode            AS InfoMoneyCode_Detail
           , View_InfoMoney_Detail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
           , View_InfoMoney_Detail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
           , View_InfoMoney_Detail.InfoMoneyName            AS InfoMoneyName_Detail

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName
           , Object_Destination.ObjectCode AS DestinationObjectCode
           , Object_Destination.ValueData  AS DestinationObjectName

           , tmpReport.Amount :: TFloat AS Amount

      FROM Object_ProfitLoss_View AS View_ProfitLoss

           LEFT JOIN (SELECT tmpProfitLoss.ProfitLossId
                           , tmpProfitLoss.BusinessId
                           , tmpProfitLoss.JuridicalId_Basis
                           , tmpProfitLoss.UnitId_ProfitLoss
                           , tmpProfitLoss.BranchId_ProfitLoss
                           , tmpProfitLoss.RouteId_inf
                           , SUM (tmpProfitLoss.Amount) AS Amount
                           , ContainerLinkObject_InfoMoney.ObjectId       AS InfoMoneyId
                           , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                           , ContainerLinkObject_Juridical.ObjectId       AS JuridicalId_inf
                           , ContainerLinkObject_Personal.ObjectId        AS PersonalId_inf
                           , ContainerLinkObject_Unit.ObjectId            AS UnitId_inf
                           , ContainerLinkObject_Car.ObjectId             AS CarId_inf
                           , ContainerLinkObject_Goods.ObjectId           AS GoodsId_inf
                      FROM
                     (SELECT tmpMIReport.ContainerId_inf
                           , tmpMIReport.UnitId_ProfitLoss
                           , tmpMIReport.BranchId_ProfitLoss
                           , tmpMIReport.RouteId_inf
                           , SUM (tmpMIReport.Amount) AS Amount
                           , ContainerLinkObject_ProfitLoss.ObjectId AS ProfitLossId
                           , ContainerLinkObject_Business.ObjectId AS BusinessId
                           , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_Basis
                            -- ??? как сделать что б не попали операции переброски накопленной прибыль прошлого месяца в долг по прибыли???
                      FROM (SELECT Container.Id AS ContainerId
                                 , CASE WHEN MIReport.PassiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                             THEN MIReport.ActiveContainerId
                                        WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() -- прибыль текущего периода
                                             THEN MIReport.PassiveContainerId
                                   END AS ContainerId_inf
                                 , SUM (CASE WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() THEN -1 ELSE 1 END * MIReport.Amount) AS Amount
                                 , MILinkObject_Unit.ObjectId   AS UnitId_ProfitLoss
                                 , MILinkObject_Branch.ObjectId AS BranchId_ProfitLoss
                                 , MILinkObject_Route.ObjectId  AS RouteId_inf
                            FROM Container
                                 JOIN ReportContainerLink ON ReportContainerLink.ContainerId = Container.Id
                                 JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = ReportContainerLink.ReportContainerId
                                                                    AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MIReport.MovementItemId
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 AND MILinkObject_Unit.ObjectId >0
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                  ON MILinkObject_Branch.MovementItemId = MIReport.MovementItemId
                                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                                 AND MILinkObject_Branch.ObjectId >0
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                  ON MILinkObject_Route.MovementItemId = MIReport.MovementItemId
                                                                 AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                 AND MILinkObject_Route.ObjectId >0
                            WHERE Container.ObjectId = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                              AND Container.DescId = zc_Container_Summ()
                            GROUP BY Container.Id
                                   , MIReport.ActiveContainerId
                                   , MIReport.PassiveContainerId
                                   , MIReport.ActiveAccountId
                                   , MIReport.PassiveAccountId
                                   , MILinkObject_Unit.ObjectId
                                   , MILinkObject_Branch.ObjectId
                                   , MILinkObject_Route.ObjectId
                           ) AS tmpMIReport
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_ProfitLoss
                                                         ON ContainerLinkObject_ProfitLoss.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                                         ON ContainerLinkObject_Business.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                                         ON ContainerLinkObject_JuridicalBasis.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                      GROUP BY tmpMIReport.ContainerId_inf
                             , tmpMIReport.UnitId_ProfitLoss
                             , tmpMIReport.BranchId_ProfitLoss
                             , tmpMIReport.RouteId_inf
                             , ContainerLinkObject_ProfitLoss.ObjectId
                             , ContainerLinkObject_Business.ObjectId
                             , ContainerLinkObject_JuridicalBasis.ObjectId
                     ) AS tmpProfitLoss
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                         ON ContainerLinkObject_InfoMoney.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                                         ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_InfoMoneyDetail.DescId = tmpProfitLoss.ContainerId_inf
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                         ON ContainerLinkObject_Juridical.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Juridical.DescId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Juridical.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                                         ON ContainerLinkObject_Personal.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Personal.DescId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Personal.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                         ON ContainerLinkObject_Unit.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                        AND ContainerLinkObject_Unit.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                         ON ContainerLinkObject_Car.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                                        AND ContainerLinkObject_Car.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                                         ON ContainerLinkObject_Goods.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                        AND ContainerLinkObject_Goods.ObjectId >0
                      GROUP BY tmpProfitLoss.ProfitLossId
                             , tmpProfitLoss.BusinessId
                             , tmpProfitLoss.JuridicalId_Basis
                             , tmpProfitLoss.UnitId_ProfitLoss
                             , tmpProfitLoss.BranchId_ProfitLoss
                             , tmpProfitLoss.RouteId_inf
                             , ContainerLinkObject_InfoMoney.ObjectId
                             , ContainerLinkObject_InfoMoneyDetail.ObjectId
                             , ContainerLinkObject_Juridical.ObjectId
                             , ContainerLinkObject_Personal.ObjectId
                             , ContainerLinkObject_Unit.ObjectId
                             , ContainerLinkObject_Car.ObjectId
                             , ContainerLinkObject_Goods.ObjectId
                     ) AS tmpReport ON tmpReport.ProfitLossId = View_ProfitLoss.ProfitLossId
           
           LEFT JOIN Object AS Object_Business          ON Object_Business.Id = tmpReport.BusinessId
           LEFT JOIN Object AS Object_JuridicalBasis    ON Object_JuridicalBasis.Id = tmpReport.JuridicalId_Basis
           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Branch_ProfitLoss ON Object_Branch_ProfitLoss.Id = tmpReport.BranchId_ProfitLoss

           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney        ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Detail ON View_InfoMoney_Detail.InfoMoneyId = tmpReport.InfoMoneyId_Detail
                                                                   AND zc_isHistoryCost_byInfoMoneyDetail() = TRUE
           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id = COALESCE (tmpReport.RouteId_inf, COALESCE (tmpReport.JuridicalId_inf, COALESCE (tmpReport.PersonalId_inf, COALESCE (tmpReport.UnitId_inf, tmpReport.CarId_inf))))
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpReport.GoodsId_inf

      WHERE View_ProfitLoss.ProfitLossCode <> 90101
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.13                                        * all
 21.10.13                         *
 01.09.13                                        *
 27.08.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '01.01.2012', inEndDate:= '01.02.2014', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
