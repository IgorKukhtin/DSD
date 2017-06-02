-- Function: gpInsertUpdate_MI_ProductionSeparate_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inParentId            Integer   , -- ������� ������� ���������
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
   ioId :=lpInsertUpdate_MI_ProductionSeparate_Child (ioId               := ioId
                                                    , inMovementId       := inMovementId
                                                    , inParentId         := inParentId
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
 11.03.17         *
 11.06.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Child(ioId := 71593051 , inMovementId := 5264082 , inParentId := 0 , inGoodsId := 4261 , inGoodsKindId := 0 , inStorageLineId := 0 , inAmount := 157.6 , inLiveWeight := 0 , inHeadCount := 0 ,  inSession := '5');
