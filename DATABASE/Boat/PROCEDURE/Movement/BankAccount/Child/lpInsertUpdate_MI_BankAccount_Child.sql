-- Function: lpInsertUpdate_MI_BankAccount_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_BankAccount_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   ,
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_invoice  Integer   , -- 
    IN inObjectId            Integer   , -- 
    IN inAmount              TFloat    , -- 
    IN inComment             TVarChar  ,
    IN inUserId              Integer     -- сессия пользователя
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

     -- сохранили свойство <OperPrice>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_invoice);

     -- <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.24         *
*/

-- тест
--