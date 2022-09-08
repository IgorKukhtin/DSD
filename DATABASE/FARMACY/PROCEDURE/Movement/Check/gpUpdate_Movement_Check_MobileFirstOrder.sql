-- Function: gpUpdate_Movement_Check__MobileFirstOrder()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_MobileFirstOrder(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_MobileFirstOrder(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inisMobileFirstOrder  Boolean   , -- ������ ������� � ��������� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF NOT EXISTS(SELECT 1
                FROM MovementBoolean
                WHERE MovementBoolean.DescId = zc_MovementBoolean_MobileFirstOrder()
                  AND MovementBoolean.MovementId = inMovementId
                  AND MovementBoolean.ValueData = inisMobileFirstOrder) 
  THEN

    -- ������ ������� ������ ������� � ��������� ����������
    Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_MobileFirstOrder(), inMovementId, inisMobileFirstOrder);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
    
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 23.01.20                                                                    *
*/

-- ����