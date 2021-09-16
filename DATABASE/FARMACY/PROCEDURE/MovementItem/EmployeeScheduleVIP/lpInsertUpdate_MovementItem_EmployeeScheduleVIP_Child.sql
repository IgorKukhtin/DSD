-- Function: lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inAmount              TFloat    , -- День
    IN inPayrollTypeVIPID    Integer   , -- Тип начисления
    IN inDateStart           TDateTime , -- Дата время начала смены
    IN inDateEnd             TDateTime , -- Дата время конца счены
    IN inUserId              Integer   -- пользователь
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPayrollTypeVIPID, inMovementId, inAmount, inParentId);

     -- сохранили свойство <Дата время начала смены>
    IF inDateStart IS NOT NULL
    THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Start(), ioId, inDateStart);
    END IF;

     -- сохранили свойство <Дата время конца счены>
    IF inDateEnd IS NOT NULL
    THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_End(), ioId, inDateEnd);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
16.09.21                                                        *
*/

-- 