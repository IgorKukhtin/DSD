-- Function: gpInsertUpdate_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages(Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages(Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
    IN inUnitId              Integer   , -- подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUserId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        SELECT MovementItem.ID
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.ObjectID = inUserId
          AND MovementItem.DescId = zc_MI_Master();
      END IF;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUserId
                  AND MovementItem.ID <> ioId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        RAISE EXCEPTION 'Ошибка. Дублироапние сотрудников запрещено.';
      END IF;
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_Wages (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                             , inMovementId          := inMovementId          -- ключ Документа
                                             , inUserWagesId         := inUserId              -- сотрудник
                                             , inUserId              := vbUserId              -- пользователь
                                             , inUnitId              := inUnitId              -- подразделение
                                               );

    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages (, inSession:= '2')

