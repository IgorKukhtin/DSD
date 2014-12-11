-- Function: gpInsertUpdate_MI_ProductionPeresort()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPeresort  (Integer, Integer, Integer, TFloat, TVarChar,TVarChar, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPeresort(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
--    IN inPartionClose	     Boolean   , -- ������ ������� (��/���)        	
--    IN inCount	     TFloat    , -- ���������� ������� ��� �������� 
--    IN inRealWeight        TFloat    , -- ����������� ���(������������)
--    IN inCuterCount        TFloat    , -- ���������� �������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inComment             TVarChar  , -- �����������	                   
    IN inGoodsKindId         Integer   , -- ���� ������� 
--    IN inReceiptId         Integer   , -- ���������	


    IN inGoodsChildId        Integer   , -- ������

--    IN inParentId            Integer   , -- ������� ������� ���������
--    IN inAmountReceipt       TFloat    , -- ���������� �� ��������� �� 1 ����� 
--    IN inPartionGoodsDate    TDateTime , -- ������ ������	
    IN inPartionGoodsChild     TVarChar  , -- ������ ������        
--    IN inComment             TVarChar  , -- �����������
    IN inGoodsKindChildId    Integer   , -- ���� �������

                   
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbChildId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   
   IF COALESCE (ioId,0) <> 0
   THEN
      vbChildId := (SELECT Id FROM MovementItem where MovementId = inMovementId
                                                  AND DescId     = zc_MI_Child()
                                                  AND isErased   = FALSE);
   END IF;

   -- ��������� <Master>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inPartionClose     := ''::Boolean
                                                  , inCount            := NULL--0 ::TFloat
                                                  , inRealWeight       := NULL--0 ::TFloat
                                                  , inCuterCount       := NULL--0 ::TFloat
                                                  , inPartionGoods     := inPartionGoods
                                                  , inComment          := inComment
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inReceiptId        := NULL--0 ::integer
                                                  , inUserId           := vbUserId
                                                  );



   -- ��������� <Child>
   vbChildId := lpInsertUpdate_MI_ProductionUnion_Child(ioId          := vbChildId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsChildId
                                                 , inAmount           := inAmount
                                                 , inParentId         := ioId
                                                 , inAmountReceipt    := NULL--inAmountReceipt
                                                 , inPartionGoodsDate := NULL
                                                 , inPartionGoods     := inPartionGoods
                                                 , inComment          := NULL--'' ::TVarChar
                                                 , inGoodsKindId      := inGoodsKindChildId
                                                 , inUserId           := vbUserId
                                                 );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.14         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
