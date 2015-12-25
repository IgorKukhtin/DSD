-- Function: lpInsertUpdate_MovementItem_Payment_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment_Child (Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Payment_Child(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inUserId              Integer     -- ������������
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
    --����� ����������� ������
    vbChildId := lpInsertUpdate_MovementItem (COALESCE(vbChildId,0), zc_MI_Child(), NULL, vbMovementId, vbSummaPay, inId);
    
    IF (vbNeedPay = TRUE) AND COALESCE(vbSummaPay,0)>0
    THEN
        --���� �������� ������
        SELECT
            OperDate
        INTO
            vbBankAccountOperDate
        FROM
            Movement
        WHERE
            Id = COALESCE(vbMovementId,0);
        
        --������, ����������; �������
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
        
        
        
        -- ����� ��������� ������
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
       
        -- �������� / ������� �������� ������
        SELECT
            TTT.ioId
        INTO    
            vbMovementBankAccountId
        FROM (SELECT * FROM gpInsertUpdate_Movement_BankAccount( ioId                   := vbMovementBankAccountId   , -- ���� ������� <��������>
                                                inInvNumber            := vbBankAccountInvNumber  , -- ����� ���������
                                                inOperDate             := vbBankAccountOperDate , -- ���� ���������
                                                inAmountIn             := 0::TFloat    , -- ����� �������
                                                inAmountOut            := vbSummaPay    , -- ����� �������
                                                inAmountSumm           := 0::TFloat    , -- C���� ���, �����

                                                inBankAccountId        := vbBankAccountId   , -- ��������� ���� 	
                                                inComment              := ''::TVarChar  , -- ����������� 
                                                inMoneyPlaceId         := vbBankAccountJuridicalId   , -- �� ����, ����, �����  	
                                                inIncomeMovementId     := vbIncomeId   , -- ��������� ���������  	
                                                inContractId           := vbBankAccountContractId   , -- ��������
                                                inInfoMoneyId          := NULL::Integer   , -- ������ ���������� 
                                                inCurrencyId           := vbCurrencyId   , -- ������ 
                                                inCurrencyPartnerValue := NULL::TFloat    , -- ���� ��� ������� ����� ��������
                                                inParPartnerValue      := NULL::TFloat    , -- ������� ��� ������� ����� ��������
                                                inSession              := inUserId::TVarChar    -- ������ ������������
                                            ) as TT) AS TTT;
        --��������� ����� � ���������� "������ �� �����"
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, vbMovementBankAccountId::TFloat);
    
    ELSE
        --���� ������� �� ����� - ������� 
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 13.10.15                                                                       *
 */