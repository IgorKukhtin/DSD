-- Function: gpComplete_MovementUnit_SendOverdue()

DROP FUNCTION IF EXISTS gpComplete_MovementUnit_SendOverdue (TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_MovementUnit_SendOverdue(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  PERFORM lpComplete_MovementUnit_SendOverdue (inMovementId     := Movement.Id
                                             , inSession        := inSession)
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                    AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

  WHERE Movement.OperDate < CURRENT_DATE - INTERVAL '4 DAY'
    AND Movement.DescId = zc_Movement_Send()
    AND Movement.StatusId = zc_Enum_Status_UnComplete();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpComplete_MovementUnit_SendOverdue (inSession:= '3')       