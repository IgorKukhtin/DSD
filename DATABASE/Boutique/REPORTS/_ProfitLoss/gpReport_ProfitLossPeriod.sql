-- Function: gpReport_ProfitLossPeriod()

DROP FUNCTION IF EXISTS gpReport_ProfitLossPeriod (TDateTime, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLossPeriod(
    IN inStartDate1   TDateTime , -- 
    IN inEndDate1     TDateTime , --
    IN inStartDate2   TDateTime , -- 
    IN inEndDate2     TDateTime , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperYear TDateTime, OperMONTH TDateTime
             , ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName  TVarChar
             , PL_GroupName_original TVarChar, PL_DirectionName_original TVarChar, PL_Name_original  TVarChar
             , UnitName_ProfitLoss TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar
             , MovementDescName TVarChar
             , Amount TFloat
             , AmountPast TFloat
             , AmountDif TFloat
             , AmountMonthPast TFloat
             , AmountMonthDif  TFloat
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
     WITH 
          -- данные первого периода
          tmpMIContainer1 AS (SELECT MIContainer.ContainerId
                                   , MIContainer.OperDate
                                   , -1 * SUM (MIContainer.Amount)      AS Amount
                                   , MIContainer.ObjectExtId_Analyzer   AS UnitId_ProfitLoss
                                   , MIContainer.WhereObjectId_Analyzer AS DirectionId
                                   , MIContainer.MovementDescId
                              FROM MovementItemContainer AS MIContainer 
                              WHERE MIContainer.OperDate BETWEEN inStartDate1 AND inEndDate1
                                AND MIContainer.AccountId = zc_Enum_Account_100301()
                                AND MIContainer.isActive = FALSE
                              GROUP BY MIContainer.ContainerId
                                     , MIContainer.ObjectExtId_Analyzer
                                     , MIContainer.WhereObjectId_Analyzer
                                     , MIContainer.MovementDescId
                                     , MIContainer.OperDate
                             )
        , tmpProfitLoss1 AS (SELECT tmpMIContainer.OperDate
                                  , CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                  , tmpMIContainer.MovementDescId
                                  , tmpMIContainer.DirectionId
                                  , tmpMIContainer.UnitId_ProfitLoss
                                  , SUM (tmpMIContainer.Amount) AS Amount
                             FROM tmpMIContainer1 AS tmpMIContainer
                                  LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                                ON CLO_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                               AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                             GROUP BY CLO_ProfitLoss.ObjectId
                                    , tmpMIContainer.MovementDescId
                                    , tmpMIContainer.DirectionId
                                    , tmpMIContainer.UnitId_ProfitLoss
                                    , tmpMIContainer.OperDate
                            )

        , tmpReport1 AS (SELECT DATE_TRUNC ('YEAR', tmpProfitLoss.OperDate)  AS OperYear
                              , DATE_TRUNC ('MONTH', tmpProfitLoss.OperDate) AS OperMONTH
                              , tmpProfitLoss.ProfitLossId
                              , tmpProfitLoss.UnitId_ProfitLoss
                              , tmpProfitLoss.DirectionId
                              , tmpProfitLoss.MovementDescId
                              , SUM (tmpProfitLoss.Amount) AS Amount
                         FROM tmpProfitLoss1 AS tmpProfitLoss
                         GROUP BY tmpProfitLoss.ProfitLossId
                                , tmpProfitLoss.UnitId_ProfitLoss
                                , tmpProfitLoss.DirectionId
                                , tmpProfitLoss.MovementDescId
                                , DATE_TRUNC ('YEAR', tmpProfitLoss.OperDate)
                                , DATE_TRUNC ('MONTH', tmpProfitLoss.OperDate)
                        )
        -- данные второго периода
        , tmpMIContainer2 AS (SELECT MIContainer.ContainerId
                                   , MIContainer.OperDate
                                   , -1 * SUM (MIContainer.Amount)      AS Amount
                                   , MIContainer.ObjectExtId_Analyzer   AS UnitId_ProfitLoss
                                   , MIContainer.WhereObjectId_Analyzer AS DirectionId
                                   , MIContainer.MovementDescId
                              FROM MovementItemContainer AS MIContainer 
                              WHERE MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                AND MIContainer.AccountId = zc_Enum_Account_100301()
                                AND MIContainer.isActive = FALSE
                              GROUP BY MIContainer.ContainerId
                                     , MIContainer.ObjectExtId_Analyzer
                                     , MIContainer.WhereObjectId_Analyzer
                                     , MIContainer.MovementDescId
                                     , MIContainer.OperDate
                             )
        , tmpProfitLoss2 AS (SELECT tmpMIContainer.OperDate
                                  , CLO_ProfitLoss.ObjectId                AS ProfitLossId
                                  , tmpMIContainer.MovementDescId
                                  , tmpMIContainer.DirectionId
                                  , tmpMIContainer.UnitId_ProfitLoss
                                  , SUM (tmpMIContainer.Amount) AS Amount
                             FROM tmpMIContainer2 AS tmpMIContainer
                                  LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                                ON CLO_ProfitLoss.ContainerId = tmpMIContainer.ContainerId
                                                               AND CLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
                             GROUP BY CLO_ProfitLoss.ObjectId
                                    , tmpMIContainer.MovementDescId
                                    , tmpMIContainer.DirectionId
                                    , tmpMIContainer.UnitId_ProfitLoss
                                    , tmpMIContainer.OperDate
                            )

        , tmpReport2 AS (SELECT DATE_TRUNC ('YEAR', tmpProfitLoss.OperDate)  AS OperYear
                              , DATE_TRUNC ('MONTH', tmpProfitLoss.OperDate) AS OperMONTH
                              , tmpProfitLoss.ProfitLossId
                              , tmpProfitLoss.UnitId_ProfitLoss
                              , tmpProfitLoss.DirectionId
                              , tmpProfitLoss.MovementDescId
                              , SUM (tmpProfitLoss.Amount) AS Amount
                         FROM tmpProfitLoss2 AS tmpProfitLoss
                         GROUP BY tmpProfitLoss.ProfitLossId
                                , tmpProfitLoss.UnitId_ProfitLoss
                                , tmpProfitLoss.DirectionId
                                , tmpProfitLoss.MovementDescId
                                , DATE_TRUNC ('YEAR', tmpProfitLoss.OperDate)
                                , DATE_TRUNC ('MONTH', tmpProfitLoss.OperDate)
                        )
                        
        , tmpReport AS (SELECT tmpReport.OperYear
                             , tmpReport.OperMONTH
                             , tmpReport.ProfitLossId
                             , tmpReport.UnitId_ProfitLoss
                             , tmpReport.DirectionId
                             , tmpReport.MovementDescId
                             , tmpReport.Amount
                             , 0      AS AmountPast
                             , 0      AS AmountMonthPast
                        FROM tmpReport1 AS tmpReport
                       UNION
                        SELECT tmpReport.OperYear
                             , tmpReport.OperMONTH
                             , tmpReport.ProfitLossId
                             , tmpReport.UnitId_ProfitLoss
                             , tmpReport.DirectionId
                             , tmpReport.MovementDescId
                             , tmpReport.Amount
                             , 0      AS AmountPast
                             , 0      AS AmountMonthPast
                        FROM tmpReport2 AS tmpReport
                        UNION
                        -- данные прошлого периода
                        SELECT tmpReport.OperYear  + interval '1 Year'
                             , tmpReport.OperMonth + interval '1 Year'
                             , tmpReport.ProfitLossId
                             , tmpReport.UnitId_ProfitLoss
                             , tmpReport.DirectionId
                             , tmpReport.MovementDescId
                             , 0      AS Amount
                             , tmpReport.Amount AS AmountPast
                             , 0      AS AmountMonthPast
                        FROM tmpReport1 AS tmpReport
                        WHERE COALESCE (tmpReport.Amount,0) <> 0
                        UNION
                        -- данные прошлого месяца период1
                        SELECT DATE_TRUNC ('YEAR', tmpReport.OperMonth + interval '1 Month') AS OperYear
                             , tmpReport.OperMonth + interval '1 Month'
                             , tmpReport.ProfitLossId
                             , tmpReport.UnitId_ProfitLoss
                             , tmpReport.DirectionId
                             , tmpReport.MovementDescId
                             , 0      AS Amount
                             , 0      AS AmountPast
                             , tmpReport.Amount AS AmountMonthPast
                        FROM tmpReport1 AS tmpReport
                        WHERE COALESCE (tmpReport.Amount,0) <> 0
                          AND tmpReport.OperMonth + interval '1 Month' <= inEndDate1
                        UNION
                        -- данные прошлого месяца период2
                        SELECT DATE_TRUNC ('YEAR', tmpReport.OperMonth + interval '1 Month') AS OperYear
                             , tmpReport.OperMonth + interval '1 Month'
                             , tmpReport.ProfitLossId
                             , tmpReport.UnitId_ProfitLoss
                             , tmpReport.DirectionId
                             , tmpReport.MovementDescId
                             , 0      AS Amount
                             , 0      AS AmountPast
                             , tmpReport.Amount AS AmountMonthPast
                        FROM tmpReport2 AS tmpReport
                        WHERE COALESCE (tmpReport.Amount,0) <> 0
                          AND tmpReport.OperMonth + interval '1 Month' <= inEndDate2
                        )
     
      -- результат
      SELECT tmpReport.OperYear    :: TDateTime
           , tmpReport.OperMonth   :: TDateTime
           , View_ProfitLoss.ProfitLossGroupName
           , View_ProfitLoss.ProfitLossDirectionName
           , View_ProfitLoss.ProfitLossName
           --для печатной формы без кода
           , View_ProfitLoss.ProfitLossGroupName_original
           , View_ProfitLoss.ProfitLossDirectionName_original
           , View_ProfitLoss.ProfitLossName_original

           , Object_Unit_ProfitLoss.ValueData AS UnitName_ProfitLoss

           , Object_Direction.ObjectCode   AS DirectionObjectCode
           , Object_Direction.ValueData    AS DirectionObjectName

           , MovementDesc.ItemName         AS MovementDescName

           , tmpReport.Amount     :: TFloat AS Amount
           , tmpReport.AmountPast :: TFloat AS AmountPast
           , (COALESCE (tmpReport.Amount,0) - COALESCE (tmpReport.AmountPast,0)):: TFloat AS AmountDif
           
           , tmpReport.AmountMonthPast :: TFloat
           , (COALESCE (tmpReport.Amount,0) - COALESCE (tmpReport.AmountMonthPast,0)):: TFloat AS AmountMonthDif
           
      FROM tmpReport 
           FULL JOIN Object_ProfitLoss_View AS View_ProfitLoss
                                            ON View_ProfitLoss.ProfitLossId = tmpReport.ProfitLossId
           
           LEFT JOIN Object AS Object_Unit_ProfitLoss ON Object_Unit_ProfitLoss.Id = tmpReport.UnitId_ProfitLoss
           LEFT JOIN Object AS Object_Direction       ON Object_Direction.Id       = tmpReport.DirectionId

           LEFT JOIN MovementDesc ON MovementDesc.Id = tmpReport.MovementDescId

      WHERE View_ProfitLoss.ProfitLossCode <> 70101 -- Чистая прибыль
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.19         *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLossPeriod (inStartDate:= '31.07.2016', inEndDate:= '31.07.2016', inStartDate:= '31.07.2016', inEndDate:= '31.07.2016', inSession:= '2') WHERE Amount <> 0 ORDER BY 5
