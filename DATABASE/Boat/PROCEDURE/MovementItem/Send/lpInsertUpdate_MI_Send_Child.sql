-- Function: lpInsertUpdate_MI_Send_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Send_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Send_Child(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inObjectId               Integer   , -- Комплектующие
    IN inPartionId              Integer   , -- Комплектующие
    IN inAmount                 TFloat    , -- Количество резерв
    IN inUserId                 Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- если нет кол-ва
     IF vbIsInsert = TRUE AND COALESCE (inAmount, 0) = 0 
     THEN
         -- !!!Выход!!!
         RETURN;
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, inPartionId, inMovementId, inAmount, inParentId, inUserId);

     -- сохранили свойство <Заказ Клиента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);
     
     
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
 23.06.21         *
*/

-- тест
--