-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses_SP(
 INOUT ioId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inUnitID                   Integer   , -- Плдразделение
    IN inSummaSP                  TFloat    , -- СП
    IN inUserId                   Integer   -- пользователь
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
        
    IF vbIsInsert = TRUE
    THEN
       -- Создали <Элемент документа>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, 0, 0);
    END IF;
    
     -- сохранили свойство <СП>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSP(), ioId, inSummaSP);

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, lpGet_MovementItem_WagesAE_TotalSum (ioId, inUserId), 0);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.21                                                        *
*/

-- тест
-- 