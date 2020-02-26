-- Function: gpUnhook_MovementItem_Loyalty_Parent()

DROP FUNCTION IF EXISTS gpUnhook_MovementItem_Loyalty_Parent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnhook_MovementItem_Loyalty_Parent(
    IN inId                  Integer   , -- ���� ������� <��������>
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
     RAISE EXCEPTION '��������� �������� �� ����������� ��� ���������, ���������� � ���������� ��������������';
   END IF;
    
    -- ���������
   update  MovementItem set parentID = Null where ID = inId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
*/