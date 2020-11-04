-- Function: lpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIncomeId            Integer   , -- ���� ��������� <��������� ���������>
    IN inBankAccountId       Integer   , -- ���� ������� <��������� ����>
    IN inCurrencyId          Integer   , -- ���� ������� <������>
    IN inSummaPay            TFloat    , -- ����� �������
    IN inSummaCorrBonus      TFloat    , -- ����� ������������� ����� �� ������
    IN inSummaCorrReturnOut  TFloat    , -- ����� ������������� ����� �� ���������
    IN inSummaCorrOther      TFloat    , -- ����� ������������� ����� �� ������ ��������
    IN inNeedPay             Boolean   , -- ����� �������
    IN inisPartialPay        Boolean = FALSE , -- ��������� ������
    IN inNeedRecalcSumm      Boolean = TRUE  , --����������� �����
    IN inUserId              Integer = 0 -- ������������
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
    --��������� �������� <������������� �� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CorrBonus(), ioId, inSummaCorrBonus);
    --��������� �������� <������������� �� ���������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CorrReturnOut(), ioId, inSummaCorrReturnOut);
    --��������� �������� <������������� �� ������ ��������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CorrOther(), ioId, inSummaCorrOther);
    --��������� ����� � �������� <��������� ����>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), ioId, inBankAccountId);
    --��������� ����� � �������� <������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);
    --��������� �������� <����� �������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_NeedPay(), ioId, inNeedPay);
    --��������� �������� <��������� ������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartialPay(), ioId, inisPartialPay);
    
    IF inNeedRecalcSumm 
    THEN
      --����������� ����� �� ���������
      PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);
    END IF;  

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