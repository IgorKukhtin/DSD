-- Function: lpInsertUpdate_MI_Inventory_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Inventory_Child (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Inventory_Child(
 INOUT inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inAmountUser          TFloat    , -- Количество
    IN inUserId              Integer   -- Количество часов факт
 )                              
RETURNS Integer AS
$BODY$
 
BEGIN
     -- сохранили <Элемент документа>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), inUserId, inMovementId, inAmountUser, inParentId);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inId, CURRENT_TIMESTAMP);


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, inUserId, True);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.01.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_Inventory_Child (inId:= 0, inMovementId:= 10, inParentId:= 1, inAmountUser:= 0, inSession:= '2')
