-- Function: lpInsertUpdate_movement_BankAccount

DROP FUNCTION IF EXISTS lpInsertUpdate_movement_BankAccount(Integer, TVarChar, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_movement_BankAccount(
  INOUT ioId                   Integer, 
     IN inInvNumber            TVarChar, 
     IN inInvNumberPartner     TVarChar  , -- Номер документа (внешний)
     IN inOperDate             TDateTime, 
     IN inAmount               TFloat, 
     IN inBankAccountId        Integer, 
     IN inMoneyPlaceId         Integer, 
     IN inMovementId_Invoice     Integer, 
     IN inComment              TVarChar, 
     IN inuserid               Integer)
  RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - свойство должно быть установлено
     IF COALESCE (inBankAccountId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Расчетный счет>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inMoneyPlaceId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Lieferanten / Kunden>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inMovementId_Invoice, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Счет>.';
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, NULL, inUserId);
     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner); 
     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);


     -- поиск <Элемент документа>
     vbMovementItemId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, NULL, ioId, inAmount, NULL);

     -- сохранили связь с <Объект>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);

     -- Примечание
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);


     -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21         * 
*/

-- тест
--
