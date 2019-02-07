-- Function: lpInsertUpdate_MovementItem_Send_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send_Value(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_MovementItem_Send (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountManual       := 0  ::TFloat
                                          , inAmountStorage      := 0  ::TFloat
                                          , inReasonDifferencesId:= 0
                                          , inUserId             := inUserId
                                           ) AS tmp);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 29.07.15                                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Send_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inUserId:= 2)
