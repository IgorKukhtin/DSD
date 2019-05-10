-- Function: gpGet_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderInternal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar, OrderKindId Integer,  OrderKindName TVarChar
             , isDocument Boolean
             , MasterId Integer, MasterInvNumber TVarChar
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderInternal());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_OrderInternal_seq') AS TVarChar) AS InvNumber
             , current_date::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     		                AS UnitId
             , CAST ('' AS TVarChar) 		                AS UnitName
             , 0                     		                AS OrderKindId
             , CAST ('' AS TVarChar) 			        AS OrderKindName
             , False :: Boolean                                 AS isDocument
             , 0                     			        AS MasterId
             , CAST ('' AS TVarChar) 			        AS MasterInvNumber
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , Object_Unit.Id                                     AS UnitId
           , Object_Unit.ValueData                              AS UnitName
           , Object_OrderKind.Id                                AS OrderKindId
           , Object_OrderKind.ValueData                         AS OrderKindName
           , COALESCE(MovementBoolean_Document.ValueData, False) :: Boolean AS isDocument

           , Movement_Master.Id                                 AS MasterId
           , ('№ '||Movement_Master.InvNumber || ' от '|| TO_CHAR(Movement_Master.Operdate , 'DD.MM.YYYY')) :: TVarChar AS MasterInvNumber
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId = Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                         ON MovementLinkObject_OrderKind.MovementId = Movement.Id
                                        AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
            LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Master
                                           ON MLM_Master.MovementId = Movement.Id
                                          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MLM_Master.MovementChildId
            
       WHERE Movement.Id =  inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.19         *
 17.10.14                         *
 03.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderInternal (inMovementId:= 1, inSession:= '9818')