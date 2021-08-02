-- Function: gpInsertUpdate_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut_Order (integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut_Order (integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtOut_Order(
 INOUT ioId                    Integer   , -- Ключ объекта <Документ Перевод долга (расход)>
    IN inInvNumber             TVarChar  , -- Номер документа
    IN inInvNumberPartner      TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberOrder        TVarChar  , -- Номер заявки контрагента
    IN inOperDate              TDateTime , -- Дата документа
    IN inChecked               Boolean   , -- Проверен
 INOUT ioPriceWithVAT          Boolean   , -- Цена с НДС (да/нет)
 INOUT ioVATPercent            TFloat    , -- % НДС
    IN inChangePercent         TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId                Integer   , -- От кого (в документе)
    IN inToId                  Integer   , -- Кому (в документе)
    IN inContractFromId        Integer   , -- Договор (от кого)
    IN inContractToId          Integer   , -- Договор (кому)
    IN inPaidKindFromId        Integer   , -- Виды форм оплаты (от кого)
    IN inPaidKindToId          Integer   , -- Виды форм оплаты (кому)
    IN inPartnerId             Integer   , -- Контрагент (кому)
    IN inPartnerFromId         Integer   , -- Контрагент (от кого)
    IN inDocumentTaxKindId_inf Integer   , -- Тип формирования налогового документа
   OUT outPriceListName        TVarChar  , -- Прайс лист
    IN inMovementId_Order      Integer   , -- ключ Документа
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Tax Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut());

     -- Определяется налоговая для изменения
     IF ioId <> 0
     THEN
         vbMovementId_Tax:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = ioId AND DescId = zc_MovementLinkMovement_Master());
     END IF;

     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioPriceWithVAT, tmp.ioVATPercent, tmp.outPriceListName
      INTO ioId, ioPriceWithVAT, ioVATPercent, outPriceListName
     FROM lpInsertUpdate_Movement_TransferDebtOut (ioId               := ioId
                                                   , inInvNumber        := inInvNumber
                                                   , inInvNumberPartner := inInvNumberPartner
                                                   , inInvNumberOrder   := inInvNumberOrder
                                                   , inOperDate         := inOperDate
                                                   , inChecked          := inChecked
                                                   , ioPriceWithVAT     := ioPriceWithVAT
                                                   , ioVATPercent       := ioVATPercent
                                                   , inChangePercent    := inChangePercent
                                                   , inFromId           := inFromId
                                                   , inToId             := inToId
                                                   , inPaidKindFromId   := inPaidKindFromId
                                                   , inPaidKindToId     := inPaidKindToId
                                                   , inContractFromId   := inContractFromId
                                                   , inContractToId     := inContractToId
                                                   , inPartnerId        := inPartnerId
                                                   , inPartnerFromId    := inPartnerFromId
                                                   , inUserId           := vbUserId
                                                    ) AS tmp;

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order); 

    -- в этом случае надо восстановить/удалить Налоговую
    IF vbMovementId_Tax <> 0
    THEN
        IF inDocumentTaxKindId_inf <> 0
        THEN
             -- проверка <Тип налог. док.> не должен измениться
             IF NOT EXISTS (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementLinkObject_DocumentTaxKind() AND ObjectId = inDocumentTaxKindId_inf)
             THEN
                 RAISE EXCEPTION 'Ошибка.Нельзя изменять <Тип налогового документа>.';
             END IF;

             -- Восстановление налоговой
             IF EXISTS (SELECT Id FROM Movement WHERE Id = vbMovementId_Tax AND StatusId = zc_Enum_Status_Erased())
             THEN
                 PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Tax
                                              , inUserId     := vbUserId);
             END IF;
        ELSE
             -- Удаление налоговой
             PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Tax
                                         , inUserId     := vbUserId);
        END IF;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.01.15         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtOut_Order (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, IN inMovementId_Order:=0, inSession:= '2')
