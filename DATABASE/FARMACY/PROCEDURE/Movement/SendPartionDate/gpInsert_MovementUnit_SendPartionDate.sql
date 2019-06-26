-- Function: gpInsert_MovementUnit_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MovementUnit_SendPartionDate (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementUnit_SendPartionDate(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  PERFORM lpInsert_MovementUnit_SendPartionDate (inUnitID      := UnitId
                                               , inMovementID  := Movementid
                                               , inSession      := inSession)
  FROM (
    WITH tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId   AS UnitID
                              , MAX(Movement.id)                   AS Movementid
                         FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                                        ON MovementBoolean_Transfer.MovementId = Movement.Id
                                                       AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

                         WHERE Movement.DescId = zc_Movement_SendPartionDate()
                           AND Movement.StatusId = zc_Enum_Status_Complete() 
                           AND COALESCE(MovementBoolean_Transfer.ValueData, False) = False
                         GROUP BY MovementLinkObject_Unit.ObjectId)

    SELECT Object_Unit.Id AS UnitID
         , tmpMovement.Movementid
    FROM Object AS Object_Unit

         INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                 ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                AND ObjectBoolean_DividePartionDate.ValueData = True

         INNER JOIN tmpMovement ON tmpMovement.UnitID = Object_Unit.Id

    WHERE Object_Unit.DescId = zc_Object_Unit()) T1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.06.19                                                       *
 18.06.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsert_MovementUnit_SendPartionDate (inSession:= '3')       