-- Function: gpUpdate_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_User(
    IN inOperDate            TDateTime,  -- Дата
    IN inValueUser           TVarChar,   -- Время прихода
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbComingValueDay TVarChar;
   DECLARE vbTypeId Integer;
   DECLARE vbValue Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    IF inValueUser = '7:00' AND vbUnitId NOT IN (2886778)
    THEN
      RAISE EXCEPTION 'Ошибка. Время прихода 7:00 вам устанавлтивать запрещено.';
    END IF;

    -- проверка наличия графика
    IF NOT EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', inOperDate)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      RAISE EXCEPTION 'Ошибка. График работы сотрудеиков не найден. Обратитесь к Романовой Т.В.';
    END IF;
    
    SELECT Movement.ID 
    INTO vbMovementID
    FROM Movement
    WHERE Movement.OperDate = date_trunc('month', inOperDate)
      AND Movement.DescId = zc_Movement_EmployeeSchedule();
    
    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbUserId)
    THEN
      SELECT MovementItem.ID 
      INTO vbMovementItemID        
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = vbUserId;
    ELSE
      -- сохранили
      vbMovementItemID := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                 -- Ключ объекта <Элемент документа>
                                                                      , inMovementId          := vbMovementID      -- ключ Документа
                                                                      , inPersonId            := vbUserId          -- сотрудник
                                                                      , inComingValueDay      := '0000000000000000000000000000000'::TVarChar      -- Приходы на работу по дням
                                                                      , inUserId              := vbUserId          -- пользователь
                                                                       );

    END IF;	

    SELECT MovementItemString.ValueData
    INTO vbComingValueDay
    FROM MovementItemString
    WHERE MovementItemString.DescId = zc_MIString_ComingValueDayUser()
      AND MovementItemString.MovementItemId = vbMovementItemID;

    IF COALESCE (vbComingValueDay, '') = ''
    THEN
      vbComingValueDay := '0000000000000000000000000000000';
    END IF;
    
    vbTypeId :=  date_part('day', inOperDate);
    
    vbValue := CASE inValueUser WHEN '8:00' THEN 1
                                WHEN '9:00' THEN 2
                                WHEN '10:00' THEN 3
                                WHEN '7:00' THEN 4
                                WHEN '21:00' THEN 7
                                WHEN 'В' THEN 9
                                ELSE 0 END;

    vbComingValueDay := SUBSTRING(vbComingValueDay, 1, vbTypeId - 1) || vbValue::TVarChar || SUBSTRING(vbComingValueDay, vbTypeId + 1, 31);

    -- сохранили <приходы по дням сотрудника>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDayUser(), vbMovementItemID, vbComingValueDay);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbMovementItemID, vbUserId, False);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
10.12.18                                                        *

*/
