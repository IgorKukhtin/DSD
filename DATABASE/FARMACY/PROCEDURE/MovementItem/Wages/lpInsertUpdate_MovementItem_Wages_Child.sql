-- Function: lpInsertUpdate_MovementItem_Wages_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Wages_Child (Integer, Integer, Integer, Boolean, Integer, TFloat, TDateTime, TFloat, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Wages_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inAuto                Boolean   , -- Авто расчет
    IN inUnitId              Integer   , -- подразделение
    IN inAmount              TFloat    , -- Сумма начислено
    IN inDateCalculation     TDateTime , -- Дата расчета
    IN inSummaBase           TFloat    , -- Сумма базы
    IN inPayrollTypeID       Integer   , -- Тип начисления
    IN inComment             TVarChar  , -- Описание
    IN inUserId              Integer   -- пользователь
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);

    -- сохранили свойство <Авто расчет>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, inAuto);
    
    -- сохранили свойство <Тип начисления>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PayrollType(), ioId, inPayrollTypeID);    

     -- сохранили свойство <Дата расчета>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Calculation(), ioId, inDateCalculation);

     -- сохранили свойство <Сумма базы>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaBase(), ioId, inSummaBase);

    -- сохранили свойство <Описание>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- сохранили протокол
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.19                                                        *
*/

-- тест
-- 