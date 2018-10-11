-- Function: gpUpdate_MI_Payment_NeedPay()

DROP FUNCTION IF EXISTS gpUpdate_MI_Payment_NeedPay (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Payment_NeedPay(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   ,
    IN inNeedPay             Boolean   , -- ����� �������
   OUT outNeedPay            Boolean   , -- ����� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    
    --��������� �������� <����� �������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_NeedPay(), inId, inNeedPay);
    
    --����������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);

    outNeedPay := inNeedPay;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.18         *
*/