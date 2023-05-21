-- Function: gpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- ����������
    IN inCount	               TFloat    , -- ���������� �������
    IN inCuterWeight	       TFloat    , -- ����������� ���(�������)
    IN inPartionGoodsDate      TDateTime , -- ������ ������
    IN inPartionGoods          TVarChar  , -- ������ ������ 
 INOUT ioPartNumber            TVarChar  , -- � �� ��� �������� 
 INOUT ioModel                 TVarChar  , -- ������
    IN inGoodsKindId           Integer   , -- ���� �������
    IN inGoodsKindId_Complete  Integer   , -- ���� ������� ��
    IN inStorageId             Integer   , -- ����� ��������
    IN inPersonalId_KVK        Integer   , -- 
    IN inKVK                   TVarChar   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- ��������� <������� ���������>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId                  := ioId
                                                  , inMovementId          := inMovementId
                                                  , inGoodsId             := inGoodsId
                                                  , inAmount              := inAmount
                                                  , inCount               := inCount
                                                  , inCuterWeight         := inCuterWeight
                                                  , inPartionGoodsDate    := inPartionGoodsDate
                                                  , inPartionGoods        := inPartionGoods
                                                  , inPartNumber          := ioPartNumber
                                                  , inModel               := ioModel
                                                  , inGoodsKindId         := inGoodsKindId
                                                  , inGoodsKindId_Complete:= inGoodsKindId_Complete
                                                  , inStorageId           := inStorageId
                                                  , inUserId              := vbUserId
                                                   );

     -- ��������� ����� � <�������� ���(�.�.�)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalKVK(), ioId, inPersonalId_KVK);
     -- ��������� �������� <� ���>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_KVK(), ioId, inKVK);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.05.23         * inModel
 06.05.23         *
 26.10.20         * add inGoodsKindId_Complete
 29.06.16         * add inCuterWeight
 12.06.15                                        * add inPartionGoodsDate
 21.03.15                                        * all
 19.12.14                                                       * add zc_MILinkObject_???GoodsKindComplete
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Master

 24.07.13                                        * ����� ������� �����
 22.07.13         * add GoodsKind
 17.07.13         *
 30.06.13                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
