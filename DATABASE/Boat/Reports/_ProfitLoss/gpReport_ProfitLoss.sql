-- Function: gpReport_ProfitLoss()       ������� 30" Xiaomi Curved Gaming Monitor 30RMMNT30HFCW

DROP FUNCTION IF EXISTS gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProfitLoss (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inisMonth     Boolean   , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName  TVarChar
             , PL_GroupName_original TVarChar, PL_DirectionName_original TVarChar, PL_Name_original  TVarChar
             , PartnerName_ProfitLoss TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , MovementDescName TVarChar
             , Amount TFloat 
             , OperDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
                            -- ??? ��� ������� ��� � �� ������ �������� ���������� ����������� ������� �������� ������ � ���� �� �������???
     WITH tmpMIContainer AS (SELECT MIContainer.ContainerId
                                  , -1 * SUM (MIContainer.Amount)      AS Amount
                                  , MIContainer.ObjectExtId_Analyzer   AS PartnerId
                                  , MIContainer.WhereObjectId_Analyzer AS DirectionId
                                  , MIContainer.MovementDescId
                                  , CASE WHEN inisMonth = TRUE THEN DATE_TRUNC ('MONTH', MIContainer.OperDate) ELSE NULL END ::TDateTime AS OperDate
                             FROM MovementItemContainer AS MIContainer 
                             WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               --AND MIContainer.AccountId = zc_Enum_Account_100301()
                               AND MIContainer.isActive = FALSE
                             GROUP BY MIContainer.ContainerId
                                    , MIContainer.ObjectExtId_Analyzer
                                    , MIContainer.WhereObjectId_Analyzer
                                    , MIContainer.MovementDescId
                                    , CASE WHEN inisMonth = TRUE THEN DATE_TRUNC ('MONTH', MIContainer.OperDate) ELSE NULL END
                            )
        , tmpProfitLoss AS (SELECT CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                 , tmpMIContainer.MovementDescId
                                 , tmpMIContainer.DirectionId
                                 , tmpMIContainer.PartnerId
                                 , tmpMIContainer.OperDate
                                 , SUM (tmpMIContainer.Amount) AS Amount
                            FROM tmpMIContainer
                                 LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                               ON CLO_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                            GROUP BY CLO_ProfitLoss.ObjectId
                                   , tmpMIContainer.MovementDescId
                                   , tmpMIContainer.DirectionId
                                   , tmpMIContainer.PartnerId
                                   , tmpMIContainer.OperDate
                           )

      , tmpReport AS (SELECT tmpProfitLoss.ProfitLossId
                           , tmpProfitLoss.PartnerId
                           , tmpProfitLoss.DirectionId
                           , tmpProfitLoss.MovementDescId
                           , tmpProfitLoss.OperDate
                           , SUM (tmpProfitLoss.Amount) AS Amount
                      FROM tmpProfitLoss
                      GROUP BY tmpProfitLoss.ProfitLossId
                             , tmpProfitLoss.PartnerId
                             , tmpProfitLoss.DirectionId
                             , tmpProfitLoss.MovementDescId
                             , tmpProfitLoss.OperDate
                     )

      SELECT
             View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           --��� �������� ����� ��� ����
           , View_ProfitLoss.ProfitLossGroupName_original
           , View_ProfitLoss.ProfitLossDirectionName_original
           , View_ProfitLoss.ProfitLossName_original

           , Object_Partner_ProfitLoss.ValueData   AS PartnerName_ProfitLoss

           , View_InfoMoney.InfoMoneyGroupCode
           , View_InfoMoney.InfoMoneyDestinationCode
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyName

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName
           , Object_Destination.ObjectCode AS DestinationObjectCode
           , Object_Destination.ValueData  AS DestinationObjectName

           , MovementDesc.ItemName         AS MovementDescName

           , tmpReport.Amount :: TFloat AS Amount

           , tmpReport.OperDate ::TDateTime
      FROM Object_ProfitLoss_View AS View_ProfitLoss

           LEFT JOIN tmpReport ON tmpReport.ProfitLossId = View_ProfitLoss.ProfitLossId
           LEFT JOIN Object AS Object_Partner_ProfitLoss ON Object_Partner_ProfitLoss.Id = tmpReport.PartnerId
           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = NULL

           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id   = tmpReport.DirectionId
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = NULL

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

      --WHERE View_ProfitLoss.ProfitLossCode <> 70101 -- ������ �������
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.08.23         *
 11.06.17                                        *
*/

-- ����
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '31.07.2016', inEndDate:= '31.07.2016', inisMonth := FALSE, inSession:= '2') WHERE Amount <> 0 ORDER BY 5
