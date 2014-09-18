-- Function: gpGet_Movement_PersonalCash()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalCash (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalCash(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ParentId Integer, ParentName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
           
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalCash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_cash_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                AS OperDate
           , inOperDate                                        AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
     
           , 0                      AS ParentId
           , '' :: TVarChar         AS ParentName
           
           , 0::TFloat                                         AS Amount

           , DATE_TRUNC ('Month', inOperDate - INTERVAL '1 MONTH') :: TDateTime AS ServiceDate
           , '' :: TVarChar         AS Comment
           , 0                      AS CashId
           , '' :: TVarChar         AS CashName
   

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementPersonalService.Id         AS ParentId
           , MovementPersonalService.InvNumber  AS ParentName  
                    
           , MovementItem.Amount

           , COALESCE (MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
           , MIString_Comment.ValueData        AS Comment

           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName
         
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Movement AS MovementPersonalService 
                               ON MovementPersonalService.Id = Movement.ParentId
                              AND MovementPersonalService.DescId = zc_Movement_PersonalService()
                                                           
           
       WHERE Movement.Id =  inMovementId;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalCash (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.09.14         * 

*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalCash (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin());
