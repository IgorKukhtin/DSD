--  gpReport_Check_JackdawsSum()

DROP FUNCTION IF EXISTS gpReport_Check_JackdawsSum (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_JackdawsSum(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , SummaRRO TFloat
             , SummaChech TFloat
             , SummaReturnIn TFloat
             , RetrievedAccounting TFloat
             , SummaReceived TFloat
             , SummaReceivedDelta TFloat
             , SummaJackdaws1 TFloat
             , SummaJackdaws2 TFloat
             , SummaOther TFloat
             , ColorRA_calc Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);

     -- Результат
   RETURN QUERY
   WITH tmpMovementAll AS (SELECT
                               Movement.Id
                             , DATE_TRUNC ('DAY', Movement.OperDate)::TDateTime  AS OperDate
                             , MovementLinkObject_Unit.ObjectId                  AS UnitId
                        FROM Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND (inUnitId = 0 OR MovementLinkObject_Unit.ObjectId = inUnitId)

                        WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
                          AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId = zc_Movement_Check())
      , tmpMovement AS (SELECT
                               Movement.OperDate
                             , Movement.UnitId
                             , SUM(CASE WHEN COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) <> 0 THEN MovementFloat_TotalSumm.ValueData END)::TFloat AS SummaChech
                             , SUM(CASE WHEN COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0 
                                         AND (COALESCE(MovementBoolean_RetrievedAccounting.ValueData, False) = True 
                                          OR   COALESCE(MovementFloat_SummaReceivedFact.ValueData, 0) > 0) THEN MovementFloat_TotalSumm.ValueData END)::TFloat AS RetrievedAccounting
                             , SUM(CASE WHEN COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0 
                                         AND COALESCE(MovementBoolean_RetrievedAccounting.ValueData, False) = True THEN MovementFloat_TotalSumm.ValueData
                                        WHEN COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0 
                                         AND COALESCE(MovementFloat_SummaReceivedFact.ValueData, 0) > 0 THEN MovementFloat_SummaReceivedFact.ValueData END)::TFloat AS SummaReceived
                             , SUM(CASE WHEN COALESCE(Object_JackdawsChecks.ObjectCode, 0) = 1 
                                         AND COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0 THEN MovementFloat_TotalSumm.ValueData END)::TFloat AS SummaJackdaws1
                             , SUM(CASE WHEN COALESCE(Object_JackdawsChecks.ObjectCode, 0) = 2 
                                         AND COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0 THEN MovementFloat_TotalSumm.ValueData END)::TFloat AS SummaJackdaws2
                             , SUM(CASE WHEN COALESCE(Object_JackdawsChecks.ObjectCode, 0) = 0 
                                         AND COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0 THEN MovementFloat_TotalSumm.ValueData END)::TFloat AS SummaOther
                        FROM tmpMovementAll AS Movement

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                                          ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                                         AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
                             LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId
                                                         
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                          ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

                             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                     ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                    
                             LEFT JOIN MovementFloat AS MovementFloat_SummaReceivedFact
                                                     ON MovementFloat_SummaReceivedFact.MovementId =  Movement.Id
                                                    AND MovementFloat_SummaReceivedFact.DescId = zc_MovementFloat_SummaReceivedFact()

                             LEFT JOIN MovementBoolean AS MovementBoolean_RetrievedAccounting
                                                       ON MovementBoolean_RetrievedAccounting.MovementId = Movement.Id
                                                      AND MovementBoolean_RetrievedAccounting.DescId = zc_MovementBoolean_RetrievedAccounting()

                        GROUP BY Movement.OperDate
                               , Movement.UnitId)
      , tmpReturnIn AS (SELECT DATE_TRUNC ('DAY', Movement_ReturnIn.OperDate)     AS OperDate
                             , MovementLinkObject_Unit.ObjectId                   AS UnitId
                             , Sum(MovementFloat_TotalSumm.ValueData)::TFloat     AS TotalSumm

                        FROM Movement AS Movement_ReturnIn
                                       
                            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement_ReturnIn.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                        WHERE Movement_ReturnIn.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
                          AND Movement_ReturnIn.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                          AND Movement_ReturnIn.StatusId = zc_Enum_Status_Complete()
                          AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
                        GROUP BY DATE_TRUNC ('DAY', Movement_ReturnIn.OperDate)
                               , MovementLinkObject_Unit.ObjectId
                      )
      , tmpZReport AS (SELECT DATE_TRUNC ('DAY', ObjectDate_Date.ValueData)     AS OperDate
                             , ObjectLink_ZReportLog_Unit.ChildObjectId         AS UnitId
                             , Sum(COALESCE(ObjectFloat_SummaCash.ValueData, 0) + COALESCE(ObjectFloat_SummaCard.ValueData, 0))::TFloat   AS SummaRRO
                        FROM ObjectDate AS ObjectDate_Date
                                       

                            LEFT JOIN ObjectFloat AS ObjectFloat_SummaCash
                                                  ON ObjectFloat_SummaCash.ObjectId = ObjectDate_Date.ObjectId
                                                 AND ObjectFloat_SummaCash.DescId = zc_ObjectFloat_ZReportLog_SummaCash()
                            LEFT JOIN ObjectFloat AS ObjectFloat_SummaCard
                                                  ON ObjectFloat_SummaCard.ObjectId = ObjectDate_Date.ObjectId
                                                 AND ObjectFloat_SummaCard.DescId = zc_ObjectFloat_ZReportLog_SummaCard()

                            LEFT JOIN ObjectLink AS ObjectLink_ZReportLog_Unit
                                                 ON ObjectLink_ZReportLog_Unit.ObjectId = ObjectDate_Date.ObjectId
                                                AND ObjectLink_ZReportLog_Unit.DescId = zc_ObjectLink_ZReportLog_Unit()

                        WHERE ObjectDate_Date.ValueData >= DATE_TRUNC ('DAY', inStartDate) 
                          AND ObjectDate_Date.ValueData < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                          AND ObjectDate_Date.DescId = zc_ObjectDate_ZReportLog_Date()
                        GROUP BY DATE_TRUNC ('DAY', ObjectDate_Date.ValueData)
                               , ObjectLink_ZReportLog_Unit.ChildObjectId
                      )


  SELECT Movement.OperDate
       , Object_Unit.ID            AS UnitID
       , Object_Unit.ObjectCode    AS UnitCode
       , Object_Unit.ValueData     AS UnitName

       , tmpZReport.SummaRRO       AS SummaRRO
       , Movement.SummaChech       AS SummaChech
       , tmpReturnIn.TotalSumm     AS SummaReturnIn
       , Movement.RetrievedAccounting AS RetrievedAccounting
       , Movement.SummaReceived AS SummaReceived
       , (Movement.RetrievedAccounting - Movement.SummaReceived)::TFloat AS SummaReceivedDelta

       , Movement.SummaJackdaws1   AS SummaJackdaws1
       , Movement.SummaJackdaws2   AS SummaJackdaws2
       , Movement.SummaOther       AS SummaOther
       , zc_Color_Yelow()          AS ColorRA_calc
  FROM tmpMovement AS Movement 
  
       INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Movement.UnitId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                            
       LEFT JOIN tmpReturnIn ON tmpReturnIn.OperDate = Movement.OperDate
                            AND tmpReturnIn.UnitId = Movement.UnitId
                            
       LEFT JOIN tmpZReport ON tmpZReport.OperDate = Movement.OperDate
                           AND tmpZReport.UnitId = Movement.UnitId

       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId

  WHERE COALESCE(Movement.SummaJackdaws1, 0) > 0 OR COALESCE(Movement.SummaJackdaws2, 0) > 0 OR COALESCE(Movement.SummaOther, 0) > 0
  ORDER BY Movement.OperDate
         , Object_Unit.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.07.21                                                                                    *
*/

-- тест
-- 

select * from gpReport_Check_JackdawsSum(inStartDate := ('05.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inUnitId := 10779386 ,  inSession := '3');