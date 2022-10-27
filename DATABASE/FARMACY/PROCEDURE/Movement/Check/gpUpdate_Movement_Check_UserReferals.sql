-- Function: gpUpdate_Movement_Check_UserReferals()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_UserReferals (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_UserReferals(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inUserReferalsId    Integer   , -- ������� ����������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
    THEN
      RAISE EXCEPTION '��������� �������� <������� ����������> ��� ���������.';
    END IF;
    
    IF NOT EXISTS(SELECT MovementBoolean_MobileFirstOrder.MovementId 
                  FROM MovementBoolean AS MovementBoolean_MobileFirstOrder
                  WHERE MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                    AND MovementBoolean_MobileFirstOrder.MovementId = inMovementId
                    AND MovementBoolean_MobileFirstOrder.ValueData = TRUE)
    THEN
      RAISE EXCEPTION '��������� �������� <������� ����������> ����� ������ �� ������ �������.';
    END IF;    
        
    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserReferals(), inMovementId, inUserReferalsId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> ', inSession;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.10.22                                                       *
*/
-- ����
-- 
select * from gpUpdate_Movement_Check_UserReferals(inMovementId := 29868898 , inUserReferalsId := 14468719 ,  inSession := '3');