-- Function: lpInsertUpdate_MI_Inventory_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_MarginCategory_Child(
 INOUT i0Id                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inMarginCategoryId    Integer   , -- MarginCategory
    IN inAmount              TFloat    , -- %
    IN inComment             TVarChar  , -- 
    IN inUserId              Integer     -- 
 )                              
RETURNS Integer AS
$BODY$
  DECLARE vbIsInsert Boolean; 
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
   
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inMarginCategoryId, inMovementId, inAmount, inParentId);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.17         *
*/

-- тест
-- 