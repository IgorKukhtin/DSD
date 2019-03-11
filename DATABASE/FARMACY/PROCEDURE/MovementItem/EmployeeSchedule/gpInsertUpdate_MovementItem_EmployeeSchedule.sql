-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule(INTEGER, INTEGER, INTEGER, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
 INOUT ioValue               TVarChar  , -- часы
 INOUT ioTypeId              Integer   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbComingValueDay TVarChar;

   DECLARE vbValue INTEGER;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer AND 9383066  <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    IF COALESCE (ioId, 0) <> 0
    THEN
      SELECT MovementItemString.ValueData
      INTO vbComingValueDay
      FROM MovementItemString
      WHERE MovementItemString.DescId = zc_MIString_ComingValueDay()
        AND MovementItemString.MovementItemId = ioId;
    ELSE
      vbComingValueDay := '0000000000000000000000000000000';
    END IF;

    IF COALESCE (vbComingValueDay, '') = ''
    THEN
      vbComingValueDay := '0000000000000000000000000000000';
    END IF;
    
    IF ioTypeId > 0
    THEN
      vbValue := CASE ioValue WHEN '8:00' THEN 1
                              WHEN '9:00' THEN 2
                              WHEN '10:00' THEN 3
                              WHEN '7:00' THEN 4
                              WHEN '21:00' THEN 7
                              WHEN 'В' THEN 9
                              ELSE 0 END;

      vbComingValueDay := SUBSTRING(vbComingValueDay, 1, ioTypeId - 1) || vbValue::TVarChar || SUBSTRING(vbComingValueDay, ioTypeId + 1, 31);
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := ioId              -- Ключ объекта <Элемент документа>
                                                        , inMovementId          := inMovementId      -- ключ Документа
                                                        , inPersonId            := inUserId          -- сотрудник
                                                        , inComingValueDay      := vbComingValueDay  -- Приходы на работу по дням
                                                        , inUserId              := vbUserId          -- пользователь
                                                         );

    --
    IF ioTypeId > 0
    THEN
      ioValue := lpDecodeValueDay(ioTypeId, vbComingValueDay);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
11.12.18                                                        *
09.12.18                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_EmployeeSchedule (, inSession:= '2')


