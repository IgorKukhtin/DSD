-- Function: lpUpdate_MI_ProductionUnionTech_Recalc()

DROP FUNCTION IF EXISTS lpUpdate_MI_ProductionUnionTech_Recalc (Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_ProductionUnionTech_Recalc(
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , -- ���� ������� <������� ���������>
    IN inReceiptId           Integer   , -- 
    IN inIsTaxExit           Boolean   ,
 INOUT ioAmount              TFloat    , -- ����������
    IN inAmountReceipt       TFloat    , -- ���������� �� ��������� �� 1 �����
   OUT outAmount_master      TFloat    , -- ���������� � zc_MI_Master
    IN inUserId              Integer     -- ������������
)                              
RETURNS RECORD
AS
$BODY$
BEGIN
       -- �������� ���-�� ��� zc_MI_Master
       outAmount_master =
                  (SELECT SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                   FROM MovementItem
                        LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                                      ON MIBoolean_TaxExit.MovementItemId =  MovementItem.Id
                                                     AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
                                                     AND MIBoolean_TaxExit.ValueData = TRUE
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                   WHERE MovementItem.ParentId = inParentId
                     AND MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Child()
                     AND MovementItem.isErased = FALSE
                     AND MIBoolean_TaxExit.MovementItemId IS NULL
                  );

       -- !!!��������� ��-�� <����������> � zc_MI_Master!!!
       PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, outAmount_master, MovementItem.ParentId)
       FROM MovementItem
       WHERE MovementItem.Id = inParentId;


       -- !!!�������� ��-�� <����������> ��� ��� � ���� isTaxExit=TRUE!!! (���������� ����� �������� ��-�� � �������� isTaxExit=FALSE)
       PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId
                                          , CASE WHEN MovementItem.Id = inMovementItemId -- ���� ��� ������� ������� ���������������, ����� ������������ <���������� �� ��������� �� 1 �����> � ���.
                                                      THEN outAmount_master * inAmountReceipt / tmpReceiptChild.Value_master
                                                 WHEN tmpReceiptChild.Value_master <> 0 -- ��� ��������� ������������ ��-�� �� <���������>
                                                      THEN outAmount_master * tmpReceiptChild.Value / tmpReceiptChild.Value_master
                                                 ELSE 0
                                             END
                                          , MovementItem.ParentId)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReceipt(), MovementItem.Id, tmpReceiptChild.Value)
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), MovementItem.Id, COALESCE (tmpReceiptChild.isTaxExit, FALSE))
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), MovementItem.Id, inUserId)
             , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), MovementItem.Id, CURRENT_TIMESTAMP)
       FROM MovementItem
            LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                          ON MIBoolean_TaxExit.MovementItemId =  MovementItem.Id
                                         AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN (SELECT COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                            , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                            , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)              AS isTaxExit
                            , ObjectFloat_Value.ValueData                                    AS Value
                            , ObjectFloat_Value_master.ValueData                             AS Value_master
                      FROM ObjectLink AS ObjectLink_ReceiptChild_Receipt
                            INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                    AND Object_ReceiptChild.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                 ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                 ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                            INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                   ON ObjectFloat_Value_master.ObjectId = inReceiptId
                                                  AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                  AND ObjectFloat_Value_master.ValueData <> 0
                            INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                   ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                  AND ObjectFloat_Value.ValueData <> 0

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                    ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                                   AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                       WHERE ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId
                         AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                      ) AS tmpReceiptChild ON tmpReceiptChild.GoodsId = MovementItem.ObjectId
                                          AND tmpReceiptChild.GoodsKindId = COALESCE (MILO_GoodsKind.ObjectId, 0)
       WHERE MovementItem.ParentId = inParentId
         AND MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Child()
         AND MovementItem.isErased = FALSE
         AND (MIBoolean_TaxExit.ValueData = TRUE -- ������ �� ��� ���� isTaxExit=TRUE
           OR tmpReceiptChild.isTaxExit = TRUE   -- ������ �� ��� �� <���������> isTaxExit=TRUE
             )
         AND (MovementItem.Id = inMovementItemId OR inIsTaxExit = FALSE) -- ���� ��� ������� isTaxExit=TRUE, ����� ��������� ������������� �� ����
        ;
        IF inIsTaxExit = TRUE
        THEN
            -- ��� �������� isTaxExit=TRUE, ���-�� ������ ���������, ������� ���������� ��� ����������� ����
            ioAmount:= (SELECT Amount FROM MovementItem WHERE Id = inMovementItemId);
        END IF;


       -- ����������� �������� ����� �� ���������
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.05.15                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_MI_ProductionUnionTech_Recalc (inMovementItemId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
