-- Function: lpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TransferDebtIn(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перевод долга (приход)>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberMark       TVarChar  , -- Номер "перекресленої зеленої марки зi складу"
    IN inOperDate            TDateTime , -- Дата документа
    IN inChecked             Boolean   , -- Проверен
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindFromId      Integer   , -- Виды форм оплаты
    IN inPaidKindToId        Integer   , -- Виды форм оплаты
    IN inContractFromId      Integer   , -- Договора
    IN inContractToId        Integer   , -- Договора
    IN inPartnerId           Integer   , -- Контрагент кому
    IN inPartnerFromId       Integer   , -- Контрагент от кого
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_TaxCorrective Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF COALESCE (inContractFromId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор (от кого)>.';
     END IF;

     -- проверка
     IF COALESCE (inContractToId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор (кому)>.';
     END IF;

     -- меняется дата у всех корректировок
     IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND OperDate = inOperDate)
     THEN
         -- поиск любой проведенной корректировки
         vbMovementId_TaxCorrective:= (SELECT MAX (MovementLinkMovement.MovementId) FROM MovementLinkMovement INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MovementLinkMovement.MovementChildId = ioId AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master());
         -- проверка - все корректировки должны быть хотя бы распроведены
         IF vbMovementId_TaxCorrective <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Изменение даты невозможно, документ <Корректировка к налоговой> № <%> от <%> в статусе <%>.', (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective), lfGet_Object_ValueData (zc_Enum_Status_Complete());
         END IF;
         -- меняется дата
         UPDATE Movement SET OperDate = inOperDate
         FROM MovementLinkMovement
         WHERE Movement.Id = MovementLinkMovement.MovementId
           AND MovementLinkMovement.MovementChildId = ioId
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (MovementLinkMovement.MovementId, inUserId, FALSE)
         FROM MovementLinkMovement
         WHERE MovementLinkMovement.MovementChildId = ioId
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     END IF;


     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransferDebtIn(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили свойство <Номер "перекресленої зеленої марки зi складу">
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);

     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerFrom(), ioId, inPartnerFromId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.02.16         * add inPartnerFromId
 01.12.14         * add InvNumberMark
 03.09.14         * add inChecked
 20.06.14                                                       * add InvNumberPartner
 07.05.14                                        * add vbAccessKeyId
 04.05.14                                        * del ioPriceListId, outPriceListName
 25.04.14         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TransferDebtIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
