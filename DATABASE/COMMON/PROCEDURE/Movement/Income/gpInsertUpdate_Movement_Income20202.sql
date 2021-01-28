-- Function: gpInsertUpdate_Movement_Income20202()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income20202 (Integer, TVarChar, TDateTime, TDateTime, TVarChar, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income20202(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента

    IN inis20202             Boolean   , -- спецодежда
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     
     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioCurrencyValue, tmp.ioParValue
            INTO ioId, ioCurrencyValue, ioParValue
     FROM lpInsertUpdate_Movement_Income20202 (ioId                := ioId
                                             , inInvNumber         := inInvNumber
                                             , inOperDate          := inOperDate
                                             , inOperDatePartner   := inOperDatePartner
                                             , inInvNumberPartner  := inInvNumberPartner
                                             , inis20202           := inis20202
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
 27.01.21         * _20202
 22.11.18         *
 29.05.15                                        * lpInsertUpdate_Movement_Income
 06.09.14                                        * add lpInsert_MovementProtocol
 23.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 10.02.14                                        * add lpGetAccessKey
 07.10.13                                        * add lpCheckRight
 06.10.13                                        * add lfCheck_Movement_Parent
 30.09.13                                        * del zc_MovementLinkObject_PersonalDriver
 27.09.13                                        * del zc_MovementLinkObject_Car
 07.07.13                                        * rename zc_MovementFloat_ChangePercent
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income20202 (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
