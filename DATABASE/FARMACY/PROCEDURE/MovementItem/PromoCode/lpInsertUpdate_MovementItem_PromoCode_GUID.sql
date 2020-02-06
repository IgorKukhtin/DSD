-- Function: lpInsertUpdate_MovementItem_PromoCode_GUID()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoCode_GUID (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoCode_GUID(
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

    IF EXISTS(SELECT 1 FROM MovementItem_PromoCode_GUID WHERE MovementItem_PromoCode_GUID.MovementItemId = inMovementItemId)    
    THEN
      UPDATE MovementItem_PromoCode_GUID SET GUID = inGUID WHERE MovementItem_PromoCode_GUID.MovementItemId = inMovementItemId;
    ELSE
      INSERT INTO MovementItem_PromoCode_GUID (MovementItemId, GUID) VALUES (inMovementItemId, inGUID);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.20                                                       *
*/