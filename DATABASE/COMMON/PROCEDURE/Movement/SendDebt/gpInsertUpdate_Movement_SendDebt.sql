-- Function: gpInsertUpdate_Movement_SendDebt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Tfloat, Tfloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendDebt(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

 INOUT ioMasterId            Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioChildId             Integer   , -- Ключ объекта <Элемент документа>

    IN inAmount              TFloat    , -- сумма  
    IN inCurrencyValue_From  TFloat    , -- Курс  
    IN inParValue_From       TFloat    , -- Номинал валюты для которой вводится курс  
    IN inCurrencyValue_To    TFloat    , -- Курс  
    IN inParValue_To         TFloat    , -- Номинал валюты для которой вводится курс  
        
    IN inJuridicalFromId     Integer   , -- Юр.лицо
    IN inPartnerFromId       Integer   , -- Контрагент
    IN inContractFromId      Integer   , -- Договор
    IN inPaidKindFromId      Integer   , -- Вид форм оплаты
    IN inInfoMoneyFromId     Integer   , -- Статьи назначения
    IN inBranchFromId        Integer   , -- 
    IN inCurrencyId_From     Integer   , -- валюта
    
    IN inJuridicalToId       Integer   , -- Юр.лицо
    IN inPartnerToId         Integer   , -- Контрагент
    IN inContractToId        Integer   , -- Договор
    IN inPaidKindToId        Integer   , -- Вид форм оплаты
    IN inInfoMoneyToId       Integer   , -- Статьи назначения
    IN inBranchToId          Integer   , -- 
    IN inCurrencyId_To       Integer   , -- валюта
    
    IN inComment             TVarChar  , -- Примечание
    
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebt());

     -- проверка
     IF (COALESCE (inJuridicalFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юридическое лицо (Дебет)>.';
     END IF;
     -- проверка
     IF (COALESCE (inInfoMoneyFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <УП статья назначения (Дебет)>.';
     END IF;
     -- проверка
     IF (COALESCE (inContractFromId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Договор (Дебет)>.';
     END IF;
     -- проверка
     IF inPaidKindFromId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerFromId, 0) = 0
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalFromId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION 'Ошибка. Для формы оплаты <%> должен быть установлен <Контрагент (Дебет)>.', lfGet_Object_ValueData (inPaidKindFromId);
     ELSE IF inPaidKindFromId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerFromId, 0) = 0
          THEN  inPartnerFromId:= (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalFromId AND DescId = zc_ObjectLink_Partner_Juridical());
          END IF;
     END IF;

     -- проверка
     IF (COALESCE (inJuridicalToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юридическое лицо (Кредит)>.';
     END IF;
     -- проверка
     IF (COALESCE (inInfoMoneyToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <УП статья назначения (Кредит)>.';
     END IF;
     -- проверка
     IF (COALESCE (inContractToId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Договор (Кредит)>.';
     END IF;
     -- проверка
     IF inPaidKindToId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerToId, 0) = 0
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalToId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION 'Ошибка. Для формы оплаты <%> должен быть установлен <Контрагент (Кредит)>.', lfGet_Object_ValueData (inPaidKindToId);
     ELSE IF inPaidKindToId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerToId, 0) = 0
          THEN  inPartnerToId:= (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalToId AND DescId = zc_ObjectLink_Partner_Juridical());
          END IF;
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_SendDebt())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SendDebt(), inInvNumber, inOperDate, NULL);

   
     -- сохранили <Главный Элемент документа>
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), CASE WHEN inPartnerFromId <> 0 AND inPaidKindFromId = zc_Enum_PaidKind_SecondForm() THEN inPartnerFromId ELSE inJuridicalFromId END, ioId, inAmount, NULL);

     -- сохранили связь с <Договор ОТ >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMasterId, inContractFromId);

     -- сохранили связь с <Вид форм оплаты ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMasterId, inPaidKindFromId);

     -- сохранили связь с <Статьи назначения ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);

     -- сохранили связь с <Филиал ОТ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioMasterId, inBranchFromId);


     -- сохранили связь с <Валютой>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioMasterId, inCurrencyId_From); 
     -- сохранили свойство <Курс>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioMasterId, inCurrencyValue_From);
     -- сохранили свойство <Номинал>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioMasterId, inParValue_From);

     -- сохранили связь с <Валютой>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioMasterId, inCurrencyId_From); 
     -- сохранили свойство <Курс>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioMasterId, inCurrencyValue_From);
     -- сохранили свойство <Номинал>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioMasterId, inParValue_From);
     
     -- сохранили свойство <Комментарий>
     PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMasterId, inComment);


     -- сохранили <Второй Элемент документа>
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), CASE WHEN inPartnerToId <> 0 AND inPaidKindToId = zc_Enum_PaidKind_SecondForm() THEN inPartnerToId ELSE inJuridicalToId END, ioId, inAmount, NULL);

     -- сохранили связь с <Договор КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioChildId, inContractToId);

     -- сохранили связь с <Вид форм оплаты КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioChildId, inPaidKindToId);

     -- сохранили связь с <Статьи назначения КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, inInfoMoneyToId);

     -- сохранили связь с <Филиал КОМУ>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioChildId, inBranchToId);

     -- сохранили связь с <Валютой>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioChildId, inCurrencyId_To); 
     -- сохранили свойство <Курс>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioChildId, inCurrencyValue_To);
     -- сохранили свойство <Номинал>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioChildId, inParValue_To);

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebt())
     THEN
          PERFORM lpComplete_Movement_SendDebt (inMovementId := ioId
                                              , inUserId     := vbUserId);
     END IF;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.02.19         * add валюта дебет/ кредит
 24.01.19         * add inCurrencyId, inCurrencyValue, inParValue
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 24.09.14                                        * add inPartner...
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 28.01.14                                        * add lpComplete_Movement_SendDebt
 24.01.14         *
*/

-- тест
-- 