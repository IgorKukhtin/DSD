-- Function: gpReport_GoodsMI_ProductionUnion ()

DROP FUNCTION IF EXISTS gpReport_ProductionUnion_Olap (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertProductionUnion_Olap (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProductionUnion_Olap (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionUnion_Olap (
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inStartDate2         TDateTime ,
    IN inEndDate2           TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inIsPartion          Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inChildGoodsGroupId  Integer   ,
    IN inChildGoodsId       Integer   ,
    IN inFromId             Integer   ,    -- �� ����
    IN inToId               Integer   ,    -- ����
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Invnumber TVarchar, OperDate TDatetime, MonthDate TDatetime, isPeresort boolean
             , DocumentKindId Integer, DocumentKindName TVarchar, ReceiptName TVarchar
             , PartionGoodsId Integer, PartionGoods TVarchar, PartionGoods_Date TDatetime
             , GoodsGroupName TVarchar, GoodsCode Integer, GoodsId Integer, GoodsName TVarchar
             , GoodskindName TVarchar, GoodskindName_Complete TVarchar
             , MeasureName TVarchar
             , Amount TFloat, Amount_weight TFloat, Summ TFloat
             , PartionGoodsId_out Integer, ChildpartionGoods TVarchar, ChildpartionGoods_Date TDatetime
             , ChildGoodsGroupName TVarchar, GoodsId_child Integer, ChildGoodsCode Integer, ChildGoodsName TVarchar
             , ChildGoodskindName TVarchar, ChildMeasureName TVarchar
             , ChildAmount TFloat, ChildAmountReceipt TFloat, ChildAmountcalc TFloat, ChildAmount_weight TFloat
             , ChildAmountReceipt_weight TFloat, ChildAmountcalc_weight TFloat
             , ChildSumm TFloat, ChildSummReceipt TFloat, ChildSummcalc TFloat
             , CuterCount TFloat
             , InfoMoneyId Integer, InfoMoneycode Integer, InfoMoneyGroupName TVarchar
             , InfoMoneydestinationName TVarchar, InfoMoneyName TVarchar, InfoMoneyName_all TVarchar
             , InfoMoneyId_Detail Integer, InfoMoneycode_Detail Integer, InfoMoneyGroupName_Detail TVarchar
             , InfoMoneydestinationName_Detail TVarchar, InfoMoneyName_Detail TVarchar
             , InfoMoneyName_all_Detail TVarchar, GoodsGroupNamefull TVarchar, GoodsGroupAnalystName TVarchar
             , TradeMarkName TVarchar, GoodstagName TVarchar, GoodsplatformName TVarchar, ChildGoodsGroupNamefull TVarchar
             , ChildGoodsGroupAnalystName TVarchar, ChildTradeMarkName TVarchar, ChildGoodstagName TVarchar, ChildGoodsplatformName TVarchar
              )
AS
$BODY$
   DECLARE vbIsDate Boolean;
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- ����������� �� ������
    /*CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpChildGoods (ChildGoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;*/

    vbIsDate:= (inStartDate  + INTERVAL '2 MONTH' > inEndDate)
            OR (inStartDate2 + INTERVAL '2 MONTH' > inEndDate2)
           ;

    IF inStartDate  = '01.01.2019' AND inEndDate  = '31.12.2019'
   AND inStartDate2 = '01.01.2020' AND inEndDate2 = '31.12.2020'
    THEN
        -- ���������
        RETURN QUERY
           WITH   _tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                                WHERE inGoodsGroupId <> 0 AND inGoodsId = 0
                               UNION
                                SELECT inGoodsId AS GoodsId WHERE inGoodsId <> 0
                               UNION
                                SELECT Object.Id AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Goods() AND inGoodsGroupId = 0 AND inGoodsId = 0
                               )
       
                , _tmpChildGoods AS (SELECT lfSelect.GoodsId AS GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfSelect
                                      WHERE inChildGoodsGroupId <> 0 AND inChildGoodsId = 0
                                     UNION
                                      SELECT inChildGoodsId AS GoodsId WHERE inChildGoodsId <> 0
                                     UNION
                                      SELECT Object.Id AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Goods() AND inChildGoodsGroupId = 0 AND inChildGoodsId = 0
                                     )
        -- ���������
        SELECT tReport.Invnumber, DATE_TRUNC ('YEAR', tReport.OperDate) :: TDateTime  AS OperDate, DATE_TRUNC ('YEAR', tReport.MonthDate) :: TDateTime AS MonthDate
             , tReport.isPeresort
             , tReport.DocumentKindId, tReport.DocumentKindName
           --, tReport.ReceiptName
             , '' :: TVarChar AS ReceiptName
             , tReport.PartionGoodsId, tReport.PartionGoods, tReport.PartionGoods_Date
             , tReport.GoodsGroupName, tReport.GoodsId, tReport.GoodsCode, tReport.GoodsName
             , tReport.GoodskindName, tReport.GoodskindName_Complete
             , tReport.MeasureName
             , SUM (tReport.Amount) :: TFloat AS Amount, SUM (tReport.Amount_weight) :: TFloat AS Amount_weight, SUM (tReport.Summ) :: TFloat AS Summ
             , tReport.PartionGoodsId_out, tReport.ChildpartionGoods, tReport.ChildpartionGoods_Date
             , tReport.ChildGoodsGroupName, tReport.GoodsId_child, tReport.ChildGoodsCode, tReport.ChildGoodsName
             , tReport.ChildGoodskindName, tReport.ChildMeasureName
             , SUM (tReport.ChildAmount) :: TFloat AS ChildAmount, SUM (tReport.ChildAmountReceipt) :: TFloat AS ChildAmountReceipt, SUM (tReport.ChildAmountcalc) :: TFloat AS ChildAmountcalc, SUM (tReport.ChildAmount_weight) :: TFloat AS ChildAmount_weight
             , SUM (tReport.ChildAmountReceipt_weight) :: TFloat AS ChildAmountReceipt_weight, SUM (tReport.ChildAmountcalc_weight) :: TFloat AS ChildAmountcalc_weight
             , SUM (tReport.ChildSumm) :: TFloat AS ChildSumm, SUM (tReport.ChildSummReceipt) :: TFloat AS ChildSummReceipt, SUM (tReport.ChildSummcalc) :: TFloat AS ChildSummcalc
             , SUM (tReport.CuterCount) :: TFloat AS CuterCount

           --, tReport.InfoMoneyId, tReport.InfoMoneyCode
             , 0 :: Integer AS InfoMoneyId, 0 :: Integer AS InfoMoneyCode
             , tReport.InfoMoneyGroupName
           --, tReport.InfoMoneydestinationName, tReport.InfoMoneyName, tReport.InfoMoneyName_all
             , '' :: TVarChar AS InfoMoneydestinationName, '' :: TVarChar AS InfoMoneyName, '' :: TVarChar AS InfoMoneyName_all

           --, tReport.InfoMoneyId_Detail, tReport.InfoMoneyCode_Detail
             , 0 :: Integer AS InfoMoneyId_Detail, 0 :: Integer AS InfoMoneyCode_Detail
             , tReport.InfoMoneyGroupName_Detail
           --, tReport.InfoMoneydestinationName_Detail, tReport.InfoMoneyName_Detail, tReport.InfoMoneyName_all_Detail
             , '' :: TVarChar AS InfoMoneydestinationName_Detail, '' :: TVarChar AS InfoMoneyName_Detail, '' :: TVarChar AS InfoMoneyName_all_Detail

             , tReport.GoodsGroupNamefull, tReport.GoodsGroupAnalystName
             , tReport.TradeMarkName, tReport.GoodstagName, tReport.GoodsplatformName, tReport.ChildGoodsGroupNamefull
             , tReport.ChildGoodsGroupAnalystName, tReport.ChildTradeMarkName, tReport.ChildGoodstagName, tReport.ChildGoodsplatformName
        FROM tReport_ProductionUnion_Olap  AS tReport
             JOIN _tmpGoods ON _tmpGoods.GoodsId = tReport.GoodsId
        WHERE tReport.MonthDate BETWEEN inStartDate AND inEndDate2
        --AND (tReport.GoodsId_child IN (SELECT _tmpChildGoods.GoodsId FROM _tmpChildGoods) OR (inChildGoodsGroupId = 0 AND inChildGoodsId = 0))
          AND (tReport.GoodsId IN (SELECT DISTINCT tReport.GoodsId
                                   FROM tReport_ProductionUnion_Olap AS tReport
                                        JOIN _tmpChildGoods ON _tmpChildGoods.GoodsId = tReport.GoodsId_child
                                   WHERE tReport.MonthDate BETWEEN inStartDate AND inEndDate2
                                   --AND tReport.Amount > 0
                                  )
            OR tReport.GoodsId_child IN (SELECT _tmpChildGoods.GoodsId FROM _tmpChildGoods)
            OR (inChildGoodsGroupId = 0 AND inChildGoodsId = 0)
              )
 
        GROUP BY tReport.Invnumber, tReport.OperDate, tReport.MonthDate, tReport.isPeresort
             , tReport.DocumentKindId, tReport.DocumentKindName
           --, tReport.ReceiptName

             , tReport.PartionGoodsId, tReport.PartionGoods, tReport.PartionGoods_Date
             , tReport.GoodsGroupName, tReport.GoodsCode, tReport.GoodsId, tReport.GoodsName
             , tReport.GoodskindName, tReport.GoodskindName_Complete
             , tReport.MeasureName

             , tReport.PartionGoodsId_out, tReport.ChildpartionGoods, tReport.ChildpartionGoods_Date
             , tReport.ChildGoodsGroupName, tReport.GoodsId_child, tReport.ChildGoodsCode, tReport.ChildGoodsName
             , tReport.ChildGoodskindName, tReport.ChildMeasureName

           --, tReport.InfoMoneyId, tReport.InfoMoneycode
             , tReport.InfoMoneyGroupName
           --, tReport.InfoMoneydestinationName, tReport.InfoMoneyName, tReport.InfoMoneyName_all

           --, tReport.InfoMoneyId_Detail, tReport.InfoMoneycode_Detail
             , tReport.InfoMoneyGroupName_Detail
           --, tReport.InfoMoneydestinationName_Detail, tReport.InfoMoneyName_Detail, tReport.InfoMoneyName_all_Detail

             , tReport.GoodsGroupNamefull, tReport.GoodsGroupAnalystName
             , tReport.TradeMarkName, tReport.GoodstagName, tReport.GoodsplatformName, tReport.ChildGoodsGroupNamefull
             , tReport.ChildGoodsGroupAnalystName, tReport.ChildTradeMarkName, tReport.ChildGoodstagName, tReport.ChildGoodsplatformName

       ;

    ELSE

    -- ���������
    RETURN QUERY

    WITH   _tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                         WHERE inGoodsGroupId <> 0 AND inGoodsId = 0
                        UNION
                         SELECT inGoodsId AS GoodsId WHERE inGoodsId <> 0
                        UNION
                         SELECT Object.Id AS GoodsId FROM Object WHERE Object.DescId = zc_Object_Goods() AND inGoodsGroupId = 0 AND inGoodsId = 0
                        )

         , _tmpChildGoods AS (SELECT lfSelect.GoodsId AS ChildGoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfSelect
                               WHERE inChildGoodsGroupId <> 0 AND inChildGoodsId = 0
                              UNION
                               SELECT inChildGoodsId AS ChildGoodsId WHERE inChildGoodsId <> 0
                              UNION
                               SELECT Object.Id AS ChildGoodsId FROM Object WHERE Object.DescId = zc_Object_Goods() AND inChildGoodsGroupId = 0 AND inChildGoodsId = 0
                              )
         -- ����������� �� �� ����
         , _tmpFromGroup AS (SELECT lfSelect.UnitId AS FromId FROM  lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect
                             WHERE inFromId <> 0
                            UNION
                             SELECT Object.Id AS FromId FROM Object WHERE Object.DescId = zc_Object_Unit() AND inFromId = 0
                            )
         -- ����������� �� ����
         , _tmpToGroup AS (SELECT lfSelect.UnitId AS ToId FROM  lfSelect_Object_Unit_byGroup (inToId) AS lfSelect
                           WHERE inToId <> 0
                          UNION
                           SELECT Object.Id AS ToId FROM Object WHERE Object.DescId = zc_Object_Unit() AND inToId = 0
                          )

           -- ������ ������� �������
         , tmpMI_ContainerIn1 AS (SELECT CASE WHEN vbIsDate = TRUE THEN MIContainer.OperDate ELSE DATE_TRUNC ('YEAR', MIContainer.OperDate) END AS OperDate
                                       , MIContainer.ObjectExtId_Analyzer                     AS FromId
                                       , MIContainer.WhereObjectId_Analyzer                   AS ToId
                                       , MIContainer.MovementId                               AS MovementId
                                       , MIContainer.MovementItemId                           AS MovementItemId
                                       , MILO_Receipt.ObjectId                                AS ReceiptId
                                       , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                                       , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                                       , MIContainer.DescId                                   AS MIContainerDescId
                                       , MIContainer.ContainerId                              AS ContainerId
                                       , MIContainer.ObjectId_Analyzer                        AS GoodsId
                                       , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId
                                       , SUM (MIContainer.Amount)                             AS Amount

                                  FROM MovementItemContainer AS MIContainer
                                       INNER JOIN _tmpFromGroup ON _tmpFromGroup.FromId = MIContainer.ObjectExtId_Analyzer
                                       INNER JOIN _tmpToGroup   ON _tmpToGroup.ToId     = MIContainer.WhereObjectId_Analyzer
                                       INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                       LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                  ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                                 AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                       LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                                    ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                                                                   AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                                       -- ����� � ����������
                                       LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                                        ON MILO_Receipt.MovementItemId = MIContainer.MovementItemId
                                                                       AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                                  WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                    AND MIContainer.isActive = TRUE
                                    AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                  GROUP BY MIContainer.MovementId
                                         , MIContainer.MovementItemId
                                         , MILO_Receipt.ObjectId
                                         , MovementBoolean_Peresort.ValueData
                                         , MLO_DocumentKind.ObjectId
                                         , MIContainer.DescId
                                         , MIContainer.ContainerId
                                         , MIContainer.ObjectId_Analyzer
                                         , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                         , CASE WHEN vbIsDate = TRUE THEN MIContainer.OperDate ELSE DATE_TRUNC ('YEAR', MIContainer.OperDate) END
                                         , MIContainer.ObjectExtId_Analyzer
                                         , MIContainer.WhereObjectId_Analyzer
                                 )
         , tmpMI_Master_Cuter1 AS (SELECT MIFloat_CuterCount.*
                                   FROM MovementItemFloat AS MIFloat_CuterCount
                                   WHERE MIFloat_CuterCount.MovementItemId IN (SELECT DISTINCT tmpMI_ContainerIn1.MovementItemId FROM tmpMI_ContainerIn1)
                                     AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                   )
         , tmpMI_Partion_Cuter1 AS (SELECT tmpMI_ContainerIn.MovementItemId
                                        , SUM (CASE WHEN COALESCE (MI_Partion.Amount, 0) <> 0
                                                    THEN MI_Child.Amount / MI_Partion.Amount * COALESCE (MIFloat_CuterCount.ValueData, 0)
                                                    ELSE 0
                                               END )  AS CuterCount
                                    FROM tmpMI_ContainerIn1 AS tmpMI_ContainerIn
                                         INNER JOIN MovementItem AS MI_Child
                                                                 ON MI_Child.ParentId   = tmpMI_ContainerIn.MovementItemId
                                                                AND MI_Child.MovementId = tmpMI_ContainerIn.MovementId
                                                                AND MI_Child.DescId = zc_MI_Child()
                                                                AND MI_Child.isErased = FALSE
                                         INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MI_Child.Id
                                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                          AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress()
                                         INNER JOIN MovementItemContainer AS MIContainer_Child
                                                                          ON MIContainer_Child.MovementItemId = MI_Child.Id
                                                                         AND MIContainer_Child.DescId = zc_MIContainer_Count()

                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId    = MIContainer_Child.ContainerId
                                                                        AND MIContainer.DescId         = zc_MIContainer_Count()
                                                                        AND MIContainer.WhereObjectId_Analyzer = tmpMI_ContainerIn.FromId
                                                                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                                        AND MIContainer.IsActive       = TRUE
                                                                        AND MIContainer.Amount         <> 0

                                         LEFT JOIN MovementItem AS MI_Partion ON MI_Partion.Id = MIContainer.MovementItemId

                                         LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                                     ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                                                    AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

                                    WHERE tmpMI_ContainerIn.FromId <> tmpMI_ContainerIn.ToId
                                      AND tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count()
                                    GROUP BY tmpMI_ContainerIn.MovementItemId
                                    )

         , tmpContainer_in1 AS (SELECT DISTINCT tmp.ContainerId
                                     , tmp.GoodsId
                                     , tmp.GoodsKindId
                                     , CASE WHEN tmp.GoodsKindId = zc_GoodsKind_WorkProgress()
                                             AND COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0) = 0
                                                 THEN zc_GoodsKind_Basis()
                                            ELSE COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                                       END AS GoodsKindId_complete
                                     --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                                     , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                                     , CLO_InfoMoney.ObjectId             AS InfoMoneyId
                                     , CLO_InfoMoneyDetail.ObjectId       AS InfoMoneyId_Detail
                                FROM tmpMI_ContainerIn1 AS tmp
                                     LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                   ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerId
                                                                  AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                   ON CLO_InfoMoney.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                                   ON CLO_InfoMoneyDetail.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                          ON ObjectLink_GoodsKindComplete.ObjectId = ContainerLO_PartionGoods.ObjectId
                                                         AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                )

         , tmpOut1 AS (SELECT MIContainer.OperDate                 AS OperDate
                            , MIContainer.MovementId               AS MovementId
                            , MIContainer.MovementItemId           AS MovementItemId
                            , MovementItem.ParentId                AS MovementItemId_master
                            , MIContainer.DescId                   AS MIContainerDescId
                            , tmpContainer_in.GoodsId              AS GoodsId_in
                            , tmpContainer_in.GoodsKindId          AS GoodsKindId_in
                            , tmpContainer_in.GoodsKindId_complete AS GoodsKindId_complete_in
                            , tmpContainer_in.PartionGoodsId       AS PartionGoodsId_in
                            , tmpContainer_in.InfoMoneyId          AS InfoMoneyId_in
                            , tmpContainer_in.InfoMoneyId_Detail   AS InfoMoneyId_Detail_in
                            , MIContainer.ContainerId              AS ContainerId
                            , MIContainer.ObjectId_Analyzer        AS GoodsId
                            , COALESCE (MILO_GoodsKind.ObjectId, MIContainer.ObjectIntId_Analyzer) AS GoodsKindId
                            , (MIContainer.Amount)                 AS Amount
                            , MI_Master.Amount                     AS Amount_Master
                          --, MIFloat_CuterCount_master.ValueData  AS CuterCount_master

                       FROM tmpContainer_in1 AS tmpContainer_in
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId_Analyzer = tmpContainer_in.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                           AND MIContainer.isActive = FALSE
                           INNER JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = MIContainer.ObjectId_Analyzer
                           LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                                 AND MovementItem.MovementId = MIContainer.MovementId
                                                 AND MovementItem.DescId   = zc_MI_Child()
                           LEFT JOIN MovementItem AS MI_Master
                                                  ON MI_Master.Id = MovementItem.ParentId
                                                 AND MI_Master.MovementId = MIContainer.MovementId
                                                 AND MI_Master.DescId   = zc_MI_Master()
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                            ON MILO_GoodsKind.MovementItemId = MIContainer.MovementItemId
                                                           AND MILO_GoodsKind.DescId        = zc_MILinkObject_GoodsKind()
                         --LEFT JOIN tmpMI_Master_Cuter1 AS MIFloat_CuterCount_master
                         --                              ON MIFloat_CuterCount_master.MovementItemId = MI_Master.Id
                         --                             AND MIFloat_CuterCount_master.DescId        = zc_MIFloat_CuterCount()
                      )

         , tmpMovementBoolean1 AS (SELECT MovementBoolean.*
                                   FROM MovementBoolean
                                   WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpOut1.MovementId FROM tmpOut1)
                                     AND MovementBoolean.DescId = zc_MovementBoolean_Peresort()
                                  )
         , tmpMovementLinkObject1 AS (SELECT MovementLinkObject.*
                                      FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpOut1.MovementId FROM tmpOut1)
                                        AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentKind()
                                     )
         --
         , tmpMIAmountReceipt1 AS (SELECT MovementItemFloat.*
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpOut1.MovementItemId FROM tmpOut1)
                                     AND MovementItemFloat.DescId = zc_MIFloat_AmountReceipt()
                                  )
         , tmpMIBoolean1 AS (SELECT MovementItemBoolean.*
                             FROM MovementItemBoolean
                             WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpOut1.MovementItemId FROM tmpOut1)
                               AND MovementItemBoolean.DescId IN (zc_MIBoolean_TaxExit(), zc_MIBoolean_WeightMain())
                                  )

         -- ���-�� ������� ������
         , tmpMICuterCount1 AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpOut1.MovementItemId_master FROM tmpOut1)
                                  AND MovementItemFloat.DescId = zc_MIFloat_CuterCount()
                                )

         , tmpMI_ContainerOut1 AS
                       (SELECT MIContainer.OperDate
                             , MIContainer.MovementId
                             , MIContainer.MovementItemId
                             , MIContainer.MovementItemId_master
                             , MIContainer.MIContainerDescId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.GoodsId_in
                             , MIContainer.GoodsKindId_in
                             , MIContainer.GoodsKindId_complete_in
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.InfoMoneyId_in
                             , MIContainer.InfoMoneyId_Detail_in
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId
                             , MIContainer.GoodsKindId
                           --, MIContainer.CuterCount_master
                             , -1 * SUM (MIContainer.Amount)     AS Amount
                             , SUM (MIContainer.Amount_Master)   AS Amount_Master
                        FROM tmpOut1 AS MIContainer
                             LEFT JOIN tmpMovementBoolean1 AS MovementBoolean_Peresort
                                                           ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                             LEFT JOIN tmpMovementLinkObject1 AS MLO_DocumentKind
                                                              ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                        GROUP BY MIContainer.OperDate
                               , MIContainer.MovementId
                               , MIContainer.MovementItemId
                               , MIContainer.MovementItemId_master
                               , MIContainer.MIContainerDescId
                               , COALESCE (MovementBoolean_Peresort.ValueData, FALSE)
                               , COALESCE (MLO_DocumentKind.ObjectId, 0)
                               , MIContainer.GoodsId_in
                               , MIContainer.GoodsKindId_in
                               , MIContainer.GoodsKindId_complete_in
                               , MIContainer.PartionGoodsId_in
                               , MIContainer.InfoMoneyId_in
                               , MIContainer.InfoMoneyId_Detail_in
                               , MIContainer.ContainerId
                               , MIContainer.GoodsId
                               , MIContainer.GoodsKindId
                             --, MIContainer.CuterCount_master
                       )

           -- ������ �� ��������
         , tmpReceipt AS (SELECT tmp.ReceiptId                                                  AS ReceiptId
                               , tmp.MovementItemId                                             AS MovementItemId
                               , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                               , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                               , ObjectFloat_Value.ValueData                                    AS Value
                               , ObjectFloat_Value_master.ValueData                             AS Value_master
                          FROM (SELECT DISTINCT tmpMI_ContainerIn1.ReceiptId, tmpMI_ContainerIn1.MovementItemId FROM tmpMI_ContainerIn1
                              -- UNION
                              --  SELECT DISTINCT tmpMI_ContainerIn2.ReceiptId FROM tmpMI_ContainerIn2
                               ) AS tmp
                               INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                     ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmp.ReceiptId
                                                    AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                               INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                       AND Object_ReceiptChild.isErased = FALSE
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                    ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                   AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                               INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                      ON ObjectFloat_Value_master.ObjectId = tmp.ReceiptId
                                                     AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                     AND ObjectFloat_Value_master.ValueData <> 0
                               INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                      ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                     AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                          )

         , tmpMI_out1 AS (SELECT tmpMI_ContainerOut.OperDate
                               , tmpMI_ContainerOut.MovementId
                               , tmpMI_ContainerOut.isPeresort
                               , tmpMI_ContainerOut.DocumentKindId
                               , tmpReceipt.ReceiptId
                               , tmpMI_ContainerOut.GoodsId_in
                               , tmpMI_ContainerOut.GoodsKindId_in
                               , tmpMI_ContainerOut.GoodsKindId_complete_in
                               , tmpMI_ContainerOut.PartionGoodsId_in
                               , tmpMI_ContainerOut.InfoMoneyId_in
                               , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                               , tmpMI_ContainerOut.GoodsId
                               , tmpMI_ContainerOut.GoodsKindId
                               , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperCount
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperSumm
                               , SUM (COALESCE (MIFloat_AmountReceipt.ValueData, 0)) AS AmountReceipt
                               , SUM (COALESCE (tmpReceipt.Value, 0))                AS Value
                               , SUM (COALESCE (tmpReceipt.Value_master, 0))         AS Value_master
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.Amount_Master ELSE 0 END) AS Amount_Master
                               , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))    AS CuterCount_Master
                               , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)       AS isTaxExit
                               , COALESCE (MIBoolean_WeightMain.ValueData, FALSE)    AS isWeightMain
                          FROM tmpMI_ContainerOut1 AS tmpMI_ContainerOut
                               LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                             ON ContainerLO_PartionGoods.ContainerId = tmpMI_ContainerOut.ContainerId
                                                            AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                            AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                               LEFT JOIN tmpMIAmountReceipt1 AS MIFloat_AmountReceipt
                                                             ON MIFloat_AmountReceipt.MovementItemId = tmpMI_ContainerOut.MovementItemId
                                                             AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                               LEFT JOIN tmpMIBoolean1 AS MIBoolean_TaxExit
                                                       ON MIBoolean_TaxExit.MovementItemId = tmpMI_ContainerOut.MovementItemId
                                                      AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
                               LEFT JOIN tmpMIBoolean1 AS MIBoolean_WeightMain
                                                       ON MIBoolean_WeightMain.MovementItemId =  tmpMI_ContainerOut.MovementItemId
                                                      AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()

                               LEFT JOIN tmpMICuterCount1 AS MIFloat_CuterCount
                                                          ON MIFloat_CuterCount.MovementItemId = tmpMI_ContainerOut.MovementItemId_master
                                                         AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                               -- ������������ ���������
                               LEFT JOIN tmpReceipt ON tmpReceipt.MovementItemId = tmpMI_ContainerOut.MovementItemId_master
                                                   AND tmpReceipt.GoodsId        = tmpMI_ContainerOut.GoodsId
                                                   AND COALESCE (tmpReceipt.GoodsKindId ,0) = COALESCE (tmpMI_ContainerOut.GoodsKindId,0)
                                                   AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                          GROUP BY tmpMI_ContainerOut.OperDate
                                 , tmpMI_ContainerOut.MovementId
                                 , tmpMI_ContainerOut.isPeresort
                                 , tmpMI_ContainerOut.DocumentKindId
                                 , tmpReceipt.ReceiptId
                                 , tmpMI_ContainerOut.GoodsId_in
                                 , tmpMI_ContainerOut.GoodsKindId_in
                                 , tmpMI_ContainerOut.GoodsKindId_complete_in
                                 , tmpMI_ContainerOut.PartionGoodsId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                                 , tmpMI_ContainerOut.GoodsId
                                 , tmpMI_ContainerOut.GoodsKindId
                                 , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END
                                 , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                                 , COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                         )

         , tmpOperationGroup1 AS (SELECT DATE_TRUNC ('MONTH', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_ContainerIn.isPeresort
                                       , tmpMI_ContainerIn.DocumentKindId
                                       , tmpMI_ContainerIn.ReceiptId

                                       , COALESCE (tmpContainer_in.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpContainer_in.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                        AS GoodsId
                                       , tmpMI_ContainerIn.GoodsKindId                    AS GoodsKindId
                                       , tmpContainer_in.GoodsKindId_complete             AS GoodsKindId_complete
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperCount
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperSumm
                                       , SUM (COALESCE (tmpMI_Master_Cuter.ValueData,0) + COALESCE (tmpMI_Partion_Cuter.CuterCount, 0))                        AS CuterCount
                                       , 0 AS PartionGoodsId_out
                                       , 0 AS GoodsId_out
                                       , 0 AS GoodsKindId_out
                                       , 0 AS OperCount_out
                                       , 0 AS OperSumm_out
                                       , 0 AS AmountReceipt_out
                                       , 0 AS SummReceipt_out
                                       , 0 AS AmountCalc_out
                                       , 0 AS AmountCalcForWeght
                                       , 0 AS SummCalc_out
                                       , 0 AS AmountForWeght
                                       , 0 AS AmountReceiptForWeght
                                  FROM tmpMI_ContainerIn1 AS tmpMI_ContainerIn
                                       INNER JOIN (SELECT DISTINCT tmpOut1.GoodsId_in
                                                   FROM tmpOut1
                                                   ) AS tmpGoodsIn ON tmpGoodsIn.GoodsId_in = tmpMI_ContainerIn.GoodsId

                                       LEFT JOIN tmpContainer_in1 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                       LEFT JOIN tmpMI_Master_Cuter1 AS tmpMI_Master_Cuter
                                                                     ON tmpMI_Master_Cuter.MovementItemId = tmpMI_ContainerIn.MovementItemId
                                                                    AND tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count()
                                       LEFT JOIN tmpMI_Partion_Cuter1 AS tmpMI_Partion_Cuter
                                                                      ON tmpMI_Partion_Cuter.MovementItemId = tmpMI_ContainerIn.MovementItemId
                                                                     AND tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count()

                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , tmpMI_ContainerIn.isPeresort
                                         , tmpMI_ContainerIn.DocumentKindId
                                         , tmpMI_ContainerIn.ReceiptId
                                         , COALESCE (tmpContainer_in.PartionGoodsId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId
                                         , tmpMI_ContainerIn.GoodsKindId
                                         , tmpContainer_in.GoodsKindId_complete
                                         , DATE_TRUNC ('MONTH', tmpMI_ContainerIn.OperDate)
                                  UNION
                                  SELECT tmpMI_out.OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_out.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_out.isPeresort
                                       , tmpMI_out.DocumentKindId
                                       , tmpMI_out.ReceiptId
                                       , tmpMI_out.PartionGoodsId_in
                                       , tmpMI_out.InfoMoneyId_in
                                       , tmpMI_out.InfoMoneyId_Detail_in
                                       , tmpMI_out.GoodsId_in
                                       --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END AS GoodsKindId_in
                                       , tmpMI_out.GoodsKindId_in
                                       , tmpMI_out.GoodsKindId_complete_in AS GoodsKindId_complete
                                       , 0 AS OperCount
                                       , 0 AS OperSumm
                                       , 0 AS CuterCount

                                       , tmpMI_out.PartionGoodsId       AS PartionGoodsId_out
                                       , tmpMI_out.GoodsId              AS GoodsId_out
                                       --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END AS GoodsKindId_out
                                       , tmpMI_out.GoodsKindId          AS GoodsKindId_out
                                       , SUM (tmpMI_out.OperCount)      AS OperCount_out
                                       , SUM (tmpMI_out.OperSumm)       AS OperSumm_out
                                       , SUM (tmpMI_out.AmountReceipt * tmpMI_out.CuterCount_Master)  AS AmountReceipt_out
                                       , SUM (CASE WHEN COALESCE (tmpMI_out.OperCount,0) <> 0 THEN tmpMI_out.AmountReceipt * tmpMI_out.CuterCount_Master * (tmpMI_out.OperSumm / tmpMI_out.OperCount) ELSE 0 END)  AS SummReceipt_out
                                       , SUM (CASE WHEN tmpMI_out.GoodsKindId_in = zc_GoodsKind_WorkProgress()
                                                   THEN CASE WHEN tmpMI_out.isTaxExit = FALSE
                                                                  THEN tmpMI_out.CuterCount_Master * tmpMI_out.Value
                                                             WHEN tmpMI_out.Value_master <> 0
                                                                  THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                             ELSE 0
                                                        END

                                                   WHEN tmpMI_out.Value_master <> 0
                                                        THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                   ELSE 0
                                              END)  AS AmountCalc_out
                                       , SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_out.GoodsId
                                                                                                , inGoodsKindId            := tmpMI_out.GoodsKindId
                                                                                                , inInfoMoneyDestinationId := Object_InfoMoney_Goods.InfoMoneyDestinationId
                                                                                                , inInfoMoneyId            := Object_InfoMoney_Goods.InfoMoneyId
                                                                                                , inIsWeightMain           := tmpMI_out.isWeightMain
                                                                                                , inIsTaxExit              := tmpMI_out.isTaxExit
                                                                                                 )
                                                   THEN CASE WHEN tmpMI_out.GoodsKindId_in = zc_GoodsKind_WorkProgress()
                                                             THEN CASE WHEN tmpMI_out.isTaxExit = FALSE
                                                                            THEN tmpMI_out.CuterCount_Master * tmpMI_out.Value
                                                                       WHEN tmpMI_out.Value_master <> 0
                                                                            THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                                       ELSE 0
                                                                  END

                                                             WHEN tmpMI_out.Value_master <> 0
                                                                  THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                             ELSE 0
                                                        END
                                                   ELSE 0
                                              END)                      AS AmountCalcForWeght

                                       , SUM (CASE WHEN COALESCE (tmpMI_out.OperCount,0) <> 0 THEN
                                                   (CASE WHEN tmpMI_out.GoodsKindId_in = zc_GoodsKind_WorkProgress()
                                                         THEN CASE WHEN tmpMI_out.isTaxExit = FALSE
                                                                        THEN tmpMI_out.CuterCount_Master * tmpMI_out.Value
                                                                   WHEN tmpMI_out.Value_master <> 0
                                                                        THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                                   ELSE 0
                                                              END

                                                         WHEN tmpMI_out.Value_master <> 0
                                                              THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                         ELSE 0
                                                     END) * (tmpMI_out.OperSumm / tmpMI_out.OperCount)
                                              ELSE 0 END)  AS SummCalc_out

                                       , SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_out.GoodsId
                                                                                                , inGoodsKindId            := tmpMI_out.GoodsKindId
                                                                                                , inInfoMoneyDestinationId := Object_InfoMoney_Goods.InfoMoneyDestinationId
                                                                                                , inInfoMoneyId            := Object_InfoMoney_Goods.InfoMoneyId
                                                                                                , inIsWeightMain           := tmpMI_out.isWeightMain
                                                                                                , inIsTaxExit              := tmpMI_out.isTaxExit
                                                                                                 )
                                                   THEN tmpMI_out.OperCount
                                                   ELSE 0
                                              END)                      AS AmountForWeght
                                       , SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_out.GoodsId
                                                                                                , inGoodsKindId            := tmpMI_out.GoodsKindId
                                                                                                , inInfoMoneyDestinationId := Object_InfoMoney_Goods.InfoMoneyDestinationId
                                                                                                , inInfoMoneyId            := Object_InfoMoney_Goods.InfoMoneyId
                                                                                                , inIsWeightMain           := tmpMI_out.isWeightMain
                                                                                                , inIsTaxExit              := tmpMI_out.isTaxExit
                                                                                                 )
                                                   THEN tmpMI_out.AmountReceipt * tmpMI_out.CuterCount_Master
                                                   ELSE 0
                                              END)                      AS AmountReceiptForWeght
                                  FROM tmpMI_out1 AS tmpMI_out
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_out.GoodsId
                                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                       LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_Goods ON Object_InfoMoney_Goods.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                  GROUP BY tmpMI_out.OperDate
                                         , CASE WHEN inIsMovement = TRUE THEN tmpMI_out.MovementId ELSE 0 END
                                         , tmpMI_out.isPeresort
                                         , tmpMI_out.DocumentKindId
                                         , tmpMI_out.ReceiptId
                                         , tmpMI_out.PartionGoodsId_in
                                         , tmpMI_out.InfoMoneyId_in
                                         , tmpMI_out.InfoMoneyId_Detail_in
                                         , tmpMI_out.GoodsId_in
                                         , tmpMI_out.GoodsKindId_in
                                         , tmpMI_out.GoodsKindId_complete_in
                                         , tmpMI_out.PartionGoodsId
                                         , tmpMI_out.GoodsId
                                         , tmpMI_out.GoodsKindId
                                 )

           --������ ������� �������
         , tmpMI_ContainerIn2 AS
                       (SELECT MIContainer.OperDate                                 AS OperDate
                             , MIContainer.MovementId                               AS MovementId
                             , MIContainer.ObjectExtId_Analyzer                     AS FromId
                             , MIContainer.WhereObjectId_Analyzer                   AS ToId
                             , MIContainer.MovementItemId                           AS MovementItemId
                             , MILO_Receipt.ObjectId                                AS ReceiptId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.DescId                                   AS MIContainerDescId
                             , MIContainer.ContainerId                              AS ContainerId
                             , MIContainer.ObjectId_Analyzer                        AS GoodsId
                             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId
                             , SUM (MIContainer.Amount)                             AS Amount
                        FROM MovementItemContainer AS MIContainer
			     INNER JOIN _tmpFromGroup ON _tmpFromGroup.FromId = MIContainer.ObjectExtId_Analyzer
 		             INNER JOIN _tmpToGroup   ON _tmpToGroup.ToId     = MIContainer.WhereObjectId_Analyzer
 		             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                             LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                        ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                       AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                             LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                          ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                                                         AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                             -- ����� � ����������
                             LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                              ON MILO_Receipt.MovementItemId = MIContainer.MovementItemId
                                                             AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                        WHERE MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                          AND MIContainer.isActive = TRUE
                          AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        GROUP BY MIContainer.MovementId
                               , MIContainer.MovementItemId
                               , MILO_Receipt.ObjectId
                               , MovementBoolean_Peresort.ValueData
                               , MLO_DocumentKind.ObjectId
                               , MIContainer.DescId
                               , MIContainer.ContainerId
                               , MIContainer.ObjectId_Analyzer
                               , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                               , MIContainer.OperDate
                               , MIContainer.ObjectExtId_Analyzer
                               , MIContainer.WhereObjectId_Analyzer
                       )
         , tmpMI_Master_Cuter2 AS (SELECT MIFloat_CuterCount.*
                                   FROM MovementItemFloat AS MIFloat_CuterCount
                                   WHERE MIFloat_CuterCount.MovementItemId IN (SELECT DISTINCT tmpMI_ContainerIn2.MovementItemId FROM tmpMI_ContainerIn2)
                                     AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                   )

         , tmpMI_Partion_Cuter2 AS (SELECT tmpMI_ContainerIn.MovementItemId
                                        , SUM (CASE WHEN COALESCE (MI_Partion.Amount, 0) <> 0
                                                    THEN MI_Child.Amount / MI_Partion.Amount * COALESCE (MIFloat_CuterCount.ValueData, 0)
                                                    ELSE 0
                                               END )  AS CuterCount
                                    FROM tmpMI_ContainerIn2 AS tmpMI_ContainerIn
                                         INNER JOIN MovementItem AS MI_Child
                                                                 ON MI_Child.ParentId   = tmpMI_ContainerIn.MovementItemId
                                                                AND MI_Child.MovementId = tmpMI_ContainerIn.MovementId
                                                                AND MI_Child.DescId = zc_MI_Child()
                                                                AND MI_Child.isErased = FALSE
                                         INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MI_Child.Id
                                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                          AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress()
                                         INNER JOIN MovementItemContainer AS MIContainer_Child
                                                                          ON MIContainer_Child.MovementItemId = MI_Child.Id
                                                                         AND MIContainer_Child.DescId = zc_MIContainer_Count()

                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId    = MIContainer_Child.ContainerId
                                                                        AND MIContainer.DescId         = zc_MIContainer_Count()
                                                                        AND MIContainer.WhereObjectId_Analyzer = tmpMI_ContainerIn.FromId
                                                                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                                        AND MIContainer.IsActive       = TRUE
                                                                        AND MIContainer.Amount         <> 0

                                         LEFT JOIN MovementItem AS MI_Partion ON MI_Partion.Id = MIContainer.MovementItemId

                                         LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                                     ON MIFloat_CuterCount.MovementItemId = MI_Partion.Id
                                                                    AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

                                    WHERE tmpMI_ContainerIn.FromId <> tmpMI_ContainerIn.ToId
                                      AND tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count()
                                    GROUP BY tmpMI_ContainerIn.MovementItemId
                                    )

         , tmpContainer_in2 AS (SELECT DISTINCT tmp.ContainerId
                                     , tmp.GoodsId
                                     , tmp.GoodsKindId
                                     , CASE WHEN tmp.GoodsKindId = zc_GoodsKind_WorkProgress()
                                             AND COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0) = 0
                                                 THEN zc_GoodsKind_Basis()
                                            ELSE COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                                       END AS GoodsKindId_complete
                                     --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                                     , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                                     , CLO_InfoMoney.ObjectId             AS InfoMoneyId
                                     , CLO_InfoMoneyDetail.ObjectId       AS InfoMoneyId_Detail
                                FROM tmpMI_ContainerIn2 AS tmp
                                     LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                   ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerId
                                                                  AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                   ON CLO_InfoMoney.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                                   ON CLO_InfoMoneyDetail.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                          ON ObjectLink_GoodsKindComplete.ObjectId = ContainerLO_PartionGoods.ObjectId
                                                         AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                )

         , tmpOut2 AS (SELECT CASE WHEN vbIsDate = TRUE THEN MIContainer.OperDate ELSE DATE_TRUNC ('YEAR', MIContainer.OperDate) END AS OperDate
                            , MIContainer.MovementId               AS MovementId
                            , MIContainer.MovementItemId           AS MovementItemId
                            , MovementItem.ParentId                AS MovementItemId_master
                            , MIContainer.DescId                   AS MIContainerDescId
                            , tmpContainer_in.GoodsId              AS GoodsId_in
                            , tmpContainer_in.GoodsKindId          AS GoodsKindId_in
                            , tmpContainer_in.GoodsKindId_complete AS GoodsKindId_complete_in
                            , tmpContainer_in.PartionGoodsId       AS PartionGoodsId_in
                            , tmpContainer_in.InfoMoneyId          AS InfoMoneyId_in
                            , tmpContainer_in.InfoMoneyId_Detail   AS InfoMoneyId_Detail_in
                            , MIContainer.ContainerId              AS ContainerId
                            , MIContainer.ObjectId_Analyzer        AS GoodsId
                            , COALESCE (MILO_GoodsKind.ObjectId, MIContainer.ObjectIntId_Analyzer) AS GoodsKindId
                            , (MIContainer.Amount)                 AS Amount
                            , MI_Master.Amount                     AS Amount_Master
                          --, MIFloat_CuterCount_master.ValueData  AS CuterCount_master

                       FROM tmpContainer_in2 AS tmpContainer_in
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId_Analyzer = tmpContainer_in.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                                           AND MIContainer.isActive = FALSE
                           INNER JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = MIContainer.ObjectId_Analyzer
                           LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                                 AND MovementItem.MovementId = MIContainer.MovementId
                                                 AND MovementItem.DescId   = zc_MI_Child()
                           LEFT JOIN MovementItem AS MI_Master
                                                  ON MI_Master.Id = MovementItem.ParentId
                                                 AND MI_Master.MovementId = MIContainer.MovementId
                                                 AND MI_Master.DescId   = zc_MI_Master()
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                            ON MILO_GoodsKind.MovementItemId = MIContainer.MovementItemId
                                                           AND MILO_GoodsKind.DescId        = zc_MILinkObject_GoodsKind()
                         --LEFT JOIN tmpMI_Master_Cuter1 AS MIFloat_CuterCount_master
                         --                              ON MIFloat_CuterCount_master.MovementItemId = MI_Master.Id
                         --                             AND MIFloat_CuterCount_master.DescId        = zc_MIFloat_CuterCount()
                      )

         , tmpMovementBoolean2 AS (SELECT MovementBoolean.*
                                   FROM MovementBoolean
                                   WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpOut2.MovementId FROM tmpOut2)
                                     AND MovementBoolean.DescId = zc_MovementBoolean_Peresort()
                                  )
         , tmpMovementLinkObject2 AS (SELECT MovementLinkObject.*
                                      FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpOut2.MovementId FROM tmpOut2)
                                        AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentKind()
                                     )
         --
         , tmpMIAmountReceipt2 AS (SELECT MovementItemFloat.*
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpOut2.MovementItemId FROM tmpOut2)
                                     AND MovementItemFloat.DescId = zc_MIFloat_AmountReceipt()
                                  )
         , tmpMIBoolean2 AS (SELECT MovementItemBoolean.*
                             FROM MovementItemBoolean
                             WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpOut2.MovementItemId FROM tmpOut2)
                               AND MovementItemBoolean.DescId IN (zc_MIBoolean_TaxExit(), zc_MIBoolean_WeightMain())
                                  )

         -- ���-�� ������� ������
         , tmpMICuterCount2 AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpOut2.MovementItemId_master FROM tmpOut2)
                                  AND MovementItemFloat.DescId = zc_MIFloat_CuterCount()
                                )

         , tmpMI_ContainerOut2 AS
                       (SELECT MIContainer.OperDate
                             , MIContainer.MovementId
                             , MIContainer.MovementItemId
                             , MIContainer.MovementItemId_master
                             , MIContainer.MIContainerDescId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.GoodsId_in
                             , MIContainer.GoodsKindId_in
                             , MIContainer.GoodsKindId_complete_in
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.InfoMoneyId_in
                             , MIContainer.InfoMoneyId_Detail_in
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId
                             , MIContainer.GoodsKindId
                           --, MIContainer.CuterCount_master
                             , -1 * SUM (MIContainer.Amount)    AS Amount
                             , SUM (MIContainer.Amount_Master)  AS Amount_Master
                        FROM tmpOut2 AS MIContainer
                             LEFT JOIN tmpMovementBoolean2 AS MovementBoolean_Peresort
                                                           ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                             LEFT JOIN tmpMovementLinkObject2 AS MLO_DocumentKind
                                                              ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                        GROUP BY MIContainer.OperDate
                               , MIContainer.MovementId
                               , MIContainer.MovementItemId
                               , MIContainer.MovementItemId_master
                               , MIContainer.MIContainerDescId
                               , COALESCE (MovementBoolean_Peresort.ValueData, FALSE)
                               , COALESCE (MLO_DocumentKind.ObjectId, 0)
                               , MIContainer.GoodsId_in
                               , MIContainer.GoodsKindId_in
                               , MIContainer.GoodsKindId_complete_in
                               , MIContainer.PartionGoodsId_in
                               , MIContainer.InfoMoneyId_in
                               , MIContainer.InfoMoneyId_Detail_in
                               , MIContainer.ContainerId
                               , MIContainer.GoodsId
                               , MIContainer.GoodsKindId
                             --, MIContainer.CuterCount_master
                       )

         -- ������ �� ��������
         , tmpReceipt2 AS (SELECT tmp.ReceiptId                                                  AS ReceiptId
                                , tmp.MovementItemId                                             AS MovementItemId
                                , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                                , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                                , ObjectFloat_Value.ValueData                                    AS Value
                                , ObjectFloat_Value_master.ValueData                             AS Value_master
                           FROM (SELECT DISTINCT tmpMI_ContainerIn2.ReceiptId, tmpMI_ContainerIn2.MovementItemId FROM tmpMI_ContainerIn2
                                ) AS tmp
                                INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                      ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmp.ReceiptId
                                                     AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                        AND Object_ReceiptChild.isErased = FALSE
                                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                     ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                    ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                   AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                       ON ObjectFloat_Value_master.ObjectId = tmp.ReceiptId
                                                      AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                      AND ObjectFloat_Value_master.ValueData <> 0
                                INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                       ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                           )

         , tmpMI_out2 AS (SELECT tmpMI_ContainerOut.OperDate
                               , tmpMI_ContainerOut.MovementId
                               , tmpMI_ContainerOut.isPeresort
                               , tmpMI_ContainerOut.DocumentKindId
                               , tmpReceipt.ReceiptId
                               , tmpMI_ContainerOut.GoodsId_in
                               , tmpMI_ContainerOut.GoodsKindId_in
                               , tmpMI_ContainerOut.GoodsKindId_complete_in
                               , tmpMI_ContainerOut.PartionGoodsId_in
                               , tmpMI_ContainerOut.InfoMoneyId_in
                               , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                               , tmpMI_ContainerOut.GoodsId
                               , tmpMI_ContainerOut.GoodsKindId
                               --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                               , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperCount
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperSumm
                               , SUM (COALESCE (MIFloat_AmountReceipt.ValueData, 0)) AS AmountReceipt
                               , SUM (COALESCE (tmpReceipt.Value, 0))                AS Value
                               , SUM (COALESCE (tmpReceipt.Value_master, 0))         AS Value_master
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.Amount_Master ELSE 0 END) AS Amount_Master
                               , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))    AS CuterCount_Master
                               , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)       AS isTaxExit
                               , COALESCE (MIBoolean_WeightMain.ValueData, FALSE)    AS isWeightMain
                          FROM tmpMI_ContainerOut2 AS tmpMI_ContainerOut
                               LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                             ON ContainerLO_PartionGoods.ContainerId = tmpMI_ContainerOut.ContainerId
                                                            AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                            AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                               LEFT JOIN tmpMIAmountReceipt2 AS MIFloat_AmountReceipt
                                                             ON MIFloat_AmountReceipt.MovementItemId = tmpMI_ContainerOut.MovementItemId
                                                             AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                               LEFT JOIN tmpMIBoolean2 AS MIBoolean_TaxExit
                                                       ON MIBoolean_TaxExit.MovementItemId = tmpMI_ContainerOut.MovementItemId
                                                      AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
                               LEFT JOIN tmpMIBoolean2 AS MIBoolean_WeightMain
                                                       ON MIBoolean_WeightMain.MovementItemId =  tmpMI_ContainerOut.MovementItemId
                                                      AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()

                               LEFT JOIN tmpMICuterCount2 AS MIFloat_CuterCount
                                                          ON MIFloat_CuterCount.MovementItemId = tmpMI_ContainerOut.MovementItemId_master
                                                         AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                               -- ������������ ���������
                               LEFT JOIN tmpReceipt2 AS tmpReceipt
                                                     ON tmpReceipt.MovementItemId = tmpMI_ContainerOut.MovementItemId_master
                                                    AND tmpReceipt.GoodsId        = tmpMI_ContainerOut.GoodsId
                                                    AND COALESCE (tmpReceipt.GoodsKindId ,0)   = COALESCE (tmpMI_ContainerOut.GoodsKindId,0)
                                                    AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()

                          GROUP BY tmpMI_ContainerOut.OperDate
                                 , tmpMI_ContainerOut.MovementId
                                 , tmpMI_ContainerOut.isPeresort
                                 , tmpMI_ContainerOut.DocumentKindId
                                 , tmpReceipt.ReceiptId
                                 , tmpMI_ContainerOut.GoodsId_in
                                 , tmpMI_ContainerOut.GoodsKindId_in
                                 , tmpMI_ContainerOut.GoodsKindId_complete_in
                                 , tmpMI_ContainerOut.PartionGoodsId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                                 , tmpMI_ContainerOut.GoodsId
                                 , tmpMI_ContainerOut.GoodsKindId
                                 , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END
                                 , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                                 , COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                         )
         , tmpOperationGroup2 AS (SELECT DATE_TRUNC ('MONTH', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_ContainerIn.isPeresort
                                       , tmpMI_ContainerIn.DocumentKindId
                                       , tmpMI_ContainerIn.ReceiptId

                                       , COALESCE (tmpContainer_in.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpContainer_in.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                        AS GoodsId
                                       , tmpMI_ContainerIn.GoodsKindId                    AS GoodsKindId
                                       , tmpContainer_in.GoodsKindId_complete             AS GoodsKindId_complete
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperCount
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperSumm
                                       , SUM (COALESCE (tmpMI_Master_Cuter.ValueData,0) + COALESCE (tmpMI_Partion_Cuter.CuterCount, 0))                        AS CuterCount

                                       , 0 AS PartionGoodsId_out
                                       , 0 AS GoodsId_out
                                       , 0 AS GoodsKindId_out
                                       , 0 AS OperCount_out
                                       , 0 AS OperSumm_out
                                       , 0 AS AmountReceipt_out
                                       , 0 AS SummReceipt_out
                                       , 0 AS AmountCalc_out
                                       , 0 AS AmountCalcForWeght
                                       , 0 AS SummCalc_out
                                       , 0 AS AmountForWeght
                                       , 0 AS AmountReceiptForWeght
                                  FROM tmpMI_ContainerIn2 AS tmpMI_ContainerIn
                                       INNER JOIN (SELECT DISTINCT tmpOut2.GoodsId_in
                                                   FROM tmpOut2
                                                   ) AS tmpGoodsIn ON tmpGoodsIn.GoodsId_in = tmpMI_ContainerIn.GoodsId

                                       LEFT JOIN tmpContainer_in2 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                       LEFT JOIN tmpMI_Master_Cuter2 AS tmpMI_Master_Cuter
                                                                     ON tmpMI_Master_Cuter.MovementItemId = tmpMI_ContainerIn.MovementItemId
                                                                    AND tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count()
                                       LEFT JOIN tmpMI_Partion_Cuter2 AS tmpMI_Partion_Cuter
                                                                      ON tmpMI_Partion_Cuter.MovementItemId = tmpMI_ContainerIn.MovementItemId
                                                                     AND tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count()
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , tmpMI_ContainerIn.isPeresort
                                         , tmpMI_ContainerIn.DocumentKindId
                                         , tmpMI_ContainerIn.ReceiptId
                                         , COALESCE (tmpContainer_in.PartionGoodsId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId
                                         , tmpMI_ContainerIn.GoodsKindId
                                         , tmpContainer_in.GoodsKindId_complete
                                         , DATE_TRUNC ('MONTH', tmpMI_ContainerIn.OperDate)

                                 UNION
                                  SELECT tmpMI_out.OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_out.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_out.isPeresort
                                       , tmpMI_out.DocumentKindId
                                       , tmpMI_out.ReceiptId
                                       , tmpMI_out.PartionGoodsId_in
                                       , tmpMI_out.InfoMoneyId_in
                                       , tmpMI_out.InfoMoneyId_Detail_in
                                       , tmpMI_out.GoodsId_in
                                       --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END AS GoodsKindId_in
                                       , tmpMI_out.GoodsKindId_in
                                       , tmpMI_out.GoodsKindId_complete_in AS GoodsKindId_complete
                                       , 0 AS OperCount
                                       , 0 AS OperSumm
                                       , 0 AS CuterCount

                                       , tmpMI_out.PartionGoodsId       AS PartionGoodsId_out
                                       , tmpMI_out.GoodsId              AS GoodsId_out
                                       --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END AS GoodsKindId_out
                                       , tmpMI_out.GoodsKindId          AS GoodsKindId_out
                                       , SUM (tmpMI_out.OperCount)      AS OperCount_out
                                       , SUM (tmpMI_out.OperSumm)       AS OperSumm_out
                                       , SUM (tmpMI_out.AmountReceipt * tmpMI_out.CuterCount_Master)  AS AmountReceipt_out
                                       , SUM (CASE WHEN COALESCE (tmpMI_out.OperCount,0) <> 0 THEN tmpMI_out.AmountReceipt * tmpMI_out.CuterCount_Master * (tmpMI_out.OperSumm / tmpMI_out.OperCount) ELSE 0 END)  AS SummReceipt_out
                                       , SUM (CASE WHEN tmpMI_out.GoodsKindId_in = zc_GoodsKind_WorkProgress()
                                                   THEN CASE WHEN tmpMI_out.isTaxExit = FALSE
                                                                  THEN tmpMI_out.CuterCount_Master * tmpMI_out.Value
                                                             WHEN tmpMI_out.Value_master <> 0
                                                                  THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                             ELSE 0
                                                        END

                                                   WHEN tmpMI_out.Value_master <> 0
                                                        THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                   ELSE 0
                                              END)  AS AmountCalc_out
                                       , SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_out.GoodsId
                                                                                                , inGoodsKindId            := tmpMI_out.GoodsKindId
                                                                                                , inInfoMoneyDestinationId := Object_InfoMoney_Goods.InfoMoneyDestinationId
                                                                                                , inInfoMoneyId            := Object_InfoMoney_Goods.InfoMoneyId
                                                                                                , inIsWeightMain           := tmpMI_out.isWeightMain
                                                                                                , inIsTaxExit              := tmpMI_out.isTaxExit
                                                                                                 )
                                                   THEN CASE WHEN tmpMI_out.GoodsKindId_in = zc_GoodsKind_WorkProgress()
                                                             THEN CASE WHEN tmpMI_out.isTaxExit = FALSE
                                                                            THEN tmpMI_out.CuterCount_Master * tmpMI_out.Value
                                                                       WHEN tmpMI_out.Value_master <> 0
                                                                            THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                                       ELSE 0
                                                                  END

                                                             WHEN tmpMI_out.Value_master <> 0
                                                                  THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                             ELSE 0
                                                        END
                                                   ELSE 0
                                              END)                      AS AmountCalcForWeght
                                       , SUM (CASE WHEN COALESCE (tmpMI_out.OperCount,0) <> 0 THEN
                                                   (CASE WHEN tmpMI_out.GoodsKindId_in = zc_GoodsKind_WorkProgress()
                                                         THEN CASE WHEN tmpMI_out.isTaxExit = FALSE
                                                                        THEN tmpMI_out.CuterCount_Master * tmpMI_out.Value
                                                                   WHEN tmpMI_out.Value_master <> 0
                                                                        THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                                   ELSE 0
                                                              END

                                                         WHEN tmpMI_out.Value_master <> 0
                                                              THEN tmpMI_out.Amount_Master * tmpMI_out.Value / tmpMI_out.Value_master
                                                         ELSE 0
                                                     END) * (tmpMI_out.OperSumm / tmpMI_out.OperCount)
                                              ELSE 0 END)  AS SummCalc_out

                                       , SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_out.GoodsId
                                                                                                , inGoodsKindId            := tmpMI_out.GoodsKindId
                                                                                                , inInfoMoneyDestinationId := Object_InfoMoney_Goods.InfoMoneyDestinationId
                                                                                                , inInfoMoneyId            := Object_InfoMoney_Goods.InfoMoneyId
                                                                                                , inIsWeightMain           := tmpMI_out.isWeightMain
                                                                                                , inIsTaxExit              := tmpMI_out.isTaxExit
                                                                                                 )
                                                   THEN tmpMI_out.OperCount
                                                   ELSE 0
                                              END)                      AS AmountForWeght
                                       , SUM (CASE WHEN TRUE = zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := tmpMI_out.GoodsId
                                                                                                , inGoodsKindId            := tmpMI_out.GoodsKindId
                                                                                                , inInfoMoneyDestinationId := Object_InfoMoney_Goods.InfoMoneyDestinationId
                                                                                                , inInfoMoneyId            := Object_InfoMoney_Goods.InfoMoneyId
                                                                                                , inIsWeightMain           := tmpMI_out.isWeightMain
                                                                                                , inIsTaxExit              := tmpMI_out.isTaxExit
                                                                                                 )
                                                   THEN tmpMI_out.AmountReceipt * tmpMI_out.CuterCount_Master
                                                   ELSE 0
                                              END)                      AS AmountReceiptForWeght
                                  FROM tmpMI_out2 AS tmpMI_out
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_out.GoodsId
                                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                       LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_Goods ON Object_InfoMoney_Goods.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                  GROUP BY tmpMI_out.OperDate
                                         , CASE WHEN inIsMovement = TRUE THEN tmpMI_out.MovementId ELSE 0 END
                                         , tmpMI_out.isPeresort
                                         , tmpMI_out.DocumentKindId
                                         , tmpMI_out.ReceiptId
                                         , tmpMI_out.PartionGoodsId_in
                                         , tmpMI_out.InfoMoneyId_in
                                         , tmpMI_out.InfoMoneyId_Detail_in
                                         , tmpMI_out.GoodsId_in
                                         --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END
                                         , tmpMI_out.GoodsKindId_in
                                         , tmpMI_out.GoodsKindId_complete_in
                                         , tmpMI_out.PartionGoodsId
                                         , tmpMI_out.GoodsId
                                         --, CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END
                                         , tmpMI_out.GoodsKindId
                                 )

         , tmpOperationGroup AS (SELECT tmpOperationGroup1.*
                                 FROM tmpOperationGroup1
                                UNION
                                 SELECT tmpOperationGroup2.*
                                 FROM tmpOperationGroup2
                                )

         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                                  , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                                  , ObjectLink_Goods_Measure.ChildObjectId       AS MeasureId
                                  , ObjectFloat_Weight.ValueData                 AS Weight
                                  , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
                                  , Object_GoodsGroupAnalyst.ValueData           AS GoodsGroupAnalystName
                                  , Object_TradeMark.ValueData                   AS TradeMarkName
                                  , Object_GoodsTag.ValueData                    AS GoodsTagName
                                  , Object_GoodsPlatform.ValueData               AS GoodsPlatformName
                             FROM (SELECT DISTINCT tmpOperationGroup.GoodsId
                                   FROM tmpOperationGroup
                                  UNION
                                   SELECT DISTINCT tmpOperationGroup.GoodsId_out AS GoodsId
                                   FROM tmpOperationGroup
                                   ) AS tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                                       ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                                  LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                  LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                       ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                                  LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                                       ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                                  LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
                            )

      -- ���������
      SELECT Movement.InvNumber
           , Movement.OperDate
           , tmpOperationGroup.OperDate   :: TDateTime AS MONTHDate
           , tmpOperationGroup.isPeresort :: Boolean AS isPeresort
           , tmpOperationGroup.DocumentKindId
           , Object_DocumentKind.ValueData    AS DocumentKindName
           , Object_Receipt.ValueData         AS ReceiptName

           , tmpOperationGroup.PartionGoodsId
           , Object_PartionGoods.ValueData    AS PartionGoods
           , ObjectDate_PartionGoods_Value.ValueData :: TDateTime AS PartionGoods_Date

           , tmpGoodsParam.GoodsGroupName     AS GoodsGroupName
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , Object_GoodsKind_complete.ValueData  AS GoodsKindName_complete
           , Object_Measure.ValueData         AS MeasureName

           , (tmpOperationGroup.OperCount)  :: TFloat AS Amount
           , (tmpOperationGroup.OperCount * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS Amount_Weight
           , tmpOperationGroup.OperSumm     :: TFloat AS Summ

           , tmpOperationGroup.PartionGoodsId_out
           , Object_PartionGoodsChild.ValueData AS ChildPartionGoods
           , ObjectDate_PartionGoodsChild_Value.ValueData :: TDateTime AS ChildPartionGoods_Date

           , tmpGoodsChildParam.GoodsGroupName      AS ChildGoodsGroupName
           , Object_GoodsChild.Id                   AS GoodsId_child
           , Object_GoodsChild.ObjectCode           AS ChildGoodsCode
           , Object_GoodsChild.ValueData            AS ChildGoodsName
           , Object_GoodsKindChild.ValueData        AS ChildGoodsKindName
           , Object_MeasureChild.ValueData          AS ChildMeasureName

           , tmpOperationGroup.OperCount_out       :: TFloat AS ChildAmount
           , tmpOperationGroup.AmountReceipt_out   :: TFloat AS ChildAmountReceipt
           , tmpOperationGroup.AmountCalc_out      :: TFloat AS ChildAmountCalc

           , (tmpOperationGroup.AmountForWeght        * (CASE WHEN tmpGoodsChildParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsChildParam.Weight ELSE 1 END ))  :: TFloat AS ChildAmount_Weight
           , (tmpOperationGroup.AmountReceiptForWeght * (CASE WHEN tmpGoodsChildParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsChildParam.Weight ELSE 1 END ))  :: TFloat AS ChildAmountReceipt_Weight
           , (tmpOperationGroup.AmountCalcForWeght    * (CASE WHEN tmpGoodsChildParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsChildParam.Weight ELSE 1 END ))  :: TFloat AS ChildAmountCalc_Weight
           , tmpOperationGroup.OperSumm_out        :: TFloat AS ChildSumm
           , tmpOperationGroup.SummReceipt_out     :: TFloat AS ChildSummReceipt
           , tmpOperationGroup.SummCalc_out        :: TFloat AS ChildSummCalc

           , CAST (tmpOperationGroup.CuterCount AS NUMERIC (16,1))          :: TFloat AS CuterCount

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all

           , View_InfoMoneyDetail.InfoMoneyId              AS InfoMoneyId_Detail
           , View_InfoMoneyDetail.InfoMoneyCode            AS InfoMoneyCode_Detail
           , View_InfoMoneyDetail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
           , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
           , View_InfoMoneyDetail.InfoMoneyName            AS InfoMoneyName_Detail
           , View_InfoMoneyDetail.InfoMoneyName_all        AS InfoMoneyName_all_Detail


            , tmpGoodsParam.GoodsGroupNameFull
            , tmpGoodsParam.GoodsGroupAnalystName
            , tmpGoodsParam.TradeMarkName
            , tmpGoodsParam.GoodsTagName
            , tmpGoodsParam.GoodsPlatformName

            , tmpGoodsChildParam.GoodsGroupNameFull     AS ChildGoodsGroupNameFull
            , tmpGoodsChildParam.GoodsGroupAnalystName  AS ChildGoodsGroupAnalystName
            , tmpGoodsChildParam.TradeMarkName          AS ChildTradeMarkName
            , tmpGoodsChildParam.GoodsTagName           AS ChildGoodsTagName
            , tmpGoodsChildParam.GoodsPlatformName      AS ChildGoodsPlatformName

        FROM tmpOperationGroup

             LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.GoodsId_out

             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = tmpOperationGroup.GoodsKindId_out

             LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = tmpOperationGroup.GoodsKindId_complete

             LEFT JOIN Object AS Object_Receipt on Object_Receipt.Id = tmpOperationGroup.ReceiptId

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = tmpOperationGroup.InfoMoneyId_Detail

             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = Object_Goods.Id
             LEFT JOIN tmpGoodsParam AS tmpGoodsChildParam ON tmpGoodsChildParam.GoodsId = Object_GoodsChild.Id

             LEFT JOIN Object AS Object_Measure on Object_Measure.Id = tmpGoodsParam.MeasureId
             LEFT JOIN Object AS Object_MeasureChild on Object_MeasureChild.Id = tmpGoodsChildParam.MeasureId

             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId
             LEFT JOIN Object AS Object_PartionGoodsChild ON Object_PartionGoodsChild.Id = tmpOperationGroup.PartionGoodsId_out

             LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                  ON ObjectDate_PartionGoods_Value.ObjectId = tmpOperationGroup.PartionGoodsId
                                 AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
             LEFT JOIN ObjectDate AS ObjectDate_PartionGoodsChild_Value
                                  ON ObjectDate_PartionGoodsChild_Value.ObjectId = tmpOperationGroup.PartionGoodsId_out
                                 AND ObjectDate_PartionGoodsChild_Value.DescId = zc_ObjectDate_PartionGoods_Value()

             LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = tmpOperationGroup.DocumentKindId
             ;

    END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.07.18         *
*/

/*
TRUNCATE TABLE tReport_ProductionUnion_Olap;
DROP TABLE tReport_ProductionUnion_Olap;
CREATE TABLE tReport_ProductionUnion_Olap (Invnumber TVarchar, OperDate TDatetime, MonthDate TDatetime, isPeresort boolean
             , DocumentKindId Integer, DocumentKindName TVarchar, ReceiptName TVarchar
             , PartionGoodsId Integer, PartionGoods TVarchar, PartionGoods_Date TDatetime
             , GoodsGroupName TVarchar, GoodsCode Integer, GoodsId Integer, GoodsName TVarchar
             , GoodskindName TVarchar, GoodskindName_Complete TVarchar
             , MeasureName TVarchar
             , Amount TFloat, Amount_weight TFloat, Summ TFloat
             , PartionGoodsId_out Integer, ChildpartionGoods TVarchar, ChildpartionGoods_Date TDatetime
             , ChildGoodsGroupName TVarchar, GoodsId_child Integer, ChildGoodsCode Integer, ChildGoodsName TVarchar
             , ChildGoodskindName TVarchar, ChildMeasureName TVarchar
             , ChildAmount TFloat, ChildAmountReceipt TFloat, ChildAmountcalc TFloat, ChildAmount_weight TFloat
             , ChildAmountReceipt_weight TFloat, ChildAmountcalc_weight TFloat
             , ChildSumm TFloat, ChildSummReceipt TFloat, ChildSummcalc TFloat
             , CuterCount TFloat
             , InfoMoneyId Integer, InfoMoneycode Integer, InfoMoneyGroupName TVarchar
             , InfoMoneydestinationName TVarchar, InfoMoneyName TVarchar, InfoMoneyName_all TVarchar
             , InfoMoneyId_Detail Integer, InfoMoneycode_Detail Integer, InfoMoneyGroupName_Detail TVarchar
             , InfoMoneydestinationName_Detail TVarchar, InfoMoneyName_Detail TVarchar
             , InfoMoneyName_all_Detail TVarchar, GoodsGroupNamefull TVarchar, GoodsGroupAnalystName TVarchar
             , TradeMarkName TVarchar, GoodstagName TVarchar, GoodsplatformName TVarchar, ChildGoodsGroupNamefull TVarchar
             , ChildGoodsGroupAnalystName TVarchar, ChildTradeMarkName TVarchar, ChildGoodstagName TVarchar, ChildGoodsplatformName TVarchar
              );
INSERT INTO tReport_ProductionUnion_Olap (Invnumber, OperDate, MonthDate, isPeresort
             , DocumentKindId, DocumentKindName, ReceiptName
             , PartionGoodsId, PartionGoods, PartionGoods_Date
             , GoodsGroupName, GoodsCode, GoodsId, GoodsName
             , GoodskindName, GoodskindName_Complete
             , MeasureName
             , Amount, Amount_weight, Summ
             , PartionGoodsId_out, ChildpartionGoods, ChildpartionGoods_Date
             , ChildGoodsGroupName, GoodsId_child, ChildGoodsCode, ChildGoodsName
             , ChildGoodskindName, ChildMeasureName
             , ChildAmount, ChildAmountReceipt, ChildAmountcalc, ChildAmount_weight
             , ChildAmountReceipt_weight, ChildAmountcalc_weight
             , ChildSumm, ChildSummReceipt, ChildSummcalc
             , CuterCount
             , InfoMoneyId, InfoMoneycode, InfoMoneyGroupName
             , InfoMoneydestinationName, InfoMoneyName, InfoMoneyName_all
             , InfoMoneyId_Detail, InfoMoneycode_Detail, InfoMoneyGroupName_Detail
             , InfoMoneydestinationName_Detail, InfoMoneyName_Detail
             , InfoMoneyName_all_Detail, GoodsGroupNamefull, GoodsGroupAnalystName
             , TradeMarkName, GoodstagName, GoodsplatformName, ChildGoodsGroupNamefull
             , ChildGoodsGroupAnalystName, ChildTradeMarkName, ChildGoodstagName, ChildGoodsplatformName
              )
select Invnumber, OperDate, MonthDate, isPeresort
             , DocumentKindId, DocumentKindName, ReceiptName
             , PartionGoodsId, PartionGoods, PartionGoods_Date
             , GoodsGroupName, GoodsCode, GoodsId, GoodsName
             , GoodskindName, GoodskindName_Complete
             , MeasureName
             , Amount, Amount_weight, Summ
             , PartionGoodsId_out, ChildpartionGoods, ChildpartionGoods_Date TDatetime
             , ChildGoodsGroupName, GoodsId_child, ChildGoodsCode, ChildGoodsName
             , ChildGoodskindName, ChildMeasureName
             , ChildAmount, ChildAmountReceipt, ChildAmountcalc, ChildAmount_weight
             , ChildAmountReceipt_weight, ChildAmountcalc_weight
             , ChildSumm, ChildSummReceipt, ChildSummcalc
             , CuterCount
             , InfoMoneyId, InfoMoneycode, InfoMoneyGroupName
             , InfoMoneydestinationName, InfoMoneyName, InfoMoneyName_all
             , InfoMoneyId_Detail, InfoMoneycode_Detail, InfoMoneyGroupName_Detail
             , InfoMoneydestinationName_Detail, InfoMoneyName_Detail
             , InfoMoneyName_all_Detail, GoodsGroupNamefull, GoodsGroupAnalystName
             , TradeMarkName, GoodstagName, GoodsplatformName, ChildGoodsGroupNamefull
             , ChildGoodsGroupAnalystName, ChildTradeMarkName, ChildGoodstagName, ChildGoodsplatformName
FROM gpInsertProductionUnion_Olap (inStartDate := ('01.01.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime , inStartDate2 := ('01.01.2020')::TDateTime , inEndDate2 := ('31.12.2020')::TDateTime , inIsMovement := 'False' , inisPartion := 'False' , inGoodsGroupId := 1832 , inGoodsId := 0 , inChildGoodsGroupId := 1945 , inChildGoodsId := 0 , inFromId := 8446 , inToId := 8446 ,  inSession := '5')
-- ORDER BY MonthDate, GoodsId, GoodsId_child, InfoMoneyId, InfoMoneyId_Detail
*/
-- ����
-- SELECT * FROM gpReport_ProductionUnion_Olap (inStartDate:= '01.06.2018', inEndDate:= '30.06.2018', inStartDate2:= '01.07.2018', inEndDate2:= '31.07.2018', inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inChildGoodsGroupId:= 0, inChildGoodsId:=0, inFromId:= 8449, inToId:= 8458, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_ProductionUnion_Olap (inStartDate:= '01.06.2018', inEndDate:= '30.06.2018', inStartDate2:= '01.07.2018', inEndDate2:= '31.07.2018', inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inChildGoodsGroupId:= 0, inChildGoodsId:=0, inFromId:= 8447, inToId:= 8458, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_ProductionUnion_Olap (inStartDate:= '01.06.2018', inEndDate:= '30.06.2018', inStartDate2:= '01.07.2018', inEndDate2:= '31.07.2018', inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inChildGoodsGroupId:= 0, inChildGoodsId:=0, inFromId:= 8447, inToId:= 8447, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_ProductionUnion_Olap(inStartDate := ('01.06.2021')::TDateTime , inEndDate := ('01.06.2021')::TDateTime , inStartDate2 := ('01.07.2021')::TDateTime , inEndDate2 := ('01.07.2021')::TDateTime , inIsMovement := 'False' , inisPartion := 'False' , inGoodsGroupId := 1995 , inGoodsId := 0 , inChildGoodsGroupId := 1945 , inChildGoodsId := 0 , inFromId := 8447 , inToId := 8447 ,  inSession := '5') ORDER BY MonthDate, GoodsId, GoodsId_child, InfoMoneyId, InfoMoneyId_Detail
