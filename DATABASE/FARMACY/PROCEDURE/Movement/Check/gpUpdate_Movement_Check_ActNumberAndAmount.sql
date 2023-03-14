-- Function: gpUpdate_Movement_Check_ActNumberAndAmount()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ActNumberAndAmount(Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ActNumberAndAmount(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inActNumber           TVarChar  , -- ����� ����
    IN inAmountAct           TFloat    , -- ����� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  --������ ������� ����� ����
  Perform lpInsertUpdate_MovementString(zc_MovementString_ActNumber(), inMovementId, inActNumber);

  --������ ������� ����� ����
  Perform lpInsertUpdate_MovementFloat(zc_MovementFloat_AmountAct(), inMovementId, inAmountAct);

  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 14.03.23                                                                    *
*/

-- ����