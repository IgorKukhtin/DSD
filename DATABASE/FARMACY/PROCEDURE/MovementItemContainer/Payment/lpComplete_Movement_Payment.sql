DROP FUNCTION IF EXISTS lpComplete_Movement_Payment (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Payment(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPaymentDate TDateTime;
BEGIN
    
    --���������, ��� �� ��� ������ ��������������� ���, ��� � ���������
    PERFORM
        lpInsertUpdate_MovementItem_Payment_Child(inId     := MI_Payment.Id, -- ���� ������� <������� ���������>
                                                  inUserId := inUserId    -- ������ ������������
                                                  )
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId;



    -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
    PERFORM lpComplete_Movement_Finance_CreateTemp();
    -- �������� ������
    PERFORM
        lpComplete_Movement_BankAccount (inMovementId := MI_Payment.MovementBankAccountId
                                       , inUserId     := inUserId)
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId
        AND
        MI_Payment.NeedPay = TRUE
        AND
        COALESCE(MI_Payment.BankAccountId,0) > 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 13.10.15                                                                     * 
*/