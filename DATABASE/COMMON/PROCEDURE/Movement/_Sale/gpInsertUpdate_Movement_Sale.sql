-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpinsertupdate_movement_sale (integer,tvarchar,tdatetime,tdatetime,tvarchar,boolean,boolean,tfloat,tfloat,tvarchar,integer,integer,integer,integer,integer,integer,tvarchar);
DROP FUNCTION IF EXISTS gpinsertupdate_movement_sale (integer,tvarchar,tdatetime,tdatetime,tvarchar,boolean,boolean,tfloat,tfloat,tvarchar,integer,integer,integer,integer,integer,tvarchar,tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inChecked             Boolean   , -- Проверен
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inInvNumberOrder      TVarChar  , -- Номер заявки контрагента
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar   , -- Прайс лист
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId:= inSession;

     -- проверка - проведенный/удаленный документ не может корректироваться
     IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Movement WHERE Id = ioId AND StatusId = zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не может корректироваться т.к. он <%>.', lfGet_Object_ValueData ((SELECT StatusId FROM Movement WHERE Id = ioId));
     END IF;

     -- проверка
     IF COALESCE (inContractId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен договор.';
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, NULL);

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

     IF COALESCE (ioPriceListId, 0) = 0
     THEN
     --Выбираем прайс
         SELECT Object_PriceList.valuedata,  coalesce(coalesce(coalesce(coalesce(ObjectLink_Partner_PriceListPromo.childobjectid, ObjectLink_Partner_PriceList.ChildObjectId),ObjectLink_Juridical_PriceListPromo.childobjectid),ObjectLink_Juridical_PriceList.childobjectid),zc_PriceList_Basis())
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
                             AND ObjectLink_Partner_PriceListPromo.objectid IS NULL
-- PriceList Juridical
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

         LEFT JOIN ObjectDate AS ObjectDate_JuridicalStartPromo
                              ON ObjectDate_JuridicalStartPromo.ObjectId = ObjectLink_Partner_Juridical.childobjectid
                             AND ObjectDate_JuridicalStartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()

         LEFT JOIN ObjectDate AS ObjectDate_JuridicalEndPromo
                              ON ObjectDate_JuridicalEndPromo.ObjectId = ObjectLink_Partner_Juridical.childobjectid
                             AND ObjectDate_JuridicalEndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()


         LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                              ON ObjectLink_Juridical_PriceListPromo.ObjectId = ObjectLink_Partner_Juridical.childobjectid
                             AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
                             AND (ObjectLink_Partner_PriceListPromo.childobjectid IS NULL OR ObjectLink_Partner_PriceList.ChildObjectId IS NULL)-- можно и не проверять
                             AND inOperDate BETWEEN ObjectDate_JuridicalStartPromo.valuedata AND ObjectDate_JuridicalEndPromo.valuedata

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                              ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.childobjectid
                             AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                             AND ObjectLink_Juridical_PriceListPromo.objectid IS NULL
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = coalesce(coalesce(coalesce(coalesce(ObjectLink_Partner_PriceListPromo.childobjectid, ObjectLink_Partner_PriceList.ChildObjectId),ObjectLink_Juridical_PriceListPromo.childobjectid),ObjectLink_Juridical_PriceList.childobjectid),zc_PriceList_Basis())

     ;

     ELSE
       SELECT Object.valuedata
       INTO outPriceListName
       FROM Object WHERE Object.Id = ioPriceListId;
     END IF;


     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);






     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 31.01.14                                                       * add inPriceListId
 30.01.14                                                       * add inInvNumberPartner
 13.01.14                                        * del property from redmain
 11.01.14                                        * add inChecked, inInvNumberOrder
 13.08.13                                        * add RAISE EXCEPTION
 13.07.13         *
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
-- SELECT * FROM gpInsertUpdate_Movement_Sale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')