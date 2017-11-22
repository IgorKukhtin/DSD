-- Function: lpInsertUpdate_MI_Inventory_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_MarginCategory_Child(
 INOUT ioId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- ключ Документа
    IN inMarginCategoryItemId    Integer   , -- MarginCategoryItem
    IN inAmount                  TFloat    , -- %
    IN inUserId                  Integer     -- 
 )                              
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean; 
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
   
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inMarginCategoryItemId, inMovementId, inAmount, Null);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.17         *
*/

-- тест
-- 