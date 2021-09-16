-- Function: gpDelete_MovementItem_EmployeeScheduleVIP_UserDay()

DROP FUNCTION IF EXISTS gpDelete_MovementItem_EmployeeScheduleVIP_UserDay(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MovementItem_EmployeeScheduleVIP_UserDay(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inId                  Integer   , -- ��� �������
    IN inTypeId              Integer   , -- ����� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbId Integer;
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
    
    IF COALESCE(inId, 0) = 0
    THEN
      RAISE EXCEPTION '�� ��������� ������ � ������� ������ �����������.';
    END IF;

    IF EXISTS(SELECT ID
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ParentID = inId
                AND MovementItem.Amount = inTypeId
                AND MovementItem.DescId = zc_MI_Child())
    THEN
       SELECT ID
       INTO vbId
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.ParentID = inId
         AND MovementItem.Amount = inTypeId
         AND MovementItem.DescId = zc_MI_Child();
    ELSE
       vbId := 0;
    END IF;

    IF COALESCE(vbId, 0) = 0
    THEN
      RAISE EXCEPTION '�� �������� ������ �� ��� � ������� ������ �����������.';
    END IF;

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;    

    -- �������
    PERFORM lpDelete_MovementItem(vbId, inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
16.09.21                                                        *

*/

-- select * from gpDelete_MovementItem_EmployeeScheduleVIP_UserDay(inMovementID := 24861838 , inId := 457009614 , inTypeId := 13 ,  inSession := '3');