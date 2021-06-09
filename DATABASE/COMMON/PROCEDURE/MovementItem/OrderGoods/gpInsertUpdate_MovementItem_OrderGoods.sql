-- Function: gpInsertUpdate_MovementItem_OrderGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderGoods(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    IN inGoodsKindId            Integer   , -- ���� �������
    IN inAmount                 TFloat    , -- ����������
    IN inPrice                  TFloat    , --
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderGoods());

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_OrderGoods (ioId           := ioId
                                                     , inMovementId   := inMovementId
                                                     , inGoodsId      := inGoodsId
                                                     , inGoodsKindId  := inGoodsKindId
                                                     , inAmount       := inAmount
                                                     , inPrice        := inPrice
                                                     , inComment      := inComment
                                                     , inUserId       := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.21         *
*/

-- ����
--