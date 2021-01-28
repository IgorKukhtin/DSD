-- Function: lpInsertUpdate_Movement_Income20202()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income20202 (Integer, TVarChar, TDateTime,TDateTime, TVarChar, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income20202(
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
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyValue TFloat;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId Integer;
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
     
     -- сохраненная валюта документа
     vbCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
     -- сохраненная Валюта (контрагента)
     vbCurrencyPartnerId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());    

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

     -- сохранили свойство <СпецОдежда (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_is20202(), ioId, inis20202);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчитали и свойство <Курс для перевода в валюту баланса>   -- ну как-то так
     --outCurrencyValue := 1.00;
     IF (inCurrencyDocumentId <> inCurrencyPartnerId) OR (inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyPartnerId <> zc_Enum_Currency_Basis())
     THEN
         IF (inCurrencyDocumentId <> inCurrencyPartnerId)
         THEN
             -- если изменилась валюта документа или если значение курса = 0
             IF (vbCurrencyDocumentId <> inCurrencyDocumentId OR vbCurrencyPartnerId <> inCurrencyPartnerId OR COALESCE (ioCurrencyValue, 0) = 0) 
             OR (inCurrencyDocumentId <> inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
             THEN
                 IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
                 THEN
                     SELECT tmp.Amount, tmp.ParValue
                     INTO ioCurrencyValue, ioParValue
                     FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                           , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                           , inCurrencyToId   := inCurrencyDocumentId
                                                           , inPaidKindId     := inPaidKindId)            AS tmp;
                 ELSE 
                     SELECT tmp.Amount, tmp.ParValue
                     INTO ioCurrencyValue, ioParValue
                     FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                           , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                           , inCurrencyToId   := inCurrencyPartnerId
                                                           , inPaidKindId     := inPaidKindId)            AS tmp;
                 END IF;    
             END IF;
         ELSE IF (inCurrencyDocumentId = inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
              THEN
                  SELECT tmp.Amount, tmp.ParValue
                  INTO ioCurrencyValue, ioParValue
                  FROM lfSelect_Movement_Currency_byDate (inOperDate       := inOperDatePartner
                                                        , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                        , inCurrencyToId   := inCurrencyDocumentId
                                                        , inPaidKindId     := inPaidKindId)            AS tmp;
              END IF;
         END IF;
     ELSE ioCurrencyValue := 1.00; ioParValue := 1.00;
     END IF; 
     
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, ioCurrencyValue);
     -- сохранили свойство <Номинал для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, ioParValue);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);
     -- сохранили связь с <Валюта (контрагента) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
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
 27.01.21         * 20202
 22.11.18         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Income20202 (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
