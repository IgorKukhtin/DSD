-- Function: gpGet_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpGetCreate_Movement_OrderInternal (TVarChar);


CREATE OR REPLACE FUNCTION gpGetCreate_Movement_OrderInternal(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderInternal());
     vbUserId := inSession;


     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , Object_Unit.Id                                     AS UnitId
           , Object_Unit.ValueData                              AS UnitName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       WHERE Movement.Id =  vbMovementId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderInternal (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.10.14                         *
 03.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderInternal (inMovementId:= 1, inSession:= '9818')