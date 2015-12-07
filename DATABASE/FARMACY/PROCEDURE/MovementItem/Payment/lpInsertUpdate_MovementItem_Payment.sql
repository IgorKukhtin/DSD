-- Function: lpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIncomeId            Integer   , -- ���� ��������� <��������� ���������>
    IN inBankAccountId       Integer   , -- ���� ������� <��������� ����>
    IN inCurrencyId          Integer   , -- ���� ������� <������>
    IN inSummaPay            TFloat    , -- ����� �������
    IN inNeedPay             Boolean   , -- ����� �������
    IN inUserId              Integer     -- ������������
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
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), NULL, inMovementId, inSummaPay, NULL);
    --��������� ����� � ���������� <��������� ���������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inIncomeId::TFloat);
    --��������� ����� � �������� <��������� ����>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), ioId, inBankAccountId);
    --��������� ����� � �������� <������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);
    
    --��������� �������� <����� �������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_NeedPay(), ioId, inNeedPay);
    
    -- SELECT
        -- MovementItem.Id
    -- INTO
        -- vbChildId
    -- FROM
        -- MovementItem
    -- WHERE
        -- MovementItem.ParentId = ioId;
    -- --����� ����������� ������
    -- vbChildId := lpInsertUpdate_MovementItem (COALESCE(vbChildId,0), zc_MI_Child(), NULL, inMovementId, inSummaPay, ioId);
        
    -- IF inNeedPay = TRUE
    -- THEN
        -- --���� �������� ������
        -- SELECT
            -- OperDate
        -- INTO
            -- vbBankAccountOperDate
        -- FROM
            -- Movement
        -- WHERE
            -- Id = COALESCE(inMovementId,0);
        
        -- --������, ����������; �������
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
        
        -- -- ����� ��������� ������
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
       
        -- -- �������� / ������� �������� ������
        -- SELECT
            -- TTT.ioId
        -- INTO    
            -- ioBankAccountId
        -- FROM (SELECT * FROM gpInsertUpdate_Movement_BankAccount( ioId                   := ioBankAccountId   , -- ���� ������� <��������>
                                                -- inInvNumber            := vbBankAccountInvNumber  , -- ����� ���������
                                                -- inOperDate             := vbBankAccountOperDate , -- ���� ���������
                                                -- inAmountIn             := 0::TFloat    , -- ����� �������
                                                -- inAmountOut            := inSummaPay    , -- ����� �������
                                                -- inAmountSumm           := 0::TFloat    , -- C���� ���, �����

                                                -- inBankAccountId        := inAccountId   , -- ��������� ���� 	
                                                -- inComment              := ''::TVarChar  , -- ����������� 
                                                -- inMoneyPlaceId         := vbBankAccountJuridicalId   , -- �� ����, ����, �����  	
                                                -- inIncomeMovementId     := inIncomeId   , -- ��������� ���������  	
                                                -- inContractId           := vbBankAccountContractId   , -- ��������
                                                -- inInfoMoneyId          := NULL::Integer   , -- ������ ���������� 
                                                -- inCurrencyId           := inCurrencyId   , -- ������ 
                                                -- inCurrencyPartnerValue := NULL::TFloat    , -- ���� ��� ������� ����� ��������
                                                -- inParPartnerValue      := NULL::TFloat    , -- ������� ��� ������� ����� ��������
                                                -- inSession              := inUserId::TVarChar    -- ������ ������������
                                            -- ) as TT) AS TTT;
        -- --��������� ����� � ���������� "������ �� �����"
        -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, ioBankAccountId::TFloat);
    
    -- ELSE
        -- --���� ������� �� ����� - ������� 
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
    --����������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�,
 13.10.15                                                                       *
 */