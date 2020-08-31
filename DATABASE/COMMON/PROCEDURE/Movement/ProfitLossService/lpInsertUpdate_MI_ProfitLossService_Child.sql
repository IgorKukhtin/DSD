-- Function: lpInsertUpdate_MI_ProfitLossService_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProfitLossService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProfitLossService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProfitLossService_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , -- ���� ������� 
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inJuridicalId         Integer   , -- ����������� ���� - �� ���� ��������� �������
    IN inJuridicalId_Child   Integer   , -- �� ���� ������
    IN inPartnerId           Integer   , -- ���������� ������
    IN inBranchId            Integer   , -- ������ (��� ����)
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAmount              TFloat    , -- �������������� ����� ����������
    IN inAmountPartner       TFloat    , -- ����� ������
    IN inSumm                TFloat    , -- ���� ��� ���������� 
    IN inMovementId_child    TFloat    , -- Id ��������� ������
    IN inOperDate            TDateTime , -- ���� ������� ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inJuridicalId, inMovementId, inAmount, inParentId);

     -- ��������� �������� <���� ������� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

     -- ��������� �������� <����� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <���� ��� ����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
     -- ��������� �������� <Id ��������� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_child);


     -- ��������� ����� � <�� ���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId_Child);

     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <���������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);

     -- ��������� ����� � <������ (��� ����)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, inBranchId);

      -- ��������� ��������
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProfitLossService_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
