-- Function: lpInsertUpdate_MovementItem_Payment_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment_Child (Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Payment_Child(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbBankAccountInvNumber TVarChar;
   DECLARE vbBankAccountOperDate TDateTime;
   DECLARE vbBankAccountJuridicalId Integer;
   DECLARE vbBankAccountContractId Integer;
   DECLARE vbChildId Integer;
   DECLARE vbNeedPay Boolean;
   DECLARE vbIncomeId Integer;
   DECLARE vbMovementBankAccountId Integer;
   DECLARE vbBankAccountId Integer; 
   DECLARE vbSummaPay TFloat;
   DECLARE vbMovementId Integer;
   DECLARE vbCurrencyId Integer;
BEGIN

    SELECT 
        COALESCE(MovementItemBoolean.ValueData,FALSE),
        MIFloat_IncomeId.ValueData::Integer,
        MovementItem.Amount,
        MovementItem.MovementId,
        MILinkObject_BankAccountId.ObjectId,
        Object_BankAccount_View.CurrencyId
    INTO 
        vbNeedPay,
        vbIncomeId,
        vbSummaPay,
        vbMovementId,
        vbBankAccountId,
        vbCurrencyId
    FROM MovementItem
        LEFT OUTER JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                           AND MovementItemBoolean.DescId = zc_MIBoolean_NeedPay()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                          ON MIFloat_IncomeId.MovementItemId = MovementItem.ID
                                         AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId() 
        LEFT OUTER JOIN MovementItemLinkObject AS MILinkObject_BankAccountId
                                              ON MILinkObject_BankAccountId.MovementItemId = MovementItem.ID
                                             AND MILinkObject_BankAccountId.DescId = zc_MILinkObject_BankAccount() 
        LEFT OUTER JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MILinkObject_BankAccountId.ObjectId
    WHERE 
        MovementItem.Id = inID;
    

    SELECT
        MovementItem.Id,
        COALESCE(MIFloat_MovementBankAccount.ValueData,0)::Integer
    INTO
        vbChildId,
        vbMovementBankAccountId
    FROM
        MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_MovementBankAccount
                                          ON MIFloat_MovementBankAccount.MovementItemId = MovementItem.ID
                                         AND MIFloat_MovementBankAccount.DescId = zc_MIFloat_MovementId() 
    WHERE
        MovementItem.ParentId = inId;
    --нашли подчиненную строку
    vbChildId := lpInsertUpdate_MovementItem (COALESCE(vbChildId,0), zc_MI_Child(), NULL, vbMovementId, vbSummaPay, inId);
    
    IF (vbNeedPay = TRUE) AND COALESCE(vbSummaPay,0)>0
    THEN
        --дата операции оплаты
        SELECT
            OperDate
        INTO
            vbBankAccountOperDate
        FROM
            Movement
        WHERE
            Id = COALESCE(vbMovementId,0);
        
        --Юрлицо, получатель; договор
        SELECT
            FromId
           ,ContractId 
        INTO
            vbBankAccountJuridicalId
           ,vbBankAccountContractId
        FROM
            Movement_Income_View
        WHERE
            Id = vbIncomeId;
        
        
        
        -- номер документа оплаты
        SELECT
            InvNumber
        INTO
            vbBankAccountInvNumber
        FROM
            Movement
        WHERE
            Id = COALESCE(vbMovementBankAccountId,0);
            
        
            
            
        if COALESCE(vbBankAccountInvNumber,'') = '' THEN
            vbBankAccountInvNumber := CAST (NEXTVAL ('movement_bankaccount_seq') AS TVarChar);
        END IF;
       
        -- обновили / создали документ оплаты
        SELECT
            TTT.ioId
        INTO    
            vbMovementBankAccountId
        FROM (SELECT * FROM gpInsertUpdate_Movement_BankAccount( ioId                   := vbMovementBankAccountId   , -- Ключ объекта <Документ>
                                                inInvNumber            := vbBankAccountInvNumber  , -- Номер документа
                                                inOperDate             := vbBankAccountOperDate , -- Дата документа
                                                inAmountIn             := 0::TFloat    , -- Сумма прихода
                                                inAmountOut            := vbSummaPay    , -- Сумма расхода
                                                inAmountSumm           := 0::TFloat    , -- Cумма грн, обмен

                                                inBankAccountId        := vbBankAccountId   , -- Расчетный счет 	
                                                inComment              := ''::TVarChar  , -- Комментарий 
                                                inMoneyPlaceId         := vbBankAccountJuridicalId   , -- Юр лицо, счет, касса  	
                                                inIncomeMovementId     := vbIncomeId   , -- Приходная накладная  	
                                                inContractId           := vbBankAccountContractId   , -- Договора
                                                inInfoMoneyId          := NULL::Integer   , -- Статьи назначения 
                                                inCurrencyId           := vbCurrencyId   , -- Валюта 
                                                inCurrencyPartnerValue := NULL::TFloat    , -- Курс для расчета суммы операции
                                                inParPartnerValue      := NULL::TFloat    , -- Номинал для расчета суммы операции
                                                inSession              := inUserId::TVarChar    -- сессия пользователя
                                            ) as TT) AS TTT;
        --Сохранили связь с документом "Платеж по банку"
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, vbMovementBankAccountId::TFloat);
    
    ELSE
        --если платить не нужно - удаляем 
        IF EXISTS(SELECT 1 FROM Movement 
                  WHERE Id = COALESCE(vbMovementBankAccountId,0) 
                    AND DescId = zc_Movement_BankAccount()
                    AND StatusId = zc_Enum_Status_Uncomplete())
        THEN
            PERFORM gpSetErased_Movement_BankAccount(inMovementId := vbMovementBankAccountId, inSession := inUserId::TVarChar);
        END IF;
        IF EXISTS(SELECT 1 FROM MovementItem WHERE ParentId = inId)
        THEN
            PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, 0);
        END IF;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 13.10.15                                                                       *
 */