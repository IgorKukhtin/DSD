-- Function: gpInsertUpdate_Movement_Income_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Partner (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income_Partner(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента

 INOUT ioPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
 INOUT ioVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки

    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inPersonalPackerId    Integer   , -- Сотрудник (заготовитель)
 INOUT ioPriceListId         Integer    , -- Прайс лист
   OUT outPriceListName      TVarChar   , -- Прайс лист
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
   OUT outCurrencyValue      TFloat    , -- курс валюты
    IN inContractToId        Integer   , -- Договора
    IN inPaidKindToId        Integer   , -- Виды форм оплаты
 INOUT ioChangePercentTo     TFloat    , -- (-)% Скидки (+)% Наценки
    IN inisIncome            Boolean   , -- False признак приход от покупателя
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


     -- нашли/замена
     ioChangePercentTo:= (SELECT MAX (Object_ContractCondition_ValueView.ChangePercentPartner)
                          FROM Object_ContractCondition_ValueView
                          WHERE Object_ContractCondition_ValueView.ContractId = inContractId
                            AND inOperDatePartner BETWEEN Object_ContractCondition_ValueView.StartDate AND Object_ContractCondition_ValueView.EndDate
                         );


     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioCurrencyValue, tmp.ioPriceListId, tmp.outPriceListName, tmp.ioPriceWithVAT, tmp.ioVATPercent
            INTO ioId, outCurrencyValue, ioPriceListId, outPriceListName, ioPriceWithVAT, ioVATPercent
     FROM lpInsertUpdate_Movement_Income (ioId                := ioId
                                        , inInvNumber         := inInvNumber
                                        , inOperDate          := inOperDate
                                        , inOperDatePartner   := inOperDatePartner
                                        , inInvNumberPartner  := inInvNumberPartner
                                        , ioPriceWithVAT      := ioPriceWithVAT
                                        , ioVATPercent        := ioVATPercent
                                        , inChangePercent     := inChangePercent
                                        , inFromId            := inFromId
                                        , inToId              := inToId
                                        , inPaidKindId        := inPaidKindId
                                        , inContractId        := inContractId
                                        , inPersonalPackerId  := inPersonalPackerId
                                        , ioPriceListId       := ioPriceListId
                                        , inCurrencyDocumentId:= inCurrencyDocumentId
                                        , inCurrencyPartnerId := inCurrencyPartnerId
                                        , ioCurrencyValue     := NULL :: TFloat
                                        , ioParValue          := NULL :: TFloat
                                        , inUserId            := vbUserId
                                         ) AS tmp;


     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     -- сохранили свойство <(-)% Скидки (+)% Наценки покупателя>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentPartner(), ioId, ioChangePercentTo);
     -- сохранили свойство <приход>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), ioId, inisIncome);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.03.21         *
 29.06.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income_Partner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
