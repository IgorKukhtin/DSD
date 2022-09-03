-- Function: gpGet_Movement_FilesToCheck()

DROP FUNCTION IF EXISTS gpGet_Movement_FilesToCheck (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_FilesToCheck(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartPromo TDateTime, EndPromo TDateTime
             , Comment TVarChar
             , FileName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_FilesToCheck_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CURRENT_DATE::TDateTime                          AS StartPromo
             , CURRENT_DATE::TDateTime                          AS EndPromo
             , '' :: TVarChar                                   AS Comment
             , '' :: TVarChar                                   AS FileName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementDate_StartPromo.ValueData  AS StartPromo
           , MovementDate_EndPromo.ValueData    AS EndPromo
           , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
           , COALESCE (MovementString_FileName.ValueData,'') :: TVarChar AS FileName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()

            LEFT JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_FileName
                                     ON MovementString_FileName.MovementId = Movement.Id
                                    AND MovementString_FileName.DescId = zc_MovementString_FileName()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_FilesToCheck();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.22                                                       *
 */

-- тест
-- select * from gpGet_Movement_FilesToCheck(inMovementId := 18340672 , inOperDate := ('23.04.2020')::TDateTime ,  inSession := '3');