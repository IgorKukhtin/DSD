-- Function: gpDelete_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpDelete_MovementItem_EmployeeSchedule_User(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MovementItem_EmployeeSchedule_User(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inId                  Integer   , -- ��� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF NOT EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
    THEN
      RAISE EXCEPTION '�������� ��� ���������, ���������� � ���������� ��������������.';
    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '�� �������� ������ ������ �����������.';
    END IF;
    
    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;    
    
    IF EXISTS(SELECT 1 FROM MovementItem
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.ParentId = inId
                               AND MovementItem.DescId = zc_MI_Child()) 
    THEN
        RAISE EXCEPTION '������.������� ������� ������� ���������� �� ����.';
    END IF;    

    -- �������
    PERFORM lpDelete_MovementItem(inId, inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
11.09.19                                                        *

*/