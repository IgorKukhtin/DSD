-- Function: lpInsertUpdate_Movement_ReturnOut_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut_Value (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer,Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnOut_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
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
     FROM lpInsertUpdate_Movement_ReturnOut (ioId                 := ioId
                                           , inInvNumber          := inInvNumber
                                           , inOperDate           := inOperDate
                                           , inOperDatePartner    := inOperDatePartner
                                           , inPriceWithVAT       := inPriceWithVAT
                                           , inVATPercent         := inVATPercent
                                           , inChangePercent      := inChangePercent
                                           , inFromId             := inFromId
                                           , inToId               := inToId
                                           , inPaidKindId         := inPaidKindId
                                           , inContractId         := inContractId
                                           , inCurrencyDocumentId := inCurrencyDocumentId
                                           , inCurrencyPartnerId  := inCurrencyPartnerId
                                           , inUserId             := inUserId
                                            ) AS tmp);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.05.15                                        *
*/

-- тест
--SELECT * FROM lpInsertUpdate_Movement_ReturnOut_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inUserId:= 2)
