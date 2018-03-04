-- Function: gpGet_Movement_LossPersonal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_LossPersonal (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_LossPersonal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_LossPersonal());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_LossPersonal_seq') as Integer) AS InvNumber
           , inOperDate            AS OperDate
           , lfObject_Status.Code  AS StatusCode
           , lfObject_Status.Name  AS StatusName

           , DATE_TRUNC ('Month', inOperDate) :: TDateTime AS ServiceDate     -- CURRENT_DATE
           , ''  ::TVarChar        AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
          ;
     ELSE
     RETURN QUERY 
       SELECT
             Movement.Id                        AS Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName

           , MovementDate_ServiceDate.ValueData AS ServiceDate
           , MovementString_Comment.ValueData   AS Comment
             
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()        
            
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_LossPersonal();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.02.18         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_LossPersonal (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
