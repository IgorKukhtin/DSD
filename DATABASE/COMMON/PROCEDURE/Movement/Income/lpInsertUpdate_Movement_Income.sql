-- Function: lpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
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
    IN inPersonalPackerId    Integer   , -- Сотрудник (заготовитель)
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
 INOUT ioCurrencyValue      TFloat    , -- курс валюты
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyValue TFloat;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) 
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF 1 = 0 AND COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;

     -- проверка - связанные документы Изменять нельзя
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= 'изменение');


     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Income());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Дата накладной у контрагента>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчитали и свойство <Курс для перевода в валюту баланса>
     --outCurrencyValue := 1.00;
     IF inCurrencyDocumentId <> inCurrencyPartnerId
     THEN
         vbCurrencyValue:= (SELECT MovementItem.Amount
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
     
     -- если не определен курс в джокументе то берем рассчет
     IF COALESCE (ioCurrencyValue, 0) = 0
     THEN 
         ioCurrencyValue := vbCurrencyValue;
     END IF;
     
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, ioCurrencyValue);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Сотрудник (заготовитель)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalPacker(), ioId, inPersonalPackerId);

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.18         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
