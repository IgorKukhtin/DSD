-- Function: lpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inObjectId               Integer   , -- Комплектующие
    IN inReceiptLevelId         Integer   , -- Этап сборки
    IN inColorPatternId         Integer   , -- Шаблон Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- Опция
    IN inAmount                 TFloat    , -- Количество     
    IN inForCount               TFloat    , -- Для кол-во
    IN inUserId                 Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, NULL, inMovementId, inAmount, inParentId, inUserId);

     
     -- сохранили связь с <Этап сборки>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptLevel(), ioId, inReceiptLevelId);
     -- сохранили связь с <Шаблон Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ColorPattern(), ioId, inColorPatternId);
     -- сохранили связь с <Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdColorPattern(), ioId, inProdColorPatternId);
     -- сохранили связь с <Options>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdOptions(), ioId, inProdOptionsId);
     -- сохранили свойство <Для кол-во>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ForCount(), ioId, CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.23         *
 12.07.21         *
*/

-- тест
-- SELECT * FROM