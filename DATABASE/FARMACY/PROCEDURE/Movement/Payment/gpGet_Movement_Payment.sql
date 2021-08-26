-- Function: gpGet_Movement_Payment()

DROP FUNCTION IF EXISTS gpGet_Movement_Payment (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Payment (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Payment (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Payment(
    IN inMovementId        Integer  , -- ключ Документа
    IN inDateStart         TDateTime, -- начало периода для листа
    IN inDateEnd           TDateTime, -- конец периода для листа
    IN inSession           TVarChar   -- сессия пользователя
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
             , DateStart TDateTime
             , DateEnd TDateTime
             , isPaymentFormed Boolean
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Payment());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        inDateStart := CURRENT_DATE;
        inDateEnd := CURRENT_DATE;
        RETURN QUERY
        SELECT
            0                                                   AS Id
          , CAST (NEXTVAL ('movement_Payment_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime	                            AS OperDate
          , Object_Status.Code               	                AS StatusCode
          , Object_Status.Name              		            AS StatusName
          , 0::TFloat                                           AS TotalCount
          , 0::TFloat                                           AS TotalSumm
          , NULL::Integer                                       AS JuridicalId
          , NULL::TVarChar                                      AS JuridicalName
          , inDateStart                                         AS DateStart
          , inDateEnd                                           AS DateEnd 
          , False                                               AS isPaymentFormed
          , NULL::TVarChar                                      AS Comment
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete())   AS Object_Status;
    ELSE
        RETURN QUERY
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
          , inDateStart AS DateStart
          , inDateEnd AS DateEnd
          , Movement_Payment.isPaymentFormed
          , Movement_Payment.Comment
        FROM
            Movement_Payment_View AS Movement_Payment
        WHERE Movement_Payment.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Payment (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 16.09.19                                                                                     *
 29.10.15                                                                        *
*/
