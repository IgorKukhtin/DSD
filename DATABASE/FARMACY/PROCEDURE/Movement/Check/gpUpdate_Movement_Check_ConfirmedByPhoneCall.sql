-- Function: gpUpdate_Movement_Check_ConfirmedByPhoneCall()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ConfirmedByPhoneCall(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ConfirmedByPhoneCall(
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inisConfirmedByPhoneCall   Boolean   , -- ������������ �� ����������� ������
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  --������������ �� ����������� ������
  Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_ConfirmedByPhoneCall(), inMovementId, inisConfirmedByPhoneCall);
  
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
  
  -- !!!�������� ��� �����!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inisConfirmedByPhoneCall, inSession;
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.06.22                                                       *
*/

-- ����
select * from gpUpdate_Movement_Check_ConfirmedByPhoneCall(inMovementId := 20526322 , inisConfirmedByPhoneCall := 'True' ,  inSession := '3');