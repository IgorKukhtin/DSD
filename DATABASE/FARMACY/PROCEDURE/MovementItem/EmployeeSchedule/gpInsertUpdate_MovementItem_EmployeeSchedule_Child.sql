-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule_Child ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule_Child (Integer, Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inUnitId              Integer   , -- подразделение
    IN inAmount              TFloat    , -- Сумма начислено
    IN inPayrollTypeID       Integer   , -- Тип начисления
    IN inDateStart           TDateTime , -- Дата время начала смены
    IN inDateEnd             TDateTime , -- Дата время конца счены
    IN inSession             TVarChar   -- пользователь
 )
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Ищем свободные zc_MI_Child() 
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.DescId = zc_MI_Child()
                  AND MovementItem.ParentId = inParentId
                  AND MovementItem.Amount = inAmount)
      THEN
        SELECT MIN(MovementItem.ID)
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.ParentId = inParentId
          AND MovementItem.Amount = inAmount;
      END IF;
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                                              , inMovementId          := inMovementId          -- ключ Документа
                                                              , inParentId            := inParentId
                                                              , inUnitId              := inUnitId
                                                              , inAmount              := inAmount
                                                              , inPayrollTypeID       := inPayrollTypeID
                                                              , inDateStart           := inDateStart
                                                              , inDateEnd             := inDateEnd
                                                              , inUserId              := vbUserId              -- пользователь
                                                               );

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.09.19                                                        *
*/

-- тест
-- 