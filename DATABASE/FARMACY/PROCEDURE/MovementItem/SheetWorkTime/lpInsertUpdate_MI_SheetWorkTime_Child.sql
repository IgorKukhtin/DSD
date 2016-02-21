-- Function: lpInsertUpdate_MI_SheetWorkTime_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SheetWorkTime_Child (Integer, Integer, Integer, TDateTime);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SheetWorkTime_Child (Integer, Integer, Integer, TDateTime, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SheetWorkTime_Child (Integer, Integer, Integer, Time, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SheetWorkTime_Child(
 INOUT inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- физлицо
    IN inValue               TDateTime ,  -- Количество часов факт
    IN inUserId              Integer   -- Количество часов факт
 )                              
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
BEGIN
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;
     
     -- сохранили <Элемент документа>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), Null, inMovementId, 0, inParentId);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), inId, inValue);


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_SheetWorkTime_Child (InMovementItemId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:= 0, inSession:= '2')
