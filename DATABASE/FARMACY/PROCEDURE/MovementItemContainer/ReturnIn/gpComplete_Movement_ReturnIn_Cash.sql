-- Function: gpComplete_Movement_ReturnIn_Cash()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn_Cash (Integer,Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn_Cash(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer              , --��� ������ 0-������, 1-�����, 2-���������
    IN inCashRegister      TVarChar             , --� ��������� ��������
    IN inTotalSummPayAdd   TFloat               , -- ������� �� ����
    IN inSession           TVarChar               -- ������ ������������
)
RETURNS  VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbCashRegisterId Integer;
BEGIN
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ���������
    IF CURRENT_DATE <> (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) 
    THEN
      UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;
    END IF;

    IF CURRENT_DATE <> (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) 
    THEN
        RAISE EXCEPTION '������.���� �������� ������ ���� �������.';
    END IF;

    -- ����������
    vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());

    -- ��������� ��� ������
    IF inPaidType = 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(), inMovementId, zc_Enum_PaidType_Cash());
    ELSEIF inPaidType = 1
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_Card());
    ELSEIF inPaidType = 2
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_CardAdd());
    ELSE
        RAISE EXCEPTION '������.�� ��������� ��� ������';
    END IF;

    -- ���������� �� ��������� ��������
    IF COALESCE(inCashRegister,'') <> ''
    THEN
        vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister -- �������� ����� ��������
                                                              , inSession:= inSession);
    ELSE
        vbCashRegisterId := 0;
    END IF;
    -- ��������� ����� � �������� ���������
    IF vbCashRegisterId <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inMovementId, vbCashRegisterId);
    END IF;

    -- ��������� ������� �� ����
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayAdd(), inMovementId, inTotalSummPayAdd);

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummReturnIn (inMovementId);

    -- ����������� ��������
    PERFORM lpComplete_Movement_ReturnIn  (inMovementId, vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�
 10.08.20                                                                                    *

*/

-- ����
-- SELECT * FROM gpComplete_Movement_ReturnIn_Cash (inMovementId:= 19806544 , inPaidType := 1, inCashRegister := '', inTotalSummPayAdd := 0, inSession:= '3')