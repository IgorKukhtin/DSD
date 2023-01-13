-- Function: gpSelect_WagesVIP_CalcMonthUser()

DROP FUNCTION IF EXISTS gpSelect_WagesVIP_CalcMonthUser (TDateTime,  TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_WagesVIP_CalcMonthUser(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UserId Integer
             , UserCode Integer
             , UserName TVarChar
             , PayrollTypeVIPID Integer
             , PayrollTypeVIPCode Integer
             , PayrollTypeVIPName TVarChar
             , HoursWork TFloat
             
             , HoursWorkDay  TFloat
             
             , AmountAccrued  TFloat
             , ApplicationAward  TFloat
             , TotalAmount  TFloat

             , SummPhone TFloat
             , SummSale TFloat
             , SummNP TFloat

             , TotalSummPhone TFloat
             , TotalSummSale TFloat
             , TotalSummNP TFloat
             )

AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);
    
    IF vbUserId = 3
    THEN
      vbUserId:= 2431210;
    END IF;

    -- Результат
    RETURN QUERY      
    SELECT WagesVIP.OperDate
         , WagesVIP.UserId
         , WagesVIP.UserCode
         , WagesVIP.UserName
         , WagesVIP.PayrollTypeVIPID
         , WagesVIP.PayrollTypeVIPCode
         , WagesVIP.PayrollTypeVIPName

         , WagesVIP.HoursWork
         , WagesVIP.HoursWorkDay
         
         , WagesVIP.AmountAccrued
         , WagesVIP.ApplicationAward
         
         
         , WagesVIP.TotalAmount

         , WagesVIP.SummPhone
         , WagesVIP.SummSale
         , WagesVIP.SummNP

         , WagesVIP.TotalSummPhone
         , WagesVIP.TotalSummSale
         , WagesVIP.TotalSummNP

    FROM gpReport_Movement_WagesVIP_CalcMonthUser(inOperDate := inOperDate ,  inSession := inSession) AS WagesVIP
    WHERE WagesVIP.UserId = vbUserId
    ORDER BY WagesVIP.OperDate;
    
    
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_WagesVIP_CalcMonthUser (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.01.22                                                        *
*/

-- тест
-- 

select * from gpSelect_WagesVIP_CalcMonthUser(inOperDate := ('01.01.2023')::TDateTime ,  inSession := '3');