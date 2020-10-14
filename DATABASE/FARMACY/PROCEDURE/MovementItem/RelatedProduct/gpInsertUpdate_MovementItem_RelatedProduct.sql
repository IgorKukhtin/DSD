-- Function: gpInsertUpdate_MovementItem_RelatedProduct()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RelatedProduct (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_RelatedProduct(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inIsChecked           Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_RelatedProduct (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsId            := inGoodsId
                                                      , inAmount             := (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat
                                                      , inUserId             := vbUserId
                                                      );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.10.20                                                       *
*/