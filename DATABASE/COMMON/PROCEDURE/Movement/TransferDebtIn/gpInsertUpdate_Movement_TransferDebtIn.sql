-- Function: gpInsertUpdate_Movement_TransferDebtIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransferDebtIn (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransferDebtIn(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перевод долга (расход)>
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
    IN inContractFromId      Integer   , -- Договор (от кого)
    IN inContractToId        Integer   , -- Договор (кому)
    IN inPaidKindFromId      Integer   , -- Виды форм оплаты (от кого)
    IN inPaidKindToId        Integer   , -- Виды форм оплаты (кому)
    IN inPartnerId           Integer   , -- Контрагент кому
    IN inPartnerFromId       Integer   , -- Контрагент от кого
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtIn());

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_TransferDebtIn (ioId    := ioId
                                                  , inInvNumber        := inInvNumber
                                                  , inInvNumberPartner := inInvNumberPartner
                                                  , inInvNumberMark    := inInvNumberMark
                                                  , inOperDate         := inOperDate
                                                  , inChecked          := inChecked
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
                                                  , inPartnerFromId    := inPartnerFromId
                                                  , inUserId           := vbUserId
                                                   ) AS tmp;

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.02.16         * add inPartnerFromId
 01.12.14         * add inInvNumberMark               
 03.09.14         * add inChecked
 20.06.14                                                       * add InvNumberPartner
 07.05.14                                        * add inPartnerId
 04.05.14                                        * del ioPriceListId, outPriceListName
 25.04.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransferDebtIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
