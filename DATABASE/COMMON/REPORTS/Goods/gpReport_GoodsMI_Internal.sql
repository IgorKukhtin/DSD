-- Function: gpReport_GoodsMI_Internal ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Internal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Internal (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   ,
    IN inFromId       Integer   ,
    IN inToId         Integer   ,
    IN inGoodsGroupId Integer   ,
    IN inIsMO_all     Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , TradeMarkName TVarChar
             , PartionGoods TVarChar
             , LocationId Integer, LocationCode Integer, LocationName TVarChar
             , LocationId_by Integer, LocationCode_by Integer, LocationName_by TVarChar
             , ArticleLossCode Integer, ArticleLossName TVarChar
             , AmountOut TFloat, AmountOut_Weight TFloat, AmountOut_Sh TFloat, SummOut_zavod TFloat, SummOut_branch TFloat, SummOut_60000 TFloat 
             , AmountIn TFloat, AmountIn_Weight TFloat, AmountIn_Sh TFloat,  SummIn_zavod TFloat, SummIn_branch TFloat, SummIn_60000 TFloat
             , AmountIn_10500 TFloat
             , AmountIn_10500_Weight TFloat
             , AmountIn_40200 TFloat
             , AmountIn_40200_Weight TFloat
             , SummIn_10500 TFloat
             , SummIn_40200 TFloat
             , Summ_calc TFloat
             , PriceOut_zavod TFloat, PriceOut_branch TFloat, PriceIn_zavod TFloat, PriceIn_branch TFloat
             , ProfitLossCode Integer, ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName TVarChar
             , ProfitLossName_All TVarChar
             )   
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
      vbUserId:= lpGetUserBySession (inSession);

      vbIsGroup:= (inSession = '');

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица - 
         CREATE TEMP TABLE _tmpGoods (GoodsId Integer, InfoMoneyId Integer, TradeMarkId Integer, MeasureId Integer, Weight TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer, UnitId_by Integer, isActive Boolean) ON COMMIT DROP;
     END IF;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunit_localfrom')
     THEN
         DELETE FROM _tmpUnit_localFrom;
         DELETE FROM _tmpUnit_localTo;
     ELSE
         -- таблица - 
         CREATE TEMP TABLE _tmpUnit_localFrom (UnitId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit_localTo (UnitId Integer) ON COMMIT DROP;
     END IF;

    -- Ограничения по товару
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId, MeasureId, Weight)
           SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          ;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId, MeasureId, Weight)
           SELECT Object.Id, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM Object
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = Object.Id
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE Object.DescId = zc_Object_Goods()
          UNION
           SELECT Object.Id, 0 AS MeasureId, 0 AS Weight FROM Object WHERE Object.DescId = zc_Object_Fuel()
          ;
    END IF;


    -- группа подразделений или подразделение или место учета (МО, Авто)
    WITH tmpFrom AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect WHERE inFromId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inFromId = 0 -- AND vbIsGroup = TRUE
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Member() AND (inIsMO_all = TRUE OR Id = inFromId) AND inDescId IN (zc_Movement_Loss(), zc_Movement_Send())
                    UNION
                     SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Car() AND (inIsMO_all = TRUE OR Id = inFromId) AND inDescId IN (zc_Movement_Loss(), zc_Movement_Send())
                    UNION
                     SELECT tmp.UnitId FROM (SELECT 8459 AS UnitId -- Склад Реализации
                                            UNION 
                                             SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect_Object_Unit_byGroup -- Возвраты общие
                                            ) AS tmp
                     WHERE inFromId = -123
                    )
         , tmpTo AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect WHERE inToId > 0
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Unit() AND inToId = 0 AND inDescId <> zc_Movement_Loss() -- AND (vbIsGroup = TRUE OR inDescId = zc_Movement_Loss())
                    UNION
                     SELECT Id AS UnitId FROM Object WHERE DescId = zc_Object_Member() AND (inIsMO_all = TRUE OR Id = inToId) AND inDescId IN (/*zc_Movement_Loss(),*/ zc_Movement_Send())
                    UNION
                     SELECT Id AS UnitId FROM Object  WHERE DescId = zc_Object_Car() AND (inIsMO_all = TRUE OR Id = inToId) AND inDescId IN (/*zc_Movement_Loss(),*/ zc_Movement_Send())
                    UNION
                     SELECT tmp.UnitId FROM (SELECT 8459 AS UnitId -- Склад Реализации
                                            UNION 
                                             SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect_Object_Unit_byGroup -- Возвраты общие
                                            ) AS tmp
                     WHERE inToId = -123
                   )
    INSERT INTO _tmpUnit (UnitId, UnitId_by, isActive)
       SELECT tmpFrom.UnitId, COALESCE (tmpTo.UnitId, 0), FALSE FROM tmpFrom LEFT JOIN tmpTo ON tmpTo.UnitId > 0
      UNION
       SELECT tmpTo.UnitId, COALESCE (tmpFrom.UnitId, 0), TRUE FROM tmpTo LEFT JOIN tmpFrom ON tmpFrom.UnitId > 0
      ;


   INSERT INTO _tmpUnit_localFrom (UnitId)
      SELECT DISTINCT UnitId FROM _tmpUnit;
   INSERT INTO _tmpUnit_localTo (UnitId)
      SELECT DISTINCT UnitId_by FROM _tmpUnit;


    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;
    ANALYZE _tmpUnit_localFrom;
    ANALYZE _tmpUnit_localTo;


    -- Результат
    RETURN QUERY
    SELECT Object_GoodsGroup.ValueData                AS GoodsGroupName 
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.Id                        AS GoodsKindId
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName
         , Object_TradeMark.ValueData                 AS TradeMarkName
         , Object_PartionGoods.ValueData              AS PartionGoods

         , Object_Location.Id         AS LocationId
         , Object_Location.ObjectCode AS LocationCode
         , Object_Location.ValueData  AS LocationName
         , Object_Location_by.Id         AS LocationId_by
         , Object_Location_by.ObjectCode AS LocationCode_by
         , Object_Location_by.ValueData  AS LocationName_by
         , Object_ArticleLoss.ObjectCode AS ArticleLossCode
         , Object_ArticleLoss.ValueData  AS ArticleLossName

         , tmpOperationGroup.AmountOut        :: TFloat AS AmountOut
         , tmpOperationGroup.AmountOut_Weight :: TFloat AS AmountOut_Weight
         , tmpOperationGroup.AmountOut_Sh     :: TFloat AS AmountOut_Sh
         , tmpOperationGroup.SummOut_zavod    :: TFloat AS SummOut_zavod
         , tmpOperationGroup.SummOut_branch   :: TFloat AS SummOut_branch
         , tmpOperationGroup.SummOut_60000    :: TFloat AS SummOut_60000
         
         , tmpOperationGroup.AmountIn        :: TFloat AS AmountIn
         , tmpOperationGroup.AmountIn_Weight :: TFloat AS AmountIn_Weight
         , tmpOperationGroup.AmountIn_Sh     :: TFloat AS AmountIn_Sh
         , tmpOperationGroup.SummIn_zavod    :: TFloat AS SummIn_zavod
         , tmpOperationGroup.SummIn_branch   :: TFloat AS SummIn_branch
         , tmpOperationGroup.SummIn_60000    :: TFloat AS SummIn_60000

         , tmpOperationGroup.AmountIn_10500  :: TFloat AS AmountIn_10500
         , tmpOperationGroup.AmountIn_10500_Weight  :: TFloat AS AmountIn_10500_Weight
         , tmpOperationGroup.AmountIn_40200  :: TFloat AS AmountIn_40200
         , tmpOperationGroup.AmountIn_40200_Weight  :: TFloat AS AmountIn_40200_Weight
         , tmpOperationGroup.SummIn_10500    :: TFloat AS SummIn_10500
         , tmpOperationGroup.SummIn_40200    :: TFloat AS SummIn_40200

         , tmpOperationGroup.Summ_calc     :: TFloat AS Summ_calc

         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_zavod  / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_zavod
         , CASE WHEN tmpOperationGroup.AmountOut <> 0 THEN tmpOperationGroup.SummOut_branch / tmpOperationGroup.AmountOut ELSE 0 END :: TFloat AS PriceOut_branch
         , CASE WHEN tmpOperationGroup.AmountIn  <> 0 THEN tmpOperationGroup.SummIn_zavod   / tmpOperationGroup.AmountIn  ELSE 0 END :: TFloat AS PriceIn_zavod
         , CASE WHEN tmpOperationGroup.AmountIn  <> 0 THEN tmpOperationGroup.SummIn_branch  / tmpOperationGroup.AmountIn  ELSE 0 END :: TFloat AS PriceIn_branch

         , View_ProfitLoss.ProfitLossCode, View_ProfitLoss.ProfitLossGroupName, View_ProfitLoss.ProfitLossDirectionName, View_ProfitLoss.ProfitLossName
         , View_ProfitLoss.ProfitLossName_all

     FROM (SELECT tmpContainer.ArticleLossId
                , tmpContainer.ContainerId_Analyzer
                , tmpContainer.UnitId
                , tmpContainer.UnitId_by
                , tmpContainer.GoodsId
                , tmpContainer.GoodsKindId
                , CLO_PartionGoods.ObjectId AS PartionGoodsId

                , SUM (tmpContainer.AmountOut)         AS AmountOut 
                , SUM (tmpContainer.AmountOut_Weight)  AS AmountOut_Weight
                , SUM (tmpContainer.AmountOut_sh)      AS AmountOut_sh
                , SUM (tmpContainer.SummOut)           AS SummOut_zavod
                , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END) AS SummOut_branch
                , SUM (CASE WHEN Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_60200() THEN tmpContainer.SummOut ELSE 0 END)                AS SummOut_60000

                , SUM (tmpContainer.AmountIn)          AS AmountIn 
                , SUM (tmpContainer.AmountIn_Weight)   AS AmountIn_Weight
                , SUM (tmpContainer.AmountIn_sh)       AS AmountIn_sh
                , SUM (tmpContainer.SummIn)            AS SummIn_zavod

                , SUM (tmpContainer.Summ_calc_real) AS SummIn_branch
                , SUM (tmpContainer.Summ_calc_real - tmpContainer.SummIn) AS SummIn_60000
                -- , SUM (CASE WHEN COALESCE (Object_Account_View.AccountDirectionId, 0) <> zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn ELSE 0 END) AS SummIn_branch
                -- , SUM (CASE WHEN Object_Account_View.AccountDirectionId = zc_Enum_AccountDirection_60200() THEN tmpContainer.SummIn ELSE 0 END)                AS SummIn_60000
                
                , SUM (tmpContainer.AmountIn_10500) AS AmountIn_10500
                , SUM (tmpContainer.AmountIn_10500_Weight) AS AmountIn_10500_Weight
                , SUM (tmpContainer.AmountIn_40200) AS AmountIn_40200
                , SUM (tmpContainer.AmountIn_40200_Weight) AS AmountIn_40200_Weight
                , SUM (tmpContainer.SummIn_10500)   AS SummIn_10500
                , SUM (tmpContainer.SummIn_40200)   AS SummIn_40200

                , SUM (tmpContainer.Summ_calc) AS Summ_calc

           FROM (SELECT tmpMI.ContainerId
                      , tmpMI.UnitId
                      , tmpMI.UnitId_by
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpMI.GoodsId END AS GoodsId
                      , tmpMI.GoodsKindId
                      , tmpMI.AccountId
                      , tmpMI.ArticleLossId
                      , tmpMI.ContainerId_Analyzer

                      , 0 AS AmountOut
                      , 0 AS AmountOut_Weight
                      , 0 AS AmountOut_sh
                      /*, tmpMI.AmountOut
                      , tmpMI.AmountOut * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountOut_Weight
                      , CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpMI.AmountOut ELSE 0 END AS AmountOut_sh*/

                      , tmpMI.SummOut

                      , 0 AS AmountIn
                      , 0 AS AmountIn_Weight
                      , 0 AS AmountIn_sh
                      /*, tmpMI.AmountIn
                      , tmpMI.AmountIn * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountIn_Weight
                      , CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpMI.AmountIn ELSE 0 END AS AmountIn_sh*/
                      , tmpMI.SummIn

                      , tmpMI.AmountIn_10500
                      , tmpMI.AmountIn_10500 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountIn_10500_Weight
                      , tmpMI.AmountIn_40200
                      , tmpMI.AmountIn_40200 * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountIn_40200_Weight
                      , tmpMI.SummIn_10500
                      , tmpMI.SummIn_40200

                      , 0 AS Summ_calc
                      , 0 AS Summ_calc_real
                 FROM (SELECT CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END AS ContainerId
                            , CASE WHEN MIContainer.AccountId = zc_Enum_Account_110101() THEN MIContainer.WhereObjectId_analyzer WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId
                            , CASE WHEN MIContainer.AccountId = zc_Enum_Account_110101() THEN MIContainer.ObjectExtId_Analyzer   WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId_by
                            , MIContainer.ObjectId_analyzer AS GoodsId
                            , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                            , COALESCE (MIContainer.AccountId, 0)  AS AccountId
                            , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.AnalyzerId, 0) ELSE 0 END AS ArticleLossId
                            , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.ContainerId_Analyzer, 0) ELSE 0 END AS ContainerId_Analyzer

                            , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut
                            , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Summ()  THEN -1 * MIContainer.Amount ELSE 0 END) AS SummOut

                            , SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Count() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SendCount_10500(), zc_Enum_AnalyzerId_SendCount_40200()) THEN MIContainer.Amount ELSE 0 END) AS AmountIn
                            , SUM (CASE WHEN MIContainer.isActive = TRUE AND MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SendCount_10500(), zc_Enum_AnalyzerId_SendCount_40200()) THEN MIContainer.Amount ELSE 0 END) AS SummIn

                            , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Count() AND COALESCE (MIContainer.AnalyzerId, 0) IN (zc_Enum_AnalyzerId_SendCount_10500()) THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountIn_10500
                            , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Count() AND COALESCE (MIContainer.AnalyzerId, 0) IN (zc_Enum_AnalyzerId_SendCount_40200()) THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountIn_40200
                            , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) IN (zc_Enum_AnalyzerId_SendSumm_10500()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SummIn_10500
                            , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) IN (zc_Enum_AnalyzerId_SendSumm_40200()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SummIn_40200
                       FROM MovementItemContainer AS MIContainer
                            INNER JOIN _tmpUnit ON _tmpUnit.UnitId    = MIContainer.WhereObjectId_analyzer
                                               AND (_tmpUnit.UnitId_by = COALESCE (MIContainer.ObjectExtId_Analyzer, 0) OR _tmpUnit.UnitId_by = 0)
                                               -- AND _tmpUnit.isActive  = MIContainer.isActive
                            INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
                                               AND Movement.OperDate = MIContainer.OperDate
                       WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                         AND MIContainer.MovementDescId = inDescId
                         AND COALESCE (MIContainer.AccountId, 0) NOT IN (/*zc_Enum_Account_110101(), */zc_Enum_Account_100301 ()) -- товар в пути + Прибыль текущего периода
                       GROUP BY CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ContainerId END
                              , CASE WHEN MIContainer.AccountId = zc_Enum_Account_110101() THEN MIContainer.WhereObjectId_analyzer WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                              , CASE WHEN MIContainer.AccountId = zc_Enum_Account_110101() THEN MIContainer.ObjectExtId_Analyzer   WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                              , MIContainer.ObjectId_analyzer
                              , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END
                              , COALESCE (MIContainer.AccountId, 0)
                              , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.AnalyzerId, 0) ELSE 0 END
                              , CASE WHEN inDescId = zc_Movement_Loss() THEN COALESCE (MIContainer.ContainerId_Analyzer, 0) ELSE 0 END
                      ) AS tmpMI
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI.GoodsId
                UNION ALL
                 SELECT NULL AS ContainerId
                      , tmpMI.UnitId
                      , tmpMI.UnitId_by
                      , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE tmpMI.GoodsId END AS GoodsId
                      , tmpMI.GoodsKindId
                      , 0 AS AccountId
                      , 0 AS ArticleLossId
                      , 0 AS ContainerId_Analyzer

                      , tmpMI.AmountOut_real AS AmountOut
                      , tmpMI.AmountOut_real * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountOut_Weight
                      , CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpMI.AmountOut_real ELSE 1 END AS AmountOut_sh
                      /*, 0 AS AmountOut
                      , 0 AS AmountOut_Weight
                      , 0 AS AmountOut_sh*/
                      , 0 AS SummOut

                      , tmpMI.AmountIn_real AS AmountIn
                      , tmpMI.AmountIn_real * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END AS AmountIn_Weight
                      , CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN tmpMI.AmountIn_real ELSE 1 END AS AmountIn_sh
                      /*, 0 AS AmountIn
                      , 0 AS AmountIn_Weight
                      , 0 AS AmountIn_sh*/
                      , 0 AS SummIn

                      , 0 AS AmountIn_10500
                      , 0 AS AmountIn_10500_Weight
                      , 0 AS AmountIn_40200
                      , 0 AS AmountIn_40200_Weight
                      , 0 AS SummIn_10500
                      , 0 AS SummIn_40200

                      , tmpMI.Summ_calc
                      , tmpMI.Summ_calc_real

                 FROM (SELECT MovementLinkObject_From.ObjectId AS UnitId
                              , MovementLinkObject_To.ObjectId AS UnitId_by
                              , MovementItem.ObjectId AS GoodsId
                              , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                              , SUM (COALESCE (MIFloat_SummPriceList.ValueData, 0)) AS Summ_calc
                              , SUM (COALESCE (MIFloat_Summ.ValueData, 0)) AS Summ_calc_real
                              , SUM (MovementItem.Amount) AS AmountOut_real
                              , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountIn_real
                               
--                          FROM Movement
                          FROM MovementDate AS MovementDate_OperDatePartner
                               INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement.DescId = zc_Movement_SendOnPrice()

                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                            AND MovementLinkObject_From.ObjectId = 8459
                      -- INNER JOIN _tmpUnit_localFrom AS _tmpFrom ON _tmpFrom.UnitId = MovementLinkObject_From.ObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                               LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                           ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummPriceList
                                                           ON MIFloat_SummPriceList.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummPriceList.DescId = zc_MIFloat_SummPriceList()

                          WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
/*                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_SendOnPrice()*/
                       GROUP BY MovementLinkObject_From.ObjectId 
                              , MovementLinkObject_To.ObjectId 
                              , MovementItem.ObjectId 
                              , MILinkObject_GoodsKind.ObjectId
                      /*SELECT CASE WHEN MIContainer.AccountId = 12102 THEN MIContainer.WhereObjectId_analyzer WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId
                            , CASE WHEN MIContainer.AccountId = 12102 THEN MIContainer.ObjectExtId_Analyzer   WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END AS UnitId_by
                            , MIContainer.ObjectId_analyzer AS GoodsId
                            , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END AS GoodsKindId
                            , 1.2 * SUM (MIContainer.Amount * COALESCE (MIFloat_Price.ValueData, 0)) AS Summ_calc
                       FROM (SELECT inStartDate AS StartDate, inEndDate AS EndDate, inDescId AS DescId
                                  , _tmpUnit.UnitId, _tmpUnit.UnitId_by
                             FROM _tmpUnit
                             WHERE inDescId = zc_Movement_SendOnPrice()
                              AND _tmpUnit.isActive = TRUE
                            ) AS tmp
                            INNER JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.OperDate BETWEEN tmp.StartDate AND tmp.EndDate  
                                                            AND MIContainer.DescId = zc_MIContainer_Count()
                                                            AND MIContainer.MovementDescId = inDescId
                                                            AND MIContainer.isActive  = TRUE
                                                            AND MIContainer.WhereObjectId_analyzer = CASE WHEN MIContainer.AccountId = 12102 THEN tmp.UnitId_by ELSE tmp.UnitId    END
                                                            AND MIContainer.ObjectExtId_Analyzer   = CASE WHEN MIContainer.AccountId = 12102 THEN tmp.UnitId    ELSE tmp.UnitId_by END
                                                            -- AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SendCount_in()
                                                            -- AND COALESCE (MIContainer.AccountId, 0) <> 12102 -- zc_Enum_AccountGroup_110000()
                            INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
                                               AND Movement.OperDate = MIContainer.OperDate
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       GROUP BY CASE WHEN MIContainer.AccountId = 12102 THEN MIContainer.WhereObjectId_analyzer WHEN MIContainer.isActive = FALSE THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                              , CASE WHEN MIContainer.AccountId = 12102 THEN MIContainer.ObjectExtId_Analyzer   WHEN MIContainer.isActive = TRUE  THEN MIContainer.WhereObjectId_analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                              , MIContainer.ObjectId_analyzer
                              , CASE WHEN vbIsGroup = TRUE THEN 0 ELSE MIContainer.ObjectIntId_Analyzer END*/
                      ) AS tmpMI
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMI.GoodsId
                      INNER JOIN _tmpUnit_localTo AS _tmpTo ON _tmpTo.UnitId = tmpMI.UnitId_by

                 ) AS tmpContainer
                 LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = tmpContainer.AccountId
                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                               ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                              AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

           GROUP BY tmpContainer.ArticleLossId
                  , tmpContainer.ContainerId_Analyzer
                  , tmpContainer.UnitId
                  , tmpContainer.UnitId_by
                  , tmpContainer.GoodsId
                  , tmpContainer.GoodsKindId
                  , CLO_PartionGoods.ObjectId
          ) AS tmpOperationGroup

          LEFT JOIN ContainerLinkObject AS ContainerLO_ProfitLoss
                                        ON ContainerLO_ProfitLoss.ContainerId = tmpOperationGroup.ContainerId_analyzer
                                       AND ContainerLO_ProfitLoss.DescId = zc_ContainerLinkObject_ProfitLoss()
          LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = ContainerLO_ProfitLoss.ObjectId

          LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = tmpOperationGroup.ArticleLossId
          LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.UnitId
          LEFT JOIN Object AS Object_Location_by ON Object_Location_by.Id = tmpOperationGroup.UnitId_by
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                               ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
          LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.15                                        * all
 19.07.15         * 
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Internal (inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inDescId:= zc_Movement_SendOnPrice(), inFromId:= 8459, inToId:= 0, inGoodsGroupId:= 1832, inIsMO_all:= FALSE, inSession := zfCalc_UserAdmin()); -- Склад Реализации
