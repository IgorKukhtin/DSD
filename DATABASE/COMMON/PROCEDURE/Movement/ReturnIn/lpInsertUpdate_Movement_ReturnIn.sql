-- Function: lpInsertUpdate_Movement_ReturnIn()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TVarChar, TVarChar, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberMark       TVarChar  , -- Номер "перекресленої зеленої марки зi складу"
    IN inParentId            Integer   , -- 
    IN inOperDate            TDateTime , -- Дата(склад)
    IN inOperDatePartner     TDateTime , -- Дата документа у покупателя
    IN inChecked             Boolean   , -- Проверен
    IN inIsPartner           Boolean   , -- основание - Акт недовоза
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inisList              Boolean   , -- Только для списка
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора

    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
    IN inCurrencyValue       TFloat    , -- курс валюты 

    IN inParValue             TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat     , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat     , -- Номинал для расчета суммы операции
    IN inMovementId_OrderReturnTare Integer , --
    In inComment             TVarChar  , -- примечание
    IN inUserId              Integer     -- Пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_TaxCorrective Integer;
   DECLARE vbBranchId Integer;
BEGIN
     -- нашли Филиал
     vbBranchId:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);

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

     -- проверка
     IF vbBranchId > 0 AND inToId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inToId AND OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId = vbBranchId)
     AND vbBranchId <> 8377   -- филиал Кр.Рог
     AND vbBranchId <> 301310 -- филиал Запорожье
     THEN
         RAISE EXCEPTION 'Ошибка.Для <%> нет прав выбрать подразделение <%>.%Можно выбрать %>'
                 , lfGet_Object_ValueData_sh (inUserId)
                 , lfGet_Object_ValueData_sh (inToId)
                 , CHR (13)
                 , (SELECT STRING_AGG (tmp.Value, ' или ') FROM (SELECT '<' || lfGet_Object_ValueData_sh (OL.ObjectId) || '>' AS Value FROM ObjectLink AS OL WHERE OL.ChildObjectId = vbBranchId AND OL.DescId = zc_ObjectLink_Unit_Branch() ORDER BY OL.ObjectId) AS tmp)
                  ;
     END IF;


     -- меняется дата у всех корректировок
     IF ioId <> 0 AND NOT EXISTS (SELECT MovementId FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner() AND ValueData = inOperDatePartner)
     THEN
         -- поиск любой проведенной корректировки
         vbMovementId_TaxCorrective:= (SELECT MAX (MovementLinkMovement.MovementId) FROM MovementLinkMovement INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MovementLinkMovement.MovementChildId = ioId AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master());
         -- проверка - все корректировки должны быть хотя бы распроведены
         IF vbMovementId_TaxCorrective <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Изменение даты невозможно, документ <Корректировка к налоговой> № <%> от <%> в статусе <%>.', (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective), lfGet_Object_ValueData (zc_Enum_Status_Complete());
         END IF;
         -- меняется дата
         UPDATE Movement SET OperDate = inOperDatePartner
         FROM MovementLinkMovement
         WHERE Movement.Id = MovementLinkMovement.MovementId
           AND MovementLinkMovement.MovementChildId = ioId
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (MovementLinkMovement.MovementId, inUserId, FALSE)
         FROM MovementLinkMovement
         WHERE MovementLinkMovement.MovementChildId = ioId
           AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     END IF;


     -- определяем ключ доступа !!!то что захардкоженно - временно!!!
     vbAccessKeyId:= zfGet_AccessKey_onUnit (inToId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn(), inUserId);

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnIn(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);
     -- испраляю ошибку
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = ioId AND AccessKeyId IS NULL;

     -- сохранили свойство <Дата накладной у контрагента>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили свойство <Номер "перекресленої зеленої марки зi складу">
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isPartner(), ioId, inIsPartner);
     -- сохранили свойство <только для списка (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inisList);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePercent(), ioId, inChangePercent);


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

     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_CurrencyValue(), ioId, inCurrencyValue);   
     -- сохранили свойство <Номинал для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- сохранили свойство <Курс для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- сохранили свойство <Номинал для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);

     -- сохранили связь с <заявка на возврат тары>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_OrderReturnTare(), ioId, inMovementId_OrderReturnTare);

     IF inOperDatePartner < '01.08.2016' OR inPaidKindId = zc_Enum_PaidKind_SecondForm()
        OR NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE)
     THEN
         -- !!!пересчитали!!!
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id
                                                 , CASE WHEN inOperDatePartner < '01.08.2016'
                                                             THEN inChangePercent
                                                        WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() AND inOperDate < zc_isReturnInNAL_bySale()
                                                             THEN inChangePercent
                                                        WHEN 1=1 AND MIFloat_PromoMovement.ValueData > 0
                                                             THEN COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                                        ELSE inChangePercent
                                                   END
                                                  )
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
         WHERE MovementItem.MovementId = ioId
           AND MovementItem.DescId = zc_MI_Master();
     END IF;


     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания> - при загрузке с моб устр., здесь дата загрузки
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);


     -- IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     -- THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     -- END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.04.22         *
 14.05.16         *
 21.08.15         * ADD inIsPartner
 26.06.15         * add Comment, ParentId
 24.12.14				         * add меняется дата у всех корректировок
 26.08.14                                        * add только в GP - рассчитали свойство <Курс для перевода в валюту баланса>
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 23.04.14                                        * add inInvNumberMark
 16.04.14                                        * add lpInsert_MovementProtocol
 26.03.14                                        * add inInvNumberPartner
 14.02.14                                                         * del DocumentTaxKind
 11.02.14                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_ReturnIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
