-- Function: lpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inCurrencyDocumentId   Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId    Integer   , -- Валюта (контрагента)
    IN inCurrencyValue        TFloat    , -- курс валюты
    IN inParValue             TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat    , -- Номинал для расчета суммы операции
    IN inComment              TVarChar  , -- Примечание
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId        := ioId
                                    , inDescId    := zc_Movement_ReturnOut()
                                    , inInvNumber := inInvNumber
                                    , inOperDate  := inOperDate
                                    , inParentId  := NULL
                                     );



     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);
     -- сохранили связь с <Валюта (контрагента) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 08.06.17                                                       *  lpInsertUpdate_Movement c параметрами
 24.04.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
