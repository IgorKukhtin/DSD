-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberOrder      TVarChar  , -- Номер заявки контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inChecked             Boolean   , -- Проверен
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar  , -- Прайс лист
   OUT outCurrencyValue      TFloat    , -- курс валюты
    IN inUserId              Integer     -- пользователь
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
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- рассчитали и сохранили свойство <Курс для перевода в валюту баланса>
     outCurrencyValue := 1.00;
     IF inCurrencyDocumentId <> inCurrencyPartnerId
     THEN
        SELECT MovementItem.Amount
       INTO outCurrencyValue  
        FROM (
              SELECT max(Movement.OperDate) as maxOperDate
              FROM Movement 
                  JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.ObjectId = inCurrencyDocumentId
                  JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                              ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                             AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                             AND MILinkObject_CurrencyTo.ObjectId = inCurrencyPartnerId
              WHERE Movement.DescId = zc_Movement_Currency()
                AND Movement.OperDate <= inOperDate
                AND Movement.StatusId = zc_Enum_Status_Complete()    
              ) as tmpDate
         JOIN Movement ON Movement.DescId = zc_Movement_Currency()
                      AND Movement.OperDate = tmpDate.maxOperDate
                      AND Movement.StatusId = zc_Enum_Status_Complete()    
         JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                          AND MovementItem.DescId = zc_MI_Master();
     END IF;
     
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);   


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

     -- определяем инфу для Прайса
     IF COALESCE (ioPriceListId, 0) = 0
     THEN
         -- поиск прайса в следующем порядке: 1) акционный у контрагента 2) обычный у контрагента 3) акционный у юр.лица 4) обычный у юр.лица 5) zc_PriceList_Basis
         SELECT Object_PriceList.valuedata,  COALESCE (COALESCE (COALESCE (COALESCE (ObjectLink_Partner_PriceListPromo.ChildObjectId, ObjectLink_Partner_PriceList.ChildObjectId),ObjectLink_Juridical_PriceListPromo.ChildObjectId),ObjectLink_Juridical_PriceList.ChildObjectId),zc_PriceList_Basis())
                INTO outPriceListName, ioPriceListId
         FROM (SELECT inToId AS Id) AS Object_To
              LEFT JOIN ObjectDate AS ObjectDate_PartnerStartPromo
                                   ON ObjectDate_PartnerStartPromo.ObjectId = Object_To.Id
                                  AND ObjectDate_PartnerStartPromo.DescId = zc_ObjectDate_Partner_StartPromo()
              LEFT JOIN ObjectDate AS ObjectDate_PartnerEndPromo
                                   ON ObjectDate_PartnerEndPromo.ObjectId = Object_To.Id
                                  AND ObjectDate_PartnerEndPromo.DescId = zc_ObjectDate_Partner_EndPromo()
              LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                                   ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_To.Id
                                  AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
                                  AND inOperDate BETWEEN ObjectDate_PartnerStartPromo.valuedata AND ObjectDate_PartnerEndPromo.valuedata
              LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                   ON ObjectLink_Partner_PriceList.ObjectId = Object_To.Id
                                  AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                  AND ObjectLink_Partner_PriceListPromo.ObjectId IS NULL
              -- PriceList Juridical
              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
              LEFT JOIN ObjectDate AS ObjectDate_JuridicalStartPromo
                                   ON ObjectDate_JuridicalStartPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND ObjectDate_JuridicalStartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()
              LEFT JOIN ObjectDate AS ObjectDate_JuridicalEndPromo
                                   ON ObjectDate_JuridicalEndPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND ObjectDate_JuridicalEndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()

              LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                                   ON ObjectLink_Juridical_PriceListPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
                                  AND (ObjectLink_Partner_PriceListPromo.ChildObjectId IS NULL OR ObjectLink_Partner_PriceList.ChildObjectId IS NULL)-- можно и не проверять
                                  AND inOperDate BETWEEN ObjectDate_JuridicalStartPromo.valuedata AND ObjectDate_JuridicalEndPromo.valuedata

              LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                   ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                  AND ObjectLink_Juridical_PriceListPromo.ObjectId IS NULL
              LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (COALESCE (COALESCE (COALESCE (ObjectLink_Partner_PriceListPromo.ChildObjectId, ObjectLink_Partner_PriceList.ChildObjectId),ObjectLink_Juridical_PriceListPromo.ChildObjectId),ObjectLink_Juridical_PriceList.ChildObjectId),zc_PriceList_Basis())
         ;
     ELSE
         -- иначе прайс из документа, надо вернуть только его название
         SELECT Object.valuedata INTO outPriceListName FROM Object WHERE Object.Id = ioPriceListId;
     END IF;

     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);

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
