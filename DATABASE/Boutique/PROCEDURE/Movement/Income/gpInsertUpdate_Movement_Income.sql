-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income 
                       (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income
                       (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inCurrencyDocumentId   Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId    Integer   , -- Валюта (контрагента)
   OUT outCurrencyValue       TFloat    , -- курс валюты
   OUT outParValue            TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat    , -- Номинал для расчета суммы операции
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
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

     outCurrencyValue := 1;
     outParValue := 0;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Income (ioId                := ioId
                                           , inInvNumber         := inInvNumber
                                           , inOperDate          := inOperDate
                                           , inFromId            := inFromId
                                           , inToId              := inToId
                                           , inCurrencyDocumentId:= inCurrencyDocumentId
                                           , inCurrencyPartnerId := inCurrencyPartnerId
                                           , inCurrencyValue     := outCurrencyValue
                                           , inParValue          := outParValue
                                           , inCurrencyPartnerValue := inCurrencyPartnerValue
                                           , inParPartnerValue   := inParPartnerValue
                                           , inComment           := inComment
                                           , inUserId            := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.04.17         *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
