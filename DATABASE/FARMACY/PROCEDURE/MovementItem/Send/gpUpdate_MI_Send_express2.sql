-- Function: gpUpdate_MI_Send_express2()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_express2 (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_express2(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession;
     
     -- ���������
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                 := inId
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := inGoodsId
                                             , inAmount             := inAmount
                                             , inAmountManual       := 0  ::TFloat
                                             , inAmountStorage      := 0  ::TFloat
                                             , inReasonDifferencesId:= 0
                                             , inUserId             := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  15.04.20        *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Send_express2 (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inUserId:= 2)
