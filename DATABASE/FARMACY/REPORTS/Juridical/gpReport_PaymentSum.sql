-- Function: gpReport_PaymentSum()

DROP FUNCTION IF EXISTS gpReport_PaymentSum (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PaymentSum(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalCode Integer
             , JuridicalName TVarChar
             , JuridicalFromCode Integer
             , JuridicalFromName TVarChar
             , TotalSummUnComplete TFloat
             , TotalSummComplete TFloat
             , TotalSumm TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- Контролшь использования подразделения

    RETURN QUERY
        SELECT
            Object_Juridical.ObjectCode
          , Movement_Payment.JuridicalName
          , Object_From.ObjectCode          AS JuridicalFromCode
          , Object_From.ValueData           AS JuridicalFromName
          , SUM(CASE WHEN Movement_Payment.StatusId = zc_Enum_Status_UnComplete() THEN MI_Payment.Amount END)::TFloat    AS TotalSumm
          , SUM(CASE WHEN Movement_Payment.StatusId = zc_Enum_Status_Complete() THEN MI_Payment.Amount END)::TFloat    AS TotalSumm
          , SUM(MI_Payment.Amount)::TFloat    AS TotalSumm
        FROM Movement_Payment_View AS Movement_Payment
        
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement_Payment.JuridicalId

             INNER JOIN MovementItem AS MI_Payment 
                                     ON MI_Payment.MovementId = Movement_Payment.Id
                                    AND MI_Payment.DescId     = zc_MI_Master()
                                    AND MI_Payment.isErased = FALSE

             LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                               ON MIFloat_IncomeId.MovementItemId = MI_Payment.ID
                                              AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()


             LEFT JOIN MovementLinkObject AS MLO_From
                                          ON MLO_From.MovementId = MIFloat_IncomeId.ValueData :: Integer
                                         AND MLO_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId

             LEFT JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                           ON MIBoolean_NeedPay.MovementItemId = MI_Payment.Id
                                          AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()

        WHERE
            Movement_Payment.OperDate BETWEEN inStartDate AND inEndDate
            AND Movement_Payment.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
            AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = True
            
        GROUP BY Object_Juridical.ObjectCode
               , Movement_Payment.JuridicalName
               , Object_From.ObjectCode
               , Object_From.ValueData  
        ORDER BY Movement_Payment.JuridicalName
               , Object_From.ObjectCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PaymentSum (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.03.22                                                       *
*/


select * from gpReport_PaymentSum(inStartDate := ('18.03.2022')::TDateTime , inEndDate := ('18.03.2022')::TDateTime , inSession := '3');