-- Function: gpReport_Movement_WagesVIP_CalcMonth()

DROP FUNCTION IF EXISTS gpReport_Movement_WagesVIP_CalcMonth (TDateTime,  TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_WagesVIP_CalcMonth(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (OperDate TDateTime
             , SummPhone TFloat
             , SummSale TFloat
             , SummNP TFloat
             , SummTotal TFloat
             , SummCalc TFloat
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- Ðåçóëüòàò
     RETURN QUERY      
      WITH tmpMovementNPAll AS (SELECT CASE WHEN DATE_TRUNC ('MONTH', inOperDate) >= '01.01.2022'
                                            THEN Movement.OperDate
                                            ELSE date_trunc('day', MovementDate_Insert.ValueData + INTERVAL '3 HOUR') END  AS OperDate
                                     , MovementFloat_TotalSumm.ValueData                                                   AS TotalSumm
                                FROM Movement

                                     INNER JOIN MovementBoolean AS MovementBoolean_NP
                                                                ON MovementBoolean_NP.MovementId = Movement.Id
                                                               AND MovementBoolean_NP.DescId = zc_MovementBoolean_NP()
                                                               AND MovementBoolean_NP.ValueData = True

                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                     LEFT JOIN MovementDate AS MovementDate_Insert
                                                            ON MovementDate_Insert.MovementId = Movement.Id
                                                           AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                                WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', inOperDate)
                                  AND Movement.OperDate < DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH'
                                  AND Movement.DescId = zc_Movement_Sale()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                             ),
           tmpMovementNP AS (SELECT Movement.OperDate
                                  , SUM(Movement.TotalSumm)       AS SummNP
                             FROM tmpMovementNPAll AS Movement
                             GROUP BY Movement.OperDate),
           tmpMovementCheck AS (SELECT Movement.*
                                     , MovementFloat_TotalSumm.ValueData                              AS TotalSumm
                                     , COALESCE(MovementBoolean_CallOrder.ValueData,FALSE) :: Boolean AS isCallOrder
                                     , False                                                          AS isOffsetVIP
                                FROM Movement

                                     INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                               AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                               AND MovementBoolean_Deferred.ValueData = True

                                     INNER JOIN MovementString AS MovementString_InvNumberOrder
                                                               ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                              AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                                              AND MovementString_InvNumberOrder.ValueData <> ''

                                     LEFT JOIN MovementBoolean AS MovementBoolean_CallOrder
                                                               ON MovementBoolean_CallOrder.MovementId = Movement.Id
                                                              AND MovementBoolean_CallOrder.DescId = zc_MovementBoolean_CallOrder()

                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                     LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                                               ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                                              AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()

                                WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', inOperDate) -  INTERVAL '1 MONTH' + INTERVAL '4 DAY'
                                  AND Movement.OperDate < DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' + INTERVAL '4 DAY'
                                  AND Movement.DescId = zc_Movement_Check()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND COALESCE(MovementBoolean_MobileApplication.ValueData, False) = False
                                UNION ALL
                                SELECT Movement.*
                                     , MovementFloat_TotalSumm.ValueData                              AS TotalSumm
                                     , False                                                          AS isCallOrder
                                     , MovementBoolean_OffsetVIP.ValueData                            AS isOffsetVIP 
                                FROM Movement

                                     INNER JOIN MovementBoolean AS MovementBoolean_OffsetVIP
                                                               ON MovementBoolean_OffsetVIP.MovementId = Movement.Id
                                                              AND MovementBoolean_OffsetVIP.DescId = zc_MovementBoolean_OffsetVIP()
                                                              AND MovementBoolean_OffsetVIP.ValueData = TRUE

                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                                
                                WHERE Movement.OperDate >= DATE_TRUNC ('MONTH', inOperDate)
                                  AND Movement.OperDate < DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH'
                                  AND Movement.DescId = zc_Movement_Check()
                                  AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                        , CASE WHEN MIN(date_trunc('day', MovementProtocol.OperDate + INTERVAL '3 HOUR')) < DATE_TRUNC ('MONTH', inOperDate)
                                                    AND date_trunc('day', Movement.OperDate) > DATE_TRUNC ('MONTH', inOperDate)
                                                    AND date_trunc('day', Movement.OperDate) >= '01.01.2022'
                                                    OR Movement.isOffsetVIP = TRUE
                                               THEN date_trunc('day', Movement.OperDate)
                                               ELSE MIN(date_trunc('day', MovementProtocol.OperDate + INTERVAL '3 HOUR')) END   AS OperDate
                                   FROM tmpMovementCheck AS Movement

                                        INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                   GROUP BY MovementProtocol.MovementId, date_trunc('day', Movement.OperDate), Movement.isOffsetVIP)
         , tmpMovement AS (SELECT tmpMovementProtocol.OperDate
                                , SUM(CASE WHEN Movement.isCallOrder = TRUE THEN Movement.TotalSumm END)::TFloat  AS SummPhone
                                , SUM(CASE WHEN Movement.isCallOrder = FALSE THEN Movement.TotalSumm END)::TFloat AS SummSale
                           FROM tmpMovementCheck AS Movement
                                INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.ID
                           WHERE tmpMovementProtocol.OperDate >= DATE_TRUNC ('MONTH', inOperDate)
                             AND tmpMovementProtocol.OperDate < DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH'
                           GROUP BY tmpMovementProtocol.OperDate)
         , tmpPayrollTypeVIP AS (SELECT Object_PayrollTypeVIP.Id             AS Id
                                      , Object_PayrollTypeVIP.ObjectCode     AS Code
                                      , Object_PayrollTypeVIP.ValueData      AS Name
                                      
                                      , ObjectFloat_PercentPhone.ValueData             AS PercentPhone
                                      , ObjectFloat_PercentOther.ValueData             AS PercentOther 

                                 FROM Object AS Object_PayrollTypeVIP

                                      LEFT JOIN ObjectFloat AS ObjectFloat_PercentPhone
                                                            ON ObjectFloat_PercentPhone.ObjectId = Object_PayrollTypeVIP.Id
                                                           AND ObjectFloat_PercentPhone.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentPhone()

                                      LEFT JOIN ObjectFloat AS ObjectFloat_PercentOther
                                                            ON ObjectFloat_PercentOther.ObjectId = Object_PayrollTypeVIP.Id
                                                           AND ObjectFloat_PercentOther.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentOther()

                                 WHERE Object_PayrollTypeVIP.DescId = zc_Object_PayrollTypeVIP()
                                   AND Object_PayrollTypeVIP.isErased = FALSE
                                 ORDER BY Object_PayrollTypeVIP.ObjectCode
                                 LIMIT 1)
      
      
    SELECT COALESCE (MovementNP.OperDate, Movement.OperDate)::TDateTime  AS OperDate
         , Movement.SummPhone::TFloat
         , Movement.SummSale::TFloat
         , MovementNP.SummNP::TFloat
         , (COALESCE(Movement.SummPhone, 0) +
           COALESCE(Movement.SummSale, 0) +
           COALESCE(MovementNP.SummNP, 0))::TFloat         AS  Summ   
         , ROUND(COALESCE(Movement.SummPhone * PayrollTypeVIP.PercentPhone / 100, 0) +
           COALESCE(Movement.SummSale * PayrollTypeVIP.PercentOther / 100, 0) +
           COALESCE(MovementNP.SummNP * PayrollTypeVIP.PercentPhone / 100, 0), 2)::TFloat     AS  SummCalc   
    FROM tmpMovement AS Movement
    
         FULL JOIN tmpMovementNP AS MovementNP 
                                 ON MovementNP.OperDate = Movement.OperDate
                                 
         LEFT JOIN tmpPayrollTypeVIP AS PayrollTypeVIP ON 1 = 1

    ORDER BY COALESCE (MovementNP.OperDate, Movement.OperDate);
    
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_WagesVIP_CalcMonth (TDateTime, TVarChar) OWNER TO postgres;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
                Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 17.01.22                                                        *
*/

-- òåñò
-- 

select * from gpReport_Movement_WagesVIP_CalcMonth(inOperDate := ('01.01.2023')::TDateTime ,  inSession := '3');