-- Function: gpReport_GoodsMI_ProductionUnion ()

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
             , ChildAmount TFloat, ChildAmountReceipt TFloat, ChildSumm TFloat
             , MainPrice TFloat, ChildPrice TFloat
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
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END AS MovementId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.DescId                 AS MIContainerDescId
                             , MIContainer.ContainerId            AS ContainerId
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0) END AS GoodsKindId
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
                        WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          AND MIContainer.isActive = TRUE
                          AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        GROUP BY CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END
                               , MovementBoolean_Peresort.ValueData
                               , MLO_DocumentKind.ObjectId
                               , MIContainer.DescId
                               , MIContainer.ContainerId
                               , MIContainer.ObjectId_Analyzer
                               , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0) END
                               , MIContainer.OperDate
                       )
           --данные второго периода
         , tmpMI_ContainerIn2 AS
                       (SELECT MIContainer.OperDate                                 AS OperDate
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END AS MovementId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.DescId                 AS MIContainerDescId
                             , MIContainer.ContainerId            AS ContainerId
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0) END AS GoodsKindId
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
                        WHERE MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                          AND MIContainer.isActive = TRUE
                          AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        GROUP BY CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END
                               , MovementBoolean_Peresort.ValueData
                               , MLO_DocumentKind.ObjectId
                               , MIContainer.DescId
                               , MIContainer.ContainerId
                               , MIContainer.ObjectId_Analyzer
                               , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0) END
                               , MIContainer.OperDate
                       )
                                
         , tmpContainer_in1 AS (SELECT DISTINCT tmp.ContainerId
                                    , tmp.GoodsId
                                    , tmp.GoodsKindId
                                    , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                               FROM tmpMI_ContainerIn1 AS tmp
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                  ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerId
                                                                 AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                              )
         , tmpContainer_in2 AS (SELECT DISTINCT tmp.ContainerId
                                    , tmp.GoodsId
                                    , tmp.GoodsKindId
                                    , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                               FROM tmpMI_ContainerIn2 AS tmp
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                  ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerId
                                                                 AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                              )

         , tmpOut1 AS (SELECT DATE_TRUNC ('Month', MIContainer.OperDate) AS OperDate
                            , MIContainer.MovementId
                            , MIContainer.MovementItemId
                            , MIContainer.DescId                AS MIContainerDescId
                            , tmpContainer_in.GoodsId           AS GoodsId_in
                            , tmpContainer_in.GoodsKindId       AS GoodsKindId_in
                            , tmpContainer_in.PartionGoodsId    AS PartionGoodsId_in
                            , MIContainer.ContainerId           AS ContainerId
                            , MIContainer.ObjectId_Analyzer     AS GoodsId       
                            , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                            ,  (MIContainer.Amount)     AS Amount
                       FROM tmpContainer_in1 AS tmpContainer_in
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId_Analyzer = tmpContainer_in.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                           AND MIContainer.isActive = FALSE
                           INNER JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = MIContainer.ObjectId_Analyzer
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
                                 
         , tmpMI_ContainerOut1 AS
                       (SELECT MIContainer.OperDate
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END AS MovementId
                             , MIContainer.MIContainerDescId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.GoodsId_in
                             , MIContainer.GoodsKindId_in
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId       
                             , MIContainer.GoodsKindId
                             , -1 * SUM (MIContainer.Amount)     AS Amount
                             , COALESCE (MIFloat_AmountReceipt.ValueData, 0)  AS AmountReceipt
                        FROM tmpOut1 AS MIContainer
                             LEFT JOIN tmpMovementBoolean1 AS MovementBoolean_Peresort
                                                          ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                     --    AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()-- and 1=0
                             LEFT JOIN tmpMovementLinkObject1 AS MLO_DocumentKind
                                                          ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                                                       --  AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind() --and 1=0
                             LEFT JOIN tmpMIAmountReceipt1 AS MIFloat_AmountReceipt
                                                           ON MIFloat_AmountReceipt.MovementItemId = MIContainer.MovementItemId
                        GROUP BY MIContainer.OperDate
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END
                             , MIContainer.MIContainerDescId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE)
                             , COALESCE (MLO_DocumentKind.ObjectId, 0) 
                             , MIContainer.GoodsId_in
                             , MIContainer.GoodsKindId_in
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId       
                             , MIContainer.GoodsKindId
                             , COALESCE (MIFloat_AmountReceipt.ValueData, 0)
                       )
                                 
          , tmpOut2 AS (SELECT DATE_TRUNC ('Month', MIContainer.OperDate) AS OperDate
                            , MIContainer.MovementId
                            , MIContainer.MovementItemId
                            , MIContainer.DescId                AS MIContainerDescId
                            , tmpContainer_in.GoodsId           AS GoodsId_in
                            , tmpContainer_in.GoodsKindId       AS GoodsKindId_in
                            , tmpContainer_in.PartionGoodsId    AS PartionGoodsId_in
                            , MIContainer.ContainerId           AS ContainerId
                            , MIContainer.ObjectId_Analyzer     AS GoodsId       
                            , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                            ,  (MIContainer.Amount)     AS Amount
                       FROM tmpContainer_in2 AS tmpContainer_in
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId_Analyzer = tmpContainer_in.ContainerId
                                                           AND MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                                           AND MIContainer.isActive = FALSE
                           INNER JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = MIContainer.ObjectId_Analyzer
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

         , tmpMI_ContainerOut2 AS
                       (SELECT MIContainer.OperDate
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END AS MovementId
                             , MIContainer.MIContainerDescId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
                             , COALESCE (MLO_DocumentKind.ObjectId, 0)              AS DocumentKindId
                             , MIContainer.GoodsId_in
                             , MIContainer.GoodsKindId_in
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId       
                             , MIContainer.GoodsKindId
                             , -1 * SUM (MIContainer.Amount)     AS Amount
                             , COALESCE (MIFloat_AmountReceipt.ValueData, 0)  AS AmountReceipt
                        FROM tmpOut2 AS MIContainer
                             LEFT JOIN tmpMovementBoolean2 AS MovementBoolean_Peresort
                                                          ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                         AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                             LEFT JOIN tmpMovementLinkObject2 AS MLO_DocumentKind
                                                          ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                                                         AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                             LEFT JOIN tmpMIAmountReceipt2 AS MIFloat_AmountReceipt
                                                           ON MIFloat_AmountReceipt.MovementItemId = MIContainer.MovementItemId
                        GROUP BY MIContainer.OperDate
                             , CASE WHEN inIsMovement = FALSE THEN 0 ELSE MIContainer.MovementId END
                             , MIContainer.MIContainerDescId
                             , COALESCE (MovementBoolean_Peresort.ValueData, FALSE)
                             , COALESCE (MLO_DocumentKind.ObjectId, 0) 
                             , MIContainer.GoodsId_in
                             , MIContainer.GoodsKindId_in
                             , MIContainer.PartionGoodsId_in
                             , MIContainer.ContainerId
                             , MIContainer.GoodsId       
                             , MIContainer.GoodsKindId
                             , COALESCE (MIFloat_AmountReceipt.ValueData, 0)
                       )

         , tmpMI_out1 AS (SELECT tmpMI_ContainerOut.OperDate
                               , tmpMI_ContainerOut.MovementId
                               , tmpMI_ContainerOut.isPeresort
                               , tmpMI_ContainerOut.DocumentKindId
                               , tmpMI_ContainerOut.GoodsId_in
                               , tmpMI_ContainerOut.GoodsKindId_in
                               , tmpMI_ContainerOut.PartionGoodsId_in
                               , tmpMI_ContainerOut.GoodsId       
                               , tmpMI_ContainerOut.GoodsKindId 
                               , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperCount
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperSumm
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.AmountReceipt ELSE 0 END) AS AmountReceipt
                          FROM tmpMI_ContainerOut1 AS tmpMI_ContainerOut
                               LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                             ON ContainerLO_PartionGoods.ContainerId = tmpMI_ContainerOut.ContainerId
                                                            AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                          GROUP BY tmpMI_ContainerOut.OperDate
                                 , tmpMI_ContainerOut.MovementId
                                 , tmpMI_ContainerOut.isPeresort
                                 , tmpMI_ContainerOut.DocumentKindId
                                 , tmpMI_ContainerOut.GoodsId_in
                                 , tmpMI_ContainerOut.GoodsKindId_in
                                 , tmpMI_ContainerOut.PartionGoodsId_in
                                 , tmpMI_ContainerOut.GoodsId       
                                 , tmpMI_ContainerOut.GoodsKindId 
                                 , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END
                         )
         , tmpMI_out2 AS (SELECT tmpMI_ContainerOut.OperDate
                               , tmpMI_ContainerOut.MovementId
                               , tmpMI_ContainerOut.isPeresort
                               , tmpMI_ContainerOut.DocumentKindId
                               , tmpMI_ContainerOut.GoodsId_in
                               , tmpMI_ContainerOut.GoodsKindId_in
                               , tmpMI_ContainerOut.PartionGoodsId_in
                               , tmpMI_ContainerOut.GoodsId       
                               , tmpMI_ContainerOut.GoodsKindId 
                               , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END AS PartionGoodsId
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperCount
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerOut.Amount ELSE 0 END) AS OperSumm
                               , SUM (CASE WHEN tmpMI_ContainerOut.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerOut.AmountReceipt ELSE 0 END) AS AmountReceipt
                          FROM tmpMI_ContainerOut2 AS tmpMI_ContainerOut
                               LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                             ON ContainerLO_PartionGoods.ContainerId = tmpMI_ContainerOut.ContainerId
                                                            AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                          GROUP BY tmpMI_ContainerOut.OperDate
                                 , tmpMI_ContainerOut.MovementId
                                 , tmpMI_ContainerOut.isPeresort
                                 , tmpMI_ContainerOut.DocumentKindId
                                 , tmpMI_ContainerOut.GoodsId_in
                                 , tmpMI_ContainerOut.GoodsKindId_in
                                 , tmpMI_ContainerOut.PartionGoodsId_in
                                 , tmpMI_ContainerOut.GoodsId       
                                 , tmpMI_ContainerOut.GoodsKindId 
                                 , CASE WHEN inIsMovement = FALSE THEN 0 ELSE COALESCE (ContainerLO_PartionGoods.ObjectId, 0) END
                         )

         , tmpOperationGroup1 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , tmpMI_ContainerIn.MovementId
                                       , tmpMI_ContainerIn.isPeresort
                                       , tmpMI_ContainerIn.DocumentKindId
                                       
                                       , COALESCE (tmpContainer_in.PartionGoodsId, 0) AS PartionGoodsId
                                       , tmpMI_ContainerIn.GoodsId                    AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                AS GoodsKindId
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperCount
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperSumm

                                      , 0 AS PartionGoodsId_out
                                      , 0 AS GoodsId_out
                                      , 0 AS GoodsKindId_out
                                      , 0 AS OperCount_out
                                      , 0 AS OperSumm_out    
                                      , 0 AS AmountReceipt_out                                        
                                       
                                  FROM tmpMI_ContainerIn1 AS tmpMI_ContainerIn
                                       LEFT JOIN tmpContainer_in1 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                  GROUP BY tmpMI_ContainerIn.MovementId
                                         , tmpMI_ContainerIn.isPeresort
                                         , tmpMI_ContainerIn.DocumentKindId
                                         , COALESCE (tmpContainer_in.PartionGoodsId, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                  UNION 
                                  SELECT tmpMI_out.OperDate
                                       , tmpMI_out.MovementId
                                       , tmpMI_out.isPeresort
                                       , tmpMI_out.DocumentKindId
                                       , tmpMI_out.PartionGoodsId_in
                                       , tmpMI_out.GoodsId_in       
                                       , tmpMI_out.GoodsKindId_in
                                       , 0 AS OperCount
                                       , 0 AS OperSumm

                                       , tmpMI_out.PartionGoodsId AS PartionGoodsId_out
                                       , tmpMI_out.GoodsId        AS GoodsId_out
                                       , tmpMI_out.GoodsKindId    AS GoodsKindId_out
                                       , tmpMI_out.OperCount      AS OperCount_out
                                       , tmpMI_out.OperSumm       AS OperSumm_out 
                                       , tmpMI_out.AmountReceipt  AS AmountReceipt_out
                                  FROM tmpMI_out1 AS tmpMI_out    
                                 )

         , tmpOperationGroup2 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , tmpMI_ContainerIn.MovementId
                                       , tmpMI_ContainerIn.isPeresort
                                       , tmpMI_ContainerIn.DocumentKindId
                                       
                                       , COALESCE (tmpContainer_in.PartionGoodsId, 0) AS PartionGoodsId
                                       , tmpMI_ContainerIn.GoodsId                    AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                AS GoodsKindId
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Count() THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperCount
                                       , SUM (CASE WHEN tmpMI_ContainerIn.MIContainerDescId = zc_MIContainer_Summ()  THEN tmpMI_ContainerIn.Amount ELSE 0 END) AS OperSumm

                                      , 0 AS PartionGoodsId_out
                                      , 0 AS GoodsId_out
                                      , 0 AS GoodsKindId_out
                                      , 0 AS OperCount_out
                                      , 0 AS OperSumm_out 
                                       , 0 AS AmountReceipt_out                                             
                                       
                                  FROM tmpMI_ContainerIn2 AS tmpMI_ContainerIn
                                       LEFT JOIN tmpContainer_in2 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                  GROUP BY tmpMI_ContainerIn.MovementId
                                         , tmpMI_ContainerIn.isPeresort
                                         , tmpMI_ContainerIn.DocumentKindId
                                         , COALESCE (tmpContainer_in.PartionGoodsId, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                  UNION 
                                  SELECT tmpMI_out.OperDate
                                       , tmpMI_out.MovementId
                                       , tmpMI_out.isPeresort
                                       , tmpMI_out.DocumentKindId
                                       , tmpMI_out.PartionGoodsId_in
                                       , tmpMI_out.GoodsId_in       
                                       , tmpMI_out.GoodsKindId_in
                                       , 0 AS OperCount
                                       , 0 AS OperSumm

                                       , tmpMI_out.PartionGoodsId AS PartionGoodsId_out
                                       , tmpMI_out.GoodsId        AS GoodsId_out
                                       , tmpMI_out.GoodsKindId    AS GoodsKindId_out
                                       , tmpMI_out.OperCount      AS OperCount_out
                                       , tmpMI_out.OperSumm       AS OperSumm_out  
                                       , tmpMI_out.AmountReceipt  AS AmountReceipt_out
                                  FROM tmpMI_out2 AS tmpMI_out  
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
           
           , (tmpOperationGroup.OperCount_out * (CASE WHEN ObjectLink_Goods_MeasureChild.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_WeightChild.ValueData ELSE 1 END ))      :: TFloat AS ChildAmount
           , (tmpOperationGroup.AmountReceipt_out * (CASE WHEN ObjectLink_Goods_MeasureChild.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_WeightChild.ValueData ELSE 1 END ))  :: TFloat AS ChildAmountReceipt
           , tmpOperationGroup.OperSumm_out   :: TFloat AS ChildSumm

           , CASE WHEN tmpOperationGroup.OperCount     <> 0 THEN tmpOperationGroup.OperSumm     / tmpOperationGroup.OperCount     ELSE 0 END :: TFloat AS MainPrice
           , CASE WHEN tmpOperationGroup.OperCount_out <> 0 THEN tmpOperationGroup.OperSumm_out / tmpOperationGroup.OperCount_out ELSE 0 END :: TFloat AS ChildPrice

           
        FROM tmpOperationGroup

             LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.GoodsId_out

             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = tmpOperationGroup.GoodsKindId_out
                    
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
-- SELECT * FROM gpReport_ProductionUnion_Olap (inStartDate:= '01.06.2018', inEndDate:= '01.06.2018', inStartDate2:= '05.06.2017', inEndDate2:= '05.06.2017', inIsMovement:= FALSE, inIsMovement:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inChildGoodsGroupId:= 0, inChildGoodsId:=0, inFromId:= 0, inToId:= 0, inSession:= zfCalc_UserAdmin());
