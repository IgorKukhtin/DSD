-- Function: gpGet_Movement_FounderService()

DROP FUNCTION IF EXISTS gpGet_Movement_FounderService (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_FounderService(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat
             , Comment TVarChar
             , FounderId Integer, FounderName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_FounderService());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_FounderService_seq') AS TVarChar) AS InvNumber
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           
           , 0::TFloat                        AS Amount

           , ''::TVarChar                     AS Comment
           , 0                                AS FounderId
           , CAST ('' as TVarChar)            AS FounderName

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;
  
     ELSE

     RETURN QUERY 
       SELECT
             inMovementId as Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('Movement_FounderService_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementItem.Amount
           , MIString_Comment.ValueData AS Comment

           , Object_Founder.Id          AS FounderId
           , Object_Founder.ValueData   AS FounderName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Founder ON Object_Founder.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
       WHERE Movement.Id =  inMovementId;

   END IF;  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_FounderService (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.09.14         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_FounderService (inMovementId:= 1, inOperDate:= CURRENT_DATE,  inSession:= zfCalc_UserAdmin());
