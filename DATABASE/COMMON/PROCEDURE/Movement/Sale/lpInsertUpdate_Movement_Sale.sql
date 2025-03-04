-- Function: lpInsertUpdate_Movement_Sale()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

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
 INOUT ioChangePercent         TFloat     , -- (-)% Скидки (+)% Наценки
    IN inFromId                Integer    , -- От кого (в документе)
    IN inToId                  Integer    , -- Кому (в документе)
    IN inPaidKindId            Integer    , -- Виды форм оплаты
    IN inContractId            Integer    , -- Договора
    IN inRouteSortingId        Integer    , -- Сортировки маршрутов
    IN inCurrencyDocumentId    Integer    , -- Валюта (документа)
    IN inCurrencyPartnerId     Integer    , -- Валюта (контрагента)
    IN inMovementId_Order      Integer    , -- ключ Документа
    IN inMovementId_ReturnIn   Integer    , -- ключ Документа Возврат
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
   DECLARE vbIsInsert    Boolean;
   DECLARE vbBranchId    Integer;
   DECLARE vbIsContract_NotVAT Boolean;
   DECLARE vbCurrencyUser      Boolean;
BEGIN

     -- Проверка/замена Валюта - Договор
     IF COALESCE (inCurrencyDocumentId, 0) IN (0, zc_Enum_Currency_Basis())
        AND zc_Enum_Currency_Basis() <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Currency())
     THEN
         inCurrencyPartnerId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Currency());
     END IF;
     -- Проверка/замена Валюта - Прайс
     IF COALESCE (inCurrencyDocumentId, 0) IN (0, zc_Enum_Currency_Basis())
        AND zc_Enum_Currency_Basis() <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioPriceListId AND OL.DescId = zc_ObjectLink_PriceList_Currency())
     THEN
         inCurrencyDocumentId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioPriceListId AND OL.DescId = zc_ObjectLink_PriceList_Currency());
     END IF;

     -- замена, т.к. теперь история
     ioChangePercent:= COALESCE ((SELECT Object_PercentView.ChangePercent FROM Object_ContractCondition_PercentView AS Object_PercentView WHERE Object_PercentView.ContractId = inContractId AND inOperDatePartner BETWEEN Object_PercentView.StartDate AND Object_PercentView.EndDate), 0);

     -- нашли
     vbIsContract_NotVAT:= COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inContractId AND OB.DescId = zc_ObjectBoolean_Contract_NotVAT()), FALSE);

     -- нашли Филиал
     vbBranchId:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);

     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) 
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;
     -- проверка
     IF (COALESCE (ioId, 0) = 0 AND COALESCE (inOperDatePartner, zc_DateStart()) < (inOperDate - INTERVAL '1 DAY'))
        OR inOperDatePartner IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка.Неверно значение дата у покупателя <%>.', inOperDatePartner;
     END IF;
     -- проверка
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;
     -- проверка
     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyDocumentId <> inCurrencyPartnerId
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Неверное значение <Валюта (цена)> или <Валюта (покупатель)>';
     END IF;

     -- проверка
     IF vbBranchId > 0 AND inFromId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inFromId AND OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId = vbBranchId)
         AND inUserId <> 409393 -- Божок С.Н.
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав выбрать подразделение <%>.%Можно выбрать %>'
                 , lfGet_Object_ValueData_sh (inFromId)
                 , CHR (13)
                 , (SELECT STRING_AGG (tmp.Value, ' или ') FROM (SELECT '<' || lfGet_Object_ValueData_sh (OL.ObjectId) || '>' AS Value FROM ObjectLink AS OL WHERE OL.ChildObjectId = vbBranchId AND OL.DescId = zc_ObjectLink_Unit_Branch() ORDER BY OL.ObjectId) AS tmp)
                 ;
     END IF;


     -- !!!Меняем параметры!!!
     IF COALESCE (inCurrencyDocumentId, 0) = 0 THEN inCurrencyDocumentId:= zc_Enum_Currency_Basis(); END IF;
     -- !!!Меняем параметры!!!
     IF COALESCE (inCurrencyPartnerId, 0) = 0 THEN inCurrencyPartnerId:= zc_Enum_Currency_Basis(); END IF;
     -- !!!Меняем параметры!!!
     IF inCurrencyDocumentId = inCurrencyPartnerId
     THEN ioCurrencyPartnerValue := 0;
          ioParPartnerValue:= 0;
     END IF;

     --ручной ввод курса
     vbCurrencyUser := COALESCE( (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = ioId AND MB.DescId = zc_MovementBoolean_CurrencyUser()), FALSE);


     -- Прайс-лист
     IF ((COALESCE (ioPriceListId, 0) = 0 -- OR COALESCE (ioId, 0) = 0
          OR 1=1 -- !!!всегда расчет!!!
         )
       --AND inUserId <> zfCalc_UserMain()
       --AND inUserId <> 9464 -- Рудик Н.В.
       --AND inUserId <> zfCalc_UserAdmin() :: Integer
        )
        OR COALESCE (ioPriceListId, 0) = 0
     THEN
         -- !!!замена!!!
         SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, CASE WHEN vbIsContract_NotVAT = TRUE THEN 0 ELSE tmp.VATPercent END
                INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                   , inPartnerId      := inToId
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := CASE WHEN inMovementId_Order <> 0 THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Order) ELSE NULL END 
                                                   , inOperDatePartner:= inOperDatePartner -- CASE WHEN inMovementId_Order <> 0 THEN NULL ELSE inOperDate END
                                                   , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                   , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                                   , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId_Order AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                    ) AS tmp;
         -- !!!замена!!!
         -- !!!расчет!!! эти параметры всегда из Прайс-листа !!!на дату inOperDatePartner!!!
         -- SELECT PriceListId, PriceListName, PriceWithVAT, VATPercent
         --        INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         -- FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inToId, inOperDate:= inOperDatePartner);
--IF inUserId = 5
--THEN
--    RAISE EXCEPTION 'Ошибка.<%>', lfGet_Object_ValueData_sh(ioPriceListId);
--END IF;

     ELSE
         SELECT Object_PriceList.ValueData                             AS PriceListName
              , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
              , CASE WHEN vbIsContract_NotVAT = TRUE THEN 0 ELSE ObjectFloat_VATPercent.ValueData END AS VATPercent
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


     -- определяем ключ доступа !!!то что захардкоженно - временно!!!
     vbAccessKeyId:= zfGet_AccessKey_onUnit (inFromId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner(), inUserId);

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Movement.Id = ioId AND Movement.AccessKeyId <> vbAccessKeyId;


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
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, ioChangePercent);

     IF COALESCE (vbCurrencyUser, FALSE) = FALSE
     THEN
         -- рассчет курса для баланса
         IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
         THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
              FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId, inPaidKindId:= inPaidKindId);
         ELSE IF inCurrencyPartnerId <> zc_Enum_Currency_Basis()
              THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
                   FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);
              ELSE outCurrencyValue:= 0;
                   outParValue:=0;
              END IF;
         END IF;
     ELSE
         --возвращаем сохраненные значение
         outCurrencyValue     := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_CurrencyValue()), 1);
         outParValue          := COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_ParValue()), 1);
         inCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
         inCurrencyPartnerId  := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());             
     END IF;

     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- сохранили свойство <Номинал для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, outParValue);

     -- рассчет курса для перевода из вал. док. в валюту контрагента
     /*IF inCurrencyDocumentId <> inCurrencyPartnerId
     THEN SELECT Amount, ParValue INTO ioCurrencyPartnerValue, ioParPartnerValue
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= inCurrencyDocumentId, inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);
     END IF;
     */
     -- сохранили свойство <Курс для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, ioCurrencyPartnerValue);
     -- сохранили свойство <Номинал для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, ioParPartnerValue);


     -- сохранили свойство <Номер заявки контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты>
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
     -- сохранили связь с документом <Возврат>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReturnIn(), ioId, inMovementId_ReturnIn);
     
     -- !!!пересчитали!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id
                                             , CASE WHEN MIFloat_PromoMovement.ValueData > 0
                                                         THEN CASE WHEN zc_Enum_ConditionPromo_ContractChangePercentOff() = (SELECT MI_Child.ObjectId FROM MovementItem AS MI_Child WHERE MI_Child.MovementId = MIFloat_PromoMovement.ValueData AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() AND MI_Child.isErased = FALSE LIMIT 1)
                                                                        THEN 0  -- без учета % скидки по договору
                                                                   ELSE ioChangePercent
                                                              END
                                                    ELSE ioChangePercent
                                               END)
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                     AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
     WHERE MovementItem.MovementId = ioId
       AND MovementItem.DescId = zc_MI_Master();

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
 29.06.16         * 
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
-- SELECT * FROM lpInsertUpdate_Movement_Sale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, ioChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
