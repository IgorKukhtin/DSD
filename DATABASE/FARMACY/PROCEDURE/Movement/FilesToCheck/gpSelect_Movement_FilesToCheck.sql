-- Function: gpSelect_Movement_FilesToCheck()

DROP FUNCTION IF EXISTS gpSelect_Movement_FilesToCheck (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_FilesToCheck(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_FilesToCheck());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate   -- выбираем все документы
                                            AND Movement.DescId = zc_Movement_FilesToCheck()
                                            AND Movement.StatusId = tmpStatus.StatusId
                         )

       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementDate_StartPromo.ValueData  AS StartPromo
           , MovementDate_EndPromo.ValueData    AS EndPromo
           , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
           , COALESCE (MovementString_FileName.ValueData,'') :: TVarChar AS FileName

       FROM tmpMovement AS Movement

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

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.22                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_FilesToCheck (inStartDate:= '30.01.2020', inEndDate:= '01.02.2020', inIsErased := FALSE, inSession:= '3')

