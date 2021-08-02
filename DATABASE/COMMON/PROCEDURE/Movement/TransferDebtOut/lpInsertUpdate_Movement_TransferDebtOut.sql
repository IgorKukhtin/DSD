-- Function: lpInsertUpdate_Movement_TransferDebtOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TransferDebtOut (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);



CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TransferDebtOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberOrder      TVarChar  , -- Номер заявки контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inChecked             Boolean   , -- Проверен
 INOUT ioPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
 INOUT ioVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindFromId      Integer   , -- Виды форм оплаты
    IN inPaidKindToId        Integer   , -- Виды форм оплаты
    IN inContractFromId      Integer   , -- Договора
    IN inContractToId        Integer   , -- Договора
    IN inPartnerId           Integer   , -- Контрагент (кому)
    IN inPartnerFromId       Integer   , -- Контрагент (от кого)
   OUT outPriceListName      TVarChar  , -- Прайс лист
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceListId Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF COALESCE (inContractFromId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор (от кого)>.';
     END IF;

     -- проверка
     IF COALESCE (inContractToId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор (кому)>.';
     END IF;

     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- Прайс-лист
     -- !!!замена!!!
     SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
            INTO vbPriceListId, outPriceListName, ioPriceWithVAT, ioVATPercent
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractToId
                                               , inPartnerId      := inToId
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := NULL
                                               , inOperDatePartner:= inOperDate
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE  -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= NULL
                                                ) AS tmp;
/*   IF COALESCE (ioPriceListId, 0) = 0
     THEN
         -- !!!замена!!!
         SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
                INTO ioPriceListId, outPriceListName, ioPriceWithVAT, ioVATPercent
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractToId
                                                   , inPartnerId      := inToId
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := NULL
                                                   , inOperDatePartner:= inOperDate
                                                   , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                   , inIsPrior        := FALSE  -- !!!параметр здесь не важен!!!
                                                   , inOperDatePartner_order:= NULL
                                                    ) AS tmp;
     ELSE
         SELECT Object_PriceList.ValueData                             AS PriceListName
              , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
              , ObjectFloat_VATPercent.ValueData                       AS VATPercent
                INTO outPriceListName, ioPriceWithVAT, ioVATPercent
         FROM Object AS Object_PriceList
              LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                      ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                     AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
              LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                    ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                   AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
         WHERE Object_PriceList.Id = ioPriceListId;
     END IF;
     */
     -- -----


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TransferDebtOut(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, ioPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, ioVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили свойство <Номер>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), ioId, inPaidKindFromId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), ioId, inContractFromId);
     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), ioId, inPaidKindToId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), ioId, inContractToId);
     -- сохранили связь с <Контрагент (кому)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     -- сохранили связь с <Контрагент (от кого)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerFrom(), ioId, inPartnerFromId);
     -- сохранили связь с <Прайс-лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, vbPriceListId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.08.21         *
 02.02.16         * add inPartnerFromId
 17.12.14         * add inInvNumberOrder
 03.09.14         * add inChecked
 20.06.14                                                       * add InvNumberPartner
 07.05.14                                        * add vbAccessKeyId
 07.05.14                                        * add inPartnerId
 03.05.14                                        * del inMasterId, ioPriceListId, outPriceListName
 24.04.14         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TransferDebtOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', ioPriceWithVAT:= true, ioVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
--