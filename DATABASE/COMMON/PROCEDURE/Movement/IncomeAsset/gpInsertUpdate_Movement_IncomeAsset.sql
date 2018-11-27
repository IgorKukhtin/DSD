-- Function: gpInsertUpdate_Movement_IncomeAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeAsset (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeAsset (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeAsset (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeAsset(
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
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
 INOUT ioCurrencyValue       TFloat    , -- курс валюты
 INOUT ioParValue            TFloat    , -- номинал
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeAsset());
                                              
     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioCurrencyValue, tmp.ioParValue
            INTO ioId, ioCurrencyValue, ioParValue
     FROM lpInsertUpdate_Movement_IncomeAsset (ioId                := ioId
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
                                             , inCurrencyDocumentId:= inCurrencyDocumentId
                                             , inCurrencyPartnerId := inCurrencyPartnerId
                                             , ioCurrencyValue     := ioCurrencyValue
                                             , ioParValue          := ioParValue
                                             , inComment           := inComment
                                             , inUserId            := vbUserId
                                              ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.11.18         * ioCurrencyValue
 06.10.16         * parce
 25.07.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_IncomeAsset (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
