-- Function: gpSelect_Movement_ChangeIncomePayment()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChangeIncomePayment (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChangeIncomePayment(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
             , FromId Integer, FromName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ChangeIncomePaymentKindId Integer, ChangeIncomePaymentKindName TVarChar
             , Comment TVarChar)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        SELECT
            Movement_ChangeIncomePayment_View.Id
          , Movement_ChangeIncomePayment_View.InvNumber
          , Movement_ChangeIncomePayment_View.OperDate
          , Movement_ChangeIncomePayment_View.StatusCode
          , Movement_ChangeIncomePayment_View.StatusName
          , Movement_ChangeIncomePayment_View.TotalSumm
          , Movement_ChangeIncomePayment_View.FromId
          , Movement_ChangeIncomePayment_View.FromName
          , Movement_ChangeIncomePayment_View.JuridicalId
          , Movement_ChangeIncomePayment_View.JuridicalName
          , Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindId
          , Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindName
          , Movement_ChangeIncomePayment_View.Comment
        FROM Movement_ChangeIncomePayment_View 
            JOIN tmpStatus ON tmpStatus.StatusId = Movement_ChangeIncomePayment_View.StatusId 
        WHERE Movement_ChangeIncomePayment_View.OperDate BETWEEN inStartDate AND inEndDate;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ChangeIncomePayment (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 10.12.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ChangeIncomePayment (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')