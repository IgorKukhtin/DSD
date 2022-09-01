-- Function: gpUpdate_Movement_Check_EmployeeMessage()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_EmployeeMessage(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_EmployeeMessage(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inisEmployeeMessage     Boolean   , -- �� �� ������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
  THEN
    RAISE EXCEPTION '��������� �������� <�� �� ������> ��� ���������.';
  END IF;
  
  --������ �������� ������������
  PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_EmployeeMessage(), inMovementId, not inisEmployeeMessage);
    
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 01.09.22                                                                    *
*/

-- ����

select * from gpUpdate_Movement_Check_EmployeeMessage(inMovementId := 28983728 , inisEmployeeMessage := 'False' ,  inSession := '3');