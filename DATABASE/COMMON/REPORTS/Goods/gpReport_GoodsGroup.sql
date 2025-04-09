 -- Function: gpReport_GoodsGroup ()

DROP FUNCTION IF EXISTS gpReport_GoodsGroup (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsGroup (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsGroup(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inUnitGroupId  Integer   ,
    IN inLocationId   Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inIsPartner    Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
              , isPeresort Boolean
              , MovementDescName TVarChar, MovementDescName_order TVarChar
              , isActive Boolean, isRemains Boolean, isRePrice Boolean, isInv Boolean
              , LocationDescName TVarChar, LocationCode Integer, LocationName TVarChar
              , CarCode Integer, CarName TVarChar
              , ObjectByDescName TVarChar, ObjectByCode Integer, ObjectByName TVarChar
              , PaidKindName TVarChar
              , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, GoodsKindName_complete TVarChar, PartionGoods TVarChar
              , GoodsCode_parent Integer, GoodsName_parent TVarChar, GoodsKindName_parent TVarChar
              , Price TFloat, Price_branch TFloat, Price_end TFloat, Price_branch_end TFloat, Price_partner TFloat
              , SummPartnerIn TFloat, SummPartnerOut TFloat
              , AmountStart TFloat, AmountIn TFloat, AmountOut TFloat, AmountEnd TFloat, Amount TFloat
              , SummStart TFloat, SummStart_branch TFloat, SummIn TFloat, SummIn_branch TFloat, SummOut TFloat, SummOut_branch TFloat, SummEnd TFloat, SummEnd_branch TFloat, Summ TFloat, Summ_branch TFloat

              , Amount_Change TFloat, Summ_Change_branch TFloat, Summ_Change_zavod TFloat
              , Amount_40200 TFloat, Summ_40200_branch TFloat, Summ_40200_zavod TFloat
              , Amount_Loss TFloat, Summ_Loss_branch TFloat, Summ_Loss_zavod TFloat
              , isPage3 Boolean, isExistsPage3 Boolean
               )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsBranch Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_GoodsGroup());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!определяется!!!
     vbIsBranch:= 1 = 0 OR EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId);

     -- таблица -
     /*CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;*/


    -- Результат
    RETURN QUERY

    WITH tmpSendOnPrice_out AS (SELECT * FROM gpReport_GoodsMI_SendOnPrice (inStartDate    := inStartDate
                                                                          , inEndDate      := inEndDate
                                                                          , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                          , inToId         := 0
                                                                          , inGoodsGroupId := inGoodsGroupId
                                                                          , inIsTradeMark  := FALSE
                                                                          , inIsGoods      := FALSE
                                                                          , inIsGoodsKind  := FALSE
                                                                          , inIsMovement   := FALSE
                                                                          , inIsSubjectDoc := FALSE
                                                                          , inSession      := ''
                                                                           ) AS gpReport)
        , tmpSendOnPrice_in AS (SELECT * FROM gpReport_GoodsMI_SendOnPrice (inStartDate    := inStartDate
                                                                          , inEndDate      := inEndDate
                                                                          , inFromId       := 0
                                                                          , inToId         := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                          , inGoodsGroupId := inGoodsGroupId
                                                                          , inIsTradeMark  := FALSE
                                                                          , inIsGoods      := FALSE
                                                                          , inIsGoodsKind  := FALSE
                                                                          , inIsMovement   := FALSE
                                                                          , inIsSubjectDoc := FALSE
                                                                          , inSession      := ''
                                                                           ) AS gpReport)
                  , tmpLoss AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_Loss()
                                                                       , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inToId         := 0
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inPriceListId  := 0
                                                                       , inIsMO_all     := TRUE -- FALSE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
              , tmpSend_out AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_Send()
                                                                       , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inToId         := 0
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inPriceListId  := 0
                                                                       , inIsMO_all     := TRUE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
               , tmpSend_in AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_Send()
                                                                       , inFromId       := 0
                                                                       , inToId         := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inIsMO_all     := TRUE
                                                                       , inPriceListId  := 0
                                                                       , inSession      := ''
                                                                        ) AS gpReport)

         , tmpSendAsset_out AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_SendAsset()
                                                                       , inFromId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inToId         := 0
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inPriceListId  := 0
                                                                       , inIsMO_all     := TRUE
                                                                       , inSession      := ''
                                                                        ) AS gpReport)
          , tmpSendAsset_in AS (SELECT * FROM gpReport_GoodsMI_Internal (inStartDate    := inStartDate
                                                                       , inEndDate      := inEndDate
                                                                       , inDescId       := zc_Movement_SendAsset()
                                                                       , inFromId       := 0
                                                                       , inToId         := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId := inGoodsGroupId
                                                                       , inIsMO_all     := TRUE
                                                                       , inPriceListId  := 0
                                                                       , inSession      := ''
                                                                        ) AS gpReport)

                           , tmpSale AS (SELECT * FROM gpReport_GoodsMI (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_Sale()
                                                                       , inJuridicalId       := 0
                                                                       , inPaidKindId        := 0
                                                                       , inInfoMoneyId       := 0
                                                                       , inUnitGroupId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inUnitId            := 0
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inIsPartner         := TRUE
                                                                       , inIsTradeMark       := FALSE
                                                                       , inIsGoods           := FALSE
                                                                       , inIsGoodsKind       := FALSE
                                                                       , inIsPartionGoods    := FALSE
                                                                       , inIsDate            := FALSE 
                                                                       , inisReason          := FALSE
                                                                       , inIsErased          := FALSE
                                                                       , inIsContract        := FALSE
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
                       , tmpReturnIn AS (SELECT * FROM gpReport_GoodsMI (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_ReturnIn()
                                                                       , inJuridicalId       := 0
                                                                       , inPaidKindId        := 0
                                                                       , inInfoMoneyId       := 0
                                                                       , inUnitGroupId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inUnitId            := 0
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inIsPartner         := TRUE
                                                                       , inIsTradeMark       := FALSE
                                                                       , inIsGoods           := FALSE
                                                                       , inIsGoodsKind       := FALSE
                                                                       , inIsPartionGoods    := FALSE
                                                                       , inIsDate            := FALSE
                                                                       , inisReason          := FALSE  
                                                                       , inIsErased          := FALSE 
                                                                       , inIsContract        := FALSE
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
         , tmpIncome AS (SELECT * FROM gpReport_GoodsMI_IncomeByPartner (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_Income()
                                                                       , inJuridicalId       := 0
                                                                       , inPaidKindId        := 0
                                                                       , inInfoMoneyId       := 0
                                                                       , inUnitGroupId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inUnitId            := 0
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inisDate            := FALSE
                                                                       , inisMovement        := FALSE
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
      , tmpReturnOut AS (SELECT * FROM gpReport_GoodsMI_IncomeByPartner (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_ReturnOut()
                                                                       , inJuridicalId       := 0
                                                                       , inPaidKindId        := 0
                                                                       , inInfoMoneyId       := 0
                                                                       , inUnitGroupId       := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inUnitId            := 0
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inisDate            := FALSE
                                                                       , inisMovement        := FALSE
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
  , tmpProductionUnion_in AS (SELECT * FROM gpReport_GoodsMI_Production (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_ProductionUnion()
                                                                       , inIsActive          := TRUE
                                                                       , inUnitId            := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
 , tmpProductionUnion_out AS (SELECT * FROM gpReport_GoodsMI_Production (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_ProductionUnion()
                                                                       , inIsActive          := FALSE
                                                                       , inUnitId            := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
  , tmpProductionSeparate_in AS (SELECT * FROM gpReport_GoodsMI_Production (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_ProductionSeparate()
                                                                       , inIsActive          := TRUE
                                                                       , inUnitId            := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
 , tmpProductionSeparate_out AS (SELECT * FROM gpReport_GoodsMI_Production (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inDescId            := zc_Movement_ProductionSeparate()
                                                                       , inIsActive          := FALSE
                                                                       , inUnitId            := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inSession           := ''
                                                                        ) AS gpReport)
            , tmpInventory AS (SELECT * FROM gpReport_GoodsMI_Inventory (inStartDate         := inStartDate
                                                                       , inEndDate           := inEndDate
                                                                       , inUnitId            := CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END
                                                                       , inGoodsGroupId      := inGoodsGroupId
                                                                       , inSession           := ''
                                                                        ) AS gpReport)

       , tmpWhere AS (SELECT lfSelect.UnitId AS LocationId FROM lfSelect_Object_Unit_byGroup (CASE WHEN inLocationId <> 0 THEN inLocationId ELSE inUnitGroupId END) AS lfSelect)
       , tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect)
       , tmpContainer_Count AS (SELECT Container.Id          AS ContainerId
                                     , tmpWhere.LocationId   AS LocationId
                                     , Container.ObjectId    AS GoodsId
                                     , Container.Amount
                                FROM tmpWhere
                                     INNER JOIN ContainerLinkObject AS CLO_Location ON CLO_Location.ObjectId = tmpWhere.LocationId
                                                                                   AND CLO_Location.DescId = zc_ContainerLinkObject_Unit()
                                     INNER JOIN Container ON Container.Id = CLO_Location.ContainerId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                               )
                , tmpMI_Count AS (SELECT tmpContainer_Count.ContainerId
                                       , tmpContainer_Count.LocationId
                                       , tmpContainer_Count.GoodsId
                                       , tmpContainer_Count.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS AmountStart
                                       , tmpContainer_Count.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.LocationId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.Amount
                                 )
        , tmpContainer_Summ AS (SELECT tmpContainer_Count.LocationId
                                     , tmpContainer_Count.GoodsId
                                     , Container.Id AS ContainerId
                                     , Container.ObjectId AS AccountId
                                     , Container.Amount
                                FROM tmpContainer_Count
                                     INNER JOIN Container ON Container.ParentId = tmpContainer_Count.ContainerId
                                                         AND Container.DescId = zc_Container_Summ()
                               )
                 , tmpMI_Summ AS (SELECT tmpContainer_Summ.AccountId
                                       , tmpContainer_Summ.LocationId
                                       , tmpContainer_Summ.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS AmountStart
                                       , tmpContainer_Summ.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS AmountEnd
                                  FROM tmpContainer_Summ
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Summ.ContainerId
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY tmpContainer_Summ.AccountId
                                         , tmpContainer_Summ.ContainerId
                                         , tmpContainer_Summ.LocationId
                                         , tmpContainer_Summ.Amount
                                 )
       , tmpRemains AS (SELECT tmpMI_Count.LocationId
                             , SUM (tmpMI_Count.AmountStart * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountStart_Weight
                             , SUM (tmpMI_Count.AmountEnd   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountEnd_Weight
                             , 0 AS SummStart_zavod
                             , 0 AS SummStart_branch
                             , 0 AS SummStart_60000
                             , 0 AS SummEnd_zavod
                             , 0 AS SummEnd_branch
                             , 0 AS SummEnd_60000
                        FROM tmpMI_Count
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_Count.GoodsId
                                                                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                   ON ObjectFloat_Weight.ObjectId = tmpMI_Count.GoodsId
                                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        GROUP BY tmpMI_Count.LocationId
                       UNION ALL
                        SELECT tmpMI_Summ.LocationId
                             , 0 AS AmountStart_Weight
                             , 0 AS AmountEnd_Weight
                             , SUM (tmpMI_Summ.AmountStart) AS SummStart_zavod
                             , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.AmountStart ELSE 0 END) AS SummStart_branch
                             , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.AmountStart ELSE 0 END) AS SummStart_60000
                             , SUM (tmpMI_Summ.AmountEnd) AS SummEnd_zavod
                             , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.AmountEnd ELSE 0 END) AS SummEnd_branch
                             , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) =  zc_Enum_AccountDirection_60200() THEN tmpMI_Summ.AmountEnd ELSE 0 END) AS SummEnd_60000
                        FROM tmpMI_Summ
                             LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpMI_Summ.AccountId
                        GROUP BY tmpMI_Summ.LocationId
                       )
       , tmpResult AS (-- 0. Remains
                       SELECT 0                               AS MovementDescId
                            , Object_Location.ObjectCode      AS LocationCode
                            , Object_Location.ValueData       AS LocationName
                            , 0                               AS ObjectByCode
                            , ''                              AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , SUM (tmp.AmountStart_Weight)    AS AmountStart
                            , SUM (tmp.AmountEnd_Weight)      AS AmountEnd
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummStart_branch) ELSE SUM (tmp.SummStart_zavod) END AS SummStart
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummEnd_branch)   ELSE SUM (tmp.SummEnd_zavod)   END AS SummEnd
                            , SUM (tmp.SummStart_branch)      AS SummStart_branch
                            , SUM (tmp.SummEnd_branch)        AS SummEnd_branch
                            , 0                               AS Summ
                            , 0                               AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpRemains AS tmp
                            LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmp.LocationId
                       GROUP BY Object_Location.ObjectCode
                              , Object_Location.ValueData
                      UNION ALL
                       -- 1.1. SendOnPrice - Out
                       SELECT zc_Movement_SendOnPrice()       AS MovementDescId
                            , tmp.FromCode                    AS LocationCode
                            , tmp.FromName                    AS LocationName
                            , tmp.ToCode                      AS ObjectByCode
                            , tmp.ToName                      AS ObjectByName
                            , 0                               AS PaidKindId

                            , SUM (tmp.OperCount_Partner)     AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummOut_Partner) ELSE SUM (tmp.SummIn_Partner_zavod) END AS SummOut
                            , SUM (tmp.SummOut_Partner)       AS SummOut_branch
                            , SUM (tmp.SummOut_Partner)       AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            --***, CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummOut_Partner) ELSE SUM (tmp.SummIn_Partner_zavod) END AS Summ
                            , SUM (tmp.Summ_pl)               AS Summ
                            , SUM (tmp.SummOut_Partner)       AS Summ_branch

                            , SUM (tmp.OperCount_Change)      AS Amount_Change
                            , SUM (tmp.SummIn_Change_zavod)   AS Summ_Change_branch
                            , SUM (tmp.SummIn_Change_zavod)   AS Summ_Change_zavod
                            , SUM (tmp.OperCount_40200)       AS Amount_40200
                            , SUM (tmp.SummIn_40200_zavod)    AS Summ_40200_branch
                            , SUM (tmp.SummIn_40200_zavod)    AS Summ_40200_zavod
                            , SUM (tmp.OperCount_Loss)        AS Amount_Loss
                            , SUM (tmp.SummIn_Loss)           AS Summ_Loss_branch
                            , SUM (tmp.SummIn_Loss_zavod)     AS Summ_Loss_zavod
                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , TRUE                            AS isPage3
                       FROM tmpSendOnPrice_out AS tmp
                       GROUP BY tmp.FromCode
                              , tmp.FromName
                              , tmp.ToCode
                              , tmp.ToName
                      UNION ALL
                       -- 1.2. SendOnPrice - In
                       SELECT zc_Movement_SendOnPrice()       AS MovementDescId
                            , tmp.ToCode                      AS LocationCode
                            , tmp.ToName                      AS LocationName
                            , tmp.FromCode                    AS ObjectByCode
                            , tmp.FromName                    AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , SUM (tmp.OperCount_Partner)     AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummOut_Partner_real) ELSE SUM (tmp.SummIn_Partner_zavod_real) END AS SummIn
                            , SUM (tmp.SummOut_Partner_real)       AS SummIn_branch
                            --***, SUM (tmp.SummIn_Partner_zavod_real)  AS SummPartnerIn
                            , SUM (tmp.Summ_pl)               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            --***, SUM (tmp.SummIn_Partner_zavod_real)  AS Summ
                            , SUM (tmp.Summ_pl)               AS Summ
                            , SUM (tmp.SummOut_Partner_real)       AS Summ_branch

                            , SUM (tmp.OperCount_Change)      AS Amount_Change
                            , SUM (tmp.SummIn_Change_zavod)   AS Summ_Change_branch
                            , SUM (tmp.SummIn_Change_zavod)   AS Summ_Change_zavod
                            , SUM (tmp.OperCount_40200)       AS Amount_40200
                            , SUM (tmp.SummIn_40200_zavod)    AS Summ_40200_branch
                            , SUM (tmp.SummIn_40200_zavod)    AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , TRUE                            AS isPage3
                       FROM tmpSendOnPrice_in AS tmp
                       GROUP BY tmp.FromCode
                              , tmp.FromName
                              , tmp.ToCode
                              , tmp.ToName
                      UNION ALL
                       -- 2. Loss
                       SELECT zc_Movement_Loss()              AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , CASE WHEN tmp.ArticleLossName <> ''
                                        THEN ArticleLossCode
                                   WHEN tmp.LocationName_by <> ''
                                        THEN LocationCode_by
                                   ELSE tmp.LocationCode
                              END AS ObjectByCode
                            , CASE WHEN tmp.LocationName_by <> '' OR tmp.ArticleLossName <> ''
                                        THEN COALESCE (tmp.LocationName_by, '') ||  CASE WHEN tmp.LocationName_by <> '' AND tmp.ArticleLossName <> '' THEN ' *** ' ELSE '' END || COALESCE (tmp.ArticleLossName, '')
                                   ELSE tmp.LocationName
                              END AS ObjectByName
                            , 0                               AS PaidKindId

                            , tmp.AmountOut_Weight            AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN tmp.SummOut_branch ELSE tmp.SummOut_zavod END AS SummOut
                            , tmp.SummOut_branch              AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , tmp.SummOut_zavod               AS Summ
                            , tmp.SummOut_branch              AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpLoss AS tmp
                      UNION ALL
                       -- 3.1. Send - Out
                       SELECT zc_Movement_Send()              AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , 0                               AS PaidKindId

                            , tmp.AmountOut_Weight            AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN tmp.SummOut_branch ELSE tmp.SummOut_zavod END AS SummOut
                            , tmp.SummOut_branch              AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , tmp.SummOut_zavod               AS Summ
                            , tmp.SummOut_branch              AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpSend_out AS tmp
                      UNION ALL
                       -- 3.2. Send - In
                       SELECT zc_Movement_Send()              AS MovementDescId
                            , tmp.LocationCode_by             AS LocationCode
                            , tmp.LocationName_by             AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , tmp.LocationName                AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , tmp.AmountIn_Weight             AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN tmp.SummIn_branch ELSE tmp.SummIn_zavod END AS SummIn
                            , tmp.SummIn_branch               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , tmp.SummIn_zavod                AS Summ
                            , tmp.SummIn_branch               AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpSend_in AS tmp
                      UNION ALL
                       -- 3.3. SendAsset - Out
                       SELECT zc_Movement_SendAsset()         AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , 0                               AS PaidKindId

                            , tmp.AmountOut_Weight            AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN tmp.SummOut_branch ELSE tmp.SummOut_zavod END AS SummOut
                            , tmp.SummOut_branch              AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , tmp.SummOut_zavod               AS Summ
                            , tmp.SummOut_branch              AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpSendAsset_out AS tmp
                      UNION ALL
                       -- 3.4. SendAsset - In
                       SELECT zc_Movement_SendAsset()         AS MovementDescId
                            , tmp.LocationCode_by             AS LocationCode
                            , tmp.LocationName_by             AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , tmp.LocationName                AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , tmp.AmountIn_Weight             AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN tmp.SummIn_branch ELSE tmp.SummIn_zavod END AS SummIn
                            , tmp.SummIn_branch               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , tmp.SummIn_zavod                AS Summ
                            , tmp.SummIn_branch               AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpSendAsset_in AS tmp
                      UNION ALL
                      
                       -- 4.1. Sale
                       SELECT zc_Movement_Sale()              AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END AS ObjectByCode
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END AS ObjectByName
                            , tmp.PaidKindId :: Integer                AS PaidKindId

                            , SUM (tmp.OperCount_Partner)     AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummIn_Partner_branch) ELSE SUM (tmp.SummIn_Partner_zavod) END AS SummOut
                            , SUM (tmp.SummIn_Partner_branch) AS SummOut_branch
                            , SUM (tmp.SummOut_Partner)       AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.SummIn_Partner_zavod)  AS Summ
                            , SUM (tmp.SummIn_Partner_branch) AS Summ_branch

                            , SUM (tmp.OperCount_Change)      AS Amount_Change
                            , SUM (tmp.SummIn_Change_branch)  AS Summ_Change_branch
                            , SUM (tmp.SummIn_Change_zavod)   AS Summ_Change_zavod
                            , SUM (tmp.OperCount_40200)       AS Amount_40200
                            , SUM (tmp.SummIn_40200_branch)   AS Summ_40200_branch
                            , SUM (tmp.SummIn_40200_zavod)    AS Summ_40200_zavod
                            , SUM (tmp.OperCount_Loss)        AS Amount_Loss
                            , SUM (tmp.SummIn_Loss)           AS Summ_Loss_branch
                            , SUM (tmp.SummIn_Loss_zavod)     AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , TRUE                            AS isPage3
                       FROM tmpSale AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END
                              , tmp.PaidKindId
                      UNION ALL
                       -- 4.2. ReturnIn
                       SELECT zc_Movement_ReturnIn()          AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END AS ObjectByCode
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END AS ObjectByName
                            , tmp.PaidKindId  :: Integer               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , SUM (tmp.OperCount_Partner)     AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummIn_Partner_branch) ELSE SUM (tmp.SummIn_Partner_zavod) END AS SummIn
                            , SUM (tmp.SummIn_Partner_branch) AS SummIn_branch
                            , SUM (tmp.SummOut_Partner)       AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.SummIn_Partner_zavod)  AS Summ
                            , SUM (tmp.SummIn_Partner_branch) AS Summ_branch

                            , SUM (tmp.OperCount_Change)      AS Amount_Change
                            , SUM (tmp.SummIn_Change_branch)  AS Summ_Change_branch
                            , SUM (tmp.SummIn_Change_zavod)   AS Summ_Change_zavod
                            , SUM (tmp.OperCount_40200)       AS Amount_40200
                            , SUM (tmp.SummIn_40200_branch)   AS Summ_40200_branch
                            , SUM (tmp.SummIn_40200_zavod)    AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , TRUE                            AS isPage3
                       FROM tmpReturnIn AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END
                              , tmp.PaidKindId
                      UNION ALL
                       -- 5.1. Income
                       SELECT zc_Movement_Income()            AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END AS ObjectByCode
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END AS ObjectByName
                            , tmp.PaidKindId                  AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , SUM (tmp.AmountPartner_Weight)  AS AmountIn
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS SummIn
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS SummIn_branch
                            , SUM (tmp.Summ)                  AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS Summ
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , SUM (tmp.AmountDiff_Weight)     AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpIncome AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END
                              , tmp.PaidKindId
                      UNION ALL
                       -- 5.2. ReturnOut
                       SELECT zc_Movement_ReturnOut()         AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END AS ObjectByCode
                            , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END AS ObjectByName
                            , tmp.PaidKindId                  AS PaidKindId

                            , SUM (tmp.AmountPartner_Weight)  AS AmountOut
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS SummOut
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS SummOut_branch
                            , SUM (tmp.Summ)                  AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS Summ
                            , SUM (tmp.Summ - Summ_ProfitLoss) AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , SUM (tmp.AmountDiff_Weight)     AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , TRUE                            AS isPage3
                       FROM tmpReturnOut AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalCode /*tmp.PartnerCode*/ ELSE 0  END
                              , CASE WHEN inIsPartner = TRUE THEN tmp.JuridicalName /*tmp.PartnerName*/ ELSE '' END
                              , tmp.PaidKindId
                      UNION ALL
                       -- 5.1. ProductionUnion
                       SELECT zc_Movement_ProductionUnion()   AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , SUM (tmp.Amount_Weight)         AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.Summ_branch) ELSE SUM (tmp.Summ_zavod) END AS SummIn
                            , SUM (tmp.Summ_branch)           AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.Summ_zavod)            AS Summ
                            , SUM (tmp.Summ_branch)           AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpProductionUnion_in AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName, tmp.LocationCode_by, tmp.LocationName_by
                      UNION ALL
                       -- 5.2. ProductionUnion
                       SELECT zc_Movement_ProductionUnion()   AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , 0                               AS PaidKindId

                            , SUM (tmp.Amount_Weight)         AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.Summ_branch) ELSE SUM (tmp.Summ_zavod) END AS SummOut
                            , SUM (tmp.Summ_branch)           AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.Summ_zavod)            AS Summ
                            , SUM (tmp.Summ_branch)           AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpProductionUnion_out AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName, tmp.LocationCode_by, tmp.LocationName_by

                      UNION ALL
                       -- 6.1. ProductionSeparate
                       SELECT zc_Movement_ProductionSeparate() AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , SUM (tmp.Amount_Weight)         AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.Summ_branch) ELSE SUM (tmp.Summ_zavod) END AS SummIn
                            , SUM (tmp.Summ_branch)           AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.Summ_zavod)            AS Summ
                            , SUM (tmp.Summ_branch)           AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpProductionSeparate_in AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName, tmp.LocationCode_by, tmp.LocationName_by
                      UNION ALL
                       -- 6.2. ProductionSeparate
                       SELECT zc_Movement_ProductionSeparate() AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode_by             AS ObjectByCode
                            , tmp.LocationName_by             AS ObjectByName
                            , 0                               AS PaidKindId

                            , SUM (tmp.Amount_Weight)         AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.Summ_branch) ELSE SUM (tmp.Summ_zavod) END AS SummOut
                            , SUM (tmp.Summ_branch)          AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.Summ_zavod)            AS Summ
                            , SUM (tmp.Summ_branch)           AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpProductionSeparate_out AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName, tmp.LocationCode_by, tmp.LocationName_by
                      UNION ALL
                       -- 7.1. Inventory
                       SELECT zc_Movement_Inventory()         AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , '+' || tmp.LocationName         AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , SUM (tmp.AmountIn_Weight)       AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummIn_branch) ELSE SUM (tmp.SummIn_zavod) END AS SummIn
                            , SUM (tmp.SummIn_branch)         AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , SUM (tmp.SummIn_zavod)          AS Summ
                            , SUM (tmp.SummIn_branch)         AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpInventory AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                      UNION ALL
                       -- 7.2. Inventory
                       SELECT zc_Movement_Inventory()         AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , '-' || tmp.LocationName         AS ObjectByName
                            , 0                               AS PaidKindId

                            , SUM (tmp.AmountOut_Weight)      AS AmountOut
                            , 1 * CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummOut_branch) ELSE SUM (tmp.SummOut_zavod) END AS SummOut
                            , SUM (tmp.SummOut_branch)        AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , -1 * SUM (tmp.SummOut_zavod)    AS Summ
                            , -1 * SUM (tmp.SummOut_branch)   AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod
                            , FALSE                           AS isActive
                            , FALSE                           AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpInventory AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                      UNION ALL
                       -- 7.3. Inventory - RePrice
                       SELECT zc_Movement_Inventory()         AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , '+' || tmp.LocationName         AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , 0                               AS SummOut
                            , 0                               AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , CASE WHEN vbIsBranch = TRUE THEN SUM (tmp.SummIn_RePrice) ELSE 0 END AS SummIn
                            , SUM (tmp.SummIn_RePrice)        AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , 0                               AS Summ
                            , SUM (tmp.SummIn_RePrice)        AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod

                            , TRUE                            AS isActive
                            , TRUE                            AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpInventory AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                      UNION ALL
                       -- 7.4. Inventory - RePrice
                       SELECT zc_Movement_Inventory()         AS MovementDescId
                            , tmp.LocationCode                AS LocationCode
                            , tmp.LocationName                AS LocationName
                            , tmp.LocationCode                AS ObjectByCode
                            , '-' || tmp.LocationName         AS ObjectByName
                            , 0                               AS PaidKindId

                            , 0                               AS AmountOut
                            , CASE WHEN vbIsBranch = TRUE THEN 1 * SUM (tmp.SummOut_RePrice) ELSE 0 END AS SummOut
                            , SUM (tmp.SummOut_RePrice)       AS SummOut_branch
                            , 0                               AS SummPartnerOut
                            , 0                               AS AmountIn
                            , 0                               AS SummIn
                            , 0                               AS SummIn_branch
                            , 0                               AS SummPartnerIn

                            , 0                               AS AmountStart
                            , 0                               AS AmountEnd
                            , 0                               AS SummStart
                            , 0                               AS SummEnd
                            , 0                               AS SummStart_branch
                            , 0                               AS SummEnd_branch
                            , 0                               AS Summ
                            , -1 * SUM (tmp.SummOut_RePrice)  AS Summ_branch

                            , 0                               AS Amount_Change
                            , 0                               AS Summ_Change_branch
                            , 0                               AS Summ_Change_zavod
                            , 0                               AS Amount_40200
                            , 0                               AS Summ_40200_branch
                            , 0                               AS Summ_40200_zavod
                            , 0                               AS Amount_Loss
                            , 0                               AS Summ_Loss_branch
                            , 0                               AS Summ_Loss_zavod
                            , FALSE                           AS isActive
                            , TRUE                            AS isReprice
                            , FALSE                           AS isPage3
                       FROM tmpInventory AS tmp
                       GROUP BY tmp.LocationCode, tmp.LocationName
                      )
        , tmpPage3 AS (SELECT TRUE AS isExists WHERE EXISTS (SELECT 1 FROM tmpSendOnPrice_in
                                                       UNION SELECT 1 FROM tmpSendOnPrice_out
                                                       UNION SELECT 1 FROM tmpSale
                                                       UNION SELECT 1 FROM tmpReturnIn
                                                       UNION SELECT 1 FROM tmpReturnOut
                                                             LIMIT 1
                                                            )
                      )
   SELECT 0      :: Integer   AS MovementId
        , ''     :: TVarChar  AS InvNumber
        , NULL   :: TDateTime AS OperDate
        , NULL   :: TDateTime AS OperDatePartner
        , FALSE  :: Boolean   AS isPeresort
        , CASE WHEN tmpResult.MovementDescId = zc_Movement_Inventory() AND tmpResult.isReprice = TRUE
                    THEN MovementDesc.ItemName || ' переоценка'
               WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = TRUE
                    THEN MovementDesc.ItemName || ' ПРИХОД'
               WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = FALSE
                    THEN MovementDesc.ItemName || ' РАСХОД'
               ELSE MovementDesc.ItemName
          END :: TVarChar AS MovementDescName
        , CASE WHEN tmpResult.MovementDescId = zc_Movement_Income()
                    THEN '01 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_ReturnOut()
                    THEN '02 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND tmpResult.isActive = TRUE
                    THEN '03 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND tmpResult.isActive = FALSE
                    THEN '04 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_ProductionUnion() AND tmpResult.isActive = TRUE
                    THEN '05 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_ProductionUnion() AND tmpResult.isActive = FALSE
                    THEN '06 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_ProductionSeparate() AND tmpResult.isActive = TRUE
                    THEN '07 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_ProductionSeparate() AND tmpResult.isActive = FALSE
                    THEN '08 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_SendOnPrice() AND tmpResult.isActive = TRUE
                    THEN '109 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_SendOnPrice() AND tmpResult.isActive = FALSE
                    THEN '110 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_Sale()
                    THEN '111 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_ReturnIn()
                    THEN '112 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_Loss()
                    THEN '13 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_Inventory() AND tmpResult.isActive = TRUE  AND tmpResult.isRePrice = FALSE
                    THEN '14 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_Inventory() AND tmpResult.isActive = FALSE AND tmpResult.isRePrice = FALSE
                    THEN '15 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_Inventory() AND tmpResult.isActive = TRUE  AND tmpResult.isRePrice = TRUE
                    THEN '16 ' || MovementDesc.ItemName
               WHEN tmpResult.MovementDescId = zc_Movement_Inventory() AND tmpResult.isActive = FALSE AND tmpResult.isRePrice = TRUE
                    THEN '17 ' || MovementDesc.ItemName

               ELSE '201 ' || MovementDesc.ItemName
          END :: TVarChar AS MovementDescName_order

        , tmpResult.isActive AS isActive
        , CASE WHEN tmpResult.MovementDescId = 0 THEN TRUE ELSE FALSE END :: Boolean AS isRemains
        , tmpResult.isRePrice
        , CASE WHEN tmpResult.MovementDescId = zc_Movement_Inventory() THEN TRUE ELSE FALSE END :: Boolean AS isInv

        , ''   :: TVarChar  AS LocationDescName
        , tmpResult.LocationCode
        , tmpResult.LocationName
        , 0    :: Integer   AS CarCode
        , ''   :: TVarChar  AS CarName
        , ''   :: TVarChar  AS ObjectByDescName
        , tmpResult.ObjectByCode :: Integer  AS ObjectByCode
        , tmpResult.ObjectByName :: TVarChar AS ObjectByName

        , Object_PaidKind.ValueData AS PaidKindName

        , 0    :: Integer   AS GoodsCode
        , ''   :: TVarChar  AS GoodsName
        , ''   :: TVarChar  AS GoodsKindName
        , ''   :: TVarChar  AS GoodsKindName_complete
        , ''   :: TVarChar  AS PartionGoods
        , 0    :: Integer   AS GoodsCode_parent
        , ''   :: TVarChar  AS GoodsName_parent
        , ''   :: TVarChar  AS GoodsKindName_parent

        , CAST (CASE WHEN tmpResult.MovementDescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN /*tmpResult.MovementId = -1 AND */tmpResult.AmountStart <> 0
                          THEN tmpResult.SummStart / tmpResult.AmountStart
                     /*WHEN tmpResult.MovementId = -2 AND tmpResult.AmountEnd <> 0
                          THEN tmpResult.SummEnd / tmpResult.AmountEnd*/
                     WHEN tmpResult.AmountIn <> 0
                          THEN tmpResult.SummIn / tmpResult.AmountIn
                     WHEN tmpResult.AmountOut <> 0
                          THEN tmpResult.SummOut / tmpResult.AmountOut
                     ELSE 0
                END AS TFloat) AS Price

        , CAST (CASE WHEN tmpResult.MovementDescId = zc_Movement_Income() AND 1=0
                          THEN 0 -- MIFloat_Price.ValueData
                     WHEN /*tmpResult.MovementId = -1 AND */tmpResult.AmountStart <> 0
                          THEN tmpResult.SummStart_branch / tmpResult.AmountStart
                     /*WHEN tmpResult.MovementId = -2 AND tmpResult.AmountEnd <> 0
                          THEN tmpResult.SummEnd / tmpResult.AmountEnd*/
                     WHEN tmpResult.AmountIn <> 0
                          THEN tmpResult.SummIn_branch / tmpResult.AmountIn
                     WHEN tmpResult.AmountOut <> 0
                          THEN tmpResult.SummOut_branch / tmpResult.AmountOut
                     ELSE 0
                END AS TFloat) AS Price_branch

        , CAST (CASE WHEN tmpResult.AmountEnd <> 0
                          THEN tmpResult.SummEnd / tmpResult.AmountEnd
                     ELSE 0
                END AS TFloat) AS Price_end
        , CAST (CASE WHEN tmpResult.AmountEnd <> 0
                          THEN tmpResult.SummEnd_branch / tmpResult.AmountEnd
                     ELSE 0
                END AS TFloat) AS Price_branch_end

        , CAST (CASE WHEN tmpResult.AmountIn <> 0
                          THEN tmpResult.SummPartnerIn / tmpResult.AmountIn
                     WHEN tmpResult.AmountOut <> 0
                          THEN tmpResult.SummPartnerOut / tmpResult.AmountOut
                     ELSE 0
                END AS TFloat) AS Price_partner

        , CAST (tmpResult.SummPartnerIn AS TFloat)      AS SummPartnerIn
        , CAST (tmpResult.SummPartnerOut AS TFloat)     AS SummPartnerOut

        , CAST (tmpResult.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpResult.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpResult.AmountOut AS TFloat)   AS AmountOut
        , CAST (tmpResult.AmountEnd AS TFloat)   AS AmountEnd
        , CAST ((tmpResult.AmountIn - tmpResult.AmountOut)
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Amount

        , CAST (tmpResult.SummStart AS TFloat)   AS SummStart
        , CAST (tmpResult.SummStart_branch AS TFloat)   AS SummStart_branch
        , CAST (tmpResult.SummIn AS TFloat)      AS SummIn
        , CAST (tmpResult.SummIn_branch AS TFloat)      AS SummIn_branch
        , CAST (tmpResult.SummOut AS TFloat)     AS SummOut
        , CAST (tmpResult.SummOut_branch AS TFloat)     AS SummOut_branch
        , CAST (tmpResult.SummEnd AS TFloat)     AS SummEnd
        , CAST (tmpResult.SummEnd_branch AS TFloat)     AS SummEnd_branch
        /*, CAST ((tmpResult.SummIn - tmpResult.SummOut)
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_Loss()) THEN -1 ELSE 1 END
              * CASE WHEN tmpResult.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) AND tmpResult.isActive = FALSE THEN -1 ELSE 1 END
                AS TFloat) AS Summ*/
        , CASE WHEN vbIsBranch = TRUE THEN tmpResult.Summ_branch ELSE tmpResult.Summ END :: TFloat AS Summ
        , tmpResult.Summ_branch :: TFloat AS Summ_branch

        , tmpResult.Amount_Change       :: TFloat  AS Amount_Change
        , tmpResult.Summ_Change_branch  :: TFloat  AS Summ_Change_branch
        , tmpResult.Summ_Change_zavod   :: TFloat  AS Summ_Change_zavod
        , tmpResult.Amount_40200        :: TFloat  AS Amount_40200
        , tmpResult.Summ_40200_branch   :: TFloat  AS Summ_40200_branch
        , tmpResult.Summ_40200_zavod    :: TFloat  AS Summ_40200_zavod
        , tmpResult.Amount_Loss         :: TFloat  AS Amount_Loss
        , tmpResult.Summ_Loss_branch    :: TFloat  AS Summ_Loss_branch
        , tmpResult.Summ_Loss_zavod     :: TFloat  AS Summ_Loss_zavod

        , tmpResult.isPage3                   :: Boolean AS isPage3
        , COALESCE (tmpPage3.isExists, FALSE) :: Boolean AS isExistsPage3
   FROM tmpResult
        LEFT JOIN tmpPage3 ON tmpPage3.isExists = TRUE
        LEFT JOIN MovementDesc ON MovementDesc.Id = tmpResult.MovementDescId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpResult.PaidKindId
   ;

END;                   
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsGroup (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         * zc_Movement_SendAsset()
 12.08.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsGroup (inStartDate:= '01.11.2017', inEndDate:= '01.11.2017', inUnitGroupId:= 0, inLocationId:= 8459, inGoodsGroupId:= 1832, inIsPartner:= FALSE, inSession:= zfCalc_UserAdmin());
