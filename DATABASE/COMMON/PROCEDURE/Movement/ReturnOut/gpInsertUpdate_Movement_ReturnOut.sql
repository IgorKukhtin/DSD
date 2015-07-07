-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
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
   OUT outCurrencyValue      TFloat    , -- курс валюты
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.outCurrencyValue
            INTO ioId, outCurrencyValue
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
                                           , inUserId             := vbUserId
                                            ) AS tmp;
     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId 
 10.02.14                                        * в lp-должно быть все
 10.02.14                                                        *
 14.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2');
