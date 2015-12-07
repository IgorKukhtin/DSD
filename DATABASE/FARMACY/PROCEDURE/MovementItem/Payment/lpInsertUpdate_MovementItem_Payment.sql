-- Function: lpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIncomeId            Integer   , -- Ключ документа <приходная накладная>
    IN inBankAccountId       Integer   , -- Ключ обьекта <Расчетный счет>
    IN inCurrencyId          Integer   , -- Ключ обьекта <Валюта>
    IN inSummaPay            TFloat    , -- Сумма платежа
    IN inNeedPay             Boolean   , -- Нужно платить
    IN inUserId              Integer     -- пользователь
)
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbBankAccountInvNumber TVarChar;
   DECLARE vbBankAccountOperDate TDateTime;
   DECLARE vbBankAccountJuridicalId Integer;
   DECLARE vbBankAccountContractId Integer;
   DECLARE vbChildId Integer;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), NULL, inMovementId, inSummaPay, NULL);
    --сохранили связь с документом <приходная накладная>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inIncomeId::TFloat);
    --сохранили связь с объектом <Расчетный счет>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), ioId, inBankAccountId);
    --сохранили связь с объектом <Валюта>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);
    
    --Сохранили свойство <Нужно платить>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_NeedPay(), ioId, inNeedPay);
    
    -- SELECT
        -- MovementItem.Id
    -- INTO
        -- vbChildId
    -- FROM
        -- MovementItem
    -- WHERE
        -- MovementItem.ParentId = ioId;
    -- --нашли подчиненную строку
    -- vbChildId := lpInsertUpdate_MovementItem (COALESCE(vbChildId,0), zc_MI_Child(), NULL, inMovementId, inSummaPay, ioId);
        
    -- IF inNeedPay = TRUE
    -- THEN
        -- --дата операции оплаты
        -- SELECT
            -- OperDate
        -- INTO
            -- vbBankAccountOperDate
        -- FROM
            -- Movement
        -- WHERE
            -- Id = COALESCE(inMovementId,0);
        
        -- --Юрлицо, получатель; договор
        -- SELECT
            -- FromId
           -- ,ContractId 
        -- INTO
            -- vbBankAccountJuridicalId
           -- ,vbBankAccountContractId
        -- FROM
            -- Movement_Income_View
        -- WHERE
            -- Id = inIncomeId;
        
        -- -- номер документа оплаты
        -- SELECT
            -- InvNumber
        -- INTO
            -- vbBankAccountInvNumber
        -- FROM
            -- Movement
        -- WHERE
            -- Id = COALESCE(ioBankAccountId,0);
            
        -- if COALESCE(vbBankAccountInvNumber,'') = '' THEN
            -- vbBankAccountInvNumber := CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar);
        -- END IF;
       
        -- -- обновили / создали документ оплаты
        -- SELECT
            -- TTT.ioId
        -- INTO    
            -- ioBankAccountId
        -- FROM (SELECT * FROM gpInsertUpdate_Movement_BankAccount( ioId                   := ioBankAccountId   , -- Ключ объекта <Документ>
                                                -- inInvNumber            := vbBankAccountInvNumber  , -- Номер документа
                                                -- inOperDate             := vbBankAccountOperDate , -- Дата документа
                                                -- inAmountIn             := 0::TFloat    , -- Сумма прихода
                                                -- inAmountOut            := inSummaPay    , -- Сумма расхода
                                                -- inAmountSumm           := 0::TFloat    , -- Cумма грн, обмен

                                                -- inBankAccountId        := inAccountId   , -- Расчетный счет 	
                                                -- inComment              := ''::TVarChar  , -- Комментарий 
                                                -- inMoneyPlaceId         := vbBankAccountJuridicalId   , -- Юр лицо, счет, касса  	
                                                -- inIncomeMovementId     := inIncomeId   , -- Приходная накладная  	
                                                -- inContractId           := vbBankAccountContractId   , -- Договора
                                                -- inInfoMoneyId          := NULL::Integer   , -- Статьи назначения 
                                                -- inCurrencyId           := inCurrencyId   , -- Валюта 
                                                -- inCurrencyPartnerValue := NULL::TFloat    , -- Курс для расчета суммы операции
                                                -- inParPartnerValue      := NULL::TFloat    , -- Номинал для расчета суммы операции
                                                -- inSession              := inUserId::TVarChar    -- сессия пользователя
                                            -- ) as TT) AS TTT;
        -- --Сохранили связь с документом "Платеж по банку"
        -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, ioBankAccountId::TFloat);
    
    -- ELSE
        -- --если платить не нужно - удаляем 
        -- IF EXISTS(SELECT 1 FROM Movement 
                  -- WHERE Id = COALESCE(ioBankAccountId,0) 
                    -- AND DescId = zc_Movement_BankAccount()
                    -- AND StatusId = zc_Enum_Status_Uncomplete())
        -- THEN
            -- PERFORM gpSetErased_Movement_BankAccount(inMovementId := ioBankAccountId, inSession := inUserId::TVarChar);
        -- END IF;
        -- IF EXISTS(SELECT 1 FROM MovementItem WHERE ParentId = ioId)
        -- THEN
            -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, 0);
        -- END IF;
    -- END IF;
    --Пересчитали суммы по документу
    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 13.10.15                                                                       *
 */