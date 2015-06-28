-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
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


     -- ����� - 1
     vbMovementItemId:= (SELECT MovementItem.Id
                         FROM MovementItem
                              INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                               AND MILinkObject_Goods.ObjectId = inGoodsId
                              INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                                               AND MILinkObject_GoodsKindComplete.ObjectId = inGoodsKindId
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                           AND (MovementItem.Amount <> 0 OR MIFloat_AmountSecond.ValueData <> 0)
                        );
     -- ����� - 2
     IF COALESCE (vbMovementItemId, 0) = 0
     THEN
          vbMovementItemId:= (SELECT MovementItem.Id
                              FROM MovementItem
                                   INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                                    AND MILinkObject_Goods.ObjectId = inGoodsId
                                   INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                     ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                                                    AND MILinkObject_GoodsKindComplete.ObjectId = inGoodsKindId
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId = zc_MI_Master()
                                AND MovementItem.isErased = FALSE
                              LIMIT 1
                             );
     END IF;
     -- ��������
     IF COALESCE (vbMovementItemId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� �� ������.';
     END IF;


     -- ������
     IF inReceiptId_basis > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = vbMovementItemId AND MovementItemLinkObject.DescId = zc_MILinkObject_ReceiptBasis())
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


     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, ioAmount, NULL)
     FROM MovementItem
     WHERE MovementItem.Id = vbMovementItemId;

     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), vbMovementItemId, ioAmountSecond);

     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), vbMovementItemId, inCuterCount);
     -- ��������� �������� <���������� ������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCountSecond(), vbMovementItemId, inCuterCountSecond);

     -- ��������� ����� � <���������> : ���� + ���������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), MovementItem.Id, inReceiptId_basis)
     FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                            ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                           AND MILinkObject_Goods.ObjectId = inGoodsId
          INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                            ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                           AND MILinkObject_GoodsKindComplete.ObjectId = inGoodsKindId
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
     ;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);

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
