-- Function: gpReport_ProfitLoss()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- ������ ������������
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
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());

     RETURN QUERY 
                            -- ??? ��� ������� ��� � �� ������ �������� ���������� ����������� ������� �������� ������ � ���� �� �������???
      WITH tmpContainer AS (SELECT Container.Id AS ContainerId
                                 , ReportContainerLink.ReportContainerId
                                 , ReportContainerLink.ChildContainerId AS ContainerId_inf
                            FROM Container
                                 JOIN ReportContainerLink ON ReportContainerLink.ContainerId = Container.Id
                            WHERE Container.ObjectId = zc_Enum_Account_100301() -- 100301; "������� �������� �������"
                              AND Container.DescId = zc_Container_Summ()
                           )
      -- , tmpMIReport_all AS (SELECT tmpContainer.ContainerId
          , tmpMIReport AS (SELECT tmpContainer.ContainerId
                                 , tmpContainer.ContainerId_inf
                                 -- , MIReport.MovementItemId
                                 , SUM (CASE WHEN MIReport.ActiveAccountId = zc_Enum_Account_100301() THEN -1 ELSE 1 END * MIReport.Amount) AS Amount
                                 , MILinkObject_Unit.ObjectId   AS UnitId_ProfitLoss
                                 , COALESCE (MILinkObject_Branch.ObjectId, MovementLinkObject_Branch.ObjectId) AS BranchId_ProfitLoss
                                 , MILinkObject_Route.ObjectId  AS RouteId_inf
                            FROM tmpContainer
                                 INNER JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpContainer.ReportContainerId
                                                                          AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MIReport.MovementItemId
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 -- AND MILinkObject_Unit.ObjectId >0
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                  ON MILinkObject_Branch.MovementItemId = MIReport.MovementItemId
                                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                                 -- AND MILinkObject_Branch.ObjectId >0
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                  ON MILinkObject_Route.MovementItemId = MIReport.MovementItemId
                                                                 AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                 -- AND MILinkObject_Route.ObjectId >0
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                                             ON MovementLinkObject_Branch.MovementId = MIReport.MovementId
                                                            AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
                            GROUP BY tmpContainer.ContainerId
                                   , tmpContainer.ContainerId_inf
                                   -- , MIReport.MovementItemId
                                   , MILinkObject_Unit.ObjectId
                                   , MILinkObject_Branch.ObjectId
                                   , MILinkObject_Route.ObjectId
                                   , MovementLinkObject_Branch.ObjectId
                           )
/*          , tmpMIReport AS (SELECT tmpMIReport_all.ContainerId
                                 , tmpMIReport_all.ContainerId_inf
                                 , SUM (tmpMIReport_all.Amount) AS Amount
                                 , MILinkObject_Unit.ObjectId   AS UnitId_ProfitLoss
                                 , MILinkObject_Branch.ObjectId AS BranchId_ProfitLoss
                                 , MILinkObject_Route.ObjectId  AS RouteId_inf
                            FROM tmpMIReport_all
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = tmpMIReport_all.MovementItemId
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 -- AND MILinkObject_Unit.ObjectId >0
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                  ON MILinkObject_Branch.MovementItemId = tmpMIReport_all.MovementItemId
                                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                                 -- AND MILinkObject_Branch.ObjectId >0
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                  ON MILinkObject_Route.MovementItemId = tmpMIReport_all.MovementItemId
                                                                 AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                 -- AND MILinkObject_Route.ObjectId >0
                            GROUP BY tmpMIReport_all.ContainerId
                                   , tmpMIReport_all.ContainerId_inf
                                   , MILinkObject_Unit.ObjectId
                                   , MILinkObject_Branch.ObjectId
                                   , MILinkObject_Route.ObjectId
                           )*/
  , tmpProfitLoss AS (SELECT tmpMIReport.ContainerId_inf
                           , tmpMIReport.UnitId_ProfitLoss
                           , COALESCE (ContainerLinkObject_Branch.ObjectId, tmpMIReport.BranchId_ProfitLoss)
                           , tmpMIReport.RouteId_inf
                           , SUM (tmpMIReport.Amount) AS Amount
                           , ContainerLinkObject_ProfitLoss.ObjectId AS ProfitLossId
                           , ContainerLinkObject_Business.ObjectId AS BusinessId
                           , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_Basis
                      FROM tmpMIReport
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_ProfitLoss
                                                         ON ContainerLinkObject_ProfitLoss.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Branch
                                                         ON ContainerLinkObject_Branch.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_Branch.DescId = zc_ContainerLinkObject_Branch()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                                         ON ContainerLinkObject_Business.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                                         ON ContainerLinkObject_JuridicalBasis.ContainerId = tmpMIReport.ContainerId
                                                        AND ContainerLinkObject_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                      GROUP BY tmpMIReport.ContainerId_inf
                             , tmpMIReport.UnitId_ProfitLoss
                             , COALESCE (ContainerLinkObject_Branch.ObjectId, tmpMIReport.BranchId_ProfitLoss)
                             , tmpMIReport.RouteId_inf
                             , ContainerLinkObject_Business.ObjectId
                             , ContainerLinkObject_JuridicalBasis.ObjectId
                     )
      , tmpReport AS (SELECT tmpProfitLoss.ProfitLossId
                           , tmpProfitLoss.BusinessId
                           , tmpProfitLoss.JuridicalId_Basis
                           , tmpProfitLoss.UnitId_ProfitLoss
                           , tmpProfitLoss.BranchId_ProfitLoss
                           , tmpProfitLoss.RouteId_inf
                           , CASE WHEN tmpProfitLoss.RouteId_inf <> 0 THEN tmpProfitLoss.RouteId_inf
                                  WHEN ContainerLinkObject_Juridical.ObjectId <> 0 THEN ContainerLinkObject_Juridical.ObjectId
                                  WHEN ContainerLinkObject_Personal.ObjectId <> 0 THEN ContainerLinkObject_Personal.ObjectId
                                  WHEN ContainerLinkObject_Unit.ObjectId <> 0 THEN ContainerLinkObject_Unit.ObjectId
                                  ELSE ContainerLinkObject_Car.ObjectId
                             END AS DirectionId
                           , SUM (tmpProfitLoss.Amount) AS Amount
                           , ContainerLinkObject_InfoMoney.ObjectId       AS InfoMoneyId
                           , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                           , ContainerLinkObject_Juridical.ObjectId       AS JuridicalId_inf
                           , ContainerLinkObject_Personal.ObjectId        AS PersonalId_inf
                           , ContainerLinkObject_Unit.ObjectId            AS UnitId_inf
                           , ContainerLinkObject_Car.ObjectId             AS CarId_inf
                           , ContainerLinkObject_Goods.ObjectId           AS GoodsId_inf
                      FROM tmpProfitLoss
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                         ON ContainerLinkObject_InfoMoney.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                                         ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_InfoMoneyDetail.DescId = tmpProfitLoss.ContainerId_inf
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                         ON ContainerLinkObject_Juridical.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Juridical.DescId = tmpProfitLoss.ContainerId_inf
                                                        -- AND ContainerLinkObject_Juridical.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Personal
                                                         ON ContainerLinkObject_Personal.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Personal.DescId = tmpProfitLoss.ContainerId_inf
                                                        -- AND ContainerLinkObject_Personal.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                         ON ContainerLinkObject_Unit.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                        -- AND ContainerLinkObject_Unit.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Car
                                                         ON ContainerLinkObject_Car.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Car.DescId = zc_ContainerLinkObject_Car()
                                                        -- AND ContainerLinkObject_Car.ObjectId >0
                           LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                                         ON ContainerLinkObject_Goods.ContainerId = tmpProfitLoss.ContainerId_inf
                                                        AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                        -- AND ContainerLinkObject_Goods.ObjectId >0
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
                     )
      SELECT
             View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           , View_ProfitLoss.onComplete

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

           LEFT JOIN tmpReport ON tmpReport.ProfitLossId = View_ProfitLoss.ProfitLossId
           
           LEFT JOIN Object AS Object_Business          ON Object_Business.Id = tmpReport.BusinessId
           LEFT JOIN Object AS Object_JuridicalBasis    ON Object_JuridicalBasis.Id = tmpReport.JuridicalId_Basis
           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Branch_ProfitLoss ON Object_Branch_ProfitLoss.Id = tmpReport.BranchId_ProfitLoss

           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney        ON View_InfoMoney.InfoMoneyId = tmpReport.InfoMoneyId
           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Detail ON View_InfoMoney_Detail.InfoMoneyId = tmpReport.InfoMoneyId_Detail
                                                                   -- AND zc_isHistoryCost_byInfoMoneyDetail() = TRUE
           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id = tmpReport.DirectionId
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmpReport.GoodsId_inf

      WHERE View_ProfitLoss.ProfitLossCode <> 90101
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.11.13                                        * all
 21.10.13                         *
 01.09.13                                        *
 27.08.13                                        *
*/

-- ����
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
