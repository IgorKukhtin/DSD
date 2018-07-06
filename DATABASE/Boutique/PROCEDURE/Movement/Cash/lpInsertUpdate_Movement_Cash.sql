-- Function: lpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inCurrencyPartnerValue TFloat    ,
    IN inParPartnerValue      TFloat    ,
    IN inAmountCurrency       TFloat    ,
    IN inAmount               TFloat    ,

    IN inAmount_MI            TFloat    ,    
    IN inCashId               Integer   , --
    IN inMoneyPlaceId         Integer   , --
    IN inInfoMoneyId          Integer   ,
    IN inUnitId               Integer   ,
    IN inCurrencyId           Integer   , --
    IN inCurrencyValue        TFloat    , --
    IN inParValue             TFloat    , --
    IN inComment              TVarChar  , -- Примечание
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert     Boolean;
   DECLARE vbId_sale_part Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка - Поставщик
     IF COALESCE (inCashId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Касса>.';
     END IF;

     -- проверка
     IF COALESCE (inCurrencyId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Валюта>.';
     END IF;

     -- Если НЕ Базовая Валюта
     IF inCurrencyId <> zc_Currency_Basis() THEN
        -- проверка
        IF COALESCE (inCurrencyValue, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка.Не определено значение <Курс>.';
        END IF;
        -- проверка
        IF COALESCE (inParValue, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка.Не определено значение <Номинал>.';
        END IF;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement (ioId        := ioId
                                   , inDescId    := zc_Movement_Cash()
                                   , inInvNumber := inInvNumber
                                   , inOperDate  := inOperDate
                                   , inParentId  := NULL
                                   , inUserId    := inUserId
                                    );

     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);

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
 09.06.17                                                       *  add inUserId in lpInsertUpdate_Movement
 10.04.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Cash (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
