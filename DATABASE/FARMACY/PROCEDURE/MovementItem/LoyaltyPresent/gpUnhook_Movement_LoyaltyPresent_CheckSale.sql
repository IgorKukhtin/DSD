-- Function: gpUnhook_Movement_LoyaltyPresent_CheckSale()

DROP FUNCTION IF EXISTS gpUnhook_Movement_LoyaltyPresent_CheckSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnhook_Movement_LoyaltyPresent_CheckSale(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;
    
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� �������� �� ���� ��������� ��� ���������, ���������� � ���������� ��������������';
   END IF;


   IF COALESCE(inMovementId, 0)  <> 0
   THEN
       -- ���������
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), inMovementId, 0);
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.02.20                                                       *
*/