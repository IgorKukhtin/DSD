-- Function: gpInsertUpdate_MovementItem_OrderInternal()

-- DROP FUNCTION gpInsertUpdate_MovementItem_OrderInternal();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountSecond        TFloat    , -- ���������� �������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbReceiptId_parent  Integer;
   DECLARE vbGoodsId_parent  Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbCuterCount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);

     -- ������ <���������� �������>
     SELECT ReceiptId_parent
          , GoodsId_parent
          , (CAST (AmountOrder / (PartionValue * PartionCount) AS NUMERIC (16, 0)) + 1) * PartionCount AS CuterCount
            INTO vbReceiptId_parent, vbGoodsId_parent, vbCuterCount
     FROM (SELECT ObjectLink_Receipt_Parent.ChildObjectId AS ReceiptId_parent
                , ObjectLink_Receipt_Goods_parent.ChildObjectId AS GoodsId_parent
                , COALESCE (inAmount, 0) + COALESCE (inAmountSecond, 0) AS AmountOrder
                , CASE WHEN ObjectFloat_PartionCount.ValueData > 0 THEN ObjectFloat_PartionCount.ValueData ELSE 0.5 END AS PartionCount
                , ObjectFloat_Value.ValueData AS PartionValue
           FROM ObjectLink AS ObjectLink_Receipt_Goods
                INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                     AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                     AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                         ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                        AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                        AND ObjectBoolean_Main.ValueData = TRUE
                INNER JOIN ObjectFloat AS ObjectFloat_Value
                                       ON ObjectFloat_Value.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
                                      AND ObjectFloat_Value.ValueData <> 0
                LEFT JOIN ObjectFloat AS ObjectFloat_PartionCount
                                      ON ObjectFloat_PartionCount.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                     AND ObjectFloat_PartionCount.DescId = zc_ObjectFloat_Receipt_PartionCount()

                INNER JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                      ON ObjectLink_Receipt_Parent.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                     AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                      ON ObjectLink_Receipt_Goods_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                     AND ObjectLink_Receipt_Goods_parent.DescId = zc_ObjectLink_Receipt_Goods()

           WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
             AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
          ) AS tmp
     WHERE AmountOrder > 0;

     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), ioId, COALESCE (vbCuterCount, 0));

     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, vbReceiptId_parent);
     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, vbGoodsId_parent);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, vbUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

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
