-- Function: lpInsertUpdate_MovementItem_Income20202()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income20202 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income20202(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inPartionNumStart     TFloat    , -- ��������� � ��� ������ ������
    IN inPartionNumEnd       TFloat    , -- ��������� � ��� ������ ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNumStart(), ioId, inPartionNumStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNumEnd(), ioId, inPartionNumEnd);


     IF vbIsInsert = FALSE AND EXISTS (SELECT MovementItemString.MovementItemId FROM MovementItemString WHERE MovementItemString.ValueData = inPartionGoods AND MovementItemString.MovementItemId = ioId AND MovementItemString.DescId = zc_MIString_PartionGoodsCalc())
     THEN
         -- ��������� �������� <������ ������>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, '');
     ELSE
         -- ��������� �������� <������ ������>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
     END IF;

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- ������� ������ <����� ������ � ���� �������>
     PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.01.21         * 20202
 29.05.15                                        * set lp
 11.05.14                                        * add lpInsert_MovementItemProtocol
 06.10.13                                        * add lfCheck_Movement_Parent
 29.09.13                                        * add recalc inCountForPrice
 12.07.13          * lpInsertUpdate_MovementFloat_TotalSumm ���� lpInsertUpdate_MovementFloat_Income_TotalSumm    
 07.07.13                                        * add lpInsertUpdate_MovementFloat_Income_TotalSumm
 07.07.13                                        * add lpInsert_Object_GoodsByGoodsKind
 30.06.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Income20202 (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
