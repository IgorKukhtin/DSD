	
-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnOut(Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inParentId            Integer   , -- ������ �� ��������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN

     -- ������������ ������ �� MovementItem
     SELECT MI.Amount 
     INTO vbAmount
     FROM MovementItem AS MI 
     WHERE MI.Id = ioId;

     -- ��������
     IF COALESCE ((SELECT MovementBoolean_Deferred.ValueData FROM MovementBoolean AS MovementBoolean_Deferred
                   WHERE MovementBoolean_Deferred.MovementId = inMovementId
                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()), False) = TRUE 
        AND (COALESCE(inAmount, 0) <> COALESCE(vbAmount, 0))
     THEN
          RAISE EXCEPTION '������.�������� �������, ������������� ���������!';
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, inParentId);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
