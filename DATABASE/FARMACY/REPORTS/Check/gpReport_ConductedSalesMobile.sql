
-- Function: gpReport_ConductedSalesMobile()

DROP FUNCTION IF EXISTS gpReport_ConductedSalesMobile (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ConductedSalesMobile(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate    TDateTime
             , CountCheck  Integer
             , TotalCount  TFloat
             , TotalSumm   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbStartDate := date_trunc('MONTH', inOperDate);
     vbEndDate := vbStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
     IF vbEndDate > CURRENT_DATE 
     THEN
       vbEndDate := CURRENT_DATE;
     END IF;
     
     -- Результат
     RETURN QUERY
     WITH 
         tmpMovement AS (SELECT date_trunc('DAY', Movement.OperDate)::TDateTime            AS OperDate
                              , Count(*)::Integer                                          AS CountCheck
                              , SUM(MovementFloat_TotalCount.ValueData)::TFloat            AS TotalCount
                              , SUM(MovementFloat_TotalSumm.ValueData)::TFloat             AS TotalSumm
                         FROM Movement
                               
                              INNER JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                                         ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                                        AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                                        AND MovementBoolean_MobileApplication.ValueData = True

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                              LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                      ON MovementFloat_TotalCount.MovementId = Movement.Id
                                                     AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= vbStartDate
                           AND Movement.OperDate < vbEndDate + INTERVAL '1 DAY'
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         GROUP BY date_trunc('DAY', Movement.OperDate))
                                 
      SELECT Movement.OperDate
           , Movement.CountCheck
           , Movement.TotalCount
           , Movement.TotalSumm
      FROM tmpMovement AS Movement
      ORDER BY Movement.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_ConductedSalesMobile (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.09.22                                                       * 
*/

-- тест

select * from gpReport_ConductedSalesMobile(inOperDate := ('01.09.2022')::TDateTime, inSession := '3');     