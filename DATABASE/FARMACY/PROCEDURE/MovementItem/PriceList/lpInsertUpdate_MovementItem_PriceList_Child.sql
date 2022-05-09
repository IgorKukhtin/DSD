-- Function: lpInsertUpdate_MovementItem_PriceList_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList_Child (Integer, Integer, Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceList_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inDateStart           TDateTime , -- Дата начала
    IN inUserId              Integer     -- сессия пользователя

)
RETURNS Integer AS
$BODY$
BEGIN

     IF EXISTS (SELECT * FROM MovementItem 
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Child()
                  AND MovementItem.ObjectId   = inGoodsId)
     THEN
       SELECT MovementItem.Id INTO ioId
       FROM MovementItem 
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Child()
         AND MovementItem.ObjectId   = inGoodsId;
         
       IF EXISTS(SELECT 1 
                 FROM MovementItemBoolean
                 WHERE MovementItemBoolean.MovementItemId = ioId
                   AND MovementItemBoolean.DescId = zc_MIBoolean_SupplierFailures()
                   AND MovementItemBoolean.ValueData = TRUE)
       THEN         
          RETURN;       
       END IF;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, 0, NULL);

     -- сохранили свойство <Отказ поставщика>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SupplierFailures(), ioId, TRUE);

     -- сохранили свойство <Сотрудник>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);

     -- сохранили связь с <Дата/время корректировки>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);

     -- сохранили свойство <Сотрудник>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Start(), ioId, inDateStart);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.05.15                         *
 19.09.14                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_PriceList_Child ()