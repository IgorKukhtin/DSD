-- Function: gpInsertUpdate_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderIncome(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа (формирование заказа)
    IN inOperDatePartner     TDateTime , -- 
    IN inUnitId              Integer   , -- Подрахделение
    IN inJuridicalId         Integer   , -- Поставщик
    IN inContractId          Integer   , -- Договор 
    IN inPaidKindId          Integer   , -- Форма оплаты
 INOUT ioCurrencyDocumentId  Integer   , -- Валюта (документа)
   OUT outCurrencyDocumentName TVarChar , -- Валюта (документа)

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки 
   OUT outCurrencyValue      TFloat    , -- Курс для перевода в валюту баланса
   OUT outParValue           TFloat    , -- Номинал для перевода в валюту баланса

    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderIncome());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderIncome(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);


     --валюту документа берем из договора , если договор пустой, берем то что введут в контроле
     IF COALESCE (inContractId,0) <> 0
     THEN
         ioCurrencyDocumentId := (SELECT ObjectLink_Contract_Currency.ChildObjectId
                                  FROM ObjectLink AS ObjectLink_Contract_Currency
                                  WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
                                    AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
                                  );
     END IF;
     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, ioCurrencyDocumentId);
     outCurrencyDocumentName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioCurrencyDocumentId);


     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчет курса для баланса
     IF ioCurrencyDocumentId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= ioCurrencyDocumentId, inPaidKindId:= CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);
     ELSE outCurrencyValue:= 0;
          outParValue:=0;
     END IF;
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- сохранили свойство <Номинал для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, outParValue);


     -- Примечание
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
         END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.17         *
 12.07.16         *
*/

-- тест
-- 