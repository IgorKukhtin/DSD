-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inFEA                 TVarChar  , -- �� ���
    IN inMeasure             TVarChar  , -- ��. ���������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_FEA(), ioId, inFEA);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Measure(), ioId, inMeasure);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.03.14                        *
 07.12.14                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
