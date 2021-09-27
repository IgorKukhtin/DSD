-- Function: gpInsertUpdate_Movement_OrderExternalUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternalUnit (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternalUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер заявки у контрагента
    IN inOperDate            TDateTime , -- Дата документа (принятия заказа от контрагента)
    IN inOperDatePartner     TDateTime , -- Дата документа (планируется отгрузка со склада)
    IN inOperDateMark        TDateTime , -- Дата маркировки
    IN inOperDateStart       TDateTime , -- Дата прогноз (нач.)
    IN inOperDateEnd         TDateTime , -- Дата прогноз (конечн.)
   OUT outPriceWithVAT       Boolean   , -- Цена с НДС (да/нет)
   OUT outVATPercent         TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
   OUT outDayCount           TFloat    , -- Количество дней прогноз
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
    IN inPersonalId          Integer   , -- Сотрудник (экспедитор)
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar  , -- Прайс лист

    IN inRetailId            Integer   , -- Торговая сеть
    IN inPartnerId           Integer   , -- Контрагент
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternalUnit());

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     -- проверка
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_Unit())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;

     -- 0.
     outDayCount:= 1 + EXTRACT (DAY FROM (inOperDateEnd - inOperDateStart));
     -- 1. эти параметры всегда из Контрагента
     -- inOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat WHERE ObjectId = inFromId AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL;

     -- 2. эти параметры всегда из Прайс-листа !!!на дату inOperDatePartner!!!
     IF COALESCE (ioPriceListId, 0) = 0
     THEN
         SELECT PriceListId, PriceListName, PriceWithVAT, VATPercent
                INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= inOperDatePartner);
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


     -- Сохранение
     ioId:= (SELECT tmp.ioId
             FROM lpInsertUpdate_Movement_OrderExternal (ioId                  := ioId
                                                       , inInvNumber           := inInvNumber
                                                       , inInvNumberPartner    := inInvNumberPartner
                                                       , inOperDate            := inOperDate
                                                       , inOperDatePartner     := inOperDatePartner
                                                       , inOperDateMark        := inOperDateMark
                                                       , inPriceWithVAT        := outPriceWithVAT
                                                       , inVATPercent          := outVATPercent
                                                       , ioChangePercent       := inChangePercent
                                                       , inFromId              := inFromId
                                                       , inToId                := inToId
                                                       , inPaidKindId          := inPaidKindId
                                                       , inContractId          := inContractId
                                                       , inRouteId             := inRouteId
                                                       , inRouteSortingId      := inRouteSortingId
                                                       , inPersonalId          := inPersonalId
                                                       , inPriceListId         := ioPriceListId
                                                       , inPartnerId           := inPartnerId
                                                       , inisPrintComment      := FALSE ::Boolean
                                                       , inUserId              := vbUserId
                                                        ) AS tmp);

     -- сохранили свойство <Дата проноз с>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- сохранили свойство <Дата проноз по>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);

     -- сохранили связь с <Торговая сеть>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailId);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- дописали св-во <Протокол Дата/время начало>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartBegin(), ioId, vbOperDate_StartBegin);
     -- дописали св-во <Протокол Дата/время завершение>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, CLOCK_TIMESTAMP());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.21         * inisPrintComment
 21.05.15         * add inRetailId, inPartnerId
 11.02.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternalUnit (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
