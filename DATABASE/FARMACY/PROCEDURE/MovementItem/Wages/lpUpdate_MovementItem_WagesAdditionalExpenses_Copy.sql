-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy(
 INOUT ioId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inUnitID                   Integer   , -- Плдразделение
    IN inSummaCleaning            TFloat    , -- Уборка
    IN inSummaOther               TFloat    , -- Прочее
    IN inComment                  TVarChar  , -- Примечание
    IN inUserId                   Integer     -- пользователь
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
    
     -- сохранили свойство <Уборка>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaCleaning(), ioId, inSummaCleaning);

     -- сохранили свойство <Прочее>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaOther(), ioId, inSummaOther);
    
    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, lpGet_MovementItem_WagesAE_TotalSum (ioId, inUserId), 0);

    -- сохранили свойство <Примечание>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);    

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.10.20                                                        *
*/

-- тест
-- 
