-- Function: lpComplete_Movement_BankAccount (Integer, Boolean)

DROP FUNCTION IF EXISTS lpinsertupdate_movement_BankAccount(Integer, TVarChar, TVarChar, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpinsertupdate_movement_BankAccount(
  INOUT ioid                   Integer, 
     IN ininvnumber            TVarChar, 
     IN inInvNumberPartner     TVarChar  , -- Номер документа (внешний)
     IN inoperdate             TDateTime, 
     IN inamount               TFloat, 
     IN inbankaccountid        Integer, 
     IN inmoneyplaceid         Integer, 
     IN inMovementId_Invoice     Integer, 
     IN incomment              TVarChar, 
     IN inuserid               Integer)
  RETURNS Integer AS
$BODY$
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
 
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankAccount(), inInvNumber, inOperDate, NULL, inUserId);

     -- <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner); 

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inBankAccountId, Null, ioId, inAmount, NULL);

     -- сохранили связь с <Объект>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);

     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     -- Комментарий
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