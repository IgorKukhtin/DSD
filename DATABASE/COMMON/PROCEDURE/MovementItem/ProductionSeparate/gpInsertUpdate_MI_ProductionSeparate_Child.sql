-- Function: gpInsertUpdate_MI_ProductionSeparate_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inGoodsId             Integer   , -- ������
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
 11.06.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inHeadCount:= 1, inComment:= '', inSession:= '2')
