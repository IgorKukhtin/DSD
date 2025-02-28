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
   DECLARE vbCuterCount TFloat;
   DECLARE vbValue_Receipt TFloat;
   DECLARE vbGoodsId_master Integer;
BEGIN
      -- ������������ <���������� �������>
      vbCuterCount:= COALESCE ((SELECT MIFloat_CuterCount.ValueData FROM MovementItemFloat AS MIFloat_CuterCount WHERE MIFloat_CuterCount.MovementItemId = inParentId AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()), 0);
      -- ������������
      vbValue_Receipt:= COALESCE ((SELECT ObjectFloat_Value.ValueData FROM ObjectFloat AS ObjectFloat_Value WHERE ObjectFloat_Value.ObjectId = inReceiptId AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()), 0);
      -- ������������
      vbGoodsId_master:= COALESCE ((SELECT MovementItem.ObjectId
                                    FROM MovementItem
                                    WHERE MovementItem.Id = inParentId
                                      AND MovementItem.ObjectId IN (2328   -- 5012;"������ ����.���."
                                                                  , 3150   -- 554;"��� �������������"
                                                                  , 5717   -- 5005;"�������� ������"
                                                                  , 6646   -- 5008;"���� ����. �����.�����"
                                                                  , 7129   -- 5011;"���� ����. �����.����."
                                                                  , 712542 -- 2359;"���� ����� �� � ����� �����."
                                                                  , 3011   -- 1500;���� ������-����� ���.�/�
                                                                  , 11853723 -- 97962715 ������ ��� ��������
                                                                   )
                                   ), 0);
      

        -- �������� ���-�� ��� zc_MI_Master
        outAmount_master = CASE -- ���  �������
                               WHEN EXISTS (SELECT 1 FROM MovementItem JOIN ObjectLink AS OL ON OL.ObjectId = MovementItem.ObjectId AND OL.ChildObjectId = zc_Enum_InfoMoney_30102() AND OL.DescId = zc_ObjectLink_Goods_InfoMoney() WHERE MovementItem.Id = inParentId)
                                    THEN (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inParentId)
                               -- ���  ���� ����. �����.
                               WHEN vbGoodsId_master > 0
                                    THEN vbCuterCount * vbValue_Receipt
                               ELSE
                               -- ��� ���������
                  (SELECT SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal
                                                                 (inGoodsId                := MovementItem.ObjectId
                                                                , inGoodsKindId            := MILO_GoodsKind.ObjectId
                                                                , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                                , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                                , inIsWeightMain           := COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                                                                , inIsTaxExit              := COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                                                                 )
                                        THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                    ELSE 0
                               END
                               )
                                        
                   FROM MovementItem
                        LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                         ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                        LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                                      ON MIBoolean_TaxExit.MovementItemId = MovementItem.Id
                                                     AND MIBoolean_TaxExit.DescId         = zc_MIBoolean_TaxExit()
                                                     AND MIBoolean_TaxExit.ValueData      = TRUE
                        LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                                      ON MIBoolean_WeightMain.MovementItemId = MovementItem.Id
                                                     AND MIBoolean_WeightMain.DescId         = zc_MIBoolean_WeightMain()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                   WHERE MovementItem.ParentId   = inParentId
                     AND MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Child()
                     AND MovementItem.isErased   = FALSE
                     AND MIBoolean_TaxExit.MovementItemId IS NULL
                  )
                          END;

       -- !!!��������� ��-�� <����������> � zc_MI_Master!!!
       PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId, outAmount_master, MovementItem.ParentId)
       FROM MovementItem
       WHERE MovementItem.Id = inParentId;


       -- !!!�������� ��-�� <����������> ��� ��� � ���� isTaxExit=TRUE!!! (���������� ����� �������� ��-�� � �������� isTaxExit=FALSE)
       PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId
                                          , CASE WHEN vbValue_Receipt = 0
                                                      THEN 0
                                                 WHEN MovementItem.Id = inMovementItemId
                                                      THEN -- ���� ��� ������� ������� ���������������, ����� ������������ <���������� �� ��������� �� 1 �����> � ���.
                                                           CASE WHEN MIFloat_CountReal.ValueData > 0 AND tmpReceiptChild.isReal = TRUE THEN MIFloat_CountReal.ValueData ELSE outAmount_master END
                                                         * inAmountReceipt / vbValue_Receipt
                                                 ELSE -- ��� ��������� ������������ <���������� �� ��������� �� 1 �����> � ���. ��� ��-�� �� <���������>
                                                      CASE WHEN MIFloat_CountReal.ValueData > 0 AND tmpReceiptChild.isReal = TRUE THEN MIFloat_CountReal.ValueData ELSE outAmount_master END
                                                    * COALESCE (MIFloat_AmountReceipt.ValueData, tmpReceiptChild.Value, 0) / vbValue_Receipt
                                             END
                                          , MovementItem.ParentId)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReceipt(), MovementItem.Id, COALESCE (MIFloat_AmountReceipt.ValueData, tmpReceiptChild.Value, 0))
             , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), MovementItem.Id, COALESCE (tmpReceiptChild.isTaxExit, MIBoolean_TaxExit.ValueData, FALSE))
             , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), MovementItem.Id, inUserId)
             , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), MovementItem.Id, CURRENT_TIMESTAMP)
       FROM MovementItem
            LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                          ON MIBoolean_TaxExit.MovementItemId =  MovementItem.Id
                                         AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                        ON MIFloat_AmountReceipt.MovementItemId =  MovementItem.Id
                                       AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()
            LEFT JOIN MovementItemFloat AS MIFloat_CountReal
                                        ON MIFloat_CountReal.MovementItemId =  MovementItem.ParentId
                                       AND MIFloat_CountReal.DescId = zc_MIFloat_CountReal()
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN (SELECT COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                            , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                            , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)              AS isTaxExit
                            , COALESCE (ObjectBoolean_Real.ValueData, FALSE)                 AS isReal
                            , ObjectFloat_Value.ValueData                                    AS Value
                       FROM ObjectLink AS ObjectLink_ReceiptChild_Receipt
                            INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                    AND Object_ReceiptChild.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                 ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                 ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                            INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                   ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                  AND ObjectFloat_Value.ValueData <> 0

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                    ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                                   AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Real
                                                    ON ObjectBoolean_Real.ObjectId = Object_ReceiptChild.Id 
                                                   AND ObjectBoolean_Real.DescId = zc_ObjectBoolean_ReceiptChild_Real()

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
         AND vbGoodsId_master = 0 -- !!!������ ���� ������ �� �� ���-�� �������!!!
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
 03.08.15                                        * add !!!������ ���� ������ �� �� ���-�� �������!!!
 04.05.15                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_MI_ProductionUnionTech_Recalc (inMovementItemId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
