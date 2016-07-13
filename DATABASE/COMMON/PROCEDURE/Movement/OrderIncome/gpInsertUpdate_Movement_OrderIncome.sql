-- Function: gpInsertUpdate_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderIncome(Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderIncome(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа (формирование заказа)
    IN inPartnerId           Integer   , -- Поставщик
    IN inContractId          Integer   , -- Договор 
    IN inPaidKindId          Integer   , -- Форма оплаты
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки 
   OUT outCurrencyValue      TFloat    , -- курс валюты

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

     -- сохранили свойство <Дата производства>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_InsertDate(), ioId, outInsertDate);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);


     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчитали и свойство <Курс для перевода в валюту баланса>
     outCurrencyValue := 1.00;
  /*   outCurrencyValue:= (SELECT MovementItem.Amount
                         FROM (SELECT MAX (Movement.OperDate) as maxOperDate
                               FROM Movement 
                                    JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.ObjectId = inCurrencyDocumentId
                                    JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                                               AND MILinkObject_CurrencyTo.ObjectId = inCurrencyPartnerId
                               WHERE Movement.DescId = zc_Movement_Currency()
                                 AND Movement.OperDate <= inOperDate
                                 AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())   
                              ) AS tmpDate
                                INNER JOIN Movement ON Movement.DescId = zc_Movement_Currency()
                                                   AND Movement.OperDate = tmpDate.maxOperDate
                                                   AND Movement.StatusId IN (zc_Enum_Status_Complete()/*, zc_Enum_Status_UnComplete()*/)
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                       AND MovementItem.DescId = zc_MI_Master()
                            );
     END IF;
*/    
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);



     -- Комментарий
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
 12.07.16         *
*/

-- тест
-- 