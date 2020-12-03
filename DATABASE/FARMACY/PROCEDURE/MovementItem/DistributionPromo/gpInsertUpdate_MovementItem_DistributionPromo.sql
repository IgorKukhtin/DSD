-- Function: gpInsertUpdate_MovementItem_DistributionPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_DistributionPromo (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_DistributionPromo(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsGroupId        Integer   , -- ������ �������
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
    ioId := lpInsertUpdate_MovementItem_DistributionPromo (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsGroupId       := inGoodsGroupId
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
 02.12.20                                                       *
*/