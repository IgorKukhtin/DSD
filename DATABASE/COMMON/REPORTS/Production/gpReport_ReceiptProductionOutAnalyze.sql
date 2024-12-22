-- Function: gpReport_ReceiptProductionOutAnalyze()

-- DROP FUNCTION IF EXISTS gpReport_ReceiptProductionOutAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ReceiptProductionOutAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptProductionOutAnalyze (
    IN inStartDate        TDateTime ,
    IN inEndDate          TDateTime ,
    IN inFromId           Integer   ,
    IN inToId             Integer   ,
    IN inGoodsGroupId     Integer   ,
    IN inPriceListId_1    Integer,
    IN inPriceListId_2    Integer,
    IN inPriceListId_3    Integer,
    IN inPriceListId_sale Integer,
    IN inIsPartionGoods   Boolean,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor

AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE Cursor3 refcursor;
BEGIN

     CREATE TEMP TABLE _tmpUnit_from (UnitId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_to (UnitId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;

     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, isStart Boolean, isCost Boolean
                                            ) ON COMMIT DROP;
     CREATE TEMP TABLE tmpResult_in  (ReceiptId Integer, PartionGoodsDate TDateTime, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, OperCount TFloat, OperSumm TFloat, CuterCount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE tmpResult_out (ReceiptId Integer, PartionGoodsDate_in TDateTime, GoodsId_in Integer, GoodsKindId_in Integer, GoodsKindId_complete_in Integer, PartionGoodsDate TDateTime, GoodsId Integer
                                    , GoodsKindId Integer, GoodsKindId_complete Integer, OperCountPlan TFloat, OperSummPlan1 TFloat, OperSummPlan2 TFloat, OperSummPlan3 TFloat
                                    , PricePlan1 TFloat, PricePlan2 TFloat, PricePlan3 TFloat, OperCount TFloat, OperSumm TFloat, CuterCount TFloat, OperCount_ReWork TFloat) ON COMMIT DROP;


     -- ����������� �� ������
     WITH RECURSIVE tmpGroup (GoodsGroupId, GoodsGroupParentId)
       AS (SELECT Object.Id, NULL :: Integer
           FROM Object
           WHERE Object.Id = inGoodsGroupId
          UNION
           SELECT ObjectLink_GoodsGroup.ObjectId, tmpGroup.GoodsGroupId
           FROM tmpGroup
                INNER JOIN ObjectLink AS ObjectLink_GoodsGroup
                                      ON ObjectLink_GoodsGroup.ChildObjectId = tmpGroup.GoodsGroupId
                                     AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
          )
     INSERT INTO _tmpGoods (GoodsId)
        SELECT ObjectLink_Goods_GoodsGroup.ObjectId
        FROM tmpGroup
             INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ChildObjectId = tmpGroup.GoodsGroupId
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
       ;
     -- ������ ������������� ��� �������������
     INSERT INTO _tmpUnit_from (UnitId)
        SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect
       ;
     -- ������ ������������� ��� �������������
     INSERT INTO _tmpUnit_to (UnitId)
        SELECT lfSelect.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect
       ;


     -- ��� ���������
     INSERT INTO tmpChildReceiptTable (ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, isStart, isCost
                                      )
          SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , lpSelect.ReceiptChildId
               , lpSelect.GoodsId_out
                 -- ���.
               , CASE WHEN inEndDate < '01.01.2024' AND lpSelect.GoodsKindId_out = 8333 THEN 0 ELSE lpSelect.GoodsKindId_out END AS GoodsKindId_out
               , lpSelect.Amount_out
               , lpSelect.isStart, lpSelect.isCost
          FROM lpSelect_Object_ReceiptChildDetail() AS lpSelect
         ;


     -- ������� - ����
     INSERT INTO tmpResult_in  (ReceiptId, PartionGoodsDate, GoodsId, GoodsKindId, GoodsKindId_complete, OperCount, OperSumm, CuterCount)
       WITH tmpMIContainer AS
           (SELECT COALESCE (MIReceipt.ObjectId, 0)                AS ReceiptId
                 , COALESCE (MIContainer.ObjectId_Analyzer, 0)     AS GoodsId
                 , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)  AS GoodsKindId
                 , MIContainer.ContainerId                         AS ContainerId
                 , MIDate_PartionGoods.ValueData                   AS PartionGoodsDate
                 , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS OperCount
                 , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS OperSumm
                 , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))                                               AS CuterCount
            FROM MovementItemContainer AS MIContainer
                 LEFT JOIN MovementItemLinkObject AS MIReceipt
                                                  ON MIReceipt.MovementItemId = MIContainer.MovementItemId
                                                 AND MIReceipt.DescId = zc_MILinkObject_Receipt()
                 LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                             ON MIFloat_CuterCount.MovementItemId = MIContainer.MovementItemId
                                            AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                            AND MIContainer.DescId = zc_MIContainer_Count()
                 LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                            ON MIDate_PartionGoods.MovementItemId = MIContainer.MovementItemId
                                           AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                           AND inIsPartionGoods = TRUE
                 INNER JOIN _tmpUnit_to   ON _tmpUnit_to.UnitId   = MIContainer.WhereObjectId_analyzer
                 INNER JOIN _tmpUnit_from ON _tmpUnit_from.UnitId = MIContainer.ObjectExtId_Analyzer
                 LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                           ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                          AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                          AND MovementBoolean_Peresort.ValueData = TRUE
            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
              AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
              AND MIContainer.IsActive = TRUE
              AND MIContainer.Amount <> 0
              AND MovementBoolean_Peresort.MovementId IS NULL -- !!!������ �����������!!!
              --AND MIContainer.ObjectIntId_Analyzer > 0      -- !!!�� ������ ��!!!
            GROUP BY MIReceipt.ObjectId
                   , MIContainer.ObjectId_Analyzer
                   , MIContainer.ObjectIntId_Analyzer
                   , MIContainer.ContainerId
                   , MIDate_PartionGoods.ValueData
           )
        -- ���������
        SELECT tmpMIContainer.ReceiptId                                           AS ReceiptId
             , CASE WHEN inIsPartionGoods = TRUE THEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, COALESCE (tmpMIContainer.PartionGoodsDate, zc_DateStart())) ELSE zc_DateStart() END AS PartionGoodsDate
             , tmpMIContainer.GoodsId                                             AS GoodsId
             , tmpMIContainer.GoodsKindId                                         AS GoodsKindId
             , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindId_complete
             , SUM (tmpMIContainer.OperCount)                                     AS OperCount
             , SUM (tmpMIContainer.OperSumm)                                      AS OperSumm
             , SUM (tmpMIContainer.CuterCount)                                    AS CuterCount
        FROM tmpMIContainer
             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                           ON CLO_PartionGoods.ContainerId = tmpMIContainer.ContainerId
                                          AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
             LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                  AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                  ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                 AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
        GROUP BY tmpMIContainer.ReceiptId
               , CASE WHEN inIsPartionGoods = TRUE THEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, COALESCE (tmpMIContainer.PartionGoodsDate, zc_DateStart())) ELSE zc_DateStart() END
               , tmpMIContainer.GoodsId
               , tmpMIContainer.GoodsKindId
               , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
            ;


     -- �������
     INSERT INTO tmpResult_out (ReceiptId, PartionGoodsDate_in, GoodsId_in, GoodsKindId_in, GoodsKindId_complete_in, PartionGoodsDate, GoodsId, GoodsKindId, GoodsKindId_complete, OperCountPlan, OperSummPlan1, OperSummPlan2, OperSummPlan3, PricePlan1, PricePlan2, PricePlan3, OperCount, OperSumm, CuterCount, OperCount_ReWork)
       WITH tmpPrice1 AS (SELECT PriceList.GoodsId, MAX (PriceList.Price) AS Price FROM ObjectHistory_PriceListItem_View AS PriceList WHERE PriceList.PriceListId = inPriceListId_1 AND inEndDate >= PriceList.StartDate AND inEndDate < PriceList.EndDate GROUP BY PriceList.GoodsId)
          , tmpPrice2 AS (SELECT PriceList.GoodsId, MAX (PriceList.Price) AS Price FROM ObjectHistory_PriceListItem_View AS PriceList WHERE PriceList.PriceListId = inPriceListId_2 AND inEndDate >= PriceList.StartDate AND inEndDate < PriceList.EndDate GROUP BY PriceList.GoodsId)
          , tmpPrice3 AS (SELECT PriceList.GoodsId, MAX (PriceList.Price) AS Price FROM ObjectHistory_PriceListItem_View AS PriceList WHERE PriceList.PriceListId = inPriceListId_3 AND inEndDate >= PriceList.StartDate AND inEndDate < PriceList.EndDate GROUP BY PriceList.GoodsId)
          , -- ������� - ����
            tmpMIContainer AS
           (SELECT COALESCE (MIReceipt.ObjectId, 0)                AS ReceiptId
                 , COALESCE (MIContainer.ObjectId_Analyzer, 0)     AS GoodsId
                 , COALESCE (MIContainer.ObjectIntId_Analyzer, MIGoodsKind.ObjectId, 0)  AS GoodsKindId
                 , MIContainer.ContainerId_Analyzer                AS ContainerId_Analyzer
                 , MIContainer.ContainerId                         AS ContainerId
                 , MIDate_PartionGoods.ValueData                   AS PartionGoodsDate
                 , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS OperCount
                 , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN -1 * MIContainer.Amount ELSE 0 END) AS OperSumm
            FROM MovementItemContainer AS MIContainer
                 LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                 LEFT JOIN MovementItemLinkObject AS MIReceipt
                                                  ON MIReceipt.MovementItemId = MovementItem.ParentId
                                                 AND MIReceipt.DescId = zc_MILinkObject_Receipt()
                 LEFT JOIN MovementItemLinkObject AS MIGoodsKind
                                                  ON MIGoodsKind.MovementItemId = MIContainer.MovementItemId
                                                 AND MIGoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                            ON MIDate_PartionGoods.MovementItemId = MIContainer.MovementItemId
                                           AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                           AND inIsPartionGoods = TRUE
                 LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                 INNER JOIN _tmpUnit_from ON _tmpUnit_from.UnitId = MIContainer.WhereObjectId_analyzer
                 INNER JOIN _tmpUnit_to   ON _tmpUnit_to.UnitId   = MIContainer.ObjectExtId_Analyzer

                 LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                           ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                          AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                          AND MovementBoolean_Peresort.ValueData = TRUE

            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
              AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
              AND MIContainer.IsActive = FALSE
              AND MIContainer.Amount <> 0
              AND (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
              AND MovementBoolean_Peresort.MovementId IS NULL -- !!!������ �����������!!!
            GROUP BY MIReceipt.ObjectId
                   , MIContainer.ObjectId_Analyzer
                   , COALESCE (MIContainer.ObjectIntId_Analyzer, MIGoodsKind.ObjectId, 0)
                   , MIContainer.ContainerId_Analyzer
                   , MIContainer.ContainerId
                   , MIDate_PartionGoods.ValueData
           )

          , -- ������ "�����������"
            tmpGoods_ReWork AS (SELECT ObjectLink.ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.ChildObjectId = zc_Enum_InfoMoney_30301() AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney())
          , -- ������ �����������
            tmpMIContainer_ReWork AS
           (SELECT MIContainer_parent.ContainerId, -1 * SUM (MIContainer.Amount) AS Amount
            FROM _tmpUnit_from
                 INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                                AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                                AND MIContainer.WhereObjectId_analyzer = _tmpUnit_from.UnitId
                                                                AND MIContainer.isActive = FALSE
                 INNER JOIN tmpGoods_ReWork ON tmpGoods_ReWork.GoodsId = MIContainer.ObjectId_Analyzer
                 INNER JOIN MovementItemContainer AS MIContainer_parent ON MIContainer_parent.Id = MIContainer.ParentId
            GROUP BY MIContainer_parent.ContainerId
           )

          , -- ��� ����������� - 1
            tmpCuterCount_find_1 AS (SELECT DISTINCT tmpMIContainer.ContainerId FROM tmpMIContainer)
          , -- ��� ����������� - 2
            tmpCuterCount_find_2 AS (SELECT MIContainer.*
                                     FROM MovementItemContainer AS MIContainer
                                     WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpCuterCount_find_1.ContainerId FROM tmpCuterCount_find_1)
                                       AND MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                       AND MIContainer.isActive = TRUE
                                    )
/*          , -- ��� ����������� - 3
            tmpCuterCount_find_3 AS (SELECT MIContainer.*
                                     FROM tmpCuterCount_find_2 AS MIContainer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                       AND MIContainer.isActive = TRUE
                                    )*/
          , -- ������ � ��-�� ��/�� - �������
            tmpCuterCount_find AS
           (SELECT tmpMI_WorkProgress_in.ContainerId                AS ContainerId
                 , SUM (tmpMI_WorkProgress_in.Amount)               AS Amount
                 , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0)) AS CuterCount
                 -- , MAX (COALESCE (MILO_Receipt.ObjectId, 0))        AS ReceiptId
            FROM (SELECT tmpMIContainer.ContainerId, MIContainer.MovementItemId , SUM (MIContainer.Amount) AS Amount
                  FROM tmpMIContainer
                       INNER JOIN tmpCuterCount_find_2 AS MIContainer ON MIContainer.ContainerId = tmpMIContainer.ContainerId
                                                                   --AND MIContainer.DescId = zc_MIContainer_Count()
                                                                   --AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                                   --AND MIContainer.isActive = TRUE
                  GROUP BY tmpMIContainer.ContainerId, MIContainer.MovementItemId
                 ) AS tmpMI_WorkProgress_in
                 LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                             ON MIFloat_CuterCount.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                            AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                 /*LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                  ON MILO_Receipt.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                 AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()*/
            GROUP BY tmpMI_WorkProgress_in.ContainerId
           )
          , -- ������ - �������
            tmpCuterCount AS
           (-- ����
            SELECT tmpCuterCount_find.ContainerId
                 , tmpCuterCount_find.Amount
                 , tmpCuterCount_find.CuterCount
            FROM tmpCuterCount_find
           UNION
            -- �� ������� (�.�. �� 01.07.2015 ��� "�����������" ������������)
            SELECT tmpMIContainer.ContainerId
                 , MAX (ObjectFloat_Value.ValueData) AS Amount
                 , 1 AS CuterCount
            FROM tmpMIContainer
                 LEFT JOIN tmpCuterCount_find ON tmpCuterCount_find.ContainerId = tmpMIContainer.ContainerId
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                       ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMIContainer.GoodsId
                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                      AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpMIContainer.GoodsKindId
                                      AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                    AND Object_Receipt.isErased = FALSE
                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                          ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                         AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                         AND ObjectBoolean_Main.ValueData = TRUE
                 INNER JOIN ObjectFloat AS ObjectFloat_Value
                                        ON ObjectFloat_Value.ObjectId = Object_Receipt.Id
                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
                                       AND ObjectFloat_Value.ValueData <> 0
            WHERE tmpCuterCount_find.ContainerId IS NULL
            GROUP BY tmpMIContainer.ContainerId
           )
            -- ������ �/� ��� �� !!!��� isCost!!!
          , tmpMIReceipt_from AS
           (SELECT Object_Receipt.Id AS ReceiptId
                 , tmp.GoodsId
                 , tmp.GoodsKindId
                 , CASE WHEN tmp.GoodsKindId = zc_GoodsKind_WorkProgress() THEN COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId_complete
                 , SUM (tmpChildReceiptTable.Amount_out * COALESCE (tmpPrice1.Price, 0)) / ObjectFloat_Value.ValueData AS Price1
                 , SUM (tmpChildReceiptTable.Amount_out * COALESCE (tmpPrice2.Price, 0)) / ObjectFloat_Value.ValueData AS Price2
                 , SUM (tmpChildReceiptTable.Amount_out * COALESCE (tmpPrice3.Price, 0)) / ObjectFloat_Value.ValueData AS Price3
            FROM (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId FROM tmpMIContainer GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                 ) AS tmp
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                       ON ObjectLink_Receipt_Goods.ChildObjectId = tmp.GoodsId
                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                      AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmp.GoodsKindId
                                      AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                      ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                     AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                    AND Object_Receipt.isErased = FALSE
                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                          ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                         AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                         AND ObjectBoolean_Main.ValueData = TRUE
                 INNER JOIN ObjectFloat AS ObjectFloat_Value
                                        ON ObjectFloat_Value.ObjectId = Object_Receipt.Id
                                       AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
                                       AND ObjectFloat_Value.ValueData <> 0
                 INNER JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = Object_Receipt.Id
                                                AND tmpChildReceiptTable.ReceiptId_from = 0
                                                AND tmpChildReceiptTable.isCost = FALSE
                 LEFT JOIN tmpPrice1 ON tmpPrice1.GoodsId = tmpChildReceiptTable.GoodsId_out
                 LEFT JOIN tmpPrice2 ON tmpPrice2.GoodsId = tmpChildReceiptTable.GoodsId_out
                 LEFT JOIN tmpPrice3 ON tmpPrice3.GoodsId = tmpChildReceiptTable.GoodsId_out

            GROUP BY Object_Receipt.Id
                   , tmp.GoodsId
                   , tmp.GoodsKindId
                   , ObjectLink_Receipt_GoodsKindComplete.ChildObjectId
                   , ObjectFloat_Value.ValueData
            )
            -- ������� - ����
          , tmpMIReceipt AS
           (SELECT tmpResult_in.ReceiptId                AS ReceiptId
                 , tmpResult_in.PartionGoodsDate         AS PartionGoodsDate_in
                 , tmpResult_in.GoodsId                  AS GoodsId_in
                 , tmpResult_in.GoodsKindId              AS GoodsKindId_in
                 , tmpResult_in.GoodsKindId_complete     AS GoodsKindId_complete_in

                 , tmpResult_in.PartionGoodsDate         AS PartionGoodsDate
                 , tmpChildReceiptTable.GoodsId_out      AS GoodsId
                 , tmpChildReceiptTable.GoodsKindId_out  AS GoodsKindId
                 , CASE WHEN tmpChildReceiptTable.GoodsKindId_out = zc_GoodsKind_WorkProgress() THEN tmpResult_in.GoodsKindId ELSE 0 END AS GoodsKindId_complete

                 , CASE WHEN tmpResult_in.CuterCount > 0 AND 1=0 THEN tmpResult_in.CuterCount * tmpChildReceiptTable.Amount_out WHEN ObjectFloat_Value.ValueData <> 0 THEN tmpResult_in.OperCount * tmpChildReceiptTable.Amount_out / ObjectFloat_Value.ValueData ELSE 0 END AS OperCountPlan
                 , CASE WHEN tmpResult_in.CuterCount > 0 AND 1=0 THEN tmpResult_in.CuterCount * tmpChildReceiptTable.Amount_out WHEN ObjectFloat_Value.ValueData <> 0 THEN tmpResult_in.OperCount * tmpChildReceiptTable.Amount_out / ObjectFloat_Value.ValueData ELSE 0 END
                   * COALESCE (tmpMIReceipt_from.Price1, COALESCE (tmpPrice1.Price, 0)) AS OperSummPlan1
                 , CASE WHEN tmpResult_in.CuterCount > 0 AND 1=0 THEN tmpResult_in.CuterCount * tmpChildReceiptTable.Amount_out WHEN ObjectFloat_Value.ValueData <> 0 THEN tmpResult_in.OperCount * tmpChildReceiptTable.Amount_out / ObjectFloat_Value.ValueData ELSE 0 END
                   * COALESCE (tmpMIReceipt_from.Price2, COALESCE (tmpPrice2.Price, 0)) AS OperSummPlan2
                 , CASE WHEN tmpResult_in.CuterCount > 0 AND 1=0 THEN tmpResult_in.CuterCount * tmpChildReceiptTable.Amount_out WHEN ObjectFloat_Value.ValueData <> 0 THEN tmpResult_in.OperCount * tmpChildReceiptTable.Amount_out / ObjectFloat_Value.ValueData ELSE 0 END
                   * COALESCE (tmpMIReceipt_from.Price3, COALESCE (tmpPrice3.Price, 0)) AS OperSummPlan3
            FROM tmpResult_in
                 LEFT JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmpResult_in.ReceiptId
                 LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpChildReceiptTable.GoodsId_out
                 LEFT JOIN tmpMIReceipt_from ON tmpMIReceipt_from.GoodsId              = tmpChildReceiptTable.GoodsId_out
                                            AND tmpMIReceipt_from.GoodsKindId          = tmpChildReceiptTable.GoodsKindId_out
                                            AND tmpMIReceipt_from.GoodsKindId_complete = CASE WHEN tmpChildReceiptTable.GoodsKindId_out = zc_GoodsKind_WorkProgress() THEN tmpResult_in.GoodsKindId ELSE 0 END

                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                       ON ObjectFloat_Value.ObjectId = tmpResult_in.ReceiptId
                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
                 LEFT JOIN tmpPrice1 ON tmpPrice1.GoodsId = tmpChildReceiptTable.GoodsId_out
                 LEFT JOIN tmpPrice2 ON tmpPrice2.GoodsId = tmpChildReceiptTable.GoodsId_out
                 LEFT JOIN tmpPrice3 ON tmpPrice3.GoodsId = tmpChildReceiptTable.GoodsId_out
            WHERE (_tmpGoods.GoodsId > 0 OR COALESCE (inGoodsGroupId, 0) = 0)
           )

        -- ��������� - ��� �������
        SELECT tmp.ReceiptId
             , tmp.PartionGoodsDate_in
             , tmp.GoodsId_in
             , tmp.GoodsKindId_in
             , tmp.GoodsKindId_complete_in
             , tmp.PartionGoodsDate
             , tmp.GoodsId
             , tmp.GoodsKindId
             , tmp.GoodsKindId_complete
             , SUM (tmp.OperCountPlan)  AS OperCountPlan
             , SUM (tmp.OperSummPlan1)  AS OperSummPlan1
             , SUM (tmp.OperSummPlan2)  AS OperSummPlan2
             , SUM (tmp.OperSummPlan3)  AS OperSummPlan3
             , COALESCE (tmpPrice1.Price, 0) AS Price1
             , COALESCE (tmpPrice2.Price, 0) AS Price2
             , COALESCE (tmpPrice3.Price, 0) AS Price3
             , SUM (tmp.OperCount)      AS OperCount
             , SUM (tmp.OperSumm)       AS OperSumm
             , SUM (tmp.CuterCount)     AS CuterCount
             , SUM (tmp.OperCount_ReWork)  AS OperCount_ReWork

        FROM (SELECT tmpMIContainer.ReceiptId                                           AS ReceiptId
                   , CASE WHEN inIsPartionGoods = TRUE THEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, COALESCE (tmpMIContainer.PartionGoodsDate, zc_DateStart())) ELSE zc_DateStart() END AS PartionGoodsDate_in
                   , COALESCE (CLO_Goods.ObjectId, COALESCE (Container.ObjectId, 0))    AS GoodsId_in
                   , COALESCE (CLO_GoodsKind.ObjectId, 0)                               AS GoodsKindId_in
                   , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindId_complete_in

                   , CASE WHEN inIsPartionGoods = TRUE THEN COALESCE (ObjectDate_PartionGoods_Value_out.ValueData, COALESCE (tmpMIContainer.PartionGoodsDate, zc_DateStart())) ELSE zc_DateStart() END AS PartionGoodsDate
                   , tmpMIContainer.GoodsId                                             AS GoodsId
                   , tmpMIContainer.GoodsKindId                                         AS GoodsKindId
                   , COALESCE (ObjectLink_GoodsKindComplete_out.ChildObjectId, 0)       AS GoodsKindId_complete
                   , SUM (tmpMIContainer.OperCount)                                     AS OperCount
                   , SUM (tmpMIContainer.OperSumm)                                      AS OperSumm
                   , 0 AS OperCountPlan
                   , 0 AS OperSummPlan1
                   , 0 AS OperSummPlan2
                   , 0 AS OperSummPlan3
                   , SUM (CASE WHEN tmpCuterCount.Amount <> 0 THEN tmpCuterCount.CuterCount * tmpMIContainer.OperCount / tmpCuterCount.Amount ELSE 0 END) AS CuterCount
                   , SUM (CASE WHEN tmpCuterCount.Amount <> 0 THEN COALESCE (tmpMIContainer_ReWork.Amount, 0) * tmpMIContainer.OperCount / tmpCuterCount.Amount ELSE 0 END) AS OperCount_ReWork

              FROM tmpMIContainer
                   LEFT JOIN tmpCuterCount ON tmpCuterCount.ContainerId = tmpMIContainer.ContainerId
                   LEFT JOIN tmpMIContainer_ReWork ON tmpMIContainer_ReWork.ContainerId = tmpMIContainer.ContainerId

                   LEFT JOIN ContainerLinkObject AS CLO_PartionGoods_out
                                                 ON CLO_PartionGoods_out.ContainerId = tmpMIContainer.ContainerId
                                                AND CLO_PartionGoods_out.DescId = zc_ContainerLinkObject_PartionGoods()
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete_out
                                        ON ObjectLink_GoodsKindComplete_out.ObjectId = CLO_PartionGoods_out.ObjectId
                                       AND ObjectLink_GoodsKindComplete_out.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                   LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value_out ON ObjectDate_PartionGoods_Value_out.ObjectId = CLO_PartionGoods_out.ObjectId
                                                                            AND ObjectDate_PartionGoods_Value_out.DescId = zc_ObjectDate_PartionGoods_Value()


                   LEFT JOIN Container ON Container.Id = tmpMIContainer.ContainerId_Analyzer
                   LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                 ON CLO_Goods.ContainerId = tmpMIContainer.ContainerId_Analyzer
                                                AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                   LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                 ON CLO_GoodsKind.ContainerId = tmpMIContainer.ContainerId_Analyzer
                                                AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                   LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                 ON CLO_PartionGoods.ContainerId = tmpMIContainer.ContainerId_Analyzer
                                                AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                   LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                        AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                        ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                       AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
              GROUP BY tmpMIContainer.ReceiptId
                     , CASE WHEN inIsPartionGoods = TRUE THEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, COALESCE (tmpMIContainer.PartionGoodsDate, zc_DateStart())) ELSE zc_DateStart() END
                     , COALESCE (CLO_Goods.ObjectId, COALESCE (Container.ObjectId, 0))
                     , COALESCE (CLO_GoodsKind.ObjectId, 0)
                     , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                     , CASE WHEN inIsPartionGoods = TRUE THEN COALESCE (ObjectDate_PartionGoods_Value_out.ValueData, COALESCE (tmpMIContainer.PartionGoodsDate, zc_DateStart())) ELSE zc_DateStart() END
                     , tmpMIContainer.GoodsId
                     , tmpMIContainer.GoodsKindId
                     , COALESCE (ObjectLink_GoodsKindComplete_out.ChildObjectId, 0)
             UNION ALL
              SELECT tmpMIReceipt.ReceiptId
                   , tmpMIReceipt.PartionGoodsDate_in
                   , tmpMIReceipt.GoodsId_in
                   , tmpMIReceipt.GoodsKindId_in
                   , tmpMIReceipt.GoodsKindId_complete_in
                   , tmpMIReceipt.PartionGoodsDate
                   , tmpMIReceipt.GoodsId
                   , tmpMIReceipt.GoodsKindId
                   , tmpMIReceipt.GoodsKindId_complete
                   , 0 AS OperCount
                   , 0 AS OperSumm
                   , tmpMIReceipt.OperCountPlan
                   , tmpMIReceipt.OperSummPlan1
                   , tmpMIReceipt.OperSummPlan2
                   , tmpMIReceipt.OperSummPlan3
                   , 0 AS CuterCount
                   , 0 AS OperCount_ReWork
              FROM tmpMIReceipt
             ) AS tmp
                 LEFT JOIN tmpPrice1 ON tmpPrice1.GoodsId = tmp.GoodsId
                 LEFT JOIN tmpPrice2 ON tmpPrice2.GoodsId = tmp.GoodsId
                 LEFT JOIN tmpPrice3 ON tmpPrice3.GoodsId = tmp.GoodsId
        GROUP BY tmp.ReceiptId
               , tmp.PartionGoodsDate_in
               , tmp.GoodsId_in
               , tmp.GoodsKindId_in
               , tmp.GoodsKindId_complete_in
               , tmp.PartionGoodsDate
               , tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.GoodsKindId_complete
               , tmpPrice1.Price
               , tmpPrice2.Price
               , tmpPrice3.Price
                ;

 -- � ��������� ������� ������� ������ ��� ������� 1 � 2, ���� ����� ����������� ���������� �� � ������� ������� 
      CREATE TEMP TABLE tmpCursor1 ( GoodsId Integer, GoodsKindId Integer, MasterKey TVarChar, PartionGoodsDate TDateTime
                                   , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, GoodsKindId_complete Integer, GoodsKindName_complete TVarChar, MeasureName TVarChar
                                   , OperCount TFloat, OperCount_Weight TFloat, OperSumm TFloat, Price TFloat, OperSummPlan_real TFloat, OperCountPlan TFloat, OperCountPlan_Weight TFloat
                                   , OperSummPlan1_real TFloat, OperSummPlan2_real TFloat, OperSummPlan3_real TFloat, OperSummPlan1 TFloat, OperSummPlan2 TFloat, OperSummPlan3 TFloat
                                   , PricePlan1 TFloat, PricePlan2 TFloat, PricePlan3 TFloat
                                   , TaxSumm_min TFloat, TaxSumm_max TFloat, OperCount_ReWork TFloat, CuterCount TFloat, OperCount_gp_plan TFloat, OperCount_gp_real TFloat, LossGP_real  NUMERIC (16, 1), LossGP_plan  NUMERIC (16, 1)
                                   , TaxGP_real NUMERIC (16, 1), TaxGP_plan NUMERIC (16, 1)
                                   , Price_sale TFloat, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName  TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar) ON COMMIT DROP;
      INSERT INTO tmpCursor1 ( GoodsId, GoodsKindId, MasterKey, PartionGoodsDate
                             , GoodsGroupNameFull, GoodsGroupName, GoodsCode, GoodsName, GoodsKindName, GoodsKindId_complete, GoodsKindName_complete, MeasureName
                             , OperCount, OperCount_Weight, OperSumm, Price, OperSummPlan_real, OperCountPlan, OperCountPlan_Weight
                             , OperSummPlan1_real, OperSummPlan2_real, OperSummPlan3_real, OperSummPlan1, OperSummPlan2, OperSummPlan3, PricePlan1, PricePlan2, PricePlan3
                             , TaxSumm_min, TaxSumm_max, OperCount_ReWork, CuterCount, OperCount_gp_plan, OperCount_gp_real, LossGP_real, LossGP_plan, TaxGP_real, TaxGP_plan
                             , Price_sale , InfoMoneyGroupName, InfoMoneyDestinationName, InfoMoneyCode, InfoMoneyName)
 
       WITH tmpTaxSumm AS (SELECT tmpResult.GoodsId
                               , tmpResult.GoodsKindId
                               , tmpResult.PartionGoodsDate
                               , tmpResult.GoodsKindId_complete
                               , SUM (tmpResult_in.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS OperCount_Weight_gp
                               , MIN (CAST (100 * tmpResult.OperSumm / tmpResult_in.OperSumm AS NUMERIC(16, 1))) AS TaxSumm_min
                               , MAX (CAST (100 * tmpResult.OperSumm / tmpResult_in.OperSumm AS NUMERIC(16, 1))) AS TaxSumm_max
                          FROM tmpResult_out AS tmpResult
                               LEFT JOIN tmpResult_in ON tmpResult_in.ReceiptId            = tmpResult.ReceiptId
                                                     AND tmpResult_in.PartionGoodsDate     = tmpResult.PartionGoodsDate_in
                                                     AND tmpResult_in.GoodsId              = tmpResult.GoodsId_in
                                                     AND tmpResult_in.GoodsKindId          = tmpResult.GoodsKindId_in
                                                     AND tmpResult_in.GoodsKindId_complete = tmpResult.GoodsKindId_complete_in
                               LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                     ON ObjectFloat_Weight.ObjectId = tmpResult_in.GoodsId
                                                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                    ON ObjectLink_Goods_Measure.ObjectId = tmpResult_in.GoodsId
                                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                          WHERE tmpResult_in.OperSumm <> 0 AND tmpResult.OperSumm <> 0
                          GROUP BY tmpResult.GoodsId
                                 , tmpResult.GoodsKindId
                                 , tmpResult.PartionGoodsDate
                                 , tmpResult.GoodsKindId_complete
                         )
      SELECT tmpResult.GoodsId
           , tmpResult.GoodsKindId
           , (tmpResult.GoodsId :: TVarChar || ';' || tmpResult.GoodsKindId :: TVarChar || ';' || tmpResult.PartionGoodsDate :: TVarChar|| ';' || tmpResult.GoodsKindId_complete :: TVarChar) :: TVarChar AS MasterKey

           , CASE WHEN tmpResult.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpResult.PartionGoodsDate END :: TDateTime AS PartionGoodsDate

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.ValueData                  AS GoodsKindName         
           , Object_GoodsKind_complete.Id                AS GoodsKindId_complete
           , Object_GoodsKind_complete.ValueData         AS GoodsKindName_complete
           , Object_Measure.ValueData                    AS MeasureName

           , tmpResult.OperCount
           , tmpResult.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight
           , tmpResult.OperSumm
           , CAST (CASE WHEN tmpResult.OperCount <> 0 THEN tmpResult.OperSumm / tmpResult.OperCount ELSE 0 END AS NUMERIC (16, 3)) AS Price

           , tmpResult.OperCountPlan * CASE WHEN tmpResult.OperCount <> 0 THEN tmpResult.OperSumm / tmpResult.OperCount ELSE 0 END AS OperSummPlan_real

           , tmpResult.OperCountPlan
           , tmpResult.OperCountPlan * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCountPlan_Weight

           , tmpResult.OperCount * tmpResult.PricePlan1 AS OperSummPlan1_real -- CASE WHEN tmpResult.OperCountPlan <> 0 THEN tmpResult.OperSummPlan1 / tmpResult.OperCountPlan ELSE 0 END AS OperSummPlan1_real
           , tmpResult.OperCount * tmpResult.PricePlan2 AS OperSummPlan2_real -- CASE WHEN tmpResult.OperCountPlan <> 0 THEN tmpResult.OperSummPlan2 / tmpResult.OperCountPlan ELSE 0 END AS OperSummPlan2_real
           , tmpResult.OperCount * tmpResult.PricePlan3 AS OperSummPlan3_real -- CASE WHEN tmpResult.OperCountPlan <> 0 THEN tmpResult.OperSummPlan3 / tmpResult.OperCountPlan ELSE 0 END AS OperSummPlan3_real

           , tmpResult.OperSummPlan1
           , tmpResult.OperSummPlan2
           , tmpResult.OperSummPlan3
           , tmpResult.PricePlan1 AS PricePlan1 -- CAST (CASE WHEN tmpResult.OperCountPlan <> 0 THEN tmpResult.OperSummPlan1 / tmpResult.OperCountPlan ELSE 0 END AS NUMERIC (16, 3)) AS PricePlan1
           , tmpResult.PricePlan2 AS PricePlan2 -- CAST (CASE WHEN tmpResult.OperCountPlan <> 0 THEN tmpResult.OperSummPlan2 / tmpResult.OperCountPlan ELSE 0 END AS NUMERIC (16, 3)) AS PricePlan2
           , tmpResult.PricePlan3 AS PricePlan3 -- CAST (CASE WHEN tmpResult.OperCountPlan <> 0 THEN tmpResult.OperSummPlan3 / tmpResult.OperCountPlan ELSE 0 END AS NUMERIC (16, 3)) AS PricePlan3

           , tmpTaxSumm.TaxSumm_min
           , tmpTaxSumm.TaxSumm_max

           , tmpResult.OperCount_ReWork
           , tmpResult.CuterCount
           , tmpResult.OperCount_gp * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_gp_plan
           , tmpTaxSumm.OperCount_Weight_gp AS OperCount_gp_real

           , CAST (CASE WHEN (tmpResult.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) <> 0
                             THEN 100 - 100 * tmpTaxSumm.OperCount_Weight_gp / (tmpResult.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                         ELSE 0
                    END AS NUMERIC (16, 1)) AS LossGP_real
           , CAST (CASE WHEN (tmpResult.OperCountPlan) <> 0
                             THEN 100 - 100 * tmpResult.OperCount_gp / tmpResult.OperCountPlan
                         ELSE 0
                    END AS NUMERIC (16, 1)) AS LossGP_plan

           , CAST (CASE WHEN tmpResult.CuterCount <> 0 THEN tmpTaxSumm.OperCount_Weight_gp / tmpResult.CuterCount ELSE 0 END AS NUMERIC (16, 1)) AS TaxGP_real
           , CAST (CASE WHEN tmpResult.CuterCount <> 0 THEN (tmpResult.OperCount_gp * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                                                          / tmpResult.CuterCount
                        ELSE 0
                   END AS NUMERIC (16, 1)) AS TaxGP_plan

             -- !!!����������� ��������!!!
           , (COALESCE (PriceListSale_gk.Price, PriceListSale.Price) * 1.2 / CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData <> 0 THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Price_sale

           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

       FROM (SELECT tmpResult_out.PartionGoodsDate, tmpResult_out.GoodsId, tmpResult_out.GoodsKindId, tmpResult_out.GoodsKindId_complete
                  , SUM (tmpResult_out.OperCount)        AS OperCount
                  , SUM (tmpResult_out.OperSumm)         AS OperSumm
                  , SUM (tmpResult_out.OperCountPlan)    AS OperCountPlan
                  , SUM (tmpResult_out.OperSummPlan1)    AS OperSummPlan1
                  , SUM (tmpResult_out.OperSummPlan2)    AS OperSummPlan2
                  , SUM (tmpResult_out.OperSummPlan3)    AS OperSummPlan3
                  , SUM (tmpResult_out.CuterCount)       AS CuterCount
                  , SUM (tmpResult_out.OperCount_ReWork) AS OperCount_ReWork
                  , SUM (CASE WHEN (1 - COALESCE (ObjectFloat_TaxLoss.ValueData, 0) / 100) <> 0 THEN tmpResult_out.OperCount * (1 - COALESCE (ObjectFloat_TaxLoss.ValueData, 0) / 100) ELSE 0 END) AS OperCount_gp
                  , tmpResult_out.PricePlan1
                  , tmpResult_out.PricePlan2
                  , tmpResult_out.PricePlan3
             FROM tmpResult_out
                  LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                        ON ObjectFloat_TaxLoss.ObjectId = tmpResult_out.ReceiptId
                                       AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
             GROUP BY tmpResult_out.PartionGoodsDate, tmpResult_out.GoodsId, tmpResult_out.GoodsKindId, tmpResult_out.GoodsKindId_complete
                    , tmpResult_out.PricePlan1
                    , tmpResult_out.PricePlan2
                    , tmpResult_out.PricePlan3
            ) AS tmpResult
            LEFT JOIN tmpTaxSumm ON tmpTaxSumm.GoodsId              = tmpResult.GoodsId
                                AND tmpTaxSumm.GoodsKindId          = tmpResult.GoodsKindId
                                AND tmpTaxSumm.PartionGoodsDate     = tmpResult.PartionGoodsDate
                                AND tmpTaxSumm.GoodsKindId_complete = tmpResult.GoodsKindId_complete

            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale_gk ON PriceListSale_gk.PriceListId = inPriceListId_sale
                                                                          AND PriceListSale_gk.GoodsId = tmpResult.GoodsId
                                                                          AND PriceListSale_gk.GoodsKindId = tmpResult.GoodsKindId
                                                                          AND inEndDate >= PriceListSale_gk.StartDate AND inEndDate < PriceListSale_gk.EndDate
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                       AND PriceListSale.GoodsId = tmpResult.GoodsId
                                                                       AND PriceListSale.GoodsKindId = 0
                                                                       AND inEndDate >= PriceListSale.StartDate AND inEndDate < PriceListSale.EndDate
                                                                       AND PriceListSale_gk.GoodsId IS NULL

            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpResult.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = COALESCE (tmpResult.GoodsKindId_complete, 0 /*zc_GoodsKind_Basis()*/)

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
       WHERE tmpResult.OperCount        <> 0
          OR tmpResult.OperCountPlan    <> 0
          OR tmpResult.OperCount_ReWork <> 0
          OR tmpResult.CuterCount       <> 0;

    -- 
      CREATE TEMP TABLE tmpCursor2 (GoodsId Integer, GoodsKindId Integer, MasterKey TVarChar, PartionGoodsDate TDateTime, Code Integer, ReceiptCode TVarChar, Comment TVarChar, isMain Boolean
                                  , GoodsGroupNameFull TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, TradeMarkName TVarChar, GoodsId_in Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId_in Integer, GoodsKindName TVarChar, GoodsKindId_complete_in Integer, GoodsKindName_complete TVarChar,MeasureId Integer, MeasureName TVarChar
                                  , OperCountIn TFloat, OperCountIn_Weight TFloat, OperSummIn TFloat, PriceIn TFloat, TaxSumm TFloat
                                  , OperCount TFloat, OperCount_Weight TFloat, OperSumm TFloat, Price TFloat
                                  , OperSummPlan_real TFloat, OperCountPlan TFloat, OperCountPlan_Weight TFloat
                                  , OperSummPlan1_real TFloat, OperSummPlan2_real TFloat, OperSummPlan3_real TFloat, OperSummPlan1 TFloat, OperSummPlan2 TFloat, OperSummPlan3 TFloat
                                  , PricePlan1 TFloat, PricePlan2 TFloat, PricePlan3 TFloat
                                  , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName  TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
                                  , CuterCount TFloat
                                   ) ON COMMIT DROP;
      INSERT INTO tmpCursor2 (GoodsId, GoodsKindId, MasterKey, PartionGoodsDate, COde, ReceiptCode, Comment, isMain
                            , GoodsGroupNameFull, GoodsGroupAnalystName, GoodsTagName, TradeMarkName, GoodsId_in, GoodsCode, GoodsName, GoodsKindId_in, GoodsKindName, GoodsKindId_complete_in, GoodsKindName_complete, MeasureId, MeasureName
                            , OperCountIn, OperCountIn_Weight, OperSummIn, PriceIn, TaxSumm,  OperCount, OperCount_Weight, OperSumm, Price, OperSummPlan_real, OperCountPlan, OperCountPlan_Weight
                            , OperSummPlan1_real, OperSummPlan2_real, OperSummPlan3_real, OperSummPlan1, OperSummPlan2, OperSummPlan3, PricePlan1, PricePlan2, PricePlan3
                            , InfoMoneyGroupName, InfoMoneyDestinationName, InfoMoneyCode, InfoMoneyName
                            , CuterCount
                              )


       SELECT tmpResult.GoodsId
            , tmpResult.GoodsKindId
            , (tmpResult.GoodsId :: TVarChar || ';' || tmpResult.GoodsKindId :: TVarChar || ';' || tmpResult.PartionGoodsDate :: TVarChar|| ';' || tmpResult.GoodsKindId_complete :: TVarChar) :: TVarChar AS MasterKey
            , CASE WHEN tmpResult.PartionGoodsDate_in = zc_DateStart() THEN NULL ELSE tmpResult.PartionGoodsDate_in END :: TDateTime AS PartionGoodsDate

           , Object_Receipt.ObjectCode      AS Code
           , ObjectString_Code.ValueData    AS ReceiptCode
           , ObjectString_Comment.ValueData AS Comment

           , ObjectBoolean_Main.ValueData        AS isMain

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
           , Object_GoodsTag.ValueData                   AS GoodsTagName
           , Object_TradeMark.ValueData                  AS TradeMarkName
           , Object_Goods.Id                             AS GoodsId_in
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.Id                         AS GoodsKindId_in 
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_GoodsKind_complete.Id                AS GoodsKindId_complete_in
           , Object_GoodsKind_complete.ValueData         AS GoodsKindName_complete
           , Object_Measure.Id                           AS MeasureId
           , Object_Measure.ValueData                    AS MeasureName

           , tmpResult_in.OperCount AS OperCountIn
           , tmpResult_in.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCountIn_Weight
           , tmpResult_in.OperSumm AS OperSummIn
           , CAST (CASE WHEN tmpResult_in.OperCount <> 0 THEN tmpResult_in.OperSumm / tmpResult_in.OperCount ELSE 0 END AS NUMERIC (16, 3)) AS PriceIn

           , CAST (CASE WHEN tmpResult_in.OperSumm <> 0 THEN 100 * tmpResult.OperSumm / tmpResult_in.OperSumm ELSE 0 END AS NUMERIC(16, 1)) AS TaxSumm

           , tmpResult.OperCount
           , tmpResult.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight
           , tmpResult.OperSumm
           , CAST (CASE WHEN tmpResult.OperCount <> 0 THEN tmpResult.OperSumm / tmpResult.OperCount ELSE 0 END AS NUMERIC (16, 3)) AS Price

           , tmpResult.OperCountPlan * CASE WHEN tmpResult.OperCount <> 0 THEN tmpResult.OperSumm / tmpResult.OperCount ELSE 0 END AS OperSummPlan_real

           , tmpResult.OperCountPlan
           , tmpResult.OperCountPlan * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCountPlan_Weight

           , tmpResult.OperCount * tmpResult.PricePlan1 AS OperSummPlan1_real
           , tmpResult.OperCount * tmpResult.PricePlan2 AS OperSummPlan2_real
           , tmpResult.OperCount * tmpResult.PricePlan3 AS OperSummPlan3_real

           , tmpResult.OperSummPlan1
           , tmpResult.OperSummPlan2
           , tmpResult.OperSummPlan3

           , tmpResult.PricePlan1 -- tmpPricePlan.PricePlan1
           , tmpResult.PricePlan2 -- tmpPricePlan.PricePlan2
           , tmpResult.PricePlan3 -- tmpPricePlan.PricePlan3

           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName 
           
           , tmpResult_in.CuterCount
           
       FROM tmpResult_out AS tmpResult

            LEFT JOIN tmpResult_in ON tmpResult_in.ReceiptId            = tmpResult.ReceiptId
                                  AND tmpResult_in.PartionGoodsDate     = tmpResult.PartionGoodsDate_in
                                  AND tmpResult_in.GoodsId              = tmpResult.GoodsId_in
                                  AND tmpResult_in.GoodsKindId          = tmpResult.GoodsKindId_in
                                  AND tmpResult_in.GoodsKindId_complete = tmpResult.GoodsKindId_complete_in

            LEFT JOIN Object AS Object_Receipt   ON Object_Receipt.Id   = tmpResult.ReceiptId
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpResult.GoodsId_in
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId_in
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = COALESCE (tmpResult.GoodsKindId_complete_in, 0 /*zc_GoodsKind_Basis()*/)

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                 ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                    ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Receipt_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId   
       WHERE tmpResult.OperCount     <> 0
          OR tmpResult.OperCountPlan <> 0
          OR tmpResult_in.OperCount  <> 0
       ;


      -- ���������
      OPEN Cursor1 FOR

      SELECT tmpCursor1.*
      FROM tmpCursor1;
      
      RETURN NEXT Cursor1;


     -- ���������
     OPEN Cursor2 FOR

      SELECT tmpCursor2.*
      FROM tmpCursor2;
      
      RETURN NEXT Cursor2;
      
     OPEN Cursor3 FOR
      WITH
      tmp AS (SELECT tmpCursor2.*
                   , ROW_NUMBER() OVER (PARTITION BY tmpCursor2.MasterKey ORDER BY tmpCursor2.ReceiptCode) AS Ord
              FROM tmpCursor2
             )

      SELECT tmpCursor1.GoodsId
           , tmpCursor1.GoodsKindId
           , tmpCursor1.MasterKey
           , tmpCursor1.PartionGoodsDate

           , tmpCursor1.GoodsGroupNameFull
           , tmpCursor1.GoodsGroupName
           , tmpCursor1.GoodsCode
           , tmpCursor1.GoodsName
           , tmpCursor1.GoodsKindName
           , tmpCursor1.GoodsKindName_complete
           , tmpCursor1.MeasureName

           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCount ELSE 0 END         AS OperCount
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCount_Weight  ELSE 0 END AS OperCount_Weight
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSumm ELSE 0 END          AS OperSumm
           , tmpCursor1.Price     AS Price

           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan_real ELSE 0 END AS OperSummPlan_real

           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCountPlan ELSE 0 END        AS  OperCountPlan
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCountPlan_Weight ELSE 0 END AS OperCountPlan_Weight

           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan1_real  ELSE 0 END AS  OperSummPlan1_real
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan2_real  ELSE 0 END AS  OperSummPlan2_real
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan3_real  ELSE 0 END AS  OperSummPlan3_real

           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan1  ELSE 0 END AS OperSummPlan1
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan2  ELSE 0 END AS OperSummPlan2
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperSummPlan3  ELSE 0 END AS OperSummPlan3
           , tmpCursor1.PricePlan1 AS PricePlan1
           , tmpCursor1.PricePlan2 AS PricePlan2
           , tmpCursor1.PricePlan3 AS PricePlan3

           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.TaxSumm_min       ELSE 0 END AS  TaxSumm_min      
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.TaxSumm_max       ELSE 0 END AS  TaxSumm_max      
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCount_ReWork  ELSE 0 END AS  OperCount_ReWork 
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor2.CuterCount        ELSE 0 END AS  CuterCount
           , tmpCursor2.CuterCount                                                     AS  CuterCount_inf      -- 
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCount_gp_plan ELSE 0 END AS  OperCount_gp_plan
           , CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.OperCount_gp_real ELSE 0 END AS  OperCount_gp_real
           --, CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.LossGP_real       ELSE 0 END AS  LossGP_real      
           --, CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.LossGP_plan       ELSE 0 END AS  LossGP_plan      
           --, CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.TaxGP_real        ELSE 0 END AS  TaxGP_real       
           --, CASE WHEN tmpCursor2.Ord = 1 THEN tmpCursor1.TaxGP_plan        ELSE 0 END AS  TaxGP_plan       
           , tmpCursor1.Price_sale

           , tmpCursor1.InfoMoneyGroupName              AS InfoMoneyGroupName
           , tmpCursor1.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , tmpCursor1.InfoMoneyCode                   AS InfoMoneyCode
           , tmpCursor1.InfoMoneyName                   AS InfoMoneyName
           
           --
           , tmpCursor2.GoodsId               AS GoodsId_child        
           , tmpCursor2.GoodsKindId           AS GoodsKindId_child     
           , tmpCursor2.PartionGoodsDate      AS PartionGoodsDate_child

           , tmpCursor2.Code                   AS Code_child                  
           , tmpCursor2.ReceiptCode            AS ReceiptCode_child           
           , tmpCursor2.Comment                AS Comment_child               
           , tmpCursor2.isMain                 AS isMain_child                
           , tmpCursor2.GoodsGroupNameFull     AS GoodsGroupNameFull_child    
           , tmpCursor2.GoodsGroupAnalystName  AS GoodsGroupAnalystName_child 
           , tmpCursor2.GoodsTagName           AS GoodsTagName_child          
           , tmpCursor2.TradeMarkName          AS TradeMarkName_child         
           , tmpCursor2.GoodsCode              AS GoodsCode_child             
           , tmpCursor2.GoodsName              AS GoodsName_child             
           , tmpCursor2.GoodsKindName          AS GoodsKindName_child         
           , tmpCursor2.GoodsKindName_complete AS GoodsKindName_complete_child
           , tmpCursor2.MeasureName            AS MeasureName_child           

           , tmpCursor2.OperCountIn          AS OperCountIn_child         
           , tmpCursor2.OperCountIn_Weight   AS OperCountIn_Weight_child  
           , tmpCursor2.OperSummIn           AS OperSummIn_child          
           , tmpCursor2.PriceIn              AS PriceIn_child             
           , tmpCursor2.TaxSumm              AS TaxSumm_child             
           , tmpCursor2.OperCount            AS OperCount_child           
           , tmpCursor2.OperCount_Weight     AS OperCount_Weight_child    
           , tmpCursor2.OperSumm             AS OperSumm_child            
           , tmpCursor2.Price                AS Price_child               
           , tmpCursor2.OperSummPlan_real    AS OperSummPlan_real_child   
           , tmpCursor2.OperCountPlan        AS OperCountPlan_child       
           , tmpCursor2.OperCountPlan_Weight AS OperCountPlan_Weight_child
           , tmpCursor2.OperSummPlan1_real   AS OperSummPlan1_real_child  
           , tmpCursor2.OperSummPlan2_real   AS OperSummPlan2_real_child  
           , tmpCursor2.OperSummPlan3_real   AS OperSummPlan3_real_child  

           , tmpCursor2.OperSummPlan1 AS OperSummPlan1_child
           , tmpCursor2.OperSummPlan2 AS OperSummPlan2_child
           , tmpCursor2.OperSummPlan3 AS OperSummPlan3_child

           , tmpCursor2.PricePlan1 AS PricePlan1_child
           , tmpCursor2.PricePlan2 AS PricePlan2_child
           , tmpCursor2.PricePlan3 AS PricePlan3_child

           , tmpCursor2.InfoMoneyGroupName       AS InfoMoneyGroupName_child
           , tmpCursor2.InfoMoneyDestinationName AS InfoMoneyDestinationName_child
           , tmpCursor2.InfoMoneyCode            AS InfoMoneyCode_child
           , tmpCursor2.InfoMoneyName            AS InfoMoneyName_child 
           
           , CAST (CASE WHEN (tmpCursor2.OperCount_Weight) <> 0
                             THEN 100 - 100 * tmpCursor2.OperCountIn_Weight / (tmpCursor2.OperCount_Weight)
                         ELSE 0
                    END AS NUMERIC (16, 1)) AS LossGP_real---_child          --++

           , CAST (CASE WHEN (tmpCursor2.OperCountPlan) <> 0
                             THEN 100 - 100 * tmpCursor2.OperCount / tmpCursor2.OperCountPlan
                         ELSE 0
                    END AS NUMERIC (16, 1)) AS LossGP_plan --_child

           , CAST (CASE WHEN tmpCursor1.CuterCount <> 0 THEN tmpCursor2.OperCountIn_Weight / tmpCursor1.CuterCount ELSE 0 END AS NUMERIC (16, 1)) AS TaxGP_real
           , CAST (CASE WHEN tmpCursor1.CuterCount <> 0 THEN tmpCursor2.OperCount / tmpCursor1.CuterCount ELSE 0 END          AS NUMERIC (16, 1)) AS TaxGP_plan

      FROM tmpCursor1
          LEFT JOIN tmp AS tmpCursor2 ON tmpCursor2.MasterKey = tmpCursor1.MasterKey  
      ;
      
      RETURN NEXT Cursor3;

END;
 $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.04.24         * add Cursor3
 10.08.15                                        *
*/

-- ����
-- SELECT * FROM gpReport_ReceiptProductionOutAnalyze (inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inFromId:= 8447, inToId:= 8447, inGoodsGroupId:= 0, inPriceListId_1:= 0, inPriceListId_2:= 0, inPriceListId_3:= 0, inPriceListId_sale:= 0, inIsPartionGoods:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReport_ReceiptProductionOutAnalyze( ('01.09.2020')::TDateTime ,  ('01.09.2020')::TDateTime ,  8447 , 8447 ,  1918 ,  18887 ,  18886 ,  18885 , 18840 , 'False' ,   '5');
-- SELECT * FROM gpReport_ReceiptProductionOutAnalyze(inStartDate := ('16.12.2024')::TDateTime , inEndDate := ('17.12.2024')::TDateTime , inFromId := 8448 , inToId := 8448 , inGoodsGroupId := 0 , inPriceListId_1 := 18887 , inPriceListId_2 := 18886 , inPriceListId_3 := 2515112 , inPriceListId_sale := 18840 , inIsPartionGoods := 'False' ,  inSession := '9457'::TVarChar); -- FETCH ALL "<unnamed portal 1>";
