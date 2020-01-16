-- Function: gpInsert_MovementItem_LoyaltySaveMoney_Cash()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_LoyaltySaveMoney_Cash (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_LoyaltySaveMoney_Cash(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBuyerID             Integer   , -- ����� ������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �� �������� �����.';
    END IF;
    
    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = vbUserId)
    THEN 
      SELECT MovementItem.ID 
      INTO ioId
      FROM MovementItem 
      WHERE MovementItem.MovementId = inMovementId 
        AND MovementItem.ObjectId = vbUserId;
    ELSE

      -- ���������
      ioId := lpInsertUpdate_MovementItem_LoyaltySaveMoney  (ioId                 := ioId
                                                           , inMovementId         := inMovementId
                                                           , inBuyerID            := inBuyerID
                                                           , inComment            := ''
                                                           , inUnitID             := vbUnitId
                                                           , inUserId             := vbUserId
                                                           );
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.01.20                                                       *
*/