-- Function: gpGet_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpGetCreate_Movement_OrderInternal (TVarChar);


CREATE OR REPLACE FUNCTION gpGetCreate_Movement_OrderInternal(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar, OrderKindId Integer,  OrderKindName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbUserName TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderInternal());
     vbUserId := inSession;
     vbUnitId := lpGet_DefaultValue('zc_Object_Unit', vbUserId);

     IF COALESCE(vbUnitId, 0) = 0 THEN 
        SELECT ValueData INTO vbUserName FROM Object WHERE Object.Id = vbUserId;
        RAISE EXCEPTION 'У пользователя "%" не определено подразделение по умолчанию', vbUserName;
     END IF;

     -- Пытаемся найти устраивающий нас документ. Это самая поздняя непроведенная заявка от данной точки не позже недели. 
     
     SELECT max(Movement.Id) INTO vbMovementId 
       FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE Movement.StatusId = zc_Enum_Status_UnComplete() 
         AND Movement.DescId = zc_Movement_OrderInternal() 
         AND Movement.OperDate > (current_date - interval '7 day')
         AND MovementLinkObject_Unit.ObjectId = vbUnitId;

     IF COALESCE (vbMovementId, 0) = 0 THEN
        vbMovementId := gpInsertUpdate_Movement_OrderInternal(0, '', current_date, vbUnitId, 0, inSession);
     END IF;

     RETURN QUERY
       SELECT
             tmp.Id
           , tmp.InvNumber
           , tmp.OperDate
           , tmp.StatusCode
           , tmp.StatusName
           , tmp.UnitId
           , tmp.UnitName
           , tmp.OrderKindId 
           , tmp.OrderKindName
       FROM gpGet_Movement_OrderInternal (vbMovementId, inSession) AS tmp;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetCreate_Movement_OrderInternal (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.10.14                         *
 03.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderInternal (inMovementId:= 1, inSession:= '9818')