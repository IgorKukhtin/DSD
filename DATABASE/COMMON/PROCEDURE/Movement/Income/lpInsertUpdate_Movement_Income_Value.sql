-- Function: lpInsertUpdate_Movement_Income_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income_Value (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки 

    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты 
    IN inContractId          Integer   , -- Договора
    IN inPersonalPackerId    Integer   , -- Сотрудник (заготовитель)
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- сохранили <Документ>
     ioId:= 
    (SELECT tmp.ioId
     FROM lpInsertUpdate_Movement_Income (ioId                := ioId
                                        , inInvNumber         := inInvNumber
                                        , inOperDate          := inOperDate
                                        , inOperDatePartner   := inOperDatePartner
                                        , inInvNumberPartner  := inInvNumberPartner
                                        , inPriceWithVAT      := inPriceWithVAT
                                        , inVATPercent        := inVATPercent
                                        , inChangePercent     := inChangePercent
                                        , inFromId            := inFromId
                                        , inToId              := inToId
                                        , inPaidKindId        := inPaidKindId
                                        , inContractId        := inContractId
                                        , inPersonalPackerId  := inPersonalPackerId
                                        , inCurrencyDocumentId:= inCurrencyDocumentId
                                        , inCurrencyPartnerId := inCurrencyPartnerId
                                        , ioCurrencyValue     := NULL :: TFloat
                                        , inUserId            := inUserId
                                         ) AS tmp);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Income_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
