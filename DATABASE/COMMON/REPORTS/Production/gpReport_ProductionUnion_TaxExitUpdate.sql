-- Function: gpReport_ProductionUnion_TaxExitUpdate () - <������������ � ������� ������ (�����) or (��������)>

--DROP FUNCTION IF EXISTS gpReport_ProductionUnion_TaxExitUpdate (TDateTime, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ProductionUnion_TaxExitUpdate (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ProductionUnion_TaxExitUpdate (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ProductionUnion_TaxExitUpdate (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ProductionUnion_TaxExitUpdate (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProductionUnion_TaxExitUpdate (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionUnion_TaxExitUpdate (
    IN inStartDate      TDateTime ,
    IN inEndDate        TDateTime ,
    IN inFromId         Integer   ,
    IN inToId           Integer   ,  
    IN inParam          Integer   ,
    IN inIsList         Boolean   , --��� ������ - ������ �� �����
    IN inIsListReport   Boolean   , --��� ������ - ������ �� ����� � ������
    IN inIsNotPartion   Boolean   , -- ������������ ������ (��/���)
    IN inIsTerm         Boolean   , --
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId_Complete Integer, GoodsKindName_Complete TVarChar, MeasureName TVarChar
             , PartionGoodsDate TDateTime
             , RealDelicShp TFloat
             , RealWeightShp_calc TFloat
             , AmountShp_diff TFloat
             , Amount_Humidity TFloat
             , TaxLossVPR TFloat
             , TaxLossVPR_fact TFloat
             , TaxLoss_diff TFloat
             , AmountReceipt TFloat
             , RealWeightMsg_calc TFloat
             , AmountMsg_diff TFloat
             , TaxLossCEH TFloat
             , TaxLossCEH_fact TFloat
             , TaxLossCEH_diff TFloat
             , AmountTRM_befor_plan TFloat
             , AmountTRM_befor_fact TFloat
             , AmountTRM_befor_diff TFloat
             , TaxLossTRM TFloat
             , TaxLossTRM_fact TFloat
             , TaxLossTRM_diff TFloat
             , TaxExit TFloat
             , TaxExit_fact TFloat
             , TaxExit_diff TFloat
             , Amount_GP_in TFloat
             , ValueGP TFloat, ValuePF TFloat
             , ValueGP_diff TFloat, ValuePF_diff TFloat

             , CuterCount_inf  TFloat  -- �������� ����
             , CuterCount_calcinf  TFloat -- �������� ���� (������)
             , RealWeightShpinf    TFloat  -- ��� �/� ���� (���)
             , RealWeightShp_calcinf  TFloat   -- ��� �/� ����� ����������� (������)

             , Amountinf       TFloat   -- ���� ���-��
             , Amount_inf_calc TFloat   -- ���� ���-��

             , RealWeightMsg_inf TFloat  --��� �/� ���� (���)
             , RealWeightMsg_calcinf     TFloat    --��� �/� ����� ��������� (������)
             , Amount_outinf  TFloat   -- ����������� �/� (������), ��
             , RealWeight_inf  TFloat     -- ��� �/� ����
             --��������� �����
             , Amount_main_det     TFloat   --���-�� ����
             , AmountMain_part_det TFloat   --����������� �/� (������), ��
             , Part_main_det       TFloat   --����
             , isPrint    Boolean           --
             , ContainerId Integer
           )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF zfConvert_StringToNumber (inSession) < 0
     THEN
         vbUserId:= -1 * zfConvert_StringToNumber (inSession);
     ELSE
         vbUserId:= lpGetUserBySession (inSession);
     END IF;

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- ���������
    RETURN QUERY

    WITH -- ������� �/� ��
         tmpMI_WorkProgress_in AS
                     (SELECT MIContainer.MovementId                  AS MovementId
                           , MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                             -- ������������ ������ (��/���)
                           , CASE WHEN inIsNotPartion = FALSE THEN COALESCE (CLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                             --
                           , CASE WHEN MIContainer.IsActive = TRUE THEN MIContainer.Amount ELSE 0 END AS Amount
                      FROM MovementItemContainer AS MIContainer
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                           LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                     ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                    AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                    AND MovementBoolean_Peresort.ValueData = TRUE
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        --
                        AND MIContainer.WhereObjectId_Analyzer = inFromId
                        -- ��� �������
                        AND MIContainer.ObjectExtId_Analyzer   = inFromId
                        --
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0
                        -- !!!������ �����������!!!
                        AND MovementBoolean_Peresort.MovementId IS NULL
                        --
                        AND (MIContainer.ObjectIntId_Analyzer IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis()) -- ����������� ��� ��� �/� ��
                              -- !!!�����������!!!
                          /*OR (MIContainer.WhereObjectId_Analyzer = 951601 -- ��� �������� ����
                          AND MIContainer.AnalyzerId             = 951601 -- ��� �������� ����
                            )*/)
                        AND inIsList = FALSE

                    UNION
                      SELECT MIContainer.MovementId                  AS MovementId
                           , MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                             -- ������������ ������ (��/���)
                           , CASE WHEN inIsNotPartion = FALSE THEN COALESCE (CLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                             --
                           , CASE WHEN MIContainer.IsActive = TRUE THEN MIContainer.Amount ELSE 0 END AS Amount
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN (SELECT DISTINCT OP.ObjectId AS MovementId FROM Object_Print AS OP WHERE OP.UserId = vbUserId) AS tmpOP ON tmpOP.MovementId = MIContainer.MovementId
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                           LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                     ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                    AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                    AND MovementBoolean_Peresort.ValueData = TRUE
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        --
                        AND MIContainer.WhereObjectId_Analyzer = inFromId
                        -- ��� �������
                        AND MIContainer.ObjectExtId_Analyzer   = inFromId
                        --
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0
                        -- !!!������ �����������!!!
                        AND MovementBoolean_Peresort.MovementId IS NULL
                        --
                        AND (MIContainer.ObjectIntId_Analyzer IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis()) -- ����������� ��� ��� �/� ��
                            )
                        AND inIsList = TRUE
                      )
         -- ������� �/� �� - ��� � �������� ������ ������� ��� � tmpMI_WorkProgress_in
       , tmpMI_WorkProgress_find AS
                     (SELECT MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                             -- ������������ ������ (��/���)
                           , CASE WHEN inIsNotPartion = FALSE THEN COALESCE (CLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                             --
                           , COALESCE (MIContainer.ObjectIntId_Analyzer, zc_GoodsKind_Basis()) AS GoodsKindId_Complete
                      FROM ObjectDate AS ObjectDate_PartionGoods_Value
                           INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                          ON CLO_PartionGoods.ObjectId = ObjectDate_PartionGoods_Value.ObjectId
                                                         AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                           INNER JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = CLO_PartionGoods.ContainerId
                                                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                         AND CLO_Unit.ObjectId = inFromId
                           INNER JOIN Container ON Container.Id = CLO_PartionGoods.ContainerId AND Container.DescId = zc_Container_Count()
                           LEFT JOIN tmpMI_WorkProgress_in ON tmpMI_WorkProgress_in.ContainerId = CLO_PartionGoods.ContainerId

                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = Container.Id
                                                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                           AND MIContainer.IsActive = FALSE
                                                           AND MIContainer.Amount <> 0
                           LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId

                      WHERE ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                        AND ObjectDate_PartionGoods_Value.ValueData BETWEEN inStartDate AND inEndDate
                        AND tmpMI_WorkProgress_in.ContainerId IS NULL
                        --���� ������ ������ �� ����� �� ��� �����
                        AND inIsList = FALSE
                      GROUP BY MIContainer.ContainerId
                             , MIContainer.ObjectId_Analyzer
                             , CASE WHEN inIsNotPartion = FALSE THEN COALESCE (CLO_PartionGoods.ObjectId, 0) ELSE 0 END
                             , MIContainer.ObjectIntId_Analyzer
                     )
         -- ������� �/� �� - �������������
       , tmpMI_WorkProgress_in_group AS (SELECT tmpMI_WorkProgress_in.ContainerId, tmpMI_WorkProgress_in.GoodsId, tmpMI_WorkProgress_in.PartionGoodsId
                                         FROM tmpMI_WorkProgress_in
                                         GROUP BY tmpMI_WorkProgress_in.ContainerId, tmpMI_WorkProgress_in.GoodsId, tmpMI_WorkProgress_in.PartionGoodsId

                                        UNION
                                         SELECT tmpMI_WorkProgress_find.ContainerId, tmpMI_WorkProgress_find.GoodsId, tmpMI_WorkProgress_find.PartionGoodsId
                                         FROM tmpMI_WorkProgress_find
                                         GROUP BY tmpMI_WorkProgress_find.ContainerId, tmpMI_WorkProgress_find.GoodsId, tmpMI_WorkProgress_find.PartionGoodsId
                                        )
         -- ������� �/� �� � ������� ParentId
       , tmpMI_WorkProgress_out AS
                     (SELECT MIContainer.ParentId
                           , tmpMI_WorkProgress_in_group.ContainerId
                           -- , 0 AS ContainerId
                           , tmpMI_WorkProgress_in_group.GoodsId
                           , tmpMI_WorkProgress_in_group.PartionGoodsId
                           , SUM (MIContainer.Amount) AS Amount
                      FROM tmpMI_WorkProgress_in_group
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpMI_WorkProgress_in_group.ContainerId
                                                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                           AND MIContainer.IsActive = FALSE
                     GROUP BY MIContainer.ParentId
                            , tmpMI_WorkProgress_in_group.ContainerId
                            , tmpMI_WorkProgress_in_group.GoodsId
                            , tmpMI_WorkProgress_in_group.PartionGoodsId
                     )
      /*
         -- ������������� �� ������
       , tmpUnit_oth AS (-- "������� ������� �����", �� ���������� - !!!�����������!!!
                         SELECT tmpSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8439) AS tmpSelect
                         WHERE inFromId NOT IN (951601, 981821) -- ��� �������� ���� + ��� �����. ����
                           AND tmpSelect.UnitId NOT IN (133049)-- "����� ���������� ����"
                        UNION
                         -- "��� �������+���-��"
                         SELECT tmpSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmpSelect
                        UNION
                         -- "��� ������� + ���������� (����)"
                         SELECT 8020711 AS UnitId
                        )
         -- ������� �/� �� � ������� ParentId - ���� ��� ���� �� "�����������"
       , tmpMI_WorkProgress_oth AS   ----����������� �/� (������), ��
                     (SELECT tmpMI_WorkProgress_out.ContainerId
                           , -1 * SUM (tmpMI_WorkProgress_out.Amount) AS Amount
                      FROM tmpMI_WorkProgress_out
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.Id = tmpMI_WorkProgress_out.ParentId
                           INNER JOIN tmpUnit_oth ON tmpUnit_oth.UnitId = MIContainer.WhereObjectId_Analyzer
                     GROUP BY tmpMI_WorkProgress_out.ContainerId
                     )
        */
         -- ������� �� � ������� GoodsId (�/� ��) + GoodsKindId_Complete + !!!���� "������������ ��"!!!
       , tmpMI_GP_in AS
                     (SELECT tmpMI_WorkProgress_out.ContainerId
                           , tmpMI_WorkProgress_out.GoodsId
                           , tmpMI_WorkProgress_out.PartionGoodsId
                           , COALESCE (MIContainer.ObjectIntId_Analyzer, zc_GoodsKind_Basis()) AS GoodsKindId_Complete

                           , SUM (MIContainer.Amount)             AS Amount
                           , SUM (CASE WHEN ObjectFloat_Value_master.ValueData <> 0 THEN COALESCE (ObjectFloat_Value_child.ValueData, 0) * MIContainer.Amount / ObjectFloat_Value_master.ValueData ELSE 0 END) AS AmountReceipt

                           , MAX (MIContainer.ContainerId) AS ContainerId_test
                      FROM tmpMI_WorkProgress_out
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.Id = tmpMI_WorkProgress_out.ParentId
                                                           AND MIContainer.WhereObjectId_Analyzer <> inFromId -- !!!���� "������������ ��"!!!
                           /*LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                         ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()*/
                           LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                            ON MILO_Receipt.MovementItemId = MIContainer.MovementItemId
                                                           AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value_master
                                                 ON ObjectFloat_Value_master.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()

                           LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                                ON ObjectLink_Receipt_Parent.ObjectId = MILO_Receipt.ObjectId
                                               AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                           LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                                ON ObjectLink_Receipt_Goods_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                               AND ObjectLink_Receipt_Goods_parent.DescId = zc_ObjectLink_Receipt_Goods()

                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                               AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                           INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                 ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                                AND ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId -- !!!�.�. ����� - ��� �� �����!!!
                           INNER JOIN ObjectFloat AS ObjectFloat_Value_child
                                                  ON ObjectFloat_Value_child.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectFloat_Value_child.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                 AND ObjectFloat_Value_child.ValueData <> 0

                        /*LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId*/

                      /*WHERE ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId
                         OR (inFromId = 951601 -- ��� �������� ����
                             AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                            )*/
                      GROUP BY tmpMI_WorkProgress_out.ContainerId
                             , tmpMI_WorkProgress_out.GoodsId
                             , tmpMI_WorkProgress_out.PartionGoodsId
                             , MIContainer.ObjectIntId_Analyzer
                     )
         -- ��������� - ������������
       , tmpMI_WorkProgress_in_gr AS
                     (SELECT tmpMI_WorkProgress_in.ContainerId
                           , tmpMI_WorkProgress_in.GoodsId
                           , tmpMI_WorkProgress_in.PartionGoodsId
                           --, STRING_AGG (tmpMI_WorkProgress_in.MovementId :: TVarChar, ';') AS MovementId
                           , tmpMI_WorkProgress_in.MovementId
                           , COALESCE (MILO_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_Complete

                           , COALESCE (ObjectFloat_TaxExit.ValueData, 0)    AS TaxExit
                             -- ***��� �/� (��)
                           , COALESCE (ObjectFloat_ValuePF.ValueData, 0)    AS ValuePF

                           , (COALESCE (ObjectFloat_RealDelicShp.ValueData,0)) AS RealDelicShp
                           , (COALESCE (ObjectFloat_TaxLossVPR.ValueData,0))   AS TaxLossVPR
                           , (COALESCE (ObjectFloat_TaxLossCEH.ValueData,0))   ::TFloat AS TaxLossCEH
                           , (COALESCE (ObjectFloat_TaxLossTRM.ValueData,0))   ::TFloat AS TaxLossTRM

                           , SUM (tmpMI_WorkProgress_in.Amount)                 AS Amount
                           , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))   AS CuterCount
                             -- ����������� ���(������������)
                           , SUM (COALESCE (MIFloat_RealWeight.ValueData, 0))   AS RealWeight
                             -- ����������� ��� ����� ���������
                           , SUM (COALESCE (MIFloat_RealWeightMsg.ValueData,0)) AS RealWeightMsg
                             -- 	����������� ��� ����� �����������	
                           , SUM (COALESCE (MIFloat_RealWeightShp.ValueData,0)) AS RealWeightShp

                           , MAX (COALESCE (MIString_Comment.ValueData, ''))    AS Comment

                             -- ���������� ��� ������ - �������.  � ����� ������ /������, ����� ����� ���� ���� �� ������ �� ���� ��������, � �������� ������� ����� * (-1)
                           , COALESCE (MIFloat_AmountNext_out.ValueData,0) * (-1)  AS Amount_out

                      FROM tmpMI_WorkProgress_in
                           LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                       ON MIFloat_CuterCount.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                       ON MIFloat_RealWeight.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeightMsg
                                                       ON MIFloat_RealWeightMsg.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_RealWeightMsg.DescId = zc_MIFloat_RealWeightMsg()

                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeightShp
                                                       ON MIFloat_RealWeightShp.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_RealWeightShp.DescId = zc_MIFloat_RealWeightShp()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountNext_out
                                                       ON MIFloat_AmountNext_out.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_AmountNext_out.DescId = zc_MIFloat_AmountNext_out()
                                                    --AND vbUserId <> 5

                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                            ON MILO_GoodsKindComplete.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                           AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                           LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                            ON MILO_Receipt.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                           AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN MovementItemString AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                                 ON ObjectFloat_TaxExit.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
                           LEFT JOIN ObjectFloat AS ObjectFloat_ValuePF
                                                 ON ObjectFloat_ValuePF.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_ValuePF.DescId = zc_ObjectFloat_Receipt_ValuePF()  --zc_ObjectFloat_Receipt_TotalWeight()   --����� ��������   ***��� �/� (��)

                           LEFT JOIN ObjectFloat AS ObjectFloat_RealDelicShp
                                                 ON ObjectFloat_RealDelicShp.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_RealDelicShp.DescId = zc_ObjectFloat_Receipt_RealDelicShp()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxLossVPR
                                                 ON ObjectFloat_TaxLossVPR.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TaxLossVPR.DescId = zc_ObjectFloat_Receipt_TaxLossVPR()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxLossCEH
                                                 ON ObjectFloat_TaxLossCEH.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TaxLossCEH.DescId = zc_ObjectFloat_Receipt_TaxLossCEH()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxLossTRM
                                                 ON ObjectFloat_TaxLossTRM.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TaxLossTRM.DescId = zc_ObjectFloat_Receipt_TaxLossTRM()

                          -- LEFT JOIN tmpMI_WorkProgress_oth ON tmpMI_WorkProgress_oth.ContainerId = tmpMI_WorkProgress_in.ContainerId
                      GROUP BY tmpMI_WorkProgress_in.ContainerId
                             , tmpMI_WorkProgress_in.GoodsId
                             , tmpMI_WorkProgress_in.PartionGoodsId
                             , COALESCE (MILO_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis())
                             , COALESCE (ObjectFloat_TaxExit.ValueData, 0)
                             , COALESCE (ObjectFloat_ValuePF.ValueData, 0)
                             , tmpMI_WorkProgress_in.MovementId
                             , COALESCE (MIFloat_AmountNext_out.ValueData,0)
                             , (COALESCE (ObjectFloat_RealDelicShp.ValueData,0))
                             , (COALESCE (ObjectFloat_TaxLossVPR.ValueData,0))
                             , (COALESCE (ObjectFloat_TaxLossCEH.ValueData,0))
                             , (COALESCE (ObjectFloat_TaxLossTRM.ValueData,0))
                     )

         -- ����������� ������������ ��������
       , tmpMI_detail AS (WITH tmpMI AS (SELECT tmpMovement.MovementId, tmpMovement.ContainerId, tmpMovement.Amount_out
                                              , MovementItem.Id
                                              , COALESCE (MovementItem.Amount,0) AS Amount
                                              , SUM (COALESCE (MovementItem.Amount,0)) OVER (PARTITION BY MovementItem.MovementId) AS TotalAmount
                                         FROM (SELECT DISTINCT tmp.MovementId, tmp.ContainerId, tmp.Amount_out
                                               FROM tmpMI_WorkProgress_in_gr AS tmp
                                               ) AS tmpMovement
                                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                                    AND MovementItem.DescId   = zc_MI_Child()
                                                                    AND MovementItem.isErased = FALSE

                                         )
                             , tmpMIBoolean AS (SELECT * FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId  IN (SELECT DISTINCT tmpMI.Id FROM tmpMI AS tmpMI))
                             , tmpMIFloat AS (SELECT * FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI AS tmpMI) AND MIF.DescId = zc_MIFloat_AmountReceipt())
                             
                          -- ���������
                          SELECT tmp.MovementId, tmp.ContainerId
                               --, SUM (COALESCE (tmp.Amount_part,0)) AS Amount_part
                               , SUM (CASE WHEN tmp.isWeightMain = TRUE THEN COALESCE (tmp.Amount_part,0) ELSE 0 END) AS AmountMain_part
                               , SUM (CASE WHEN tmp.isWeightMain = TRUE THEN COALESCE (tmp.Amount,0) ELSE 0 END)      AS Amount_main
                               , SUM (CASE WHEN tmp.isWeightMain = TRUE THEN COALESCE (tmp.Part,0) ELSE 0 END)        AS Part_main

                          FROM (SELECT tmpMI.MovementId, tmpMI.ContainerId, tmpMI.Amount_out, tmpMI.Amount
                                     , CASE WHEN COALESCE (tmpMI.TotalAmount,0) <> 0 THEN tmpMI.Amount / tmpMI.TotalAmount ELSE 0 END AS Part
                                     , tmpMI.Amount_out * CASE WHEN COALESCE (tmpMI.TotalAmount,0) <> 0 THEN tmpMI.Amount / tmpMI.TotalAmount ELSE 0 END AS Amount_part
                                     , CASE WHEN MIBoolean_WeightMain.ValueData  = TRUE
                                             AND MIFloat_AmountReceipt.ValueData > 0
                                                 THEN TRUE
                                            ELSE FALSE
                                       END AS isWeightMain
                                FROM tmpMI
                                     LEFT JOIN tmpMIBoolean AS MIBoolean_WeightMain
                                                            ON MIBoolean_WeightMain.MovementItemId = tmpMI.Id
                                                           AND MIBoolean_WeightMain.DescId         = zc_MIBoolean_WeightMain()
                                     LEFT JOIN tmpMIFloat AS MIFloat_AmountReceipt
                                                          ON MIFloat_AmountReceipt.MovementItemId = tmpMI.Id
                                                         AND MIFloat_AmountReceipt.DescId         = zc_MIFloat_AmountReceipt()
                                                           
                                ) AS tmp
                          GROUP BY tmp.MovementId, tmp.ContainerId
                          --HAVING SUM (COALESCE (tmp.Amount_part,0)) <> 0
                         )
         -- �� ������������ ��� ������
       , tmpReport_isPartion_disable AS (SELECT gpReport.ContainerId
                                         FROM gpReport_ProductionUnion_TaxExitUpdate (inStartDate      := CASE WHEN inIsTerm = TRUE THEN inStartDate ELSE NULL END
                                                                                    , inEndDate        := CASE WHEN inIsTerm = TRUE THEN inEndDate   ELSE NULL END
                                                                                    , inFromId         := CASE WHEN inIsTerm = TRUE THEN inFromId    ELSE NULL END
                                                                                    , inToId           := CASE WHEN inIsTerm = TRUE THEN inToId      ELSE NULL END
                                                                                    , inParam          := inParam
                                                                                    , inIsList         := inIsList
                                                                                    , inIsListReport   := inIsListReport
                                                                                      -- !!! ������ �� �������
                                                                                    , inIsNotPartion   := FALSE
                                                                                    , inIsTerm         := inIsTerm
                                                                                    , inSession        := (-1 * vbUserId) :: TVarChar
                                                                                     ) AS gpReport
                                         WHERE gpReport.isPrint = FALSE
                                           -- !!! ���� ����������� ������ = ��
                                           AND inIsNotPartion   = TRUE
                                           -- ???
                                           -- AND inParam > 0
                                           AND inIsTerm = TRUE
                                        )
         -- ��������� - ������������
       , tmpResult AS
                     (SELECT tmp.ContainerId
                           , tmp.GoodsId
                           , tmp.PartionGoodsId
                           , tmp.GoodsKindId_Complete
                           , SUM (tmp.Amount_WorkProgress_in) AS Amount_WorkProgress_in
                           , SUM (tmp.Amount_WorkProgress_calc) AS Amount_WorkProgress_calc
                           , SUM (tmp.CuterCount)             AS CuterCount
                           , SUM (tmp.CuterCount_calc)        AS CuterCount_calc
                           , SUM (tmp.RealWeight)             AS RealWeight
                           , SUM (tmp.RealWeight_calc)        AS RealWeight_calc
                           , SUM (tmp.RealWeightMsg)          AS RealWeightMsg
                           , SUM (tmp.RealWeightShp)          AS RealWeightShp
                           , SUM (tmp.RealWeightShp_calc)     AS RealWeightShp_calc
                           , SUM (tmp.Amount_GP_in_calc)      AS Amount_GP_in_calc
                           , SUM (tmp.Amount_GP_in)           AS Amount_GP_in
                           , SUM (tmp.AmountReceipt_out)      AS AmountReceipt_out
                           , SUM (tmp.calcIn)                 AS calcIn
                           , SUM (tmp.calcOut)                AS calcOut
                           , MAX (tmp.TaxExit)                AS TaxExit
                           , MAX (tmp.Comment)                AS Comment
                           , MAX (tmp.MovementId)             AS MovementId
                             --
                             -- ���� % �������
                           , MAX (tmp.TaxLossVPR)             AS TaxLossVPR
                             -- ���� ������ (���), %
                           , MAX (tmp.TaxLossCEH)             AS TaxLossCEH
                             -- ���� ������ (����.), %
                           , MAX (tmp.TaxLossTRM)             AS TaxLossTRM

                             -- ���� ��� ����� �����.
                           , MAX (tmp.RealDelicShp)           AS RealDelicShp
                           , SUM (tmp.RealDelicShp_sum)       AS RealDelicShp_sum

                           , SUM (COALESCE (tmp.Amount_out,0))          AS Amount_out

                             -- ���� ��� ����� ���������, ��
                           , MAX (COALESCE (tmp.ValuePF_in,0))          AS ValuePF_in
                           , SUM (COALESCE (tmp.ValuePF_in_sum,0))      AS ValuePF_in_sum


                           , SUM (COALESCE (tmp.Amount_main_det,0))     AS Amount_main_det
                           , SUM (COALESCE (tmp.AmountMain_part_det,0)) AS AmountMain_part_det
                           , SUM (COALESCE (tmp.Part_main_det,0))       AS Part_main_det

                      FROM (-- ������������ �/� ��
                            SELECT -- !!! ���� ����������� ������ = ���
                                   CASE WHEN inIsNotPartion = FALSE THEN tmpMI_WorkProgress_in.ContainerId ELSE 0 END AS ContainerId
                                   --
                                 , tmpMI_WorkProgress_in.GoodsId
                                 , tmpMI_WorkProgress_in.PartionGoodsId
                                 , tmpMI_WorkProgress_in.GoodsKindId_Complete
                                   -- ���� ���-��
                                 , SUM (tmpMI_WorkProgress_in.Amount)        AS Amount_WorkProgress_in
                                   --
                                 , SUM (COALESCE (tmpMI_WorkProgress_in.Amount,0) - COALESCE (tmpMI_WorkProgress_in.Amount_out,0)) AS Amount_WorkProgress_calc
                                   --
                                 , SUM (tmpMI_WorkProgress_in.CuterCount)    AS CuterCount
                                 , SUM (tmpMI_WorkProgress_in.RealWeight)    AS RealWeight
                                 , SUM (COALESCE (tmpMI_WorkProgress_in.RealWeight,0) - COALESCE (tmpMI_WorkProgress_in.Amount_out,0))    AS RealWeight_calc

                                 , SUM (tmpMI_WorkProgress_in.RealWeightMsg) AS RealWeightMsg
                                 , SUM (tmpMI_WorkProgress_in.RealWeightShp) AS RealWeightShp
                                   -- ��� �/� ����� ����������� (������)
                                 , SUM (COALESCE (tmpMI_WorkProgress_in.RealWeightShp,0) - COALESCE (tmpMI_WorkProgress_in.Amount_out,0)) AS RealWeightShp_calc
                                   --
                                 , SUM (CASE WHEN tmpMI_WorkProgress_in.ValuePF <> 0
                                                  THEN (tmpMI_WorkProgress_in.Amount - COALESCE (tmpMI_WorkProgress_in.Amount_out, 0)) * tmpMI_WorkProgress_in.TaxExit / tmpMI_WorkProgress_in.ValuePF
                                             ELSE 0
                                        END)                                          AS Amount_GP_in_calc

                                 , AVG (tmpMI_WorkProgress_in.TaxExit)  AS TaxExit
                                 , SUM (tmpMI_WorkProgress_in.CuterCount * tmpMI_WorkProgress_in.TaxExit) AS calcIn
                                 , SUM (tmpMI_WorkProgress_in.CuterCount * tmpMI_WorkProgress_in.ValuePF) AS calcOut
                                 , MAX (tmpMI_WorkProgress_in.Comment)  AS Comment
                                 , 0                                    AS Amount_GP_in
                                 , 0                                    AS AmountReceipt_out
                                   -- ���� ��� ����� �����.
                                 , MAX (tmpMI_WorkProgress_in.RealDelicShp)  AS RealDelicShp
                                 , SUM (tmpMI_WorkProgress_in.RealDelicShp)  AS RealDelicShp_sum

                                   -- ���� % �������
                                 , MAX (tmpMI_WorkProgress_in.TaxLossVPR)    AS TaxLossVPR
                                   -- ���� ������ (���), %
                                 , MAX (tmpMI_WorkProgress_in.TaxLossCEH)    AS TaxLossCEH
                                   -- ���� ������ (����.), %
                                 , MAX (tmpMI_WorkProgress_in.TaxLossTRM)    AS TaxLossTRM
                                   --
                                 , MAX (tmpMI_WorkProgress_in.MovementId)    AS MovementId

                                 , SUM ((COALESCE (tmpMI_detail.Amount_main,0) - COALESCE (tmpMI_detail.AmountMain_part,0))/100) AS CuterCount_calc -- �������� ���� (������)
                                 , SUM (COALESCE (tmpMI_WorkProgress_in.Amount_out,0) ) AS Amount_out

                                   -- ���� ��� ����� ���������, ��
                                 , MAX (tmpMI_WorkProgress_in.ValuePF) AS ValuePF_in
                                 , SUM (tmpMI_WorkProgress_in.ValuePF) AS ValuePF_in_sum

                                 , SUM (COALESCE (tmpMI_detail.Amount_main,0))  AS Amount_main_det
                                 , SUM (COALESCE (tmpMI_detail.AmountMain_part,0))  AS AmountMain_part_det
                                 , SUM (COALESCE (tmpMI_detail.Part_main,0))        AS Part_main_det

                            FROM tmpMI_WorkProgress_in_gr AS tmpMI_WorkProgress_in
                                 --LEFT JOIN tmpMI_WorkProgress_oth ON tmpMI_WorkProgress_oth.ContainerId = tmpMI_WorkProgress_in.ContainerId

                                 /*LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_WorkProgress_in.GoodsId
                                                                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = tmpMI_WorkProgress_in.GoodsId
                                                      AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/

                                 LEFT JOIN tmpMI_detail ON tmpMI_detail.ContainerId = tmpMI_WorkProgress_in.ContainerId

                            -- �� ������������ ��� ������
                            WHERE tmpMI_WorkProgress_in.ContainerId NOT IN (SELECT tmpReport_isPartion_disable.ContainerId FROM tmpReport_isPartion_disable)
                             --OR vbUserId = 5

                            GROUP BY CASE WHEN inIsNotPartion = FALSE THEN tmpMI_WorkProgress_in.ContainerId ELSE 0 END
                                   , tmpMI_WorkProgress_in.GoodsId
                                   , tmpMI_WorkProgress_in.PartionGoodsId
                                   , tmpMI_WorkProgress_in.GoodsKindId_Complete

                           UNION ALL
                            -- ������ ��
                            SELECT -- !!! ���� ����������� ������ = ���
                                   CASE WHEN inIsNotPartion = FALSE THEN tmpMI_GP_in.ContainerId ELSE 0 END AS ContainerId
                                   --
                                 , tmpMI_GP_in.GoodsId
                                 , tmpMI_GP_in.PartionGoodsId
                                 , tmpMI_GP_in.GoodsKindId_Complete
                                 , 0 AS Amount_WorkProgress_in
                                 , 0 AS Amount_WorkProgress_calc
                                 , 0 AS CuterCount
                                 , 0 AS RealWeight
                                 , 0 AS RealWeight_calc
                                 , 0 AS RealWeightMsg
                                 , 0 AS RealWeightShp
                                 , 0 AS RealWeightShp_calc
                                 , 0 AS Amount_GP_in_calc
                                 , 0 AS TaxExit
                                 , 0 AS calcIn
                                 , 0 AS calcOut
                                 , '' AS Comment
                                 , tmpMI_GP_in.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount_GP_in
                                 , tmpMI_GP_in.AmountReceipt * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountReceipt_out
                                 , 0 AS RealDelicShp
                                 , 0 AS RealDelicShp_sum
                                 , 0 AS TaxLossVPR
                                 , 0 AS TaxLossCEH
                                 , 0 AS TaxLossTRM
                                 , NUll AS MovementId
                                 , 0 AS CuterCount_calc
                                 , 0 AS Amount_out
                                 , 0 AS ValuePF_in
                                 , 0 AS ValuePF_in_sum
                                 , 0 AS Amount_main_det
                                 , 0 AS AmountMain_part_det
                                 , 0 AS Part_main_det
                            FROM tmpMI_GP_in
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_GP_in.GoodsId
                                                                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = tmpMI_GP_in.GoodsId
                                                      AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            -- �� ������������ ��� ������
                            WHERE tmpMI_GP_in.ContainerId NOT IN (SELECT tmpReport_isPartion_disable.ContainerId FROM tmpReport_isPartion_disable)
                             --OR vbUserId = 5

                           UNION ALL
                            -- ������ �/� �� ������� ��� � ������������
                            SELECT -- !!! ���� ����������� ������ = ���
                                   CASE WHEN inIsNotPartion = FALSE THEN tmpMI_WorkProgress_find.ContainerId ELSE 0 END AS ContainerId
                                   --
                                 , tmpMI_WorkProgress_find.GoodsId
                                 , tmpMI_WorkProgress_find.PartionGoodsId
                                 , tmpMI_WorkProgress_find.GoodsKindId_Complete
                                 , 0 AS Amount_WorkProgress_in
                                 , 0 AS Amount_WorkProgress_calc
                                 , 0 AS CuterCount
                                 , 0 AS RealWeight
                                 , 0 AS RealWeight_calc
                                 , 0 AS RealWeightMsg
                                 , 0 AS RealWeightShp
                                 , 0 AS RealWeightShp_calc
                                 , 0 AS Amount_GP_in_calc
                                 , 0 AS TaxExit
                                 , 0 AS calcIn
                                 , 0 AS calcOut
                                 , '' AS Comment
                                 , 0 AS Amount_GP_in
                                 , 0 AS AmountReceipt_out
                                 , 0 AS RealDelicShp
                                 , 0 AS RealDelicShp_sum
                                 , 0 AS TaxLossVPR
                                 , 0 AS TaxLossCEH
                                 , 0 AS TaxLossTRM
                                 , NULL AS MovementId
                                 , 0 AS CuterCount_calc
                                 , 0 AS Amount_out
                                 , 0 AS ValuePF_in
                                 , 0 AS ValuePF_in_sum
                                 , 0 AS Amount_main_det
                                 , 0 AS AmountMain_part_det
                                 , 0 AS Part_main_det
                            FROM tmpMI_WorkProgress_find
                            -- �� ������������ ��� ������
                            WHERE tmpMI_WorkProgress_find.ContainerId NOT IN (SELECT tmpReport_isPartion_disable.ContainerId FROM tmpReport_isPartion_disable)
                             --OR vbUserId = 5

                           ) AS tmp
                      GROUP BY tmp.ContainerId
                             , tmp.GoodsId
                             , tmp.PartionGoodsId
                             , tmp.GoodsKindId_Complete
                     )


    , tmpGoodsNormDiff AS (SELECT ObjectLink_Goods.ChildObjectId AS GoodsId
                                , COALESCE (ObjectLink_GoodsKind.ChildObjectId,0) AS GoodsKindId
                                , ObjectFloat_ValuePF.ValueData AS ValuePF
                                , ObjectFloat_ValueGP.ValueData AS ValueGP

                           FROM Object AS Object_GoodsNormDiff

                               LEFT JOIN ObjectFloat AS ObjectFloat_ValuePF
                                                     ON ObjectFloat_ValuePF.ObjectId = Object_GoodsNormDiff.Id
                                                    AND ObjectFloat_ValuePF.DescId = zc_ObjectFloat_GoodsNormDiff_ValuePF()
                               LEFT JOIN ObjectFloat AS ObjectFloat_ValueGP
                                                     ON ObjectFloat_ValueGP.ObjectId = Object_GoodsNormDiff.Id
                                                    AND ObjectFloat_ValueGP.DescId = zc_ObjectFloat_GoodsNormDiff_ValueGP()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ObjectId = Object_GoodsNormDiff.Id
                                                   AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsNormDiff_Goods()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                                    ON ObjectLink_GoodsKind.ObjectId = Object_GoodsNormDiff.Id
                                                   AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsNormDiff_GoodsKind()
                               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId

                           WHERE Object_GoodsNormDiff.DescId = zc_Object_GoodsNormDiff()
                             AND Object_GoodsNormDiff.isErased = FALSE
                          )
    -- ������ ������� ��� ����������� ������ �� ����� ��� ������
    , tmpGoods AS (SELECT DISTINCT tmpResult.GoodsId
                        , tmpResult.GoodsKindId_Complete 
                        , ObjectDate_PartionGoods.ValueData  ::TDateTime  AS PartionGoodsDate
                   FROM tmpResult
                        LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                                             ON ObjectDate_PartionGoods.ObjectId = tmpResult.PartionGoodsId
                                            AND ObjectDate_PartionGoods.DescId = zc_ObjectDate_PartionGoods_Value()
                   WHERE inIsListReport = FALSE
                 UNION 
                   SELECT DISTINCT OP.ObjectId AS GoodsId
                          , OP.ReportKindId AS GoodsKindId_Complete
                          , OP.ValueDate   ::TDateTime  AS PartionGoodsDate
                     FROM Object_Print AS OP
                     WHERE OP.UserId = vbUserId
                       AND inIsListReport = TRUE  
                   )

    -- ���������
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                        AS GoodsId
         , Object_Goods.ObjectCode                AS GoodsCode
         , (Object_Goods.ValueData || CASE WHEN vbUserId = 5 AND 1=0 THEN ' ' || tmpResult.MovementId ELSE '' END) :: TVarChar  AS GoodsName
         , Object_GoodsKindComplete.Id            AS GoodsKindId_Complete
         , Object_GoodsKindComplete.ValueData     AS GoodsKindName_Complete
         , CASE WHEN vbUserId = 5 AND 1=0 THEN (select count(*) from tmpReport_isPartion_disable) :: TVarChar
                ELSE Object_Measure.ValueData
           END :: TVarChar AS MeasureName
         , ObjectDate_PartionGoods.ValueData  ::TDateTime  AS PartionGoodsDate

           -- ���� ��� ����� �����. (���������)
         , tmpResult.RealDelicShp :: TFloat        AS RealDelicShp
--++++++++++++
           -- ���� ��� ����� �����. - ������������ ��������: ��� �/� ����� ����������� (������) ��������� �������� ���� (������)
         , CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN tmpResult.RealWeightShp_calc / tmpResult.CuterCount_calc ELSE 0 END ::TFloat AS RealWeightShp_calc
           -- ���������� ��������� � ����
         , (COALESCE (CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN tmpResult.RealWeightShp_calc / tmpResult.CuterCount_calc ELSE 0 END, 0) - COALESCE (tmpResult.RealDelicShp,0)) ::TFloat AS AmountShp_diff


--++++++++++++
           -- ��������� ����� (����), ��
         , CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0
                THEN  (COALESCE (tmpResult.RealWeightShp_calc,0) - (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)))
                      / tmpResult.CuterCount_calc
                     - (COALESCE (tmpResult.ValuePF_in_sum ,0) - COALESCE (tmpResult.RealDelicShp_sum,0))

                ELSE 0
           END  :: TFloat AS Amount_Humidity

         /*
         , (tmpResult.RealWeightShp_calc -
            (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0))
            )/  COALESCE (tmpResult.CuterCount_calc,0)   -
               (COALESCE (tmpResult.ValuePF_in ,0) - COALESCE (tmpResult.RealDelicShp,0))
         */


           -- ���� % ������� - ���������: % �������
         , tmpResult.TaxLossVPR :: TFloat
           -- ���� % ������� - ������������ ��������: ��� �/� ����� ��������� (������) ��������� �������� ���� (������) ����� (���������: ��� �/� (��) ����� ��� ����� �����������) �����  (��� �/� (��) ����� % �������)
         , CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN ((COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / COALESCE (tmpResult.CuterCount_calc,0)
                                                                     - (COALESCE (tmpResult.ValuePF_in_sum ,0) - COALESCE (tmpResult.RealDelicShp_sum,0))
                                                                     - (COALESCE (tmpResult.RealDelicShp,0) - COALESCE (tmpResult.TaxLossVPR ,0))
                                                                      )
                ELSE 0
           END  :: TFloat AS TaxLossVPR_fact

           -- % ������� ����������
         , (-- ����
            CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN ((COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0))
                                                                        / COALESCE (tmpResult.CuterCount_calc,0)
                                                                      - (COALESCE (tmpResult.ValuePF_in_sum ,0) - COALESCE (tmpResult.RealDelicShp_sum,0))
                                                                      - (COALESCE (tmpResult.RealDelicShp,0) - COALESCE (tmpResult.TaxLossVPR ,0))
                                                                       )
                ELSE 0
           END
           -- ����� ����
           - COALESCE (tmpResult.TaxLossVPR,0)
           )  :: TFloat AS TaxLoss_diff

           -- ���� ��� ����� ���������, ��
         , COALESCE (tmpResult.ValuePF_in ,0) ::TFloat AS AmountReceipt

--++++++++++++
           -- ���� ��� ����� ���������, �� - ������������ ��������: ��� �/� ����� ��������� (������) ��������� �������� ���� (������)
         , CASE --WHEN 1=1 AND vbUserId = 5 AND COALESCE (tmpResult.CuterCount_calc,0) <> 0
                --     THEN (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / tmpResult.CuterCount_calc
                WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0
                     THEN (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / tmpResult.CuterCount_calc
                ELSE 0
           END ::TFloat AS RealWeightMsg_calc
           -- ���� ��� ����� ���������, ��
         , CAST (CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / tmpResult.CuterCount_calc ELSE 0 END
           - COALESCE (tmpResult.ValuePF_in ,0) AS NUMERIC (16,2)) ::TFloat AS AmountMsg_diff

           -- ���������: % ������ (���)
         , tmpResult.TaxLossCEH :: TFloat
         , CASE WHEN COALESCE (tmpResult.Amount_WorkProgress_calc,0) <> 0 THEN (COALESCE (tmpResult.Amount_WorkProgress_calc,0) - COALESCE (tmpResult.RealWeight,0) ) / COALESCE (tmpResult.Amount_WorkProgress_calc,0) * 100 ELSE 0 END :: TFloat AS TaxLossCEH_fact
         , (CASE WHEN COALESCE (tmpResult.Amount_WorkProgress_calc,0) <> 0 THEN (COALESCE (tmpResult.Amount_WorkProgress_calc,0) - COALESCE (tmpResult.RealWeight,0) ) / COALESCE (tmpResult.Amount_WorkProgress_calc,0) * 100 ELSE 0 END
          - COALESCE (tmpResult.TaxLossCEH,0)) ::TFloat AS TaxLossCEH_diff

           -- ���� ��� ����� ���������, ��
         , (COALESCE (tmpResult.ValuePF_in, 0) - (COALESCE (tmpResult.ValuePF_in ,0) * tmpResult.TaxLossCEH / 100)) ::TFloat AS AmountTRM_befor_plan
--++++++++++++
           -- ���� ��� ����� ���������, ��
         , CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN COALESCE (tmpResult.RealWeight,0) / tmpResult.CuterCount_calc ELSE 0 END ::TFloat AS AmountTRM_befor_fact
           -- ���� ��� ����� ���������, ��
         , (CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN COALESCE (tmpResult.RealWeight,0) / tmpResult.CuterCount_calc ELSE 0 END
           - (COALESCE (tmpResult.ValuePF_in, 0) - (COALESCE (tmpResult.ValuePF_in ,0) * tmpResult.TaxLossCEH / 100)) ) :: TFloat AS  AmountTRM_befor_diff

           -- ���� ������ (����.), % - ���������
         , tmpResult.TaxLossTRM :: TFloat
           -- ���� ������ (����.), %
         , CASE WHEN COALESCE (tmpResult.CuterCount_calc ,0) <> 0 AND (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) <> 0
                THEN ((COALESCE (tmpResult.RealWeight,0) / tmpResult.CuterCount_calc) - COALESCE (tmpResult.Amount_GP_in,0)/ tmpResult.CuterCount_calc  )
                    /  ((COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / tmpResult.CuterCount_calc  )
                       * 100
                ELSE 0
           END   ::TFloat AS  TaxLossTRM_fact
           -- ���� ������ (����.), %
         , (CASE WHEN COALESCE (tmpResult.CuterCount_calc ,0) <> 0 AND (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) <> 0
                THEN ((COALESCE (tmpResult.RealWeight,0) / tmpResult.CuterCount_calc) - COALESCE (tmpResult.Amount_GP_in,0)/ tmpResult.CuterCount_calc  )
                    /  ((COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / tmpResult.CuterCount_calc  )
                       * 100
                ELSE 0
           END
           - COALESCE (tmpResult.TaxLossTRM,0)
            )  ::TFloat AS TaxLossTRM_diff

          -- % ������
          , tmpResult.TaxExit :: TFloat  AS TaxExit  --����� �� , �� ����

            -- ���� ����� ��, ��
          , CASE WHEN COALESCE (tmpResult.CuterCount_calc ,0) <> 0 THEN COALESCE (tmpResult.Amount_GP_in,0)/tmpResult.CuterCount_calc ELSE 0 END ::TFloat  AS TaxExit_fact
            -- ���� ����� ��, ��
          , (CAST (CASE WHEN COALESCE (tmpResult.CuterCount_calc ,0) <> 0 THEN COALESCE (tmpResult.Amount_GP_in,0)/tmpResult.CuterCount_calc ELSE 0 END
            - COALESCE (tmpResult.TaxExit,0) AS NUMERIC (16,2)))  :: TFloat  AS TaxExit_diff

            -- ����� �� ����
          , tmpResult.Amount_GP_in :: TFloat             AS Amount_GP_in

            -- ����� ���������� ��, ��
          , (CAST (tmpGoodsNormDiff.ValueGP AS NUMERIC (16,2))) ::TFloat  AS ValueGP
            -- ����� ���������� �/� (��), ��
          , (CAST (tmpGoodsNormDiff.ValuePF AS NUMERIC (16,2))) ::TFloat  AS ValuePF

            -- ���� �� ����� ����� ��, �� 
          , (CAST( ABS ((CASE WHEN COALESCE (tmpResult.CuterCount_calc ,0) <> 0 THEN COALESCE (tmpResult.Amount_GP_in,0)/tmpResult.CuterCount_calc ELSE 0 END
            - COALESCE (tmpResult.TaxExit,0) )
                 ) AS NUMERIC (16,2) )
            - CAST (COALESCE (tmpGoodsNormDiff.ValueGP,0) AS NUMERIC (16,2))) ::TFloat AS ValueGP_diff

            -- ���� �� ����� ��� ����� ���������, ��
          , (CAST( ABS ((CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0)) / tmpResult.CuterCount_calc ELSE 0 END
           - COALESCE (tmpResult.ValuePF_in ,0)) )
            - COALESCE (tmpGoodsNormDiff.ValuePF,0) AS NUMERIC (16,2))) ::TFloat AS ValuePF_diff

            -- �������� ����
          , COALESCE (tmpResult.CuterCount,0) ::TFloat AS CuterCount_inf
            -- �������� ���� (������)
          , COALESCE (tmpResult.CuterCount_calc,0) ::TFloat AS CuterCount_calcinf

            -- ��� �/� ���� (���)
          , tmpResult.RealWeightShp ::TFloat AS RealWeightShpinf
            -- ��� �/� ����� ����������� (������)
          , tmpResult.RealWeightShp_calc ::TFloat AS RealWeightShp_calcinf

            -- ���� ���-��
          , COALESCE (tmpResult.Amount_WorkProgress_in, 0)   :: TFloat AS Amountinf
          , COALESCE (tmpResult.Amount_WorkProgress_calc, 0) :: TFloat AS Amount_inf_calc
          
            -- ��� �/� ���� (���)
          , COALESCE (tmpResult.RealWeightMsg,0)  ::TFloat AS RealWeightMsg_inf
            --��� �/� ����� ��������� (������)
          , (COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0))  ::TFloat AS RealWeightMsg_calcinf
            -- ����������� �/� (������), ��
          , (COALESCE (tmpResult.Amount_out,0) * (-1) )  ::TFloat AS Amount_outinf
            -- ��� �/� ����
          , COALESCE (tmpResult.RealWeight,0)  ::TFloat AS RealWeight_inf

          --��������� �����

            -- ���-�� ���� (���. �����)
          , tmpResult.Amount_main_det     ::TFloat AS Amount_main_det     
            -- ����������� �/� (������/������), �� (���. �����)
          , tmpResult.AmountMain_part_det ::TFloat AS AmountMain_part_det
            -- ����
          , tmpResult.Part_main_det       ::TFloat AS Part_main_det      

                      
          , CASE -- !!! ���� ����������� ������ = ��
                 WHEN inIsNotPartion = TRUE
                      -- ����� ��� �������� ��� 
                      THEN TRUE
                 -- ���� ��� �� ��������
                 WHEN inIsTerm = FALSE
                      -- �������� ��� 
                      THEN TRUE

                 -- ����� ��� �������� �� ��� 
                 WHEN -- ����� ���������� �/� (��), ��
                      tmpGoodsNormDiff.ValuePF <
                      -- % ������� ����������
                      ABS (-- ����
                           CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN ((COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0))
                                                                                       / COALESCE (tmpResult.CuterCount_calc,0)
                                                                                     - (COALESCE (tmpResult.ValuePF_in_sum ,0) - COALESCE (tmpResult.RealDelicShp_sum,0))
                                                                                     - (COALESCE (tmpResult.RealDelicShp,0) - COALESCE (tmpResult.TaxLossVPR ,0))
                                                                                      )
                               ELSE 0
                          END
                          -- ����� ����
                          - COALESCE (tmpResult.TaxLossVPR,0)
                          )
                      THEN FALSE

                 ELSE TRUE
            END ::Boolean AS isPrint

          , tmpResult.ContainerId :: Integer AS ContainerId

     FROM tmpResult
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpResult.GoodsId
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpResult.GoodsKindId_Complete

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                               ON ObjectDate_PartionGoods.ObjectId = tmpResult.PartionGoodsId
                              AND ObjectDate_PartionGoods.DescId = zc_ObjectDate_PartionGoods_Value()

          --���� ������ �� ����� ������ - ������������ ����� ������
          INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpResult.GoodsId
                             AND COALESCE (tmpGoods.GoodsKindId_Complete,0) = COALESCE (tmpResult.GoodsKindId_Complete,0)
                             AND (tmpGoods.PartionGoodsDate = ObjectDate_PartionGoods.ValueData ::TDateTime OR inIsNotPartion = TRUE)


          LEFT JOIN tmpGoodsNormDiff ON tmpGoodsNormDiff.GoodsId = tmpResult.GoodsId
                                    AND COALESCE (tmpGoodsNormDiff.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId_Complete,0)

       WHERE TRUE = CASE -- !!!��� ��������!!!
                         WHEN zfConvert_StringToNumber (inSession) < 0
                              -- 
                              THEN TRUE

                         -- !!! ���� ����������� ������ = ��
                         WHEN inIsNotPartion = TRUE
                              -- ����� ��� �������� ��� 
                              THEN TRUE
                         -- ���� ��� �� ��������
                         WHEN inIsTerm = FALSE
                              -- �������� ��� 
                              THEN TRUE
        
                         -- ����� ��� �������� �� ��� 
                         WHEN -- ����� ���������� �/� (��), ��
                              tmpGoodsNormDiff.ValuePF <
                              -- % ������� ����������
                              ABS (-- ����
                                   CASE WHEN COALESCE (tmpResult.CuterCount_calc,0) <> 0 THEN ((COALESCE (tmpResult.Amount_WorkProgress_in,0) - COALESCE (tmpResult.Amount_out,0))
                                                                                               / COALESCE (tmpResult.CuterCount_calc,0)
                                                                                             - (COALESCE (tmpResult.ValuePF_in_sum ,0) - COALESCE (tmpResult.RealDelicShp_sum,0))
                                                                                             - (COALESCE (tmpResult.RealDelicShp,0) - COALESCE (tmpResult.TaxLossVPR ,0))
                                                                                              )
                                       ELSE 0
                                  END
                                  -- ����� ����
                                  - COALESCE (tmpResult.TaxLossVPR,0)
                                  )
                              THEN FALSE
        
                         ELSE TRUE
                    END :: Boolean
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.07.24         * Update
 15.12.20         * RealWeightMsg
 17.03.15                                        *
*/

-- ����
-- SELECT * FROM gpReport_ProductionUnion_TaxExitUpdate(inStartDate := ('01.07.2024')::TDateTime , inEndDate := ('01.07.2024')::TDateTime , inFromId := 8448 , inToId := 8448 , inParam:=0, inIsList:= FALSE, inIsNotPartion:= TRUE, inSession := '9457');
-- SELECT * FROM gpReport_ProductionUnion_TaxExitUpdate(inStartDate := ('17.11.2024')::TDateTime , inEndDate := ('19.11.2024')::TDateTime , inFromId := 8448 , inToId := 8448 , inParam := 0 , inIsList := 'False' , inIsListReport := 'False' , inisPartion := 'True' , inIsTerm := 'True', inSession := '5');
