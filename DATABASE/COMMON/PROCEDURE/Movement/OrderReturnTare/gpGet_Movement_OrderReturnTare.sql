-- Function: gpGet_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderReturnTare (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderReturnTare(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_Transport Integer, InvNumber_Transport_Full TVarChar
             , ManagerId Integer, ManagerName TVarChar
             , SecurityId Integer, SecurityName TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , UpdateName TVarChar
             , UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                              AS Id
             , CAST (NEXTVAL ('movement_OrderReturnTare_seq') AS TVarChar) AS InvNumber
             , inOperDate :: TDateTime                        AS OperDate  --CURRENT_DATE
             , Object_Status.Code                             AS StatusCode
             , Object_Status.Name                             AS StatusName
             , 0                                              AS MovementId_Transport
             , CAST ('' AS TVarChar)                          AS InvNumber_Transport_Full

             , 0                                              AS ManagerId
             , CAST ('' AS TVarChar)                          AS ManagerName
             , 0                                              AS SecurityId
             , CAST ('' AS TVarChar)                          AS SecurityName

             , CAST ('' as TVarChar) 		                  AS Comment

             , Object_Insert.ValueData                        AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime                  AS InsertDate
             , CAST ('' AS TVarChar)                          AS UpdateName
             , CAST (Null AS TDateTime)                       AS UpdateDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
         ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                      AS Id
           , Movement.InvNumber               AS InvNumber
           , Movement.OperDate                AS OperDate
           , Object_Status.ObjectCode         AS StatusCode
           , Object_Status.ValueData          AS StatusName

           , Movement_Transport.Id            AS MovementId_Transport
           --, ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , zfCalc_PartionMovementName (Movement_Transport.DescId, MovementDesc.ItemName, Movement_Transport.InvNumber, Movement_Transport.OperDate) AS InvNumber_Transport_Full

           , Object_Manager.Id                AS ManagerId
           , Object_Manager.ValueData         AS ManagerName
           , Object_Security.Id               AS SecurityId
           , Object_Security.ValueData        AS SecurityName
           
           , MovementString_Comment.ValueData AS Comment

           , Object_Insert.ValueData          AS InsertName
           , MovementDate_Insert.ValueData    AS InsertDate
           , Object_Update.ValueData          AS UpdateName
           , MovementDate_Update.ValueData    AS UpdateDate

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Manager
                                         ON MovementLinkObject_Manager.MovementId = Movement.Id
                                        AND MovementLinkObject_Manager.DescId = zc_MovementLinkObject_Manager()
            LEFT JOIN Object AS Object_Manager ON Object_Manager.Id = MovementLinkObject_Manager.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Security
                                         ON MovementLinkObject_Security.MovementId = Movement.Id
                                        AND MovementLinkObject_Security.DescId = zc_MovementLinkObject_Security()
            LEFT JOIN Object AS Object_Security ON Object_Security.Id = MovementLinkObject_Security.ObjectId

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

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Transport.DescId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderReturnTare();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.22         *
 06.01.22         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderReturnTare (inMovementId:= 1, inOperDate:= CURRENT_TIMESTAMP, inSession:= '9818')