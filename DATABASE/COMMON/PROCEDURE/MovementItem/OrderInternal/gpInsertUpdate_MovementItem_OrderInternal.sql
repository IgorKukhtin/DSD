-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, TVarChar);

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
    IN inIsPack              Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbToId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <�����>.';
     END IF;
     
     --������ �� �����
     SELECT MovementLinkObject_To.ObjectId AS ToId
   INTO vbToId
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


     -- �������� + �������� �����������
     IF COALESCE (inGoodsKindId, 0) = 0 AND NOT EXISTS (SELECT MovementId 
                                                        FROM MovementLinkObject 
                                                        WHERE DescId = zc_MovementLinkObject_From() 
                                                          AND MovementId = inMovementId AND ( ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp) -- 8446 ��� �������+���-�� 
                                                                                          OR (ObjectId = 8451 AND vbToId = 8455))   --  8451 "��� ��������"  8455 ����� ������ - ��� ���� ������
                                                       )
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <��� ������> ��� <%>.', lfGet_Object_ValueData (inGoodsId);
     END IF;
     -- ��������
     IF ioId > 0 AND inIsPack = FALSE
     THEN
         RAISE EXCEPTION '������.��������� ����� <�������� ��� ������>.';
     END IF;


     IF inIsPack = TRUE
     THEN
          vbMovementItemId:= ioId;
     ELSE
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
     END IF;

     -- ��������
     IF COALESCE (vbMovementItemId, 0) = 0 AND 1=0
     THEN
         RAISE EXCEPTION '������.������� �� ������.';
     END IF;


     -- ������
     IF inIsPack = FALSE -- inReceiptId_basis > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = vbMovementItemId AND MovementItemLinkObject.DescId = zc_MILinkObject_ReceiptBasis())
     THEN
         -- ������ <����������>
         SELECT COALESCE (ObjectFloat_TaxExit.ValueData, 0) * inCuterCount
              , COALESCE (ObjectFloat_TaxExit.ValueData, 0) * inCuterCountSecond
                INTO ioAmount, ioAmountSecond
         FROM (SELECT inReceiptId_basis AS ReceiptId) AS tmpReceipt
              LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                    ON ObjectFloat_TaxExit.ObjectId = inReceiptId_basis
                                   AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
        ;
     END IF;


     -- ��������� �������� !!!�� ���������!!!
     IF vbMovementItemId > 0 THEN PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE); END IF;

     -- ��������� <������� ���������>
     IF vbMovementItemId > 0
     THEN
         PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, ioAmount, NULL)
         FROM MovementItem
         WHERE MovementItem.Id = vbMovementItemId;
     ELSE
         ioId:= lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, ioAmount, NULL);
         vbMovementItemId:= ioId;
     END IF;

     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), vbMovementItemId, ioAmountSecond);

     IF inIsPack = FALSE
     THEN
          -- ��������� �������� <���������� �������>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), vbMovementItemId, inCuterCount);
          -- ��������� �������� <���������� ������� �������>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCountSecond(), vbMovementItemId, inCuterCountSecond);

          -- ��������� ����� � <���������> : ���� + ���������
          /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), MovementItem.Id, inReceiptId_basis)
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
          ;*/
     END IF;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� !!!����� ���������!!!
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.06.15                                        * all
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
