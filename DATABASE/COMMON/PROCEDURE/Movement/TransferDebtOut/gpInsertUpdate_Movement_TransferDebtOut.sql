-- Function: gpInsertUpdate_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- Юридические лица (от кого)
    IN inToId                Integer   , -- Юридические лица (кому)
    IN inContractFromId      Integer   , -- Договор (от кого)
    IN inContractToId        Integer   , -- Договор (кому)
    IN inPaidKindFromId      Integer   , -- Виды форм оплаты (от кого)
    IN inPaidKindToId        Integer   , -- Виды форм оплаты (кому)
    IN inMasterId            Integer   , -- Налоговая накладная
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar  , -- Прайс лист
    IN inSession             TVarChar    -- сессия пользователя--
)
RETURNS RECORD AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка. Неверный формат даты.';
     END IF;

     -- проверка
     IF COALESCE (inContractFromId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлен договор (от кого).';
     END IF;
     IF COALESCE (inContractToId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлен договор (кому).';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransferDebtOut(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Договор (от кого)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- сохранили связь с <Договор (кому)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     
     -- сохранили связь с <Виды форм оплаты (от кого)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- сохранили связь с <Виды форм оплаты (кому)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     
     -- сохранили связь с <налоговая накладная>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inMasterId);

     -- прайс из документа,  вернуть только его название
     SELECT Object.valuedata INTO outPriceListName FROM Object WHERE Object.Id = ioPriceListId;
     
     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
     END IF;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.04.14  	  *
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtOut (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTransferDebtOutKind:= 0, inSession:= '2')
