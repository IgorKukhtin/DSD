-- Function: gpUpdate_MovementItem_EmployeeSchedule_Unit()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_Unit (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_Unit(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inUnitId            Integer   , -- ������������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066)
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    SELECT 
      Movement.StatusId
    INTO
      vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ������������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), inId, inUnitId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 25.03.19                                                                                    *
*/
-- ����
-- select * from gpUpdate_MovementItem_EmployeeSchedule_Unit(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');