-- Function: gpUpdate_Movement_Check_RefusalConfirmed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_RefusalConfirmed(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_RefusalConfirmed(
    IN inMovementId           Integer   , -- ���� ������� <��������>
    IN inisRefusalConfirmed   Boolean   , -- ����������� ����� ����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  -- ����������� ����� ����������
  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RefusalConfirmed(), inMovementId, True);
  
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
  
  -- !!!�������� ��� �����!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inisRefusalConfirmed, inSession;
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.06.22                                                       *
*/

-- ���� select * from gpUpdate_Movement_Check_RefusalConfirmed(inMovementId := 20526322 , inisConfirmedByPhoneCall := 'True' ,  inSession := '3');
