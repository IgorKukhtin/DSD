-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ> 
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inGoodsId                Integer   , -- Комплектующие
    IN inAmount                 TFloat    , -- Количество
    IN inComment                TVarChar  , 
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- сохранили свойство <Заказ Клиента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


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
 24.12.22         *
*/

-- тест
--