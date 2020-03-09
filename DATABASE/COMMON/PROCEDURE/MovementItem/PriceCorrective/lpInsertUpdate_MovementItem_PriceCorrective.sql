-- Function: gpInsertUpdate_MovementItem_PriceCorrective()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceCorrective(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceCorrective(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <������� ��������� ������� ����� (������)>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ���� -  �� ������� ��������������("+"����������� ��� "-"�������������) 
    IN inPriceTax_calc       TFloat    , -- ���� ������� (����.) - ������������, ������� ��������������
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inGoodsKindId         Integer   , -- ���� �������
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

     -- ��������� �������� <���� ������� (����.)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc(), ioId, inPriceTax_calc);

     -- ��������� �������� <���� ������� (�����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTo(), ioId, inPriceTax_calc - inPrice);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

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
 30.05.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_PriceCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, inCountForPrice:= 1, inGoodsKindId:= 0, inUserId:=5)
