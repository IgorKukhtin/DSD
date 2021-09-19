-- Function: gpInsertUpdate_MovementItem_WagesVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesVIP(Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesVIP(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
    IN inisIssuedBy          Boolean   , -- подразделение
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
                  AND MovementItem.ObjectID <> inUserId
                  AND MovementItem.ID = ioId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        RAISE EXCEPTION 'Ошибка. Изменение сотрудника запрещено.';
      END IF;
    END IF;

    -- сохранили
    IF COALESCE (ioId, 0) = 0
    THEN
    
        IF inisIssuedBy = TRUE
        THEN
          RAISE EXCEPTION 'Ошибка. Строка не сохранена установка признака выдачи запрещена.';        
        END IF;
        
        ioId := lpInsertUpdate_MovementItem_WagesVIP_Calc (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                                         , inMovementId          := inMovementId          -- ключ Документа
                                                         , inUserWagesId         := inUserId              -- сотрудник
                                                         , inAmountAccrued       := 0                     -- Начисленная З/П сотруднику	
                                                         , inHoursWork           := 0                     -- Отработано часов
                                                         , inUserId              := vbUserId              -- пользователь
                                                           );
    END IF;

    -- сохранили свойство <Дата выдачи>
    IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId), FALSE)
    THEN
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
       -- сохранили свойство <Выдано>
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);    
    END IF;

    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.09.21                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesVIP (, inSession:= '2')
