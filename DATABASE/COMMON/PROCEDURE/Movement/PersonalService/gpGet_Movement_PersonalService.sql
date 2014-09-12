-- Function: gpGet_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalService (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalService(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSumm TFloat
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbServiceDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalService());
     vbUserId := inSession;

     -- расчет - 1-ое число месяца
     vbServiceDate:= DATE_TRUNC ('MONTH', inOperDate);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) AS InvNumber
             , inOperDate               AS OperDate
             , Object_Status.Code       AS StatusCode
             , Object_Status.Name       AS StatusName

             , vbServiceDate            AS ServiceDate 
             , CAST (0 AS TFloat)       AS TotalSumm
             , CAST ('' AS TVarChar)    AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , Date_ServiceDate.ValueData         AS ServiceDate 
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm
           , MovementString_Comment.ValueData   AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS Date_ServiceDate
                                   ON Date_ServiceDate.MovementId = Movement.Id
                                  AND Date_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                  
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_PersonalService();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalService (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.09.14         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalService (inMovementId:= 1, inSession:= '9818')