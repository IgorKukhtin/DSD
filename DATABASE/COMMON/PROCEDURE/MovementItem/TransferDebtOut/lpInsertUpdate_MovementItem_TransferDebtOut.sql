-- Function: gpInsertUpdate_MovementItem_TransferDebtOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TransferDebtOut(integer, integer, integer, tfloat, tfloat, tfloat, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TransferDebtOut(integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, integer, integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TransferDebtOut(
 INOUT ioId                  Integer   , -- ���� ������� <������� ��������� ������� ����� (������)>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inBoxCount            TFloat    , -- ���������� ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inBoxId               Integer   , -- �����
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);
     
     -- ��������� �������� <���������� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inPrice AS NUMERIC (16, 2))
                      END;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.01.15         * add inBoxCount, inBoxId
 11.05.14                                        * all
 07.05.14                                        * add lpInsert_MovementItemProtocol
 05.05.14                                        * del zc_MIFloat_AmountPartner
 22.04.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_TransferDebtOut (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, inCountForPrice:= 1, inGoodsKindId:= 0, inUserId:=5)