-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, TFloat, Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inCount_onCount       TFloat    , -- ���������� �������
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inPartionGoodsDate    TDateTime , -- ������ ������	
    IN inPartionGoods        TVarChar  , -- ������ ������        
 INOUT ioPartNumber          TVarChar  , -- � �� ��� ��������
 INOUT ioModel               TVarChar  , -- ������
    IN inGoodsKindId         Integer   , -- ���� ������� 
    IN inGoodsKindCompleteId Integer   , -- ���� ������� ��
    IN inStorageId           Integer   , -- ����� ��������           
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- ��������� 
   ioId := lpInsertUpdate_MI_ProductionUnion_Child(ioId               := ioId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsId
                                                 , inAmount           := inAmount
                                                 , inParentId         := inParentId
                                                 , inPartionGoodsDate := inPartionGoodsDate
                                                 , inPartionGoods     := inPartionGoods 
                                                 , inPartNumber       := ioPartNumber
                                                 , inModel            := ioModel
                                                 , inGoodsKindId      := inGoodsKindId
                                                 , inGoodsKindCompleteId := inGoodsKindCompleteId  
                                                 , inStorageId        := inStorageId
                                                 , inCount_onCount    := inCount_onCount -- COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_Count()), 0)
                                                 , inUserId           := vbUserId
                                                 );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.05.23         * Model
 07.11.15         * add inGoodsKindCompleteId
 21.03.15                                        * all
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Child
 24.07.13                                        * ����� ������� �����
 15.07.13         *     
 30.06.13                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
