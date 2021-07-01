-- Function: gpInsertUpdate_Movement_OrderExternal()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternal(
 INOUT ioId                      Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber               TVarChar  , -- Номер документа
    IN inInvNumberPartner        TVarChar  , -- Номер заявки у контрагента
    IN inOperDate                TDateTime , -- Дата документа
   OUT outOperDatePartner        TDateTime , -- Дата отгрузки со склада
   OUT outOperDatePartner_sale   TDateTime , -- Дата расходного документа у контрагента
    IN inOperDateMark            TDateTime , -- Дата маркировки
   OUT outPriceWithVAT           Boolean   , -- Цена с НДС (да/нет)
   OUT outVATPercent             TFloat    , -- % НДС
 INOUT ioChangePercent           TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId                  Integer   , -- От кого (в документе)
    IN inToId                    Integer   , -- Кому (в документе)
    IN inPaidKindId              Integer   , -- Виды форм оплаты
    IN inContractId              Integer   , -- Договора
    IN inRouteId                 Integer   , -- Маршрут
    IN inRouteSortingId          Integer   , -- Сортировки маршрутов
 INOUT ioPersonalId              Integer   , -- Сотрудник (экспедитор)
   OUT outPersonalName           TVarChar  , -- Сотрудник (экспедитор)
 INOUT ioPriceListId             Integer   , -- Прайс лист
   OUT outPriceListName          TVarChar  , -- Прайс лист
    IN inPartnerId               Integer   , -- Контрагент
    IN inisPrintComment          Boolean   , -- печатать Примечание в Расходной накладной (да/нет)
    IN inComment                 TVarChar  , -- Примечание
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisAuto Boolean;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     -- проверка
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_ArticleLoss())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;


     -- !!!захардкодил временно!!!
     IF EXISTS (SELECT View_Contract_InvNumber.ContractId FROM Object_Contract_InvNumber_View AS View_Contract_InvNumber WHERE View_Contract_InvNumber.ContractId = inContractId AND View_Contract_InvNumber.InfoMoneyId = zc_Enum_InfoMoney_30201()) -- Доходы + Мясное сырье + Мясное сырье
     THEN inToId:= 133049; -- Склад реализации мясо
     END IF;

     vbisAuto := COALESCE ( (SELECT MovementBoolean.ValueData FROM MovementBoolean WHERE MovementBoolean.DescId = zc_MovementBoolean_isAuto() AND MovementBoolean.MovementId = ioId), TRUE) :: Boolean ;
     -- 1. эти параметры всегда из Контрагента
     IF vbisAuto = TRUE
     THEN
         -- для этого режима -  расчитаваем значение
         outOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat WHERE ObjectId = inFromId AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL;
     ELSE
         -- для этого режима - берем св-во
         outOperDatePartner:= (SELECT MovementDate.ValueData
                               FROM MovementDate
                               WHERE MovementDate.MovementId = ioId
                                 AND MovementDate.DescId = zc_MovementDate_OperDatePartner());
     END IF;
     -- расчет от zc_MovementDate_OperDatePartner
     outOperDatePartner_sale:= outOperDatePartner + (COALESCE ((SELECT ValueData FROM ObjectFloat WHERE ObjectId = inFromId AND DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL;

     -- 2. эти параметры всегда из Прайс-листа
     IF COALESCE (ioPriceListId, 0) = 0
        OR 1=1 -- !!!всегда расчет!!!
     THEN
         -- !!!замена!!!
         SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
                INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                   , inPartnerId      := inFromId
                                                   , inMovementDescId := zc_Movement_Sale() -- !!!не ошибка!!!
                                                   , inOperDate_order := inOperDate
                                                   , inOperDatePartner:= NULL
                                                   , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                   , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                                   , inOperDatePartner_order:= outOperDatePartner
                                                    ) AS tmp;
         -- !!!замена!!!
         -- !!!на дату outOperDatePartner!!!
         -- SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
         --        INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         -- FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= outOperDatePartner) AS tmp;
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


     -- определение Экспедитора по дню недели или тот же самый
     ioPersonalId:= COALESCE ((SELECT ObjectLink_Partner_MemberTake.ChildObjectId
                               FROM ObjectLink AS ObjectLink_Partner_MemberTake
                               WHERE ObjectLink_Partner_MemberTake.ObjectId = inFromId
                                 AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM outOperDatePartner
                                                                                                 + (((--COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inFromId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()),  0)
                                                                                                     COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inFromId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0)
                                                                                                     ) :: TVarChar || ' DAY') :: INTERVAL)
                                                                                          )
                                                       WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                       WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                       WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                       WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                       WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                       WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                       WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                    END
                              ), ioPersonalId);
     -- название всегда по ioPersonalId
     outPersonalName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioPersonalId);


     -- Сохранение
     SELECT tmp.ioId, tmp.ioChangePercent
            INTO ioId, ioChangePercent
     FROM lpInsertUpdate_Movement_OrderExternal (ioId                  := ioId
                                               , inInvNumber           := inInvNumber
                                               , inInvNumberPartner    := inInvNumberPartner
                                               , inOperDate            := inOperDate
                                               , inOperDatePartner     := outOperDatePartner
                                               , inOperDateMark        := inOperDateMark
                                               , inPriceWithVAT        := outPriceWithVAT
                                               , inVATPercent          := outVATPercent
                                               , ioChangePercent       := ioChangePercent
                                               , inFromId              := inFromId
                                               , inToId                := inToId
                                               , inPaidKindId          := inPaidKindId
                                               , inContractId          := inContractId
                                               , inRouteId             := inRouteId
                                               , inRouteSortingId      := inRouteSortingId
                                               , inPersonalId          := ioPersonalId
                                               , inPriceListId         := ioPriceListId
                                               , inPartnerId           := inPartnerId
                                               , inisPrintComment      := inisPrintComment
                                               , inUserId              := vbUserId
                                                ) AS tmp;

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
 20.06.18         *
 13.09.15         * add ioPersonalId, ioPersonalName
 26.05.15         * add inPartnerId
 18.08.14                                        * add lpInsertUpdate_Movement_OrderExternal
 26.08.14                                                        *
 25.08.14                                        * all
 18.08.14                                                        *
 06.06.14                                                        *
 01.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
