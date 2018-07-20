-- Function: gpReport_GoodsMI_ProductionUnion ()
 временный
DROP FUNCTION IF EXISTS gpReport_ProductionUnion_Olap (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionUnion_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inStartDate2         TDateTime ,  
    IN inEndDate2           TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inChildGoodsGroupId  Integer   ,
    IN inChildGoodsId       Integer   ,
    IN inFromId             Integer   ,    -- от кого 
    IN inToId               Integer   ,    -- кому
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime
             , MonthDate TDateTime
             , isPeresort Boolean, DocumentKindName TVarChar
             , PartionGoods TVarChar
             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , Amount TFloat, Summ TFloat
             , ChildPartionGoods TVarChar
             , ChildGoodsGroupName TVarChar
             , ChildGoodsCode Integer, ChildGoodsName TVarChar
             , ChildGoodsKindName TVarChar
             , ChildAmount TFloat, ChildAmountReceipt TFloat, ChildAmountCalc TFloat
             , ChildAmount_Weight TFloat, ChildAmountReceipt_Weight TFloat, ChildAmountCalc_Weight    TFloat

             , ChildSumm TFloat
             , MainPrice TFloat, ChildPrice TFloat

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             )   
AS
$BODY$
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpChildGoods (ChildGoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;
  
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    IF inChildGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpChildGoods (ChildGoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inChildGoodsId <> 0
         THEN
             INSERT INTO _tmpChildGoods (ChildGoodsId)
              SELECT inChildGoodsId;
         ELSE
             INSERT INTO _tmpChildGoods (ChildGoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;


    -- ограничения по ОТ КОГО
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;
    END IF;

    -- ограничения по КОМУ
    IF inToId <> 0
    THEN
        INSERT INTO _tmpToGroup (ToId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpToGroup (ToId)
          SELECT Id FROM Object_Unit_View ;
    END IF;

  
    -- Результат
    RETURN QUERY
      WITH 
           -- данные первого периода
           tmpMI_ContainerIn1 AS
                       (SELECT MIContainer.OperDate                                 AS OperDate
                             , MIContainer.MovementId                               AS MovementId
                             , MIContainer.MovementItemId                           AS MovementItemId 
                             , MILO_Receipt.ObjectId                                AS ReceiptId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.DescId                 AS MIContainerDescId
                             , MIContainer.ContainerId            AS ContainerId
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId
                             , SUM (MIContainer.Amount)           AS Amount
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
                             -- связь с рецептурой
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
                               , MIContainer.OperDate
                       )
         , tmpContainer_in1 AS (SELECT DISTINCT tmp.ContainerId
                                     , tmp.GoodsId
                                     , tmp.GoodsKindId
                                     , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
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
                                )

         , tmpOut1 AS (SELECT DATE_TRUNC ('Month', MIContainer.OperDate) AS OperDate
                            , MIContainer.MovementId             AS MovementId
                            , MIContainer.MovementItemId         AS MovementItemId
                            , MovementItem.ParentId              AS MovementItemId_master
                            , MIContainer.DescId                 AS MIContainerDescId
                            , tmpContainer_in.GoodsId            AS GoodsId_in
                            , tmpContainer_in.GoodsKindId        AS GoodsKindId_in
                            , tmpContainer_in.PartionGoodsId     AS PartionGoodsId_in
                            , tmpContainer_in.InfoMoneyId        AS InfoMoneyId_in
                            , tmpContainer_in.InfoMoneyId_Detail AS InfoMoneyId_Detail_in 
                            , MIContainer.ContainerId            AS ContainerId
                            , MIContainer.ObjectId_Analyzer      AS GoodsId       
                            , MIContainer.ObjectIntId_Analyzer   AS GoodsKindId
                            , (MIContainer.Amount)               AS Amount
                            , MI_Master.Amount                   AS Amount_Master

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

         -- кол-во кутеров мастер
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
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.InfoMoneyId_in
                             , MIContainer.InfoMoneyId_Detail_in 
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId       
                             , MIContainer.GoodsKindId
                             , -1 * SUM (MIContainer.Amount)     AS Amount
                             , SUM (MIContainer.Amount_Master)  AS Amount_Master
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
                               , MIContainer.PartionGoodsId_in
                               , MIContainer.InfoMoneyId_in
                               , MIContainer.InfoMoneyId_Detail_in 
                               , MIContainer.ContainerId
                               , MIContainer.GoodsId       
                               , MIContainer.GoodsKindId
                       )

         -- данные из рецептур
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
                               , tmpMI_ContainerOut.GoodsId_in
                               , tmpMI_ContainerOut.GoodsKindId_in
                               , tmpMI_ContainerOut.PartionGoodsId_in
                               , tmpMI_ContainerOut.InfoMoneyId_in
                               , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                               , tmpMI_ContainerOut.GoodsId       
                               , tmpMI_ContainerOut.GoodsKindId 
                               , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
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

                               -- привязывваем рецептуры
                               LEFT JOIN tmpReceipt ON tmpReceipt.MovementItemId = tmpMI_ContainerOut.MovementItemId_master
                                                   AND tmpReceipt.GoodsId        = tmpMI_ContainerOut.GoodsId
                                                   AND COALESCE (tmpReceipt.GoodsKindId ,0)   = COALESCE (tmpMI_ContainerOut.GoodsKindId,0)
                                                   AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()
                                                 
                          GROUP BY tmpMI_ContainerOut.OperDate
                                 , tmpMI_ContainerOut.MovementId
                                 , tmpMI_ContainerOut.isPeresort
                                 , tmpMI_ContainerOut.DocumentKindId
                                 , tmpMI_ContainerOut.GoodsId_in
                                 , tmpMI_ContainerOut.GoodsKindId_in
                                 , tmpMI_ContainerOut.PartionGoodsId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                                 , tmpMI_ContainerOut.GoodsId       
                                 , tmpMI_ContainerOut.GoodsKindId 
                                 , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END
                               , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                               , COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                         )
         , tmpOperationGroup1 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_ContainerIn.isPeresort
                                       , tmpMI_ContainerIn.DocumentKindId
                                       
                                       , COALESCE (tmpContainer_in.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpContainer_in.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                        AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                    AS GoodsKindId
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperCount
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperSumm


                                      , 0 AS PartionGoodsId_out
                                      , 0 AS GoodsId_out
                                      , 0 AS GoodsKindId_out
                                      , 0 AS OperCount_out
                                      , 0 AS OperSumm_out    
                                      , 0 AS AmountReceipt_out                                        
                                      , 0 AS AmountCalc_out 
                                      , 0 AS AmountCalcForWeght
                                      , 0 AS AmountForWeght 
                                      , 0 AS AmountReceiptForWeght
                                  FROM tmpMI_ContainerIn1 AS tmpMI_ContainerIn
                                       LEFT JOIN tmpContainer_in1 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , tmpMI_ContainerIn.isPeresort
                                         , tmpMI_ContainerIn.DocumentKindId
                                         , COALESCE (tmpContainer_in.PartionGoodsId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                  UNION 
                                  SELECT tmpMI_out.OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_out.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_out.isPeresort
                                       , tmpMI_out.DocumentKindId
                                       , tmpMI_out.PartionGoodsId_in
                                       , tmpMI_out.InfoMoneyId_in
                                       , tmpMI_out.InfoMoneyId_Detail_in
                                       , tmpMI_out.GoodsId_in       
                                       , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END AS GoodsKindId_in
                                       , 0 AS OperCount
                                       , 0 AS OperSumm

                                       , tmpMI_out.PartionGoodsId       AS PartionGoodsId_out
                                       , tmpMI_out.GoodsId              AS GoodsId_out
                                       , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END AS GoodsKindId_out
                                       , SUM (tmpMI_out.OperCount)      AS OperCount_out
                                       , SUM (tmpMI_out.OperSumm)       AS OperSumm_out 
                                       , SUM (tmpMI_out.AmountReceipt)  AS AmountReceipt_out
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
                                                   THEN tmpMI_out.AmountReceipt
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
                                         , tmpMI_out.PartionGoodsId_in
                                         , tmpMI_out.InfoMoneyId_in
                                         , tmpMI_out.InfoMoneyId_Detail_in
                                         , tmpMI_out.GoodsId_in       
                                         , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END
                                         , tmpMI_out.PartionGoodsId
                                         , tmpMI_out.GoodsId
                                         , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END
                                 )

           --данные второго периода
         , tmpMI_ContainerIn2 AS
                       (SELECT MIContainer.OperDate                                 AS OperDate
                             , MIContainer.MovementId                               AS MovementId
                             , MIContainer.MovementItemId                           AS MovementItemId 
                             , MILO_Receipt.ObjectId                                AS ReceiptId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.DescId                 AS MIContainerDescId
                             , MIContainer.ContainerId            AS ContainerId
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId
                             , SUM (MIContainer.Amount)           AS Amount
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
                             -- связь с рецептурой
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
                       )
         , tmpContainer_in2 AS (SELECT DISTINCT tmp.ContainerId
                                     , tmp.GoodsId
                                     , tmp.GoodsKindId
                                     , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
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
                                )

         , tmpOut2 AS (SELECT DATE_TRUNC ('Month', MIContainer.OperDate) AS OperDate
                            , MIContainer.MovementId             AS MovementId
                            , MIContainer.MovementItemId         AS MovementItemId
                            , MovementItem.ParentId              AS MovementItemId_master
                            , MIContainer.DescId                 AS MIContainerDescId
                            , tmpContainer_in.GoodsId            AS GoodsId_in
                            , tmpContainer_in.GoodsKindId        AS GoodsKindId_in
                            , tmpContainer_in.PartionGoodsId     AS PartionGoodsId_in
                            , tmpContainer_in.InfoMoneyId        AS InfoMoneyId_in
                            , tmpContainer_in.InfoMoneyId_Detail AS InfoMoneyId_Detail_in 
                            , MIContainer.ContainerId            AS ContainerId
                            , MIContainer.ObjectId_Analyzer      AS GoodsId       
                            , MIContainer.ObjectIntId_Analyzer   AS GoodsKindId
                            , (MIContainer.Amount)               AS Amount
                            , MI_Master.Amount                   AS Amount_Master

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

         -- кол-во кутеров мастер
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
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.InfoMoneyId_in
                             , MIContainer.InfoMoneyId_Detail_in 
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId       
                             , MIContainer.GoodsKindId
                             , -1 * SUM (MIContainer.Amount)     AS Amount
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
                               , MIContainer.PartionGoodsId_in
                               , MIContainer.InfoMoneyId_in
                               , MIContainer.InfoMoneyId_Detail_in 
                               , MIContainer.ContainerId
                               , MIContainer.GoodsId       
                               , MIContainer.GoodsKindId
                       )

         -- данные из рецептур
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
                               , tmpMI_ContainerOut.GoodsId_in
                               , tmpMI_ContainerOut.GoodsKindId_in
                               , tmpMI_ContainerOut.PartionGoodsId_in
                               , tmpMI_ContainerOut.InfoMoneyId_in
                               , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                               , tmpMI_ContainerOut.GoodsId       
                               , tmpMI_ContainerOut.GoodsKindId 
                               , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
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

                               -- привязывваем рецептуры
                               LEFT JOIN tmpReceipt2 AS tmpReceipt
                                                     ON tmpReceipt.MovementItemId = tmpMI_ContainerOut.MovementItemId_master
                                                    AND tmpReceipt.GoodsId        = tmpMI_ContainerOut.GoodsId
                                                    AND COALESCE (tmpReceipt.GoodsKindId ,0)   = COALESCE (tmpMI_ContainerOut.GoodsKindId,0)
                                                    AND tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count()
                                                 
                          GROUP BY tmpMI_ContainerOut.OperDate
                                 , tmpMI_ContainerOut.MovementId
                                 , tmpMI_ContainerOut.isPeresort
                                 , tmpMI_ContainerOut.DocumentKindId
                                 , tmpMI_ContainerOut.GoodsId_in
                                 , tmpMI_ContainerOut.GoodsKindId_in
                                 , tmpMI_ContainerOut.PartionGoodsId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_in
                                 , tmpMI_ContainerOut.InfoMoneyId_Detail_in
                                 , tmpMI_ContainerOut.GoodsId       
                                 , tmpMI_ContainerOut.GoodsKindId 
                                 , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END
                               , COALESCE (MIBoolean_TaxExit.ValueData, FALSE)
                               , COALESCE (MIBoolean_WeightMain.ValueData, FALSE)
                         )
         , tmpOperationGroup2 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_ContainerIn.isPeresort
                                       , tmpMI_ContainerIn.DocumentKindId
                                       
                                       , COALESCE (tmpContainer_in.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpContainer_in.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                        AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                    AS GoodsKindId
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperCount
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperSumm


                                      , 0 AS PartionGoodsId_out
                                      , 0 AS GoodsId_out
                                      , 0 AS GoodsKindId_out
                                      , 0 AS OperCount_out
                                      , 0 AS OperSumm_out    
                                      , 0 AS AmountReceipt_out                                        
                                      , 0 AS AmountCalc_out 
                                      , 0 AS AmountCalcForWeght
                                      , 0 AS AmountForWeght 
                                      , 0 AS AmountReceiptForWeght
                                  FROM tmpMI_ContainerIn2 AS tmpMI_ContainerIn
                                       LEFT JOIN tmpContainer_in2 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , tmpMI_ContainerIn.isPeresort
                                         , tmpMI_ContainerIn.DocumentKindId
                                         , COALESCE (tmpContainer_in.PartionGoodsId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId, 0)
                                         , COALESCE (tmpContainer_in.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                  UNION 
                                  SELECT tmpMI_out.OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_out.MovementId ELSE 0 END AS MovementId
                                       , tmpMI_out.isPeresort
                                       , tmpMI_out.DocumentKindId
                                       , tmpMI_out.PartionGoodsId_in
                                       , tmpMI_out.InfoMoneyId_in
                                       , tmpMI_out.InfoMoneyId_Detail_in
                                       , tmpMI_out.GoodsId_in       
                                       , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END AS GoodsKindId_in
                                       , 0 AS OperCount
                                       , 0 AS OperSumm

                                       , tmpMI_out.PartionGoodsId       AS PartionGoodsId_out
                                       , tmpMI_out.GoodsId              AS GoodsId_out
                                       , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END AS GoodsKindId_out
                                       , SUM (tmpMI_out.OperCount)      AS OperCount_out
                                       , SUM (tmpMI_out.OperSumm)       AS OperSumm_out 
                                       , SUM (tmpMI_out.AmountReceipt)  AS AmountReceipt_out
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
                                                   THEN tmpMI_out.AmountReceipt
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
                                         , tmpMI_out.PartionGoodsId_in
                                         , tmpMI_out.InfoMoneyId_in
                                         , tmpMI_out.InfoMoneyId_Detail_in
                                         , tmpMI_out.GoodsId_in       
                                         , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId_in END
                                         , tmpMI_out.PartionGoodsId
                                         , tmpMI_out.GoodsId
                                         , CASE WHEN inIsMovement = FALSE THEN 0 ELSE tmpMI_out.GoodsKindId END
                                 )

         , tmpOperationGroup AS (SELECT tmpOperationGroup1.*                                      
                                 FROM tmpOperationGroup1
                                UNION
                                SELECT tmpOperationGroup2.*
                                FROM tmpOperationGroup2
                                 )

      -- Результат 
      SELECT Movement.InvNumber
           , Movement.OperDate
           , tmpOperationGroup.OperDate   :: TDateTime AS MonthDate
           , tmpOperationGroup.isPeresort :: Boolean AS isPeresort
           , Object_DocumentKind.ValueData    AS DocumentKindName

           , Object_PartionGoods.ValueData    AS PartionGoods
           
           , Object_GoodsGroup.ValueData      AS GoodsGroupName 
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName  
           , Object_GoodsKind.ValueData       AS GoodsKindName
           
           , (tmpOperationGroup.OperCount * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))  :: TFloat AS Amount
           , tmpOperationGroup.OperSumm  :: TFloat AS Summ

           , Object_PartionGoodsChild.ValueData AS ChildPartionGoods
           
           , Object_GoodsGroupChild.ValueData AS ChildGoodsGroupName 
           , Object_GoodsChild.ObjectCode     AS ChildGoodsCode
           , Object_GoodsChild.ValueData      AS ChildGoodsName
           , Object_GoodsKindChild.ValueData  AS ChildGoodsKindName
           
           , tmpOperationGroup.OperCount_out       :: TFloat AS ChildAmount
           , tmpOperationGroup.AmountReceipt_out   :: TFloat AS ChildAmountReceipt
           , tmpOperationGroup.AmountCalc_out      :: TFloat AS ChildAmountCalc
           
           , (tmpOperationGroup.AmountForWeght        * (CASE WHEN ObjectLink_Goods_MeasureChild.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_WeightChild.ValueData ELSE 1 END ))  :: TFloat AS ChildAmount_Weight
           , (tmpOperationGroup.AmountReceiptForWeght * (CASE WHEN ObjectLink_Goods_MeasureChild.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_WeightChild.ValueData ELSE 1 END ))  :: TFloat AS ChildAmountReceipt_Weight
           , (tmpOperationGroup.AmountCalcForWeght    * (CASE WHEN ObjectLink_Goods_MeasureChild.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_WeightChild.ValueData ELSE 1 END ))  :: TFloat AS ChildAmountCalc_Weight
           , tmpOperationGroup.OperSumm_out   :: TFloat AS ChildSumm

           , CASE WHEN tmpOperationGroup.OperCount     <> 0 THEN tmpOperationGroup.OperSumm     / tmpOperationGroup.OperCount     ELSE 0 END :: TFloat AS MainPrice
           , CASE WHEN tmpOperationGroup.OperCount_out <> 0 THEN tmpOperationGroup.OperSumm_out / tmpOperationGroup.OperCount_out ELSE 0 END :: TFloat AS ChildPrice

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
           
        FROM tmpOperationGroup

             LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.GoodsId_out

             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = tmpOperationGroup.GoodsKindId_out
                    
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = tmpOperationGroup.InfoMoneyId_Detail
        
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupChild
                                  ON ObjectLink_Goods_GoodsGroupChild.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_Goods_GoodsGroupChild.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroupChild ON Object_GoodsGroupChild.Id = ObjectLink_Goods_GoodsGroupChild.ChildObjectId

             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId
             LEFT JOIN Object AS Object_PartionGoodsChild ON Object_PartionGoodsChild.Id = tmpOperationGroup.PartionGoodsId_out

             LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = tmpOperationGroup.DocumentKindId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_MeasureChild
                                  ON ObjectLink_Goods_MeasureChild.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_Goods_MeasureChild.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectFloat AS ObjectFloat_WeightChild
                                   ON ObjectFloat_WeightChild.ObjectId = Object_GoodsChild.Id
                                  AND ObjectFloat_WeightChild.DescId = zc_ObjectFloat_Goods_Weight()

  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.18         *
*/

-- тест
-- SELECT * FROM gpReport_ProductionUnion_Olap (inStartDate:= '01.06.2018', inEndDate:= '01.06.2018', inStartDate2:= '05.06.2017', inEndDate2:= '05.06.2017', inIsMovement:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inChildGoodsGroupId:= 0, inChildGoodsId:=0, inFromId:= 0, inToId:= 0, inSession:= zfCalc_UserAdmin());