-- Function: gpReport_Movement_PayIncome()

DROP FUNCTION IF EXISTS gpReport_Movement_PayIncome (TDateTime, TDateTime, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Movement_PayIncome(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inMakerId                  Integer ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , UnitId Integer
             , UnitName TVarChar
             , MainJuridicalId Integer
             , MainJuridicalName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , SummaJuridical TFloat
             , TotalSumm TFloat
                                     
             , OperDatePay TDateTime
             , SummaNoPay TFloat
             , SummaPay TFloat
             , SummaRemainder TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
        WITH tmpMovement AS (SELECT Movement.MovementId
                                  , Movement.InvNumber
                                  , Movement.OperDate
                                  , Movement.UnitId
                                  , Movement.MainJuridicalId
                                  , Movement.JuridicalId
                                  , Round(SUM(Movement.PriceWithVAT * Movement.Amount), 2) AS SummaJuridical
                             FROM gpReport_MovementIncome_Promo (inMakerId:= inMakerId, inStartDate:= '01.01.2020', inEndDate:= CURRENT_DATE, inSession:= '3') AS Movement
                             GROUP BY Movement.MovementId
                                    , Movement.InvNumber  
                                    , Movement.OperDate
                                    , Movement.UnitId
                                    , Movement.MainJuridicalId
                                    , Movement.JuridicalId),
             tmpMovementSum AS (SELECT Movement.MovementId
                                     , Movement.InvNumber
                                     , Movement.OperDate
                                     , Movement.UnitId
                                     , Movement.MainJuridicalId
                                     , Movement.JuridicalId
                                     , Movement.SummaJuridical
                                     , MovementFloat_TotalSumm.ValueData     AS TotalSumm
                                     
                                     , MICP.OperDate                         AS OperDatePay 
                                     , Round(-1.0 * MICP.Amount * Movement.SummaJuridical / MovementFloat_TotalSumm.ValueData, 2)  AS SummaPay 
                                     , MIC.ContainerId
                                FROM tmpMovement AS Movement
                                
                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId = Movement.MovementId
                                                            AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                            
                                     LEFT JOIN MovementItemContainer AS MIC 
                                                                     ON MIC.MovementId = Movement.MovementId
                                                                    AND MIC.DescId = zc_MIContainer_SummIncomeMovementPayment()

                                     LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                        AND Container.ID = MIC.ContainerId

                                     LEFT JOIN MovementItemContainer AS MICP 
                                                                     ON MICP.ContainerId = Container.Id
                                                                    AND MICP.DescId = zc_MIContainer_SummIncomeMovementPayment()
                                                                    AND MICP.MovementId <> Movement.MovementId
                                                                    AND MICP.OperDate BETWEEN inStartDate AND inEndDate
                                ), 
             tmpMovementPay AS (SELECT Movement.MovementId
                                     , Movement.InvNumber
                                     , Movement.OperDate
                                     , Movement.UnitId
                                     , Movement.MainJuridicalId
                                     , Movement.JuridicalId
                                     , Movement.SummaJuridical
                                     , Movement.TotalSumm
                                                             
                                     , Movement.OperDatePay 
                                     , SUM(Movement.SummaPay)   AS SummaPay
                                     , Movement.ContainerId
                                FROM tmpMovementSum AS Movement
                                WHERE COALESCE (Movement.SummaPay , 0) > 0
                                GROUP BY Movement.MovementId
                                       , Movement.InvNumber
                                       , Movement.OperDate
                                       , Movement.UnitId
                                       , Movement.MainJuridicalId
                                       , Movement.JuridicalId
                                       , Movement.SummaJuridical
                                       , Movement.TotalSumm                                                     
                                       , Movement.OperDatePay 
                                       , Movement.ContainerId
                                ), 
             tmpMovementNoPay AS (SELECT Movement.MovementId
                                       , Movement.OperDatePay 
                                       , Round(SUM(MICP.Amount * Movement.SummaJuridical / Movement.TotalSumm), 2) AS SummaNoPay
                                  FROM tmpMovementPay AS Movement
                                  
                                       LEFT JOIN MovementItemContainer AS MICP 
                                                                       ON MICP.ContainerId = Movement.ContainerId
                                                                      AND MICP.DescId = zc_MIContainer_SummIncomeMovementPayment()
                                                                      AND MICP.OperDate < Movement.OperDatePay
                                                                      
                                  GROUP BY Movement.MovementId
                                         , Movement.OperDatePay 
                                  )
                                    
                                    
        SELECT Movement.MovementId
             , Movement.InvNumber
             , Movement.OperDate
             , Movement.UnitId
             , Object_Unit.ValueData                     AS UnitName
             , Movement.MainJuridicalId
             , Object_MainJuridical.ValueData            AS MainJuridicalName
             , Movement.JuridicalId
             , Object_Juridical.ValueData                AS JuridicalName
             , Movement.SummaJuridical::TFloat
             , Movement.TotalSumm::TFloat
                                     
             , Movement.OperDatePay 
             , tmpMovementNoPay.SummaNoPay::TFloat
             , Movement.SummaPay::TFloat 
             , (tmpMovementNoPay.SummaNoPay - Movement.SummaPay)::TFloat AS SummaRemainder
        FROM tmpMovementPay AS Movement                           

             LEFT JOIN tmpMovementNoPay ON tmpMovementNoPay.MovementId = Movement.MovementId
                                       AND tmpMovementNoPay.OperDatePay = Movement.OperDatePay
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId

             LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = Movement.MainJuridicalId

             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement.JuridicalId

        ORDER BY Movement.OperDatePay, Movement.MovementId 

;

            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_Movement_PayIncome (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 04.01.21                                                      * 
 */

-- тест
-- SELECT * FROM gpReport_Movement_PayIncome (inStartDate:= '01.12.2020', inEndDate:= '31.12.2020', inMakerId:= 15451717 , inSession:= zfCalc_UserAdmin())