-- Function: gpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, TFloat, TDateTime, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, TFloat, TDateTime, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsMainId         Integer   , -- ������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����
    IN inPrice               TFloat    , -- !!!���� ������������!!!
    IN inPartionGoodsDate    TDateTime , -- ������ ������
    IN inRemains             TFloat    , -- �������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
BEGIN

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsMainId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���� ������������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE (inPrice, 0));

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- ��������� ����� � <������� �� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);

     -- ��������� �������� <����������>
     IF NOT (inRemains IS NULL) THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), ioId, inRemains);
     END IF;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.15                         *
 19.09.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PriceList (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
