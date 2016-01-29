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
             , Comment TVarChar

             , ReturnOutInvNumber TVarChar, ReturnOutInvNumberPartner TVarChar
             , ReturnOutOperDate TDateTime, ReturnOutOperDatePartner TDateTime
             , IncomeOperDate TDateTime, IncomeInvNumber TVarChar
             )

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

          , Movement_ReturnOut_View.InvNumber         AS ReturnOutInvNumber
          , Movement_ReturnOut_View.InvNumberPartner  AS ReturnOutInvNumberPartner
          , Movement_ReturnOut_View.OperDate          AS ReturnOutOperDate
          , Movement_ReturnOut_View.OperDatePartner   AS ReturnOutOperDatePartner
          , Movement_ReturnOut_View.IncomeOperDate    
          , Movement_ReturnOut_View.IncomeInvNumber   
          
        FROM Movement_ChangeIncomePayment_View 
            JOIN tmpStatus ON tmpStatus.StatusId = Movement_ChangeIncomePayment_View.StatusId 
            LEFT JOIN MovementLinkMovement AS MLM_ChangeIncomePayment 
                                           ON MLM_ChangeIncomePayment.MovementChildId = Movement_ChangeIncomePayment_View.Id
                                          AND MLM_ChangeIncomePayment.DescId = zc_MovementLinkMovement_ChangeIncomePayment()
            LEFT JOIN Movement_ReturnOut_View ON Movement_ReturnOut_View.Id = MLM_ChangeIncomePayment.MovementId
            
        WHERE Movement_ChangeIncomePayment_View.OperDate BETWEEN inStartDate AND inEndDate;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ChangeIncomePayment (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 27.01.16         * 
 10.12.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ChangeIncomePayment (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')
