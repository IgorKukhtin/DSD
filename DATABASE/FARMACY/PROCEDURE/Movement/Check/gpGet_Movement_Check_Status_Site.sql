-- Function: gpGet_Movement_Check_Status_Site()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_Status_Site (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_Status_Site(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ConfirmedKindCode Integer, ConfirmedKindName TVarChar
             , ConfirmedKindClientCode Integer, ConfirmedKindClientName TVarChar
             , isCallOrder Boolean, TotalSumm TFloat
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Check());
     vbUserId := inSession;

     RETURN QUERY
     SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , Object_ConfirmedKind.ObjectCode            AS ConfirmedKindCode
           , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
           , Object_ConfirmedKindClient.ObjectCode      AS ConfirmedKindClientCode
           , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName
           , COALESCE(MovementBoolean_CallOrder.ValueData,FALSE) :: Boolean AS isCallOrder
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
     FROM Movement AS Movement_Check

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                       ON MovementLinkObject_ConfirmedKind.MovementId = Movement_Check.Id
                                      AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
          LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                       ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement_Check.Id
                                      AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
          LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

          LEFT JOIN MovementBoolean AS MovementBoolean_CallOrder
                                    ON MovementBoolean_CallOrder.MovementId = Movement_Check.Id
                                   AND MovementBoolean_CallOrder.DescId = zc_MovementBoolean_CallOrder()

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

     WHERE Movement_Check.Id = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check_Status_Site (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.08.2                                                        *
*/

-- тест
-- 
select * from gpGet_Movement_Check_Status_Site(inMovementId := 29773648,  inSession := '3');