-- Function: gpUpdate_MI_ProductionUnionTech_Child()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnionTech_Child(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId              Integer   , -- ������
 INOUT ioAmount               TFloat    , -- ����������
    IN inParentId             Integer   , -- ������� ������� ���������
 INOUT ioAmountReceipt        TFloat    , -- ���������� �� ��������� �� 1 �����
   OUT outAmount_master       TFloat    , -- ���������� � zc_MI_Master
   OUT outAmountWeight        TFloat    , -- 
   OUT outAmountReceiptWeight TFloat    , -- 
   OUT outIsWeightMain        Boolean   ,
   OUT outIsTaxExit           Boolean   ,
   OUT outGroupNumber         Integer   ,
    IN inPartionGoodsDate     TDateTime , -- ������ ������
    IN inGoodsKindId          Integer   , -- ���� �������      
    IN inGoodsKindCompleteId  Integer   , -- ���� ������� ��         
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbReceiptId Integer;
   DECLARE vbCuterCount TFloat;

   DECLARE vbFromId Integer;
   DECLARE vbToId   Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech_Child());


   -- �������� - ���� �� ����� inParentId + inMovementId
   IF inMovementId <> 0 AND NOT EXISTS (SELECT Id FROM MovementItem WHERE Id = inParentId AND MovementId = inMovementId)
   THEN
       RAISE EXCEPTION '������.MovementId.';
   END IF;

   -- ���� inParentId - ��� ������� - ������
   IF NOT EXISTS (SELECT MovementItem.Id FROM MovementItem INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() WHERE MovementItem.Id = inParentId)
   THEN
       RAISE EXCEPTION '������.������ �� <��������> �� ������������.';
   END IF;
   -- ���� ������ inGoodsId
   IF ioId > 0 AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.ObjectId = inGoodsId)
   THEN
       RAISE EXCEPTION '������.��� ���� �������� �����.';
   END IF;


   -- �������� ��� ��� �������+���-��
   vbFromId:= COALESCE ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From()), 0);
   vbToId  := COALESCE ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To())  , 0);
   IF (vbFromId <> vbToId) OR (NOT EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = vbFromId)
                           AND vbFromId <> 981821   -- ��� �����. ����
                           AND vbFromId <> 2790412  -- ��� �������
                           AND vbFromId <> 8020711  -- ��� ������� + ���������� (����)
                              )
   THEN
       RAISE EXCEPTION '������.��������� �������� ������ ��� ������������ <%>.', lfGet_Object_ValueData (8446);
   END IF;


   -- ������������ <ReceiptId>
   vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
   -- ������������ <ReceiptId>
   vbReceiptId:= (SELECT MILO_Receipt.ObjectId FROM MovementItemLinkObject AS MILO_Receipt WHERE MILO_Receipt.MovementItemId = inParentId AND MILO_Receipt.DescId = zc_MILinkObject_Receipt());

   -- ������������ <���������� �������>
   vbCuterCount:= (SELECT MIFloat_CuterCount.ValueData FROM MovementItemFloat AS MIFloat_CuterCount WHERE MIFloat_CuterCount.MovementItemId = inParentId AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount());
   -- ��������
   IF COALESCE (vbCuterCount, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <���������� �������> �� ����������.';
   END IF;


   -- ������, ������ ��� �������
   IF ioId > 0
   THEN
       IF COALESCE (ioAmountReceipt, 0) <> COALESCE ((SELECT MIFloat_AmountReceipt.ValueData FROM MovementItemFloat AS MIFloat_AmountReceipt WHERE MIFloat_AmountReceipt.MovementItemId = ioId AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()), 0)
         OR EXISTS (SELECT MIBoolean_TaxExit.ValueData FROM MovementItemBoolean AS MIBoolean_TaxExit WHERE MIBoolean_TaxExit.MovementItemId =  ioId AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit() AND MIBoolean_TaxExit.ValueData = TRUE)
       THEN ioAmount:= vbCuterCount * ioAmountReceipt; -- ���� ������� <���������� �� ��������� �� 1 �����> ����� ������ <����������>
       ELSE IF COALESCE (ioAmount, 0) <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0)
            THEN ioAmountReceipt:= 0; -- ���� ������� <����������> ����� ���������� <���������� �� ��������� �� 1 �����>
            END IF;
       END IF;
   ELSE
       IF ioAmountReceipt <> 0
       THEN ioAmount:= vbCuterCount * ioAmountReceipt; -- ���� ������� <���������� �� ��������� �� 1 �����> ����� ������ <����������>
       END IF;
   END IF;

   IF vbStatusId = zc_Enum_Status_Complete()
   THEN
       -- 1. ����������� ��������
       PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                    , inUserId     := vbUserId);
   END IF;

   -- ���������
   ioId:= lpInsertUpdate_MI_ProductionUnionTech_Child (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inGoodsId            := inGoodsId
                                                     , inAmount             := ioAmount
                                                     , inParentId           := inParentId
                                                     , inAmountReceipt      := ioAmountReceipt
                                                     , inPartionGoodsDate   := inPartionGoodsDate
                                                     , inComment            := inComment
                                                     , inGoodsKindId        := inGoodsKindId
                                                     , inGoodsKindCompleteId := inGoodsKindCompleteId
                                                     , inUserId             := vbUserId
                                                      );
   -- ������ ����� �������� + ��������
   IF EXISTS (SELECT 1 FROM ObjectLink AS ObjectLink_Goods_InfoMoney WHERE ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_10202(), zc_Enum_InfoMoney_10203())
                                                                       AND ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                                          )
   THEN 
       PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), ioId, TRUE);
   END IF;



   -- �������� ���-�� ��� zc_MI_Master + �������� ��-�� <����������> ��� ��� � ���� isTaxExit=TRUE
   SELECT tmp.ioAmount, tmp.outAmount_master
          INTO ioAmount, outAmount_master
   FROM lpUpdate_MI_ProductionUnionTech_Recalc (inMovementId         := inMovementId
                                              , inMovementItemId     := ioId
                                              , inParentId           := inParentId
                                              , inReceiptId          := vbReceiptId
                                              , inIsTaxExit          := COALESCE ((SELECT MIBoolean_TaxExit.ValueData FROM MovementItemBoolean AS MIBoolean_TaxExit WHERE MIBoolean_TaxExit.MovementItemId = ioId AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()), FALSE)
                                              , ioAmount             := ioAmount
                                              , inAmountReceipt      := ioAmountReceipt
                                              , inUserId             := vbUserId
                                               ) AS tmp;

   -- ���������� ��������� (��� �����)
   SELECT CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_Child.GoodsId
                                                            , inGoodsKindId            := tmpMI_Child.GoodsKindId
                                                            , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                            , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                            , inIsWeightMain           := COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                                                            , inIsTaxExit              := COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                                                             )
                    THEN ioAmount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                ELSE 0
          END AS AmountWeight
        , CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_Child.GoodsId
                                                            , inGoodsKindId            := tmpMI_Child.GoodsKindId
                                                            , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                            , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                            , inIsWeightMain           := COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                                                            , inIsTaxExit              := COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                                                             )
                    THEN ioAmountReceipt * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
               ELSE 0
          END AS AmountReceiptWeight
        , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := tmpMI_Child.GoodsId
                                         , inGoodsKindId            := tmpMI_Child.GoodsKindId
                                         , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                         , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                         , inIsWeightMain           := COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                                         , inIsTaxExit              := COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                                          ) AS GroupNumber
        , COALESCE (MIBoolean_WeightMain.ValueData, FALSE) AS isWeightMain
        , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)    AS isTaxExit
          INTO outAmountWeight, outAmountReceiptWeight
             , outGroupNumber
             , outIsWeightMain, outIsTaxExit
   FROM (SELECT inGoodsId AS GoodsId, inGoodsKindId AS GoodsKindId) AS tmpMI_Child
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                              ON ObjectFloat_Weight.ObjectId = tmpMI_Child.GoodsId
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = tmpMI_Child.GoodsId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                             ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Child.GoodsId
                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
        LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                      ON MIBoolean_TaxExit.MovementItemId =  ioId
                                     AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
        LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                      ON MIBoolean_WeightMain.MovementItemId =  ioId
                                     AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()
  ;


   -- ���� ��� ��������
   IF vbStatusId = zc_Enum_Status_Complete()
   THEN
        -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
        PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
        -- �������� ��������
        PERFORM lpComplete_Movement_ProductionUnion (inMovementId    := inMovementId
                                                   , inIsHistoryCost := TRUE
                                                   , inUserId        := vbUserId);
   END IF;

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.test Admin';
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.11.15         * inGoodsKindCompleteId
 21.03.15                                        *all
 19.12.14                                                       * add zc_MILinkObject_???GoodsKindComplete
 12.12.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_ProductionUnionTech_Child (ioId:= 0, ioMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
