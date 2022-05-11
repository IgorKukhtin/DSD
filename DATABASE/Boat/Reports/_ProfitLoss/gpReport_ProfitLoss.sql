-- Function: gpReport_ProfitLoss()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName  TVarChar
             , PL_GroupName_original TVarChar, PL_DirectionName_original TVarChar, PL_Name_original  TVarChar
             , UnitName_ProfitLoss TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar
             , MovementDescName TVarChar
             , Amount TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
                            -- ??? как сделать что б не попали операции переброски накопленной прибыль прошлого месяца в долг по прибыли???
     WITH tmpMIContainer AS (SELECT MIContainer.ContainerId
                                  , -1 * SUM (MIContainer.Amount)      AS Amount
                                  , MIContainer.ObjectExtId_Analyzer   AS UnitId_ProfitLoss
                                  , MIContainer.WhereObjectId_Analyzer AS DirectionId
                                  , MIContainer.MovementDescId
                             FROM MovementItemContainer AS MIContainer 
                             WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               --AND MIContainer.AccountId = zc_Enum_Account_100301()
                               AND MIContainer.isActive = FALSE
                             GROUP BY MIContainer.ContainerId
                                    , MIContainer.ObjectExtId_Analyzer
                                    , MIContainer.WhereObjectId_Analyzer
                                    , MIContainer.MovementDescId
                            )
        , tmpProfitLoss AS (SELECT CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                 , tmpMIContainer.MovementDescId
                                 , tmpMIContainer.DirectionId
                                 , tmpMIContainer.UnitId_ProfitLoss
                                 , SUM (tmpMIContainer.Amount) AS Amount
                            FROM tmpMIContainer
                                 LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                               ON CLO_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                              AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                            GROUP BY CLO_ProfitLoss.ObjectId
                                   , tmpMIContainer.MovementDescId
                                   , tmpMIContainer.DirectionId
                                   , tmpMIContainer.UnitId_ProfitLoss
                           )

      , tmpReport AS (SELECT tmpProfitLoss.ProfitLossId
                           , tmpProfitLoss.UnitId_ProfitLoss
                           , tmpProfitLoss.DirectionId
                           , tmpProfitLoss.MovementDescId
                           , SUM (tmpProfitLoss.Amount) AS Amount
                      FROM tmpProfitLoss
                      GROUP BY tmpProfitLoss.ProfitLossId
                             , tmpProfitLoss.UnitId_ProfitLoss
                             , tmpProfitLoss.DirectionId
                             , tmpProfitLoss.MovementDescId
                     )
      SELECT
             View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           --для печатной формы без кода
           , View_ProfitLoss.ProfitLossGroupName_original
           , View_ProfitLoss.ProfitLossDirectionName_original
           , View_ProfitLoss.ProfitLossName_original

           , Object_Unit_ProfitLoss.ValueData   AS UnitName_ProfitLoss

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

      FROM Object_ProfitLoss_View AS View_ProfitLoss

           LEFT JOIN tmpReport ON tmpReport.ProfitLossId = View_ProfitLoss.ProfitLossId
           LEFT JOIN Object AS Object_Unit_ProfitLoss   ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = NULL

           LEFT JOIN Object AS Object_Direction   ON Object_Direction.Id   = tmpReport.DirectionId
           LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = NULL

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

      WHERE View_ProfitLoss.ProfitLossCode <> 70101 -- Чистая прибыль
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ProfitLoss (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.06.17                                        *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLoss (inStartDate:= '31.07.2016', inEndDate:= '31.07.2016', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
