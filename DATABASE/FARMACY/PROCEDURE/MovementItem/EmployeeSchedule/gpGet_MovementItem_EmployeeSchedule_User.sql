-- Function: gpGet_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpGet_MovementItem_EmployeeSchedule_User (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_EmployeeSchedule_User(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime,
               ValueUser TVarChar 
              )
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbUserId Integer;
   DECLARE vbComingValueDay TVarChar;
   DECLARE vbTypeId Integer;
   DECLARE vbValue Integer;
   DECLARE vbResult TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    
    vbResult := '';

    -- проверка наличия графика
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
    
      SELECT Movement.ID 
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeSchedule();
    
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = vbUserId)
      THEN

        SELECT MovementItemString.ValueData
        INTO vbComingValueDay
        FROM MovementItem
         
             INNER JOIN MovementItemString ON MovementItemString.DescId = zc_MIString_ComingValueDayUser()
                                          AND MovementItemString.MovementItemId = MovementItem.ID
          
        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = vbUserId;

        IF COALESCE (vbComingValueDay, '') = ''
        THEN
          vbComingValueDay := '0000000000000000000000000000000';
        END IF;
    
        vbTypeId :=  date_part('day',  CURRENT_DATE);
    
        vbResult :=lpDecodeValueDay(vbTypeId, vbComingValueDay);
      END IF;	
    END IF;


    RETURN QUERY
    SELECT CURRENT_DATE::TDateTime                        AS OperDate
         , vbResult                                       AS ValueUser;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.19                                                       *
*/

-- тест
-- select * from gpGet_MovementItem_EmployeeSchedule_User(inSession := '308120');
