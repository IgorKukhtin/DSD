-- Function: gpInsertUpdate_Movement_OrderExternal_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal_Sybase (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternal_Sybase(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер заявки у контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата принятия заказа от контрагента
    IN inOperDateMark        TDateTime , -- Дата маркировки
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
    IN inPersonalId          Integer   , -- Сотрудник (экспедитор)
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar  , -- Прайс лист
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) OR inOperDateMark <> DATE_TRUNC ('DAY', inOperDateMark)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;
     -- проверка
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;

     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

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
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

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

     -- определяем инфу для Прайса
     IF COALESCE (ioPriceListId, 0) = 0
     THEN
         -- поиск прайса в следующем порядке: 0.1) акционный у договора 0.2) обычный у договора 1) акционный у контрагента 2) обычный у контрагента 3) акционный у юр.лица 4) обычный у юр.лица 5) zc_PriceList_Basis
         SELECT tmp.PriceListName, tmp.PriceListId
                INTO outPriceListName, ioPriceListId
         FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= inOperDate) AS tmp;
     ELSE
         -- иначе прайс из документа, надо вернуть только его название
         SELECT Object.valuedata INTO outPriceListName FROM Object WHERE Object.Id = ioPriceListId;
     END IF;

     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, ioPriceListId);

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
 26.08.14                                                        *
 25.08.14                                        * all
 18.08.14                                                        *
 06.06.14                                                        *
 01.08.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal_Sybase (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
