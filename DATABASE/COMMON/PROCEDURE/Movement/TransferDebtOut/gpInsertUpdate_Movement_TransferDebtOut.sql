-- Function: gpInsertUpdate_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtOut (integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перевод долга (расход)>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inContractFromId      Integer   , -- Договор (от кого)
    IN inContractToId        Integer   , -- Договор (кому)
    IN inPaidKindFromId      Integer   , -- Виды форм оплаты (от кого)
    IN inPaidKindToId        Integer   , -- Виды форм оплаты (кому)
    IN inPartnerId           Integer   , -- Контрагент
    IN inDocumentTaxKindId_inf Integer  , -- Тип формирования налогового документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
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
     ioId:= lpInsertUpdate_Movement_TransferDebtOut (ioId               := ioId
                                                   , inInvNumber        := inInvNumber
                                                   , inInvNumberPartner := inInvNumberPartner
                                                   , inOperDate         := inOperDate
                                                   , inPriceWithVAT     := inPriceWithVAT
                                                   , inVATPercent       := inVATPercent
                                                   , inChangePercent    := inChangePercent
                                                   , inFromId           := inFromId
                                                   , inToId             := inToId
                                                   , inPaidKindFromId   := inPaidKindFromId
                                                   , inPaidKindToId     := inPaidKindToId
                                                   , inContractFromId   := inContractFromId
                                                   , inContractToId     := inContractToId
                                                   , inPartnerId        := inPartnerId
                                                   , inUserId           := vbUserId
                                                    );

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
 20.06.14                                                       * add InvNumberPartner
 17.04.14                                        * add восстановить/удалить Налоговую
 07.05.14                                        * add inPartnerId
 03.05.14                                        * del inMasterId, ioPriceListId, outPriceListName
 24.04.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
