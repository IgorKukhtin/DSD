-- Function: lpInsertUpdate_MovementItem_Loyalty_GUID()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loyalty_GUID (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Loyalty_GUID(
    IN inMovementItemId      Integer   , -- ���� ������� <��������>
    IN inGUID                TVarChar  , -- GUID
    IN inUserId              Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
    -- ������������ ������� ��������/�������������
    IF COALESCE (inMovementItemId, 0) = 0 
    THEN
       RAISE EXCEPTION '���������� ��������� �� ���������.';    
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem_Loyalty_GUID WHERE MovementItem_Loyalty_GUID.MovementItemId = inMovementItemId)    
    THEN
      UPDATE MovementItem_Loyalty_GUID SET GUID = inGUID WHERE MovementItem_Loyalty_GUID.MovementItemId = inMovementItemId;
    ELSE
      INSERT INTO MovementItem_Loyalty_GUID (MovementItemId, GUID) VALUES (inMovementItemId, inGUID);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.12.19                                                       *
*/