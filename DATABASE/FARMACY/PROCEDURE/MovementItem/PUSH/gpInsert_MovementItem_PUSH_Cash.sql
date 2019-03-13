-- Function: gpInsert_MovementItem_PUSH_Cash()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_PUSH_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_PUSH_Cash(
    IN inMovementId          Integer   , -- ���� ������� <������� ���������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    IF (COALESCE (inMovementId, 0) = 0)
    THEN
      RAISE EXCEPTION '������. �� �������� ����� ����������.';
    END IF;

    IF (COALESCE (vbUnitId, 0) = 0)
    THEN
      RAISE EXCEPTION '������. �� ���������� �������������.';
    END IF;

    IF NOT EXISTS(SELECT * FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_PUSH())
    THEN
      RAISE EXCEPTION '������. ���������� �� �������.';
    END IF;

    IF EXISTS(SELECT * 
              FROM MovementItem
    
                   INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                 ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                AND MILinkObject_Unit.ObjectId = vbUnitId
    
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbUserId)
    THEN
      SELECT MovementItem.ID
      INTO vbId 
      FROM MovementItem
    
           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                            AND MILinkObject_Unit.ObjectId = vbUnitId
    
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = vbUserId;
        
      UPDATE MovementItem set Amount = Amount + 1 WHERE MovementItem.ID = vbId;
    ELSE

      INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
      VALUES (zc_MI_Master(), vbUserId, inMovementId, 1, Null) RETURNING Id INTO vbId;
    END IF;

    -- ��������� <����>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Viewed(), vbId, CURRENT_TIMESTAMP);
    
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbId, vbUnitId);    
          
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, True);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 13.03.19                                                                     *
 11.03.19                                                                     *
*/