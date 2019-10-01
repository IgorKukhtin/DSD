-- Function: gpUpdate_MovementItem_Wages_Unit()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_Unit (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_Unit(
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

    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    SELECT 
      Movement.StatusId
    INTO
      vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            

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
 01.10.19                                                                                    *
*/
-- ����
-- select * from gpUpdate_MovementItem_Wages_Unit(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');