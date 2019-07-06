-- Function: gpUpdate_MovementIten_Check_PartionDateKind()

DROP FUNCTION IF EXISTS gpUpdate_MovementIten_Check_PartionDateKind (Integer, Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementIten_Check_PartionDateKind(
    IN inMovementId            Integer   , -- ���� ������� <�������� ���>
    IN inMovementItemID        Integer   , -- ���� ������� <������ ���>
    IN inPartionDateKindId     Integer   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� <�������������> ��� ���������.';
    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    SELECT 
      StatusId
    INTO
      vbStatusId
    FROM Movement 
    WHERE Id = inMovementId;
            
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ������������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemID)
    THEN
      UPDATE MovementItem SET isErased = True, Amount = 0
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemID;
    END IF;

    -- ��������� �������� <��� ����/�� ����>
    IF COALESCE (inPartionDateKindID, 0) <> COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = inMovementItemID), 0)
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), inMovementItemID, inPartionDateKindID);
      PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := inMovementItemID, inUserId := vbUserId);
    ELSE
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), inMovementItemID, 0);
    END IF;
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementItemID, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 17.11.18                                                                                    *
*/
-- ����
-- select * from gpUpdate_MovementIten_Check_PartionDateKind(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');