 -- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar
                                                       , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar
                                                       , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                       , TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar
                                                       , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                       , TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar
                                                       , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                       , TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);*/

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TVarChar
                                                       , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                       , TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inOperDatePartner          TDateTime , -- Дата акта(контрагента)
    IN inInvNumberPartner         TVarChar  , -- Номер акта (контрагента)
 INOUT ioAmountIn                 TFloat    , -- Сумма Дебет (мы оказали)
 INOUT ioAmountOut                TFloat    , -- Сумма Кредит (мы получили)
 INOUT ioAmountCurrencyDebet      TFloat    , -- Сумма Дебет (в валюте)
 INOUT ioAmountCurrencyKredit     TFloat    , -- Сумма Кредит (в валюте)
    IN inCurrencyPartnerValue     TFloat    , -- Курс для расчета суммы операции в ГРН
    IN inParPartnerValue          TFloat    , -- Номинал для расчета суммы операции в ГРН

    IN inCountDebet               TFloat    , -- кол-во Дебет
    IN inCountKredit              TFloat    , -- кол-во Кредит
    IN inPrice                    TFloat    , -- цена
   OUT outSumma                   TFloat    , -- сумма расчет

    IN inMovementId_List          TVarChar  , -- список Ид док для затрат
    IN inInvNumberInvoice         TVarChar  , -- Счет(клиента)
    IN inComment                  TVarChar  , -- Комментарий
    IN inBusinessId               Integer   , -- Бизнес
    IN inContractId               Integer   , -- Договор
    IN inContractChildId          Integer   , -- Договор ,база
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPartnerId                Integer   , -- Контрагент
    IN inJuridicalBasisId         Integer   , -- Главное юр. лицо
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inUnitId                   Integer   , -- Подразделение
    IN inMovementId_Invoice       Integer   , -- документ счет
    IN inAssetId                  Integer   , -- Для ОС
    IN inCurrencyPartnerId        Integer   , -- Валюта (контрагента)
    IN inTradeMarkId              Integer   , --
    IN inMovementId_doc           Integer   , -- Распред. затрат Акция / Трейд-маркетинг
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbCount TFloat;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIndex Integer;
   DECLARE vbAmountCurrency TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());

     -- определяем ключ доступа
     IF inPaidKindId = zc_Enum_PaidKind_FirstForm_pav()
     THEN
         vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Service());
         vbAccessKeyId:= zc_Enum_Process_AccessKey_ServicePav();
     ELSE
         vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Service());
    END IF;

     -- если валюта выбрана
     IF COALESCE (inCurrencyPartnerId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN
         -- меняется сумма ГРН - Дебет (мы оказали)
         ioAmountIn := CASE WHEN ioAmountCurrencyDebet <> 0
                            THEN ioAmountCurrencyDebet
                            ELSE 0
                        END
                        -- по курсу
                      * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                             ELSE inCurrencyPartnerValue
                        END;
         -- меняется сумма ГРН - Кредит (мы получили)
         ioAmountOut:= CASE WHEN ioAmountCurrencyKredit <> 0
                            THEN ioAmountCurrencyKredit
                            ELSE 0
                        END
                        -- по курсу
                      * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                             ELSE inCurrencyPartnerValue
                        END;
         -- расчет - сумма в валюте
         vbAmountCurrency := CASE WHEN ioAmountCurrencyDebet  <> 0 THEN  1 * ioAmountCurrencyDebet
                                  WHEN ioAmountCurrencyKredit <> 0 THEN -1 * ioAmountCurrencyKredit
                                  ELSE 0
                             END;
     ELSE
         ioAmountCurrencyDebet := 0;
         ioAmountCurrencyKredit:= 0;
     END IF;


     -- проверка Юр. лицо
     IF inContractId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Juridical() AND OL.ChildObjectId = inJuridicalId)
     THEN
         RAISE EXCEPTION 'Ошибка.Выбрано Юр. лицо = <%> не соответствует значению в договоре = <%>'
                       , lfGet_Object_ValueData (inJuridicalId)
                       , lfGet_Object_ValueData ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inContractId AND OL.DescId = zc_ObjectLink_Contract_Juridical()))
                        ;
     END IF;


     -- проверка вводят или "кол-во и цену" или "сумму"
     IF ((COALESCE (inCountDebet, 0) + COALESCE (inCountKredit, 0)) <> 0 OR (COALESCE (inPrice, 0)) <> 0 )
      AND (COALESCE (ioAmountIn, 0) + COALESCE (ioAmountOut, 0) <> 0 OR COALESCE (ioAmountCurrencyDebet, 0) + COALESCE (ioAmountCurrencyKredit, 0) <> 0)
     THEN
        RAISE EXCEPTION 'Должны быть введены только количество и цена или сумма.';
     END IF;

     -- при вводе кол и суммы валюта должна быть ГРН
     IF ((COALESCE (inCountDebet, 0) <> 0 OR  COALESCE (inCountKredit, 0) <> 0) AND COALESCE (inPrice, 0) <> 0) AND COALESCE (inCurrencyPartnerId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN
         RAISE EXCEPTION 'Ввод в валюте не предусмотрен для количества и цены.';
     END IF;

     -- проверка
     IF COALESCE (ioAmountCurrencyDebet, 0) = 0 AND COALESCE (ioAmountCurrencyKredit, 0) = 0 AND COALESCE (inCurrencyPartnerId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN
        RAISE EXCEPTION 'Введите сумму в валюте.';
     END IF;
     -- проверка
     IF (COALESCE (ioAmountIn, 0) = 0 AND COALESCE (ioAmountOut, 0) = 0 AND COALESCE (inCurrencyPartnerId, 0) IN (0, zc_Enum_Currency_Basis()))
     AND ((COALESCE (inCountDebet, 0) + COALESCE (inCountKredit, 0)) = 0 AND COALESCE (inPrice, 0) = 0 )
     THEN
        RAISE EXCEPTION 'Введите сумму или количество и цену';
     END IF;

     -- проверка
     IF COALESCE (ioAmountIn, 0) <> 0 AND COALESCE (ioAmountOut, 0) <> 0 THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;
     -- проверка
     IF COALESCE (ioAmountCurrencyDebet, 0) <> 0 AND COALESCE (ioAmountCurrencyKredit, 0) <> 0 THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма в валюте: <Дебет> или <Кредит>.';
     END IF;

     -- проверка
     IF COALESCE (inCountDebet, 0) <> 0 AND COALESCE (inCountKredit, 0) <> 0 THEN
        RAISE EXCEPTION 'Должна быть введена только одно количество: <Дебет> или <Кредит>.';
     END IF;

     -- проверка
     IF (COALESCE (inCountDebet, 0) + COALESCE (inCountKredit, 0) <> 0 AND COALESCE (inPrice, 0) = 0)
     THEN
        RAISE EXCEPTION 'Должны быть введены цена и количество: <Дебет> или <Кредит>.';
     END IF;

     -- проверка
     IF (COALESCE (inJuridicalId, 0) = 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено <Юридическое лицо>.';
     END IF;
     -- проверка
     IF inPaidKindId = zc_Enum_PaidKind_SecondForm() AND (COALESCE (inPartnerId, 0) = 0)
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION 'Ошибка. Для формы оплаты <%> должен быть установлен <Контрагент>.', lfGet_Object_ValueData (inPaidKindId);
     END IF;

     --проверка договор должен быть в Promo, иначе выдавать ошибку
     IF COALESCE (inMovementId_doc,0) <> 0
      AND EXISTS (SELECT 1 FROM Movement  WHERE Movement.Id = inMovementId_doc AND Movement.DescId = zc_Movement_PromoTrade())
      AND NOT EXISTS (--Акция
                      --Траде маркетинг
                      SELECT MovementLinkObject_Contract.ObjectId AS ContractId
                      FROM Movement
                          --для Промо договор из zc_Movement_PromoPartner
                          LEFT JOIN Movement AS Movement_PromoPartner
                                             ON Movement_PromoPartner.ParentId = Movement.Id
                                            AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                            AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                       ON MovementLinkObject_Contract.MovementId = CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Movement.Id ELSE Movement_PromoPartner.Id END
                                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                      WHERE Movement.Id = inMovementId_doc
                        AND COALESCE (MovementLinkObject_Contract.ObjectId,0) <> 0
                      LIMIT 1)
     THEN
          RAISE EXCEPTION 'Ошибка.В документе <%> № <%> от <%> должен быть установлен <Договор база>.'
                        , (SELECT MovementDesc.ItemName
                           FROM Movement
                                JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                           WHERE Movement.Id = inMovementId_doc
                          )
                        , (SELECT Movement.InvNumber
                           FROM Movement
                           WHERE Movement.Id = inMovementId_doc
                          )
                        , (SELECT zfConvert_DateToString (Movement.OperDate)
                           FROM Movement
                           WHERE Movement.Id = inMovementId_doc
                          )
                         ;
     END IF;

     -- расчет сумма в ГРН
     IF (COALESCE (inCountDebet, 0) <> 0 OR  COALESCE (inCountKredit, 0) <> 0) AND COALESCE (inPrice, 0) <> 0
     THEN   -- количество и цена
         IF inCountDebet <> 0
         THEN
            vbCount := inCountDebet;
            -- расчетная сумма
            outSumma := inCountDebet * inPrice;
            vbAmount := inCountDebet * inPrice;
         ELSE
            vbCount := -1 * inCountKredit;
            -- расчетная сумма
            outSumma := inCountKredit * inPrice;
            vbAmount := -1 * inCountKredit * inPrice;
         END IF;
     ELSE
         -- расчет сумма в ГРН
         IF ioAmountIn <> 0
         THEN
            vbAmount := ioAmountIn;
         ELSE
            vbAmount := -1 * ioAmountOut;
         END IF;
     END IF;

     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Service())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Service(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_MovementId(), ioId, inMovementId_List);
     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     -- сохранили связь с <Валюта (контрагента) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), ioId, inCurrencyPartnerId);
     -- сохранили свойство <Курс для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- сохранили свойство <Номинал для перевода из вал. док. в валюту контрагента>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), ioId, inParPartnerValue);
     -- сохранили свойство <Сумма операции (в валюте)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), ioId, vbAmountCurrency);

     --
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_TradeMark(), ioId, inTradeMarkId);
     --
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Doc(), ioId, inMovementId_doc);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), CASE WHEN inPartnerId <> 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN inPartnerId ELSE inJuridicalId END, ioId, vbAmount, NULL);

     -- Счет(клиента)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), ioId, inInvNumberInvoice);
     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Договор база>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractChild(), vbMovementItemId, inContractChildId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);

     -- сохранили связь с <Для ОС>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), vbMovementItemId, inAssetId);

     -- сохранили связь с <гл юр лицо>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalBasis(), vbMovementItemId, inJuridicalBasisId);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPrice);
     -- сохранили свойство <Количество>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), vbMovementItemId, COALESCE (vbCount,0));

     -- сохранили связь с <Типы условий договоров>
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), vbMovementItemId, inContractConditionKindId);


     --- сохраняем связи в документах приход от поставщика
     -- таблица
     CREATE TEMP TABLE tmp_List (MovementId Integer) ON COMMIT DROP;
     -- парсим
     vbIndex := 1;
     WHILE SPLIT_PART (inMovementId_List, ',', vbIndex) <> '' LOOP
         -- добавляем то что нашли
         INSERT INTO tmp_List (MovementId) SELECT SPLIT_PART (inMovementId_List, ',', vbIndex) :: Integer;
         -- теперь следуюющий
         vbIndex := vbIndex + 1;
     END LOOP;

     -- сохраняем <Документ Затрат> , если такого еще нет
     PERFORM lpInsertUpdate_Movement_IncomeCost (ioId         := 0
                                               , inParentId   := tmp_List.MovementId -- док приход
                                               , inMovementId := ioId                -- док услуг
                                               , inComment    := ''::TVarChar
                                               , inUserId     := vbUserId
                                                )
     FROM tmp_List
       LEFT JOIN (SELECT Movement.Id, tmp_List.MovementId AS ParentId
                  FROM tmp_List
                     INNER JOIN Movement on tmp_List.MovementId = Movement.ParentId
                     INNER JOIN MovemenTFloat AS MovemenTFloat_MovementId
                                              ON MovemenTFloat_MovementId.MovementId = Movement.Id
                                             AND MovemenTFloat_MovementId.DescId = zc_MovemenTFloat_MovementId()
                                             AND MovemenTFloat_MovementId.ValueData = ioId
                  WHERE tmp_List.MovementId <> 0
                  ) as tmp on tmp.ParentId =  tmp_List.MovementId
     WHERE tmp.Id isnull AND tmp_List.MovementId <> 0;

     -- метим на удаление док.затрат в приходах не из списка
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId)
     FROM (SELECT Movement.ParentId
                , MovemenTFloat.MovementId
           FROM MovemenTFloat
              LEFT JOIN Movement ON Movement.Id = MovemenTFloat.Movementid
           WHERE MovemenTFloat.DescId = zc_MovemenTFloat_MovementId()
             AND MovemenTFloat.ValueData ::Integer = ioId
           ) AS tmp
           LEFT JOIN tmp_List ON tmp_List.MovementId = tmp.ParentId
     WHERE tmp_List.MovementId Isnull;
     ---------------------

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
          PERFORM gpComplete_Movement_Service (inMovementId := ioId
                                             , inSession    := inSession
                                              );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.10.24         * inContractChildId
 08.08.24         *
 24.02.20         *
 01.08.17         *
 27.08.16         * add asset
 29.04.16         *
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 24.09.14                                        * add inPartnerId
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 10.05.14                                        * add lpInsert_MovementItemProtocol
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner
 19.01.14         * del ContractConditionKind
 28.01.14         * add ContractConditionKind
 22.01.14                                        * add IsMaster
 26.12.13                                        * add lpComplete_Movement_Service
 24.12.13                        *
 11.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Service (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inJuridicalId:= 1, inJuridicalBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inSession:= '2')
