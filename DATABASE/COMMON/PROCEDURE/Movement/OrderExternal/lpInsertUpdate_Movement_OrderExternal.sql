-- Function: lpInsertUpdate_Movement_OrderExternal()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер заявки у контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата принятия заказа от контрагента
    IN inOperDateMark        TDateTime , -- Дата маркировки
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
 INOUT ioChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
    IN inPersonalId          Integer   , -- Сотрудник (экспедитор)
    IN inPriceListId         Integer   , -- Прайс лист
    IN inPartnerId           Integer   , -- Контрагент
    IN inIsPrintComment      Boolean   , -- печатать Примечание в Расходной накладной (да/нет)
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) OR inOperDateMark <> DATE_TRUNC ('DAY', inOperDateMark)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;


     -- замена, т.к. теперь история
     ioChangePercent:= COALESCE ((SELECT Object_PercentView.ChangePercent FROM Object_ContractCondition_PercentView AS Object_PercentView WHERE Object_PercentView.ContractId = inContractId AND inOperDate BETWEEN Object_PercentView.StartDate AND Object_PercentView.EndDate), 0);


     -- определяем ключ доступа
   --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
     vbAccessKeyId:= CASE WHEN inFromId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN inToId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN inToId = 346093 -- Склад ГП ф.Одесса
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN inToId = 8413 -- Склад ГП ф.Кривой Рог
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN inToId = 8417 -- Склад ГП ф.Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN inToId = 8425 -- Склад ГП ф.Харьков
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN inToId = 8415 -- Склад ГП ф.Черкассы (Кировоград)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN inToId = 301309 -- Склад ГП ф.Запорожье
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye() 
                          WHEN inToId = 3080691 -- Склад ГП ф.Львов
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 

                          WHEN inToId = 8020714 -- Склад База ГП (Ирна)
                               THEN zc_Enum_Process_AccessKey_DocumentIrna() 

                          ELSE lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal())
                     END;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Дата маркировки>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateMark(), ioId, inOperDateMark);
     -- сохранили свойство <Дата отгрузки контрагенту>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

     -- сохранили свойство <Номер заявки у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <печатать Примечание в Расходной накладной(да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PrintComment(), ioId, inIsPrintComment);

     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, ioChangePercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Маршруты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);
     -- сохранили связь с <Сортировки маршрутов>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);

     -- сохранили связь с <Сотрудник (экспедитор)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);

     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);    


     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания> - при загрузке с моб устр., здесь дата загрузки
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.21         * add inIsPrintComment
 26.05.15         * add inPartnerId
 19.02.15         * add OperDateStart, OperDateEnd
 25.08.14                                        *
*/
/*
-- update Movement set AccessKeyId = AccessKeyId_new from (
select Object_to.*, Movement.Id, Movement.OperDate, Movement.InvNumber, Movement.AccessKeyId AS AccessKeyId_old
                   , CASE WHEN MovementLinkObject .ObjectId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject.ObjectId IN (346093 -- Склад ГП ф.Одесса
                                                             , 346094 -- Склад возвратов ф.Одесса
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject.ObjectId IN (8413 -- Склад ГП ф.Кривой Рог
                                                             , 428366 -- Склад возвратов ф.Кривой Рог
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject .ObjectId= 8417 -- Склад ГП ф.Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject.ObjectId IN (8425   -- Склад ГП ф.Харьков
                                                             , 409007 -- Склад возвратов ф.Харьков
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject .ObjectId= 8415 -- Склад ГП ф.Черкассы (Кировоград)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN MovementLinkObject .ObjectId= 301309 -- Склад ГП ф.Запорожье
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye() 
                          WHEN MovementLinkObject .ObjectId = 3080691 -- Склад ГП ф.Львов
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END as AccessKeyId_new
from Movement 
 left join     MovementLinkObject as mlo on mlo.DescId = zc_MovementLinkObject_from() 
            and mlo.MovementId = Movement .Id
 left join     MovementLinkObject on MovementLinkObject.DescId = zc_MovementLinkObject_To() 
            and MovementLinkObject .MovementId = Movement .Id
 left join     Object as Object_from on Object_from.Id = MLO.ObjectId 
 left join     Object as Object_to on Object_to.Id = MovementLinkObject.ObjectId 
 left join     Object as Object_a on Object_a.Id = Movement.AccessKeyId
where Movement.OperDate >= '01.12.2020'
and Movement.DescId = zc_Movement_OrderExternal()
and Object_from.DescId <> zc_Object_Unit()
-- and Movement.StatusId <> zc_Enum_Status_Erased()
and Movement.AccessKeyId <> CASE WHEN MovementLinkObject .ObjectId = 8411 -- Склад ГП ф Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject.ObjectId IN (346093 -- Склад ГП ф.Одесса
                                                             , 346094 -- Склад возвратов ф.Одесса
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject.ObjectId IN (8413 -- Склад ГП ф.Кривой Рог
                                                             , 428366 -- Склад возвратов ф.Кривой Рог
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject .ObjectId= 8417 -- Склад ГП ф.Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject.ObjectId IN (8425   -- Склад ГП ф.Харьков
                                                             , 409007 -- Склад возвратов ф.Харьков
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject .ObjectId= 8415 -- Склад ГП ф.Черкассы (Кировоград)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN MovementLinkObject .ObjectId= 301309 -- Склад ГП ф.Запорожье
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye() 
                          WHEN MovementLinkObject .ObjectId = 3080691 -- Склад ГП ф.Львов
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END
limit 100 
--) as tmp 
--where Movement.Id = tmp.Id
*/
-- тест
-- SELECT * FROM lpInsertUpdate_Movement_OrderExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
