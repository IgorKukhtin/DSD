-- Function: gpInsertUpdate_MovementItem_LoyaltyPresent()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LoyaltyPresent (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LoyaltyPresent(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inIsChecked           Boolean   , -- �������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_LoyaltyPresent (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsId            := inGoodsId
                                                      , inAmount             := (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat
                                                      , inComment            := inComment
                                                      , inUserId             := vbUserId
                                                      );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.09.20                                                       *
*/