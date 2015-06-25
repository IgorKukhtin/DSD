-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- 
    IN inCuterCount          TFloat    , -- ����������
 INOUT ioAmount              TFloat    , -- ����������
    IN inCuterCountSecond    TFloat    , -- ���������� �������
 INOUT ioAmountSecond        TFloat    , -- ���������� �������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inReceiptId_basis     Integer   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <�����>.';
     END IF;
     -- ��������
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <��� ������>.';
     END IF;
     -- ��������
     IF ioId > 0
     THEN
         RAISE EXCEPTION '������.��������� ����� <�������� ��� ������>.';
     END IF;


     -- �����
     IF inReceiptId_basis > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = ioId AND MovementItemLinkObject.DescId = zc_MILinkObject_ReceiptBasis())
     vbMovementItemId:= (SELECT
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND (MovementItem.Amount     <> 0 OR MIFloat_AmountSecond.ValueData <> 0)
                           AND MovementItem.isErased   = FALSE)


     -- ������
     IF inReceiptId_basis > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = ioId AND MovementItemLinkObject.DescId = zc_MILinkObject_ReceiptBasis())
     THEN
         -- ������ <����������>
         SELECT COALESCE (ObjectFloat_Value.ValueData, 0) * inCuterCount
              , COALESCE (ObjectFloat_Value.ValueData, 0) * inCuterCountSecond
                INTO ioAmount, ioAmountSecond
         FROM (SELECT inReceiptId_basis AS ReceiptId) AS tmpReceipt
              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                    ON ObjectFloat_Value.ObjectId = inReceiptId_basis
                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
        ;
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);


     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);

     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), ioId, inCuterCount);

     -- ��������� �������� <���������� ������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCountSecond(), ioId, inCuterCountSecond);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, inReceiptId_basis);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
