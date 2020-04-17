-- Function: gpUpdate_MI_Send_express2()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_express2 (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Send_express2 (Integer, Integer, Integer, TFloat,  TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_express2(
     IN inId                  Integer   , -- ���� ������� <������� ���������>
     IN inMovementId          Integer   , -- ���� ������� <��������>
     IN inGoodsId             Integer   , -- ������
     IN inAmount              TFloat    , -- ����������

  INOUT ioAmountExcess        TFloat,  -- ����. ������� � ������ ����������� (�� ����)
  INOUT ioAmountNeed          TFloat,  -- ����. ����������� � ������ ����������� (����)
  INOUT ioAmountSend_out      TFloat,  -- �������. ����. (���������)   - 1-�� ����
  INOUT ioAmountSend_in       TFloat,  -- �������. ������. (���������) - 2-�� ����
  
    IN inSession             TVarChar    -- ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount     Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession;
     
     -- �������� ����������� ��������
     vbAmount := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inId);
     
     -- �������� ����������� ����� �� ������ ��� ����
     inAmount := (CASE WHEN COALESCE (ioAmountExcess,0) + COALESCE (vbAmount,0) < inAmount THEN COALESCE (ioAmountExcess,0) + COALESCE (vbAmount,0) ELSE inAmount END) :: TFloat;
     
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

     -- ������������ ������ ��� 1-�� � 2-�� ����� (������� �� ����� ���������� ��������, � ��������� ������ �������)
     ioAmountNeed     := (COALESCE (ioAmountNeed,0)     - COALESCE (inAmount,0) + COALESCE (vbAmount,0)) ::TFloat;
     ioAmountExcess   := (COALESCE (ioAmountExcess,0)   - COALESCE (inAmount,0) + COALESCE (vbAmount,0)) ::TFloat;
     ioAmountSend_out := (COALESCE (ioAmountSend_out,0) + COALESCE (inAmount,0) - COALESCE (vbAmount,0)) ::TFloat;
     ioAmountSend_in  := (COALESCE (ioAmountSend_in,0)  + COALESCE (inAmount,0) - COALESCE (vbAmount,0)) ::TFloat;

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
