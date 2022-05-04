-- Function: lpInsertUpdate_Movement_ReturnIn_scale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn_scale (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnIn_scale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberMark       TVarChar  , -- Номер "перекресленої зеленої марки зi складу"
    IN inParentId            Integer   , -- 
    IN inOperDate            TDateTime , -- Дата(склад)
    IN inOperDatePartner     TDateTime , -- Дата документа у покупателя
    IN inChecked             Boolean   , -- Проверен
    IN inIsPartner           Boolean   , -- основание - Акт недовоза
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inisList              Boolean   , -- Только для списка
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договор
    IN inSubjectDocId        Integer   , -- Основание для перемещения
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
    IN inCurrencyValue       TFloat    , -- курс валюты
    IN inParValue            TFloat     , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat     , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat     , -- Номинал для расчета суммы операции
    In inComment             TVarChar  , -- примечание
    IN inUserId              Integer     -- Пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- сохранили <Документ>
     ioId:= (SELECT tmp.ioId
             FROM lpInsertUpdate_Movement_ReturnIn (ioId                  := ioId
                                                  , inInvNumber           := inInvNumber
                                                  , inInvNumberPartner    := inInvNumberPartner
                                                  , inInvNumberMark       := inInvNumberMark
                                                  , inParentId            := inParentId
                                                  , inOperDate            := inOperDate
                                                  , inOperDatePartner     := inOperDatePartner
                                                  , inChecked             := inChecked
                                                  , inIsPartner           := inIsPartner
                                                  , inPriceWithVAT        := inPriceWithVAT
                                                  , inisList              := inisList
                                                  , inVATPercent          := inVATPercent
                                                  , inChangePercent       := inChangePercent
                                                  , inFromId              := inFromId
                                                  , inToId                := inToId
                                                  , inPaidKindId          := inPaidKindId
                                                  , inContractId          := inContractId
                                                  , inCurrencyDocumentId  := inCurrencyDocumentId
                                                  , inCurrencyPartnerId   := inCurrencyPartnerId
                                                  , inCurrencyValue       := inCurrencyValue
                                                  , inParValue            := inCurrencyValue
                                                  , inCurrencyPartnerValue:= inCurrencyPartnerValue
                                                  , inParPartnerValue     := inParPartnerValue
                                                  , inMovementId_OrderReturnTare:= NULL
                                                  , inComment             := inComment
                                                  , inUserId              := inUserId
                                                   ) AS tmp
            );
    
     -- сохраняем свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.22                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_ReturnIn_scale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
