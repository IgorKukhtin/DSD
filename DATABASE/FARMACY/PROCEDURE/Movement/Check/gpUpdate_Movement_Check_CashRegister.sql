-- Function: gpComplete_Movement_IncomeAdmin()

--DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, Integer, TVarChar, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_CashRegister(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer   , -- ��� ������
    IN inCashRegister      TVarChar  , -- �������� ��������� ��������
    IN inZReport           Integer   ,  -- Z �����
    IN inFiscalCheckNumber TVarChar  , -- ����� ����������� ����
    IN inTotalSummPayAdd   TFloat    , -- ������� �� ����
    IN inRRN        	   TVarChar  , -- RRN ���������� ����� ����������
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
    
    IF EXISTS(SELECT * FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Send())
    THEN
      UPDATE Movement SET OperDate = CURRENT_DATE
      WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Send();
    END IF;
    
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

    -- ��������� <����� Z ������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ZReport(), inMovementId, inZReport);

    -- ��������� ����� ���� � �������� ��������
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(), inMovementId, inFiscalCheckNumber);

    -- ��������� ������� �� ����
    IF inTotalSummPayAdd <> 0  THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayAdd(), inMovementId, inTotalSummPayAdd);
	END IF;

    IF COALESCE (inRRN, '') <> ''
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_RRN(), inMovementId, inRRN);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_Check_CashRegister (Integer, Integer, TVarChar, Integer, TVarChar, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.08.21                                                       *
 
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_CashRegister (inMovementId:= 579, inSession:= '2')