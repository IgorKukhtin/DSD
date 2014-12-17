

-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, TVarChar,TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inAmountReceipt       TFloat    , -- ���������� �� ��������� �� 1 ����� 
    IN inPartionGoodsDate    TDateTime , -- ������ ������	
    IN inPartionGoods        TVarChar  , -- ������ ������        
    IN inComment             TVarChar  , -- �����������
    IN inGoodsKindId         Integer   , -- ���� �������            
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- ������ ��������
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

   -- ��������� 
   ioId := lpInsertUpdate_MI_ProductionUnion_Child(ioId               := ioId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsId
                                                 , inAmount           := inAmount
                                                 , inParentId         := inParentId
                                                 , inAmountReceipt    := inAmountReceipt
                                                 , inPartionGoodsDate := inPartionGoodsDate
                                                 , inPartionGoods     := inPartionGoods
                                                 , inComment          := inComment
                                                 , inGoodsKindId      := inGoodsKindId
                                                 , inUserId           := vbUserId
                                                 );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Child
 24.07.13                                        * ����� ������� �����
 15.07.13         *     
 30.06.13                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
