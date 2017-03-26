-- Function: gpInsertUpdate_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StoreReal (Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_StoreReal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StoreReal());
	    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_StoreReal (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := inAmount
                                                , inGoodsKindId        := inGoodsKindId
                                                , inUserId             := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 25.03.17         *
*/

-- ����
-- 