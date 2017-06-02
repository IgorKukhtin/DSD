-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inStorageLineId       Integer   , -- ����� ��-��
    IN inAmount              TFloat    , -- ����������
    IN inLiveWeight          TFloat    , -- ����� ���
    IN inHeadCount           TFloat    , -- ���������� �����	           
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionSeparate());

   -- ��������� <������� ���������>
   ioId :=lpInsertUpdate_MI_ProductionSeparate_Master (ioId               := ioId
                                                     , inMovementId       := inMovementId
                                                     , inGoodsId          := inGoodsId
                                                     , inGoodsKindId      := inGoodsKindId
                                                     , inStorageLineId    := inStorageLineId
                                                     , inAmount           := inAmount
                                                     , inLiveWeight       := inLiveWeight
                                                     , inHeadCount        := inHeadCount
                                                     , inUserId           := vbUserId
                                                      );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.17         *
 11.06.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Master(ioId := 71587375 , inMovementId := 5264082 , inGoodsId := 5225 , inGoodsKindId := 8331 , inStorageLineId := 0 , inAmount := 0.2 , inLiveWeight := 0 , inHeadCount := 0 ,  inSession := '5');
