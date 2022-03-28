-- Function: gpReport_NotPaySumIncome()

DROP FUNCTION IF EXISTS gpReport_NotPaySumIncome (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_NotPaySumIncome(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalCode Integer
             , JuridicalName TVarChar
             , JuridicalFromCode Integer
             , JuridicalFromName TVarChar
             , TotalSumm TFloat
             , TotalPaySumm TFloat
             , TotalPaySummDate TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- Контролшь использования подразделения

    RETURN QUERY
        WITH tmpContainer AS
                         (SELECT Object_Movement.ObjectCode AS MovementId, Container.Amount
                          FROM Container
                               LEFT JOIN Object AS Object_Movement ON Object_Movement.Id = Container.ObjectId
                                                                  AND Object_Movement.DescId = zc_Object_PartionMovement()
                          WHERE Container.DescId = zc_Container_SummIncomeMovementPayment()
                            AND Container.Amount > 0
                         
                         ),
             tmpIncome AS 
                         (SELECT Movement_Income.*  
                               , MovementLinkObject_From.ObjectId           AS FromId
                               , MovementLinkObject_To.ObjectId             AS ToId
                               , MovementFloat_TotalSumm.ValueData          AS TotalSumm
                               , tmpContainer.Amount                        AS PaySumm
                               , CASE WHEN MovementDate_Payment.ValueData <= inEndDate THEN tmpContainer.Amount END AS PaySummDate
                          FROM Movement AS Movement_Income
                                                                       
                               LEFT JOIN tmpContainer ON Movement_Income.Id = tmpContainer.MovementId
                                                                       
                               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId =  Movement_Income.Id
                                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          
                               LEFT JOIN MovementDate AS MovementDate_Payment
                                                      ON MovementDate_Payment.MovementId =  Movement_Income.Id
                                                     AND MovementDate_Payment.DescId = zc_MovementDate_Payment()                                                          
                                                                       
                          WHERE Movement_Income.DescId = zc_Movement_Income()
                            AND Movement_Income.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement_Income.StatusId = zc_Enum_Status_Complete()),
             tmpData AS   
                         (SELECT Movement_Income.FromId
                               , ObjectLink_Unit_Juridical.ChildObjectId    AS JuridicalId
                               , SUM(Movement_Income.TotalSumm)::TFloat     AS TotalSumm
                               , SUM(Movement_Income.PaySumm)::TFloat       AS PaySumm
                               , SUM(Movement_Income.PaySummDate)::TFloat   AS PaySummDate
                          FROM tmpIncome AS Movement_Income
                                                                       
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                    ON ObjectLink_Unit_Juridical.ObjectId = Movement_Income.ToId
                                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                                       
                          GROUP BY Movement_Income.FromId
                                 , ObjectLink_Unit_Juridical.ChildObjectId)

    SELECT Movement_Income.JuridicalId
         , Object_Juridical.ValueData                 AS JuridicalName
         , Movement_Income.FromId
         , Object_From.ValueData                      AS FromName
         , Movement_Income.TotalSumm
         , Movement_Income.PaySumm
         , Movement_Income.PaySummDate
    FROM tmpData AS Movement_Income
                                                                         
         LEFT JOIN Object AS Object_From ON Object_From.Id = Movement_Income.FromId

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement_Income.JuridicalId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_NotPaySumIncome (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.03.22                                                       *
*/

select * from gpReport_NotPaySumIncome(inStartDate := ('01.03.2022')::TDateTime , inEndDate := ('26.03.2022')::TDateTime ,  inSession := '3');


