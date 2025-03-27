 -- Function: gpInsertUpdate_MI_ProductionUnionTech()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer
                                                             , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer
                                                             , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnionTech (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, Integer, Integer
                                                             , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnionTech(
    IN inMovementItemId_order Integer   , -- ���� ������� <������� ���������>
 INOUT ioMovementItemId       Integer   , -- ���� ������� <������� ���������>
 INOUT ioMovementId           Integer   , -- ���� ������� <��������>
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inDocumentKindId       Integer   , -- ��� ��������� (� ���������)

    IN inReceiptId            Integer   , -- ���������
    IN inGoodsId              Integer   , -- ������
    IN inCount	              TFloat    , -- ���������� ������� ��� ��������
    IN inCountReal            TFloat    , -- ���������� ��. ���� ������ ��� ����� "�������"
    IN inRealWeight           TFloat    , -- ����������� ���(������������)
    IN inRealWeightMsg        TFloat    , -- ����������� ���(����� ���������)
    IN inRealWeightShp        TFloat    , -- ����������� ���(����� �����������)
    IN inCuterCount           TFloat    , -- ���������� �������  
    IN inCuterWeight          TFloat    , -- ��� �/� ����(������)

    IN inAmount               TFloat    , -- ���-�� ��.���� - !!!�������� ������ ���-�� ��������!!!
    IN inAmountForm           TFloat    , -- ���-�� ��������+1����,��
    IN inAmountForm_two       TFloat    , -- ���-�� ��������+2����,��

    IN inComment              TVarChar  , -- ����������
    IN inGoodsKindId          Integer   , -- ���� �������
    IN inGoodsKindCompleteId  Integer   , -- ���� �������  ��
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmount TFloat;
   DECLARE vbGoodsId_master Integer;
   DECLARE vbMeasureId_master Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnionTech());
   
   -- !!!��������!!!
   IF inCountReal <> 0 AND inFromId <> 2790412  -- ��� �������
                       AND inFromId <> 8449     -- ��� ������������ ������
   THEN
       RAISE EXCEPTION '������.��� ���� ��������� <���-�� ��.����> ��� ������������� <%>.', lfGet_Object_ValueData_sh (inFromId);
   END IF;


   -- !!!�������� �������� ������� ������ ��� <�������� �����>!!!
   IF EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND RoleId = 439522) -- �������� �����
   THEN
       IF  (SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, inSession) AS gpGet) - INTERVAL '2 DAY' > inOperDate
        OR (SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, inSession) AS gpGet) - INTERVAL '2 DAY' > COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioMovementId), zc_DateEnd())
       THEN
           RAISE EXCEPTION '������.������ ������ �� <%>.', zfConvert_DateToString ((SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, inSession) AS gpGet));
       END IF;
   END IF;

   -- �������� ��� ��� �������+���-��
   IF (inFromId <> inToId) OR (NOT EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = inFromId)
                           -- AND inFromId <> 951601 -- ��� �������� ����
                           AND inFromId <> 981821   -- ��� �����. ����
                           AND inFromId <> 2790412  -- ��� �������
                           AND inFromId <> 8020711  -- ��� ������� + ���������� (����)
                              )
   THEN
       RAISE EXCEPTION '������.��������� �������� ������ ��� ������������ <%>.', lfGet_Object_ValueData (8446);
   END IF;

   -- ��������
   IF COALESCE (inGoodsId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.�������� <�������� ������> �� �����������.';
   END IF;
   -- ��������
   IF COALESCE (inReceiptId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.�������� <�������� ���������> �� �����������.';
   END IF;


   -- ������ ��� ��.
   IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure() AND OL.DescId = zc_ObjectLink_Goods_Measure() AND OL.ChildObjectId = zc_Measure_Sh())
   THEN
       -- �������
       inCuterCount:= CASE WHEN COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inReceiptId AND OFl.DescId = zc_ObjectFloat_Receipt_PartionValue()), 0) > 0
                                THEN inAmount / (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inReceiptId AND OFl.DescId = zc_ObjectFloat_Receipt_PartionValue())
                           ELSE 0
                      END;
   END IF;

   -- ������������
   vbGoodsId_master:= COALESCE ((SELECT inGoodsId WHERE inGoodsId IN (2328   -- 5012;"������ ����.���."
                                                                    , 3150   -- 554;"��� �������������"
                                                                    , 5717   -- 5005;"�������� ������"
                                                                    , 6646   -- 5008;"���� ����. �����.�����"
                                                                    , 7129   -- 5011;"���� ����. �����.����."
                                                                    , 712542 -- 2359;"���� ����� �� � ����� �����."
                                                                    , 3011   -- 1500;���� ������-����� ���.�/�
                                                                    , 11853723 -- 97962715 ������ ��� ��������
                                                                     )), 0);
   -- ������������
   vbMeasureId_master:= (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inGoodsId AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure());

   -- ��������� <��������>
   IF COALESCE (ioMovementId, 0) = 0
   THEN ioMovementId:= lpInsertUpdate_Movement_ProductionUnion (ioId        := ioMovementId
                                                              , inInvNumber := NEXTVAL ('movement_productionunion_seq') :: TVarChar
                                                              , inOperDate  := inOperDate
                                                              , inFromId    := inFromId
                                                              , inToId      := inToId
                                                              , inDocumentKindId := inDocumentKindId
                                                              , inIsPeresort:= FALSE
                                                              , inUserId    := vbUserId
                                                               );
   ELSE
        -- 1. ����������� ��������
        PERFORM lpUnComplete_Movement (inMovementId := ioMovementId
                                     , inUserId     := vbUserId);

   END IF;


   -- ������� �������� Child
   CREATE TEMP TABLE _tmpChild (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindCompleteId Integer, Amount TFloat, AmountReceipt TFloat, Amount_master TFloat, isWeightMain Boolean, isTaxExit Boolean, isErased Boolean) ON COMMIT DROP;
   --
   WITH tmpMI_Child AS (SELECT MovementItem.Id                                  AS MovementItemId
                             , MovementItem.ObjectId                            AS GoodsId
                             , COALESCE (MILO_GoodsKind.ObjectId, 0)            AS GoodsKindId
                             , COALESCE (MILO_GoodsKindComplete.ObjectId, 0)    AS GoodsKindCompleteId
                             , MovementItem.Amount                              AS Amount
                             , COALESCE (MIFloat_AmountReceipt.ValueData, 0)    AS AmountReceipt
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                              ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                              ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                             AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                                         ON MIFloat_AmountReceipt.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()
                             /*LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                                           ON MIBoolean_WeightMain.MovementItemId =  MovementItem.Id
                                                          AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()*/
                        WHERE MovementItem.ParentId = ioMovementItemId
                          AND MovementItem.DescId   = zc_MI_Child()
                          AND MovementItem.isErased = FALSE
                       )
      , tmpReceiptChild AS
                       (SELECT COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                             , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                             , ObjectFloat_Value.ValueData                                    AS AmountReceipt
                             , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)              AS isTaxExit
                             , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE)           AS isWeightMain
                             , COALESCE (ObjectBoolean_Real.ValueData, FALSE)                 AS isReal
                             , ObjectFloat_Value_master.ValueData                             AS Amount_master
                        FROM ObjectLink AS ObjectLink_ReceiptChild_Receipt
                             INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                    ON ObjectFloat_Value_master.ObjectId = inReceiptId
                                                   AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                   AND ObjectFloat_Value_master.ValueData <> 0
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                  ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                  ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                             INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                   AND ObjectFloat_Value.ValueData <> 0
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                     ON ObjectBoolean_WeightMain.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                    AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                     ON ObjectBoolean_TaxExit.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                    AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Real
                                                     ON ObjectBoolean_Real.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                    AND ObjectBoolean_Real.DescId   = zc_ObjectBoolean_ReceiptChild_Real()

                             -- ���� ��-��
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_ReceiptLevel
                                                  ON ObjectLink_ReceiptChild_ReceiptLevel.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptChild_ReceiptLevel()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_From
                                                  ON ObjectLink_ReceiptLevel_From.ObjectId = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                 AND ObjectLink_ReceiptLevel_From.DescId   = zc_ObjectLink_ReceiptLevel_From()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_To
                                                  ON ObjectLink_ReceiptLevel_To.ObjectId = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                 AND ObjectLink_ReceiptLevel_To.DescId   = zc_ObjectLink_ReceiptLevel_To()
                             LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptLevel_MovementDesc
                                                   ON ObjectFloat_ReceiptLevel_MovementDesc.ObjectId  = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                  AND ObjectFloat_ReceiptLevel_MovementDesc.DescId    = zc_ObjectFloat_ReceiptLevel_MovementDesc()
                             --  ��� ����������
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel_DocumentKind
                                                  ON ObjectLink_ReceiptLevel_DocumentKind.ObjectId = ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId
                                                 AND ObjectLink_ReceiptLevel_DocumentKind.DescId   = zc_ObjectLink_ReceiptLevel_DocumentKind()

                        WHERE ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId
                          AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()

                          -- ������ ���� ��-�� ��� ��� ��� �����
                          AND (ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId IS NULL
                             OR (ObjectLink_ReceiptLevel_From.ChildObjectId      = inFromId
                             AND ObjectLink_ReceiptLevel_To.ChildObjectId        = inToId
                             AND ObjectFloat_ReceiptLevel_MovementDesc.ValueData = zc_Movement_ProductionUnion()
                                )
                              )
                          -- ��� ���� ����������
                          AND ObjectLink_ReceiptLevel_DocumentKind.ChildObjectId IS NULL
                       )
      , tmpReceipt_old AS
                       (SELECT MILO_Receipt.ObjectId AS ReceiptId
                        FROM MovementItemLinkObject AS MILO_Receipt
                        WHERE MILO_Receipt.MovementItemId = ioMovementItemId
                          AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                          AND MILO_Receipt.ObjectId <> inReceiptId
                       )
      , tmpReceiptChild_old AS
                       (SELECT COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                             , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                        FROM tmpReceipt_old
                             INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmpReceipt_old.ReceiptId
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                  ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                  ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                             INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                   AND ObjectFloat_Value.ValueData <> 0
                       )
        , tmpResult AS (SELECT COALESCE (tmpMI_Child.MovementItemId, 0)                            AS MovementItemId
                             , COALESCE (tmpMI_Child.GoodsId, tmpReceiptChild.GoodsId)             AS GoodsId
                             , COALESCE (tmpMI_Child.GoodsKindId, tmpReceiptChild.GoodsKindId)     AS GoodsKindId
                             , COALESCE (tmpMI_Child.GoodsKindCompleteId, 0)                       AS GoodsKindCompleteId
                             , CASE -- ���� �������� ��������� � ������ �� ����.��������� ��� � ����� ���������, ����� ����� �������� (!!!�� �������� �� ������!!!)
                                    WHEN tmpReceiptChild_old.GoodsId > 0 AND tmpReceiptChild.GoodsId IS NULL
                                         THEN tmpMI_Child.Amount
                                    -- ���� �������� ��������� - ��� ���-�� �� �����
                                    -- ��� ����� �������
                                    WHEN tmpReceipt_old.ReceiptId > 0
                                      OR tmpMI_Child.MovementItemId IS NULL
                                         THEN COALESCE (inCuterCount, 0) * COALESCE (tmpReceiptChild.AmountReceipt, 0)

                                    -- ���� <���������� �� ��������� �� 1 �����> � ���. ���� ������� = 0, ����� ��������� ���� �� Amount
                                    WHEN COALESCE (tmpMI_Child.AmountReceipt, -1) = 0
                                         THEN tmpMI_Child.Amount

                                    --
                                    WHEN vbMeasureId_master = zc_Measure_Sh()
                                     AND inCountReal > 0 AND tmpReceiptChild.isReal = TRUE
                                         THEN inCountReal * COALESCE (tmpMI_Child.AmountReceipt, 0) / tmpReceiptChild.Amount_master

                                    WHEN vbMeasureId_master = zc_Measure_Sh()
                                         THEN inAmount * COALESCE (tmpMI_Child.AmountReceipt, 0) / tmpReceiptChild.Amount_master

                                    ELSE COALESCE (inCuterCount, 0) * COALESCE (tmpMI_Child.AmountReceipt, 0) -- ����� �������� �� <���������� �� ��������� �� 1 �����> � ���.

                               END AS Amount

                             , CASE WHEN tmpReceiptChild_old.GoodsId > 0 AND tmpReceiptChild.GoodsId IS NULL -- ���� �������� ��������� � ������ �� ����.��������� ��� � ����� ���������, ����� ����� �������� (!!!�� �������� �� ������!!!)
                                         THEN tmpMI_Child.AmountReceipt
                                    WHEN tmpReceipt_old.ReceiptId > 0 -- ���� �������� ��������� - ��� ���-�� �� �����
                                      OR tmpMI_Child.MovementItemId IS NULL -- ��� ����� �������
                                         THEN COALESCE (tmpReceiptChild.AmountReceipt, 0)
                                    ELSE COALESCE (tmpMI_Child.AmountReceipt, 0) -- ����� ��������� ��� ��������� <���������� �� ��������� �� 1 �����> � ���.
                               END AS AmountReceipt

                             , COALESCE (tmpReceiptChild.isWeightMain, FALSE)                      AS isWeightMain
                             , COALESCE (tmpReceiptChild.isTaxExit, FALSE)                         AS isTaxExit
                             , CASE WHEN tmpReceiptChild_old.GoodsId > 0 AND tmpReceiptChild.GoodsId IS NULL THEN TRUE ELSE FALSE END AS isErased -- ���� �������� ��������� � ������ �� ����.��������� ��� � ����� ���������, ����� ����� ��������
                             , tmpReceiptChild.AmountReceipt AS AmountReceipt_calc
                             , tmpReceiptChild.Amount_master AS Amount_master_calc
                        FROM tmpMI_Child
                             LEFT JOIN tmpReceipt_old ON tmpReceipt_old.ReceiptId > 0
                             LEFT JOIN tmpReceiptChild_old ON tmpReceiptChild_old.GoodsId     = tmpMI_Child.GoodsId
                                                          AND tmpReceiptChild_old.GoodsKindId = tmpMI_Child.GoodsKindId
                             FULL JOIN tmpReceiptChild ON tmpReceiptChild.GoodsId     = tmpMI_Child.GoodsId
                                                      AND tmpReceiptChild.GoodsKindId = tmpMI_Child.GoodsKindId
                       )
        , tmpIsTaxExit AS (SELECT SUM (tmpResult.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                           FROM tmpResult
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = tmpResult.GoodsId
                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                      ON ObjectFloat_Weight.ObjectId = tmpResult.GoodsId
                                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                           WHERE tmpResult.isTaxExit = FALSE
                             AND tmpResult.isErased = FALSE
                          )
              
   -- ������������ ������ �� ��������� Child
   INSERT INTO _tmpChild (MovementItemId, GoodsId, GoodsKindId, GoodsKindCompleteId, Amount, AmountReceipt, Amount_master, isWeightMain, isTaxExit, isErased)
      SELECT tmpResult.MovementItemId
           , tmpResult.GoodsId
           , tmpResult.GoodsKindId
           , tmpResult.GoodsKindCompleteId
           , CASE WHEN tmpResult.isTaxExit = TRUE AND tmpResult.Amount_master_calc > 0
                       THEN tmpIsTaxExit.Amount * tmpResult.AmountReceipt_calc / tmpResult.Amount_master_calc
                  WHEN tmpResult.isTaxExit = TRUE
                       THEN 0
                  ELSE tmpResult.Amount
             END AS Amount

           , CASE WHEN tmpResult.isTaxExit = TRUE AND tmpResult.Amount_master_calc > 0
                       THEN tmpResult.AmountReceipt_calc
                  ELSE tmpResult.AmountReceipt
             END AS AmountReceipt

           , tmpIsTaxExit.Amount AS Amount_master

           , tmpResult.isWeightMain
           , tmpResult.isTaxExit
           , tmpResult.isErased
      FROM tmpResult
           LEFT JOIN tmpIsTaxExit ON 1 = 1
     ;


   -- ������� <����������� ������� ���������>
   PERFORM lpSetErased_MovementItem (_tmpChild.MovementItemId, vbUserId)
         , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), _tmpChild.MovementItemId, vbUserId)
         , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), _tmpChild.MovementItemId, CURRENT_TIMESTAMP)
   FROM _tmpChild WHERE _tmpChild.isErased = TRUE;


   -- ������ ��� ��.
   IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure() AND OL.ChildObjectId = zc_Measure_Sh())
   THEN
       -- ���-��
       vbAmount:= inAmount;
   ELSE
       -- ���-��
       vbAmount:= CASE WHEN vbGoodsId_master > 0
                            THEN inCuterCount * COALESCE ((SELECT ObjectFloat_Value.ValueData FROM ObjectFloat AS ObjectFloat_Value WHERE ObjectFloat_Value.ObjectId = inReceiptId AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()), 0)
                       ELSE (SELECT Amount_master FROM _tmpChild LIMIT 1)
                  END;
   END IF;


   -- ��������� <������� ������� ���������>
   ioMovementItemId:= lpInsertUpdate_MI_ProductionUnionTech_Master (ioId                 := ioMovementItemId
                                                                  , inMovementId         := ioMovementId
                                                                  , inGoodsId            := inGoodsId
                                                                  , inAmount             := COALESCE (vbAmount, 0)
                                                                  , inCount              := inCount
                                                                  , inCountReal          := inCountReal
                                                                  , inRealWeight         := inRealWeight
                                                                  , inRealWeightMsg      := inRealWeightMsg
                                                                  , inRealWeightShp      := inRealWeightShp
                                                                  , inCuterCount         := inCuterCount
                                                                  , inCuterWeight        := inCuterWeight 
                                                                  , inAmountForm         := inAmountForm
                                                                  , inAmountForm_two     := inAmountForm_two
                                                                  , inComment            := inComment
                                                                  , inGoodsKindId        := inGoodsKindId
                                                                  , inGoodsKindCompleteId:= inGoodsKindCompleteId
                                                                  , inReceiptId          := inReceiptId
                                                                  , inUserId             := vbUserId
                                                                   );
   -- ��������� ��-�� <�� ��������� ��������>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_OrderSecond(), tmp.MovementItemId, CASE WHEN MIFloat_AmountSecond.ValueData > 0 THEN TRUE ELSE FALSE END)
   FROM (SELECT ioMovementItemId AS MovementItemId) AS tmp
        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                    ON MIFloat_AmountSecond.MovementItemId = inMovementItemId_order
                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond();


   -- ��������� <����������� ������� ���������>
   UPDATE _tmpChild SET MovementItemId = lpInsertUpdate_MI_ProductionUnionTech_Child (ioId                 := _tmpChild.MovementItemId
                                                                                    , inMovementId         := ioMovementId
                                                                                    , inGoodsId            := _tmpChild.GoodsId
                                                                                    , inAmount             := COALESCE (_tmpChild.Amount, 0)
                                                                                    , inParentId           := ioMovementItemId
                                                                                    , inAmountReceipt      := _tmpChild.AmountReceipt
                                                                                    , inPartionGoodsDate   := CASE WHEN _tmpChild.MovementItemId > 0 THEN (SELECT MovementItemDate.ValueData FROM MovementItemDate WHERE MovementItemDate.MovementItemId = _tmpChild.MovementItemId AND MovementItemDate.DescId = zc_MIDate_PartionGoods()) ELSE NULL END
                                                                                    , inComment            := CASE WHEN _tmpChild.MovementItemId > 0 THEN (SELECT MovementItemString.ValueData FROM MovementItemString WHERE MovementItemString.MovementItemId = _tmpChild.MovementItemId AND MovementItemString.DescId = zc_MIString_Comment()) ELSE NULL END
                                                                                    , inGoodsKindId        := _tmpChild.GoodsKindId
                                                                                    , inGoodsKindCompleteId:= _tmpChild.GoodsKindCompleteId
                                                                                    , inUserId             := vbUserId
                                                                                     )
   WHERE _tmpChild.isErased = FALSE;


   -- ��������� ��-�� �� ��������� <������ � ����� ��� �����> + <������� �� % ������>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), _tmpChild.MovementItemId, _tmpChild.isWeightMain)
         , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), _tmpChild.MovementItemId, _tmpChild.isTaxExit)
   FROM _tmpChild
   WHERE _tmpChild.isErased = FALSE;


   -- !!!��������� ��-�� <���������> � ������!!!
   IF inMovementItemId_order <> 0
   THEN
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), MovementItem_f.Id, inReceiptId)
       FROM MovementItem
            INNER JOIN MovementItemLinkObject AS MILO_Goods
                                              ON MILO_Goods.MovementItemId = MovementItem.Id
                                             AND MILO_Goods.DescId = zc_MILinkObject_Goods()
            INNER JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                              ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            INNER JOIN MovementItem AS MovementItem_f ON MovementItem_f.MovementId = MovementItem.MovementId
                                                     AND MovementItem_f.DescId = zc_MI_Master()
            INNER JOIN MovementItemLinkObject AS MILO_Goods_f
                                              ON MILO_Goods_f.MovementItemId = MovementItem_f.Id
                                             AND MILO_Goods_f.DescId         = zc_MILinkObject_Goods()
                                             AND MILO_Goods_f.ObjectId       = MILO_Goods.ObjectId
            INNER JOIN MovementItemLinkObject AS MILO_GoodsKindComplete_f
                                              ON MILO_GoodsKindComplete_f.MovementItemId = MovementItem_f.Id
                                             AND MILO_GoodsKindComplete_f.DescId         = zc_MILinkObject_GoodsKindComplete()
                                             AND MILO_GoodsKindComplete_f.ObjectId       = MILO_GoodsKindComplete.ObjectId
       WHERE MovementItem.Id = inMovementItemId_order;
   END IF;


   -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
   PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
   -- �������� ��������
   PERFORM lpComplete_Movement_ProductionUnion (inMovementId    := ioMovementId
                                              , inIsHistoryCost := TRUE
                                              , inUserId        := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.03.25         * inAmountForm_two
 30.07.24         * inAmountForm
 13.06.16         *
 21.03.15                                        *all
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 12.12.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnionTech (ioId:= 0, ioMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
