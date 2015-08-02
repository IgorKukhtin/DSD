-- Function: gpGet_MovementId_OrderInternal_Auto()

DROP FUNCTION IF EXISTS gpGet_MovementId_OrderInternal_Auto (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_MovementId_OrderInternal_Auto(
    IN inUnitId        Integer,  -- Подразделение
   OUT outMovementId   Integer, -- № заявки
    IN inSession       TVarChar -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderInternal());
    outMovementId := 0;
    SELECT Movement.Id INTO outMovementId
        FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            JOIN MovementBoolean AS MovementBoolean_isAuto
                                 ON MovementBoolean_isAuto.MovementId = Movement.Id 
                                AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                    
        WHERE 
            Movement.StatusId = zc_Enum_Status_UnComplete() 
            AND 
            Movement.DescId = zc_Movement_OrderInternal() 
            AND 
            Movement.OperDate = CURRENT_DATE 
            AND 
            MovementLinkObject_Unit.ObjectId = inUnitId
            AND
            MovementBoolean_isAuto.ValueData = True
        ORDER BY
            Movement.Id
        LIMIT 1;
        
    IF (COALESCE(outMovementId,0) = 0)
    THEN
        RAISE EXCEPTION 'Автозаказ на сегодня ещё не создан';
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_MovementId_OrderInternal_Auto (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.10.14                         *
 03.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderInternal (inMovementId:= 1, inSession:= '9818')