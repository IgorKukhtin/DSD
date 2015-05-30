-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check(Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbAmount TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := inSession;

     -- ������� ������� �� ��������� � ������

     SELECT Id, Amount INTO vbId, vbAmount 
       FROM MovementItem WHERE MovementId = inMovementId AND ObjectId = inGoodsId AND DescId = zc_MI_Master();

     vbAmount := COALESCE(vbAmount, 0) + inAmount;

     -- ��������� <������� ���������>
     vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Master(), inGoodsId, inMovementId, vbAmount, NULL);

     IF inAmount > 0 THEN
        -- ��������� �������� <����>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, inPrice);
     END IF;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
