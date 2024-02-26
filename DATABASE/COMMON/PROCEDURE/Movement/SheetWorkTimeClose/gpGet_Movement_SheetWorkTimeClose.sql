-- Function: gpGet_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpGet_Movement_SheetWorkTimeClose (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_SheetWorkTimeClose(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime, OperDateEnd TDateTime
             , TimeClose TDateTime                             -- Время авто закрытия  на следующий день после окончания периода
             , StatusCode Integer, StatusName TVarChar
             , isClosed Boolean, isClosedAuto Boolean
             , UnitId Integer, UnitName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SheetWorkTimeClose());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_SheetWorkTimeClose_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , inOperDate                                       AS OperDateEnd
             , (inOperDate + INTERVAL '1 DAY' + INTERVAL '10 HOURS') ::TDateTime       AS TimeClose
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , FALSE   ::Boolean                                AS isClosed
             , FALSE   ::Boolean                                AS isClosedAuto

             , 0                                                AS UnitId
             , CAST ('' AS TVarChar)                            AS UnitName

             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime                    AS InsertDate

             , CAST ('' AS TVarChar)                            AS UpdateName
             , CAST (NULL AS TDateTime)                         AS UpdateDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate ::TDateTime       AS OperDate
           , MovementDate_OperDateEnd.ValueData ::TDateTime AS OperDateEnd
           , MovementDate_TimeClose.ValueData   ::TDateTime AS TimeClose
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName

           , COALESCE (MovementBoolean_Closed.ValueData, FALSE) ::Boolean     AS isClosed
           , COALESCE (MovementBoolean_ClosedAuto.ValueData, FALSE) ::Boolean AS isClosedAuto

           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           , Object_Update.ValueData             AS UpdateName
           , MovementDate_Update.ValueData       AS UpdateDate

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
            LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                      ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                     AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()

            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
            LEFT JOIN MovementDate AS MovementDate_TimeClose
                                   ON MovementDate_TimeClose.MovementId = Movement.Id
                                  AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_SheetWorkTimeClose();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.24         *
 10.08.21         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_SheetWorkTimeClose (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '9818')
