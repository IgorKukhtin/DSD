-- Function: gpComplete_Movement_IncomeAdmin()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_CashRegister(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer   , -- ��� ������
    IN inCashRegister      TVarChar  , -- �������� ��������� ��������
    IN inFiscalCheckNumber TVarChar  , -- ����� ����������� ����
    IN inTotalSummPayAdd   TFloat    , -- ������� �� ����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCashRegisterId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    vbUserId:= inSession;
    
    -- ��������� ����� � <��� ������>
    IF inPaidType <> -1
    THEN
        if inPaidType = 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
        ELSEIF inPaidType = 2
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_CardAdd());
        ELSE
            RAISE EXCEPTION '������.�� ��������� ��� ������';
        END IF;
    END IF;

    vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister, inSession := inSession);
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);

    -- ��������� ����� ���� � �������� ��������
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(), inMovementId, inFiscalCheckNumber);

    -- ��������� ������� �� ����
    IF inTotalSummPayAdd <> 0  THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayAdd(), inMovementId, inTotalSummPayAdd);
	END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.08.21                                                       *
 
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_CashRegister (inMovementId:= 579, inSession:= '2')
