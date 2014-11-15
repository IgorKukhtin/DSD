-- Function: lpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inInvNumberPartner      TVarChar   , -- Номер накладной у контрагента
    IN inInvNumberOrder        TVarChar   , -- Номер заявки контрагента
    IN inOperDate              TDateTime  , -- Дата документа
    IN inOperDatePartner       TDateTime  , -- Дата накладной у контрагента
    IN inChecked               Boolean    , -- Проверен
   OUT outPriceWithVAT         Boolean    , -- Цена с НДС (да/нет)
   OUT outVATPercent           TFloat     , -- % НДС
    IN inChangePercent         TFloat     , -- (-)% Скидки (+)% Наценки
    IN inFromId                Integer    , -- От кого (в документе)
    IN inToId                  Integer    , -- Кому (в документе)
    IN inPaidKindId            Integer    , -- Виды форм оплаты
    IN inContractId            Integer    , -- Договора
    IN inRouteSortingId        Integer    , -- Сортировки маршрутов
    IN inCurrencyDocumentId    Integer    , -- Валюта (документа)
    IN inCurrencyPartnerId     Integer    , -- Валюта (контрагента)
    IN inMovementId_Order      Integer    , -- ключ Документа
 INOUT ioPriceListId           Integer    , -- Прайс лист
   OUT outPriceListName        TVarChar   , -- Прайс лист
   OUT outCurrencyValue        TFloat     , -- курс валюты
   OUT outParValue             TFloat     , -- Номинал для перевода в валюту баланса
 INOUT ioCurrencyPartnerValue  TFloat     , -- Курс для расчета суммы операции
 INOUT ioParPartnerValue       TFloat     , -- Номинал для расчета суммы операции
    IN inUserId                Integer      -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) 
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;
     -- проверка
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;

     -- !!!Меняем параметры!!!
     IF COALESCE (inCurrencyDocumentId, 0) = 0 THEN inCurrencyDocumentId:= zc_Enum_Currency_Basis(); END IF;
     -- !!!Меняем параметры!!!
     IF COALESCE (inCurrencyPartnerId, 0) = 0 THEN inCurrencyPartnerId:= zc_Enum_Currency_Basis(); END IF;


     -- Прайс-лист
     IF COALESCE (ioPriceListId, 0) = 0
     THEN
         -- !!!расчет!!! эти параметры всегда из Прайс-листа !!!на дату inOperDatePartner!!!
         SELECT PriceListId, PriceListName, PriceWithVAT, VATPercent
                INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         FROM lfGet_Object_Partner_PriceList (inPartnerId:= inToId, inOperDate:= inOperDatePartner);
     ELSE
         SELECT Object_PriceList.ValueData                             AS PriceListName
              , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
              , ObjectFloat_VATPercent.ValueData                       AS VATPercent
                INTO outPriceListName, outPriceWithVAT, outVATPercent
         FROM Object AS Object_PriceList
              LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                      ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                     AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
              LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                    ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                   AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
         WHERE Object_PriceList.Id = ioPriceListId;
     END IF;


     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Дата накладной у контрагента>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);


     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, outPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, outVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчет курса для баланса
     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyId,  inPaidKindId:= inPaidKindId);
     END IF;
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, outParValue);

     -- рассчет курса для перевода из вал. док. в валюту контрагента
     IF inCurrencyDocumentId <> inCurrencyPartnerId
     THEN SELECT Amount, ParValue INTO ioCurrencyPartnerValue, ioParPartnerValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= inCurrencyDocumentId, inCurrencyToId:= inCurrencyPartnerId,  inPaidKindId:= inPaidKindId);
     END IF;
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, ioCurrencyPartnerValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, ioParPartnerValue);


     -- сохранили свойство <Номер заявки контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Сортировки маршрутов>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);
     -- сохранили связь с <Валюта (контрагента) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);

     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.10.14                                        * add inMovementId_Order
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 16.04.14                                        * add lpInsert_MovementProtocol
 07.04.14                                        * add проверка
 10.02.14                                        * в lp-должно быть все
 04.02.14                         * 
*/
/*
-- 1.
update Movement set StatusId = zc_Enum_Status_Erased() where DescId = zc_Movement_Sale() and StatusId <> zc_Enum_Status_Erased();
-- 2.
update dba.Bill set Id_Postgres = null where BillKind = zc_bkSaleToClient() and Id_Postgres is not null;
update dba.fBill set Id_Postgres = null where BillKind = zc_bkSaleToClient() and Id_Postgres is not null;
update dba.fBillItems set Id_Postgres = null where BillKind = zc_bkSaleToClient() and Id_Postgres is not null;
update dba.BillItems join dba.Bill on Bill.Id = BillItems.BillId and isnull(Bill.Id_Postgres,0)=0 set BillItems.Id_Postgres = null where BillItems.Id_Postgres is not null;
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Sale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
