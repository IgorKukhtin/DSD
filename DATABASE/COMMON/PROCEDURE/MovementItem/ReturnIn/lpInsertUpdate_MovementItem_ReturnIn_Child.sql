-- Function: lpInsertUpdate_MovementItem_ReturnIn_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inParentId            Integer   , -- ����
    IN inGoodsId             Integer   , -- �����
    IN inAmount              TFloat    , -- ����������
    IN inMovementId_sale     Integer   , -- 
    IN inMovementItemId_sale Integer   , -- 
    IN inUserId              Integer   , -- ������������
    IN inIsRightsAll         Boolean     -- 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId, CASE WHEN inIsRightsAll = TRUE THEN -12345 ELSE 0 END);

     -- ��������� �������� <Id ��������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_sale);

     -- ��������� �������� <Id �������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMovementItemId_sale);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 27.04.15         * add inMovementId
 11.05.14                                        * change ioCountForPrice
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.04.14                                        * rem ������� ������ <����� ������ � ���� �������>
 14.02.14                                                         * add ioCountForPrice
 13.02.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
