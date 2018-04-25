-- Function: gpGet_Movement_Send (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Send (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , Comment TVarChar 
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             --, CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) AS InvNumber
             , CAST (lfGet_InvNumber (0, zc_Movement_Send()) AS TVarChar) AS InvNumber
             , CASE WHEN inOperDate > CURRENT_DATE THEN CURRENT_DATE ELSE CURRENT_DATE /*inOperDate*/ END :: TDateTime AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
            
             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName
             , CAST ('' as TVarChar) AS Comment
           
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode               AS StatusCode
             , Object_Status.ValueData                AS StatusName

             , Object_From.Id                         AS FromId
             , Object_From.ValueData                  AS FromName
             , Object_To.Id                           AS ToId
             , Object_To.ValueData                    AS ToName
             , MovementString_Comment.ValueData       AS Comment           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
        
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Send();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 25.04.17         *
*/

-- тест
-- select * from gpGet_Movement_Send(inMovementId := 12 , inOperDate := ('20.01.2017')::TDateTime ,  inSession := '2');