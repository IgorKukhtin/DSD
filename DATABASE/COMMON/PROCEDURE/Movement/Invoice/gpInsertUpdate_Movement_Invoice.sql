-- Function: gpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice(Integer, TVarChar, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа (формирование заказа)
    IN inInvNumberPartner    TVarChar  , -- Номер документа у поставщика
    IN inJuridicalId         Integer   , -- Поставщик
    IN inContractId          Integer   , -- Договор 
    IN inPaidKindId          Integer   , -- Форма оплаты
 INOUT ioCurrencyDocumentId  Integer   , -- Валюта (документа)
   OUT outCurrencyDocumentName TVarChar , -- Валюта (документа)
    
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки 
 INOUT ioCurrencyValue       TFloat    , -- курс валюты
 INOUT ioParValue            TFloat    , -- Номинал для перевода в валюту баланса

 INOUT ioTotalSumm_f1        TFloat    , --
 INOUT ioTotalSumm_f2        TFloat    , --
 
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyDocumentId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Invoice());


     -- проверка
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Форма оплаты>.';
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     --валюту документа берем из 1) из заявки, если там пусто 2) из договора , если и там пусто, берем то что введут в контроле
     vbCurrencyDocumentId := (SELECT MovementLinkObject_CurrencyDocument.ObjectId
                              FROM MovementItem
                                   INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementItemId()
                                                               AND MIFloat_MovementId.ValueData      > 0
                                   INNER JOIN MovementItem AS MI_OrderIncome ON MI_OrderIncome.Id = MIFloat_MovementId.ValueData :: Integer
                                                                            AND MI_OrderIncome.isErased = FALSE
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                                 ON MovementLinkObject_CurrencyDocument.MovementId = MI_OrderIncome.MovementId
                                                                AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                              WHERE MovementItem.MovementId = ioId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.Amount     > 0
                              ORDER BY MovementItem.Id DESC
                              LIMIT 1);
     
     IF COALESCE (inContractId,0) <> 0 AND COALESCE (vbCurrencyDocumentId,0) = 0
     THEN
         vbCurrencyDocumentId := (SELECT ObjectLink_Contract_Currency.ChildObjectId
                                  FROM ObjectLink AS ObjectLink_Contract_Currency
                                  WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
                                    AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
                                  );
     END IF;
     --определили 
     ioCurrencyDocumentId := COALESCE (vbCurrencyDocumentId,ioCurrencyDocumentId);
     outCurrencyDocumentName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioCurrencyDocumentId);
     
     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, ioCurrencyDocumentId);
          

     -- сохранили свойство <Номер накладной у поставщика>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчет курса для баланса
     IF (ioCurrencyDocumentId <> zc_Enum_Currency_Basis()) /*AND COALESCE (ioId, 0) = 0*/ AND COALESCE (ioCurrencyValue,0) = 0
     THEN 
         SELECT Amount, ParValue 
      INTO ioCurrencyValue, ioParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= ioCurrencyDocumentId, inPaidKindId:= CASE WHEN inPaidKindId <> 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);
   --  ELSE outCurrencyValue:= 0;
   --       outParValue:=0;
     END IF;
  
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, ioCurrencyValue);
     -- сохранили свойство <Номинал для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, ioParValue);


     -- Примечание
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     --
     IF inPaidKindId = zc_Enum_PaidKind_FirstForm()
     THEN
         -- сохранили свойство <Итого сумма оплаты по другой форме оплаты> нал
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayOth(), ioId, COALESCE (ioTotalSumm_f2,0));
     ELSE 
         -- сохранили свойство <Итого сумма оплаты по другой форме оплаты> б/н
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayOth(), ioId, COALESCE (ioTotalSumm_f1,0));
     END IF;     

     IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
         END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     SELECT -- оплата б/н
            CASE WHEN inPaidKindId = zc_Enum_PaidKind_FirstForm()
                 THEN CASE WHEN ioCurrencyDocumentId IN (0, zc_Enum_Currency_Basis())
                           THEN MovementFloat_TotalSumm.ValueData         - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                           ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                      END 
                 ELSE ioTotalSumm_f1
            END AS TotalSumm_f1

             -- оплата нал
          , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm()
                 THEN CASE WHEN ioCurrencyDocumentId IN (0, zc_Enum_Currency_Basis())
                           THEN MovementFloat_TotalSumm.ValueData         - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                           ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0) 
                      END 
                 ELSE ioTotalSumm_f2
            END AS TotalSumm_f2

            INTO ioTotalSumm_f1, ioTotalSumm_f2

     FROM MovementFloat AS MovementFloat_TotalSumm
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayOth
                                  ON MovementFloat_TotalSummPayOth.MovementId = MovementFloat_TotalSumm.MovementId
                                 AND MovementFloat_TotalSummPayOth.DescId = zc_MovementFloat_TotalSummPayOth()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCurrency
                                  ON MovementFloat_TotalSummCurrency.MovementId =  MovementFloat_TotalSumm.MovementId
                                 AND MovementFloat_TotalSummCurrency.DescId = zc_MovementFloat_AmountCurrency()
     WHERE MovementFloat_TotalSumm.MovementId = ioId
       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm();

     IF COALESCE (ioTotalSumm_f1,0) < 0 OR COALESCE (ioTotalSumm_f2,0) < 0
     THEN
          RAISE EXCEPTION 'Ошибка.Сумма (б/нал - нал) не может быть меньше 0.';
     END IF;
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.03.19         * 
 25.07.16         * inInvNumberPartner
 15.07.16         *
*/

-- тест
-- 