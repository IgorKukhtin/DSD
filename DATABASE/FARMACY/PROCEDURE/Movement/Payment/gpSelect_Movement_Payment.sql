-- Function: gpSelect_Movement_Payment()

DROP FUNCTION IF EXISTS gpSelect_Movement_Payment (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Payment(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , JuridicalId Integer
             , JuridicalName TVarChar
             , isPaymentFormed Boolean
             , Comment TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN

    -- Контролшь использования подразделения
    vbJuridicalId := gpGet_User_JuridicalId(inSession);

    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        SELECT
            Movement_Payment.Id
          , Movement_Payment.InvNumber
          , Movement_Payment.OperDate
          , Movement_Payment.StatusCode
          , Movement_Payment.StatusName
          , Movement_Payment.TotalCount
          , Movement_Payment.TotalSumm
          , Movement_Payment.JuridicalId
          , Movement_Payment.JuridicalName
          , Movement_Payment.isPaymentFormed
          , Movement_Payment.Comment
        FROM
            Movement_Payment_View AS Movement_Payment
            INNER JOIN tmpStatus ON Movement_Payment.StatusId = tmpStatus.StatusId
        WHERE
            Movement_Payment.OperDate BETWEEN inStartDate AND inEndDate
          AND (vbJuridicalId = 0 OR Movement_Payment.JuridicalId = vbJuridicalId)  
        ORDER BY InvNumber;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Payment (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 16.09.19                                                                                       *
 04.07.18                                                                                       *
 29.10.15                                                                        *
*/