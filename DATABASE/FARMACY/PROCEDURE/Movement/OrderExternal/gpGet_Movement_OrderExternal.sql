-- Function: gpGet_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderExternal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , ContractId Integer, ContractName TVarChar
             , MasterId Integer, MasterInvNumber TVarChar, OrderKindName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderExternal());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     		                AS FromId
             , CAST ('' AS TVarChar) 		                AS FromName
             , 0                     		                AS ToId
             , CAST ('' AS TVarChar) 		                AS ToName
             , 0                     			        AS ContractId
             , CAST ('' AS TVarChar) 			        AS ContractName
             , 0                     			        AS MasterId
             , CAST ('' AS TVarChar) 			        AS MasterInvNumber
             , CAST ('' AS TVarChar) 			        AS OrderKindName
             , CAST ('' AS TVarChar) 		                AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , Object_Contract.Id                                 AS ContractId
           , Object_Contract.ValueData                          AS ContractName
           , Movement_Master.Id                                 AS MasterId
           , ('№ '||Movement_Master.InvNumber || ' от '|| TO_CHAR(Movement_Master.Operdate , 'DD.MM.YYYY')) :: TVarChar    AS MasterInvNumber 
           , Object_OrderKind.ValueData                         AS OrderKindName
           , COALESCE(MovementString_Comment.ValueData,'') :: TVarChar AS Comment

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Master
                                           ON MLM_Master.MovementId = Movement.Id
                                          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MLM_Master.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                         ON MovementLinkObject_OrderKind.MovementId = Movement_Master.Id
                                        AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
            LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderExternal();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderExternal (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.16         *
 01.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderExternal (inMovementId:= 1, inSession:= '9818')