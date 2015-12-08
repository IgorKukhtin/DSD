-- Function: gpInsertUpdate_MovementItem_PaymentMulti()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PaymentMulti(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIncomeId            Integer   , -- ���� ��������� <��������� ���������>
    IN inBankAccountId       Integer   , -- ���� ������� <��������� ����>
    IN inSummaPay            TFloat    , -- ����� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --��������� ��������� ����
    PERFORM gpInsertUpdate_MovementItem_Payment(ioId             := inId, -- ���� ������� <������� ���������>
                                                inMovementId     := inMovementId, -- ���� ������� <��������>
                                                inIncomeId       := inIncomeId, -- ���� ��������� <��������� ���������>
                                                ioBankAccountId  := inBankAccountId, -- ���� ������� <��������� ����>
                                                inSummaPay       := inSummaPay, -- ����� �������
                                                inNeedPay        := TRUE, -- ����� �������
                                                inSession        := inSession-- ������ ������������
                                            );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 07.12.15                                                                         *
*/