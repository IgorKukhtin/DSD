-- Function: gpReport_IncomeKill_Olap ()

DROP FUNCTION IF EXISTS gpReport_IncomeKill_Olap (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeKill_Olap (
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inGoodsId            Integer   ,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Num           Integer
             , OperDate      TDateTime
             , Col_Name      TVarChar
             , JuridicalName TVarChar
             , Value         TFloat
             , ValueAmount   TFloat
             , Color_calc    Integer
             , SummType      Integer
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- очень важная проверка
    IF COALESCE (inGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбран товар  <%>', (SELECT ValueData FROM Object WHERE ID = 5225);
    END IF;

  
    -- Результат
    RETURN QUERY
      WITH
           -- данные первого периода
           tmpMIContainer AS (SELECT MIContainer.ContainerId                 AS ContainerId
                                   , MIContainer.OperDate                    AS OperDate
                                   , MIContainer.MovementId                  AS MovementId
                                   , MIContainer.ObjectId_Analyzer           AS GoodsId
                                   , MIContainer.ObjectExtId_Analyzer        AS PartnerId
                                   , MIContainer.WhereObjectId_analyzer      AS LocationId
                                   , MIContainer.ContainerIntId_analyzer     AS ContainerIntId_analyzer

                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                    THEN MIContainer.Amount
                                               ELSE 0
                                          END) AS Amount
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                                                    THEN MIContainer.Amount
                                               ELSE 0
                                          END) AS AmountPartner
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
                                                    THEN MIContainer.Amount
                                               ELSE 0
                                          END) AS Summ
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()
                                                AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                                AND MIContainer.isActive = TRUE
                                                    THEN MIContainer.Amount
                                               ELSE 0
                                          END) AS Summ_ProfitLoss_partner
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()
                                                AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                                AND MIContainer.MovementDescId = zc_Movement_ReturnOut()
                                                AND MIContainer.isActive = TRUE
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS Summ_ProfitLoss

                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END) AS HeadCount

                                   , COALESCE (MIFloat_Price.ValueData, 0)           AS MIPrice

                              FROM MovementItemContainer AS MIContainer
                                   LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                               ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                              AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                              AND MIContainer.DescId = zc_MIContainer_Count()
                                                              AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MIContainer.MovementItemId
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                             AND MIContainer.DescId = zc_MIContainer_Count()
                              WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                AND MIContainer.MovementDescId = zc_Movement_Income()
                                AND MIContainer.ObjectId_Analyzer = inGoodsId
                                AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                              GROUP BY MIContainer.ContainerId
                                     , MIContainer.MovementId
                                     , MIContainer.ObjectId_analyzer
                                     , MIContainer.ObjectExtId_Analyzer
                                     , MIContainer.OperDate
                                     , MIContainer.WhereObjectId_analyzer
                                     , MIContainer.ContainerIntId_analyzer
                                     , COALESCE (MIFloat_Price.ValueData, 0)
                                    )

         , tmpContainer1 AS (SELECT tmp.OperDate
                                  , tmp.MovementId
                                  , tmp.GoodsId
                                  , tmp.PartnerId
                                  , tmp.LocationId
                                  , MAX (tmp.miprice)  AS MIPrice
                                  , SUM (tmp.Amount) AS Amount
                                  , SUM (tmp.AmountPartner) AS AmountPartner
                                  , SUM (tmp.Summ) AS Summ
                                  , SUM (tmp.Summ_ProfitLoss_partner) AS Summ_ProfitLoss_partner
                                  , SUM (tmp.Summ_ProfitLoss) AS Summ_ProfitLoss
                                  , SUM (tmp.HeadCount) AS HeadCount
                                  , MovementLinkObject_From.ObjectId AS JuridicalId
                                  , SUM (CASE WHEN tmp.PartnerId <> MovementLinkObject_From.ObjectId THEN tmp.Amount ELSE 0 END) AS Amount_f2
                                  , SUM (CASE WHEN tmp.PartnerId <> MovementLinkObject_From.ObjectId THEN tmp.Summ   ELSE 0 END) AS SUM_f2
                                  , COALESCE (Object_PartionGoods.ValueData, '')                                           AS PartionGoods

                            FROM tmpMIContainer AS tmp
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = tmp.MovementId
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                               ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerIntId_analyzer
                                                              AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = ContainerLO_PartionGoods.ObjectId
                            GROUP BY COALESCE (Object_PartionGoods.ValueData, '')
                                   , tmp.OperDate
                                   , tmp.MovementId
                                   , tmp.GoodsId
                                   , tmp.PartnerId
                                   , tmp.LocationId
                                   , MovementLinkObject_From.ObjectId
                            )


         , tmpContainer AS (SELECT tmpContainer.*
                                 , CASE WHEN COALESCE (tmp2.MIPrice,0) = COALESCE (tmpContainer.MIPrice,0) THEN 1 ELSE 0 END AS isDop
                            FROM tmpContainer1 AS tmpContainer
                                LEFT JOIN tmpContainer1 AS tmp2
                                                        ON tmp2.MovementId = tmpContainer.MovementId
                                                       AND tmp2.PartnerId <> tmpContainer.PartnerId
                            )

         , tmpTransportCost AS (SELECT tmp.MovementId
                                     , SUM (COALESCE (MIFloat_Taxi.ValueData, 0) + COALESCE (MIFloat_TaxiMore.ValueData, 0)
                                     + COALESCE (MIFloat_RateSumma.ValueData, 0) + COALESCE (MIFloat_RateSummaExp.ValueData, 0)) AS Taxi
                                     , SUM (COALESCE (MovementFloat_AmountCost_Master.ValueData, 0) )                            AS AmountCost
                                     , SUM (COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0))
                                          + COALESCE (MIFloat_RateSummaAdd.ValueData, 0))                                        AS RatePrice_Calc
                                                --  , SUM (COALESCE (MovementFloat_AmountMemberCost_Master.ValueData, 0)) :: TFloat AS AmountCost_Master
                               FROM (SELECT DISTINCT MovementId
                                     FROM tmpContainer) AS tmp
                                          INNER JOIN Movement AS Movement_Cost ON Movement_Cost.ParentId = tmp.MovementId
                                                             AND Movement_Cost.DescId = zc_Movement_IncomeCost()
                                                             AND Movement_Cost.StatusId = zc_Enum_Status_Complete()
                                                             AND Movement_Cost.StatusId <> zc_Enum_Status_Erased()
                                                           --AND (vbUserId <> 5 OR Movement_Cost.StatusId = zc_Enum_Status_Erased())

                                          LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                                                  ON MovementFloat_AmountCost.MovementId = Movement_Cost.Id
                                                                 AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()

                                          LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                                                  ON MovementFloat_MovementId.MovementId = Movement_Cost.Id
                                                                 AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()

                                          LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementFloat_MovementId.ValueData :: Integer

                                          LEFT JOIN MovementFloat AS MovementFloat_AmountCost_Master
                                                                  ON MovementFloat_AmountCost_Master.MovementId = Movement_Master.Id
                                                                 AND MovementFloat_AmountCost_Master.DescId     = zc_MovementFloat_AmountCost()
                                          LEFT JOIN MovementFloat AS MovementFloat_AmountMemberCost_Master
                                                                  ON MovementFloat_AmountMemberCost_Master.MovementId = Movement_Master.Id
                                                                 AND MovementFloat_AmountMemberCost_Master.DescId     = zc_MovementFloat_AmountMemberCost()

                                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement_Master.Id
                                                                AND MovementItem.DescId     = zc_MI_Master()
                                                                AND MovementItem.isErased = FALSE

                                          LEFT JOIN MovementItemFloat AS MIFloat_Taxi
                                                                      ON MIFloat_Taxi.MovementItemId =  MovementItem.Id
                                                                     AND MIFloat_Taxi.DescId = zc_MIFloat_Taxi()
                                          LEFT JOIN MovementItemFloat AS MIFloat_TaxiMore
                                                                      ON MIFloat_TaxiMore.MovementItemId =  MovementItem.Id
                                                                     AND MIFloat_TaxiMore.DescId = zc_MIFloat_TaxiMore()
                                          LEFT JOIN MovementItemFloat AS MIFloat_RateSummaExp
                                                                      ON MIFloat_RateSummaExp.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_RateSummaExp.DescId = zc_MIFloat_RateSummaExp()
                                          LEFT JOIN MovementItemFloat AS MIFloat_RateSumma
                                                                      ON MIFloat_RateSumma.MovementItemId =  MovementItem.Id
                                                                     AND MIFloat_RateSumma.DescId = zc_MIFloat_RateSumma()
                                          LEFT JOIN MovementItemFloat AS MIFloat_RatePrice
                                                                      ON MIFloat_RatePrice.MovementItemId =  MovementItem.Id
                                                                     AND MIFloat_RatePrice.DescId = zc_MIFloat_RatePrice()
                                          LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                                                      ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
                                          LEFT JOIN MovementItemFloat AS MIFloat_RateSummaAdd
                                                                      ON MIFloat_RateSummaAdd.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_RateSummaAdd.DescId = zc_MIFloat_RateSummaAdd()
                               GROUP BY tmp.MovementId
                               )


/*
4261;"СВИНИНА н/к в/ш 2кат_*"  17
2844;"ГОЛОВЫ СВ.*"             19
4183;"ГОРЛО СВ."               20
4187;"ТРАХЕЯ СВ."              21
2550;"ЯЗИК СВИННИЙ*"           22
*/
         , tmpGoods AS (SELECT Object.Id
                        FROM Object
                        WHERE Object.Id IN (4261, 2844, 4183, 4187, 2550)
                          AND Object.DescId = zc_Object_Goods()
                       )

         , tmp AS (SELECT DISTINCT tmp.PartionGoods, tmp.LocationId
                                 , Movement.Id AS MovementId
                   FROM (SELECT DISTINCT tmp.PartionGoods, tmp.LocationId FROM tmpContainer AS tmp) AS tmp
                         INNER JOIN MovementString AS MovementString_PartionGoods
                                                   ON MovementString_PartionGoods.ValueData = tmp.PartionGoods
                                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                         INNER JOIN Movement ON Movement.Id = MovementString_PartionGoods.MovementId
                                            AND Movement.DescId = zc_Movement_ProductionSeparate()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                                   )
 
         , tmpSummIn AS (SELECT MIContainer.MovementItemId
                              , SUM (COALESCE (MIContainer.Amount,0)) AS SummIn
                         FROM tmp
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementId = tmp.MovementId
                                                             AND MIContainer.DescId     = zc_MIContainer_Summ()
                                                             AND MIContainer.isActive   = TRUE
                         GROUP BY MIContainer.MovementItemId
                         )
         , tmpSeparate AS (SELECT tmp.PartionGoods
                                , SUM (CASE WHEN MI_Child.ObjectId = 4261 THEN MI_Child.Amount ELSE 0 END) AS Amount_17
                                , SUM (CASE WHEN MI_Child.ObjectId = 2844 THEN MI_Child.Amount ELSE 0 END) AS Amount_19
                                , SUM (CASE WHEN MI_Child.ObjectId = 4183 THEN MI_Child.Amount ELSE 0 END) AS Amount_20
                                , SUM (CASE WHEN MI_Child.ObjectId = 4187 THEN MI_Child.Amount ELSE 0 END) AS Amount_21
                                , SUM (CASE WHEN MI_Child.ObjectId = 2550 THEN MI_Child.Amount ELSE 0 END) AS Amount_22
                                , SUM (CASE WHEN MI_Child.ObjectId = 4261 THEN COALESCE (tmpSummIn.SummIn,0) ELSE 0 END) AS SummIn_17
                           FROM tmp 
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = tmp.MovementId
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From.ObjectId = tmp.LocationId
                                 JOIN MovementItem AS MI_Master
                                                   ON MI_Master.MovementId = tmp.MovementId
                                                  AND MI_Master.DescId   = zc_MI_Master()
                                                  AND MI_Master.isErased = FALSE
                                                  AND MI_Master.ObjectId = 5225
                                 JOIN MovementItem AS MI_Child
                                                   ON MI_Child.MovementId =  tmp.MovementId -- 12095222
                                                  AND MI_Child.DescId     = zc_MI_Child()
                                                  AND MI_Child.isErased   = False
                                 JOIN  tmpGoods ON tmpGoods.Id = MI_Child.ObjectId
                                 
                                 LEFT JOIN tmpSummIn ON tmpSummIn.MovementItemId = MI_Child.Id
                                                    AND MI_Child.ObjectId = 4261

                           GROUP BY tmp.PartionGoods
                           )

         , tmpGroup AS (SELECT tmpContainer.OperDate                      AS OperDate
                             , tmpContainer.GoodsId                       AS GoodsId
                             , tmpContainer.JuridicalId                   AS JuridicalId
                             , tmpContainer.PartionGoods                  AS PartionGoods
                             , tmpContainer.isDop
                             , SUM (tmpContainer.Amount)                  AS Amount
                             , SUM (tmpContainer.AmountPartner)           AS AmountPartner
                             , SUM (tmpContainer.Summ)                    AS Summ
                             , SUM (tmpContainer.Summ_ProfitLoss_partner) AS Summ_ProfitLoss_partner
                             , SUM (tmpContainer.Summ_ProfitLoss)         AS Summ_ProfitLoss
                             , SUM (tmpContainer.HeadCount)               AS HeadCount
                             , SUM (tmpContainer.SUM_f2)                  AS SUM_f2
                             , SUM (tmpContainer.Amount_f2)               AS Amount_f2
                             , SUM (tmpTransportCost.Taxi)                AS Taxi
                             , SUM (tmpTransportCost.AmountCost)          AS AmountCost
                             , SUM (tmpTransportCost.RatePrice_Calc)      AS RatePrice_Calc
                         FROM  (SELECT tmpContainer.OperDate                      AS OperDate
                                     , tmpContainer.GoodsId                       AS GoodsId
                                     , tmpContainer.JuridicalId                   AS JuridicalId
                                     , tmpContainer.PartionGoods                  AS PartionGoods
                                     , tmpContainer.isDop
                                     , tmpContainer.MovementId
                                     , SUM (tmpContainer.Amount)                  AS Amount
                                     , SUM (tmpContainer.AmountPartner)           AS AmountPartner
                                     , SUM (tmpContainer.Summ)                    AS Summ
                                     , SUM (tmpContainer.Summ_ProfitLoss_partner) AS Summ_ProfitLoss_partner
                                     , SUM (tmpContainer.Summ_ProfitLoss)         AS Summ_ProfitLoss
                                     , SUM (tmpContainer.HeadCount)               AS HeadCount
                                     , SUM (tmpContainer.SUM_f2)                  AS SUM_f2
                                     , SUM (tmpContainer.Amount_f2)               AS Amount_f2
                                 FROM tmpContainer
                                 GROUP BY tmpContainer.GoodsId
                                        , tmpContainer.OperDate
                                        , tmpContainer.JuridicalId
                                        , tmpContainer.PartionGoods
                                        , tmpContainer.isDop
                                        , tmpContainer.MovementId
                                 ) AS tmpContainer
                                   LEFT JOIN tmpTransportCost ON tmpTransportCost.MovementId = tmpContainer.MovementId
                         GROUP BY tmpContainer.GoodsId
                                , tmpContainer.OperDate
                                , tmpContainer.JuridicalId
                                , tmpContainer.PartionGoods
                                , tmpContainer.isDop
                         )

/*         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                                  , ObjectLink_Goods_Measure.ChildObjectId       AS MeasureId
                                  , ObjectFloat_Weight.ValueData                 AS Weight
                             FROM (SELECT DISTINCT tmpGroup.GoodsId
                                   FROM tmpGroup
                                   ) AS tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            )
*/

         , tmpOperationGroupAll AS (SELECT tmp.OperDate
                                      , tmp.JuridicalId
                                      , tmp.Amount_Weight
                                      , tmp.AmountPartner_Weight
                                      , tmp.Summ
                                      , tmp.TotalSumm
                                      , tmp.HeadCount
                                      --, tmp.HeadCount_one
                                      , tmp.AmountWeight_diff
                                      , tmp.SUM_f2
                                      --, tmp.Amount_f2
                                      , CASE WHEN COALESCE (tmp.Amount_Weight,0) <> 0 THEN tmp.Summ / tmp.Amount_Weight ELSE 0 END AS Price
                                      , CASE WHEN COALESCE (tmp.AmountPartner_Weight,0) <> 0 THEN (tmp.TotalSumm ) / tmp.AmountPartner_Weight ELSE 0 END AS PricePartner
                                      , CASE WHEN COALESCE (tmp.AmountWeight_diff,0) <> 0 THEN tmp.SUM_f2 / tmp.AmountWeight_diff ELSE 0 END AS Price_f2

                                      , tmp.Amount_7   AS Amount_7
                                      , tmp.Amount_8   AS Amount_8
                                      , tmp.Amount_9   AS Amount_9
                                      , tmp.Amount_10  AS Amount_10

                                      , tmpSeparate.Amount_17
                                      , tmpSeparate.Amount_19
                                      , tmpSeparate.Amount_20
                                      , tmpSeparate.Amount_21
                                      , tmpSeparate.Amount_22
                                      , tmpSeparate.SummIn_17

                                      , tmp.Amount_23
                                      , tmp.Amount_24
                                      , tmp.Amount_25
                                    FROM (SELECT tmpOperationGroup.OperDate
                                               , tmpOperationGroup.JuridicalId
                                               , tmpOperationGroup.PartionGoods
                                               , SUM (tmpOperationGroup.Amount) :: TFloat AS Amount_Weight         -- Ж.В ФАКТ
                                               , SUM (tmpOperationGroup.AmountPartner - tmpOperationGroup.Amount_f2) :: TFloat AS AmountPartner_Weight  -- ВЕС НАКЛАД. БН
                                               , SUM (tmpOperationGroup.Summ - tmpOperationGroup.Summ_ProfitLoss)                                                                 :: TFloat AS Summ
                                               , SUM (tmpOperationGroup.Summ - tmpOperationGroup.SUM_f2 )                                                                         :: TFloat AS TotalSumm
                                               , SUM (tmpOperationGroup.HeadCount)                                                                                                :: TFloat AS HeadCount
                                               , SUM (tmpOperationGroup.SUM_f2)                                                                                                   :: TFloat AS SUM_f2
                                               --, SUM (CASE WHEN COALESCE (tmpOperationGroup.HeadCount, 0) <> 0 THEN (tmpOperationGroup.Amount) / tmpOperationGroup.HeadCount ELSE 0 END) :: TFloat AS HeadCount_one
                                               , SUM ((tmpOperationGroup.Amount - tmpOperationGroup.AmountPartner + tmpOperationGroup.Amount_f2 )) :: TFloat AS AmountWeight_diff  -- от заготовителя- излишек,кг
                                               , SUM (CASE WHEN tmpOperationGroup.isDop = 1 THEN tmpOperationGroup.Amount_f2 ELSE 0 END ) AS Amount_7
                                               , SUM (CASE WHEN tmpOperationGroup.isDop = 1 THEN tmpOperationGroup.SUM_f2    ELSE 0 END ) AS Amount_8
                                               , SUM (CASE WHEN tmpOperationGroup.isDop = 1 THEN 0 ELSE ROUND(tmpOperationGroup.SUM_f2 / tmpOperationGroup.AmountPartner, 2) END ) AS Amount_9
                                               , SUM (CASE WHEN tmpOperationGroup.isDop = 1 THEN 0 ELSE tmpOperationGroup.SUM_f2 END )    AS Amount_10
                                               , SUM (tmpOperationGroup.RatePrice_Calc)      AS Amount_23
                                               , SUM (tmpOperationGroup.AmountCost)          AS Amount_24
                                               , SUM (tmpOperationGroup.Taxi)                AS Amount_25
                                          FROM tmpGroup AS tmpOperationGroup
                                          --     LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpOperationGroup.GoodsId
                                          GROUP BY tmpOperationGroup.OperDate
                                                 , tmpOperationGroup.JuridicalId
                                                 , tmpOperationGroup.PartionGoods
                                         ) AS tmp
                                         LEFT JOIN tmpSeparate ON tmpSeparate.PartionGoods = tmp.PartionGoods
                                   )

         , tmpOperationGroup AS (SELECT '01. Ж.В ФАКТ' AS Col_Name
                                      , 1 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_Weight  AS Value
                                      , 0::TFloat                           AS ValueAmount
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '02. К-во голов' AS Col_Name
                                      , 2 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.HeadCount
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '03. Сред. Вес 1 головы' AS Col_Name
                                      , 3 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , CASE WHEN COALESCE (tmpOperationGroupAll.HeadCount, 0) <> 0 THEN tmpOperationGroupAll.Amount_Weight / tmpOperationGroupAll.HeadCount ELSE 0 END-- tmpOperationGroupAll.HeadCount_one
                                      , tmpOperationGroupAll.HeadCount
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '04. ВЕС НАКЛАД. БН' AS Col_Name
                                      , 4 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.AmountPartner_Weight
                                      , 0::TFloat
                                      , 12713983  AS Color_calc   -- зеленая беж  -- поярче 6608867
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '05. ЦЕНА-НАКЛАД. БН' AS Col_Name
                                      , 5 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.PricePartner
                                      , tmpOperationGroupAll.AmountPartner_Weight
                                      , 12713983 AS Color_calc   -- зеленая беж
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '06. ВСЕГО СУММА БН' AS Col_Name
                                      , 6 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.TotalSumm
                                      , 0::TFloat
                                      , 12713983 AS Color_calc           -- зеленая беж
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '07. доплата за вес, кг' AS Col_Name
                                      , 7 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_7
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '08. ДОПЛАТА ВЕС-НАЛ, грн' AS Col_Name
                                      , 8 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_8
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '09. КОПЕЙКИ' AS Col_Name
                                      , 9 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_9
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '10. ДОПЛАТА КОПЕЙКИ, грн' AS Col_Name
                                      , 10 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_10
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '11. ВСЕГО ДОПЛАТА заготовителю' AS Col_Name
                                      , 11 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.SUM_f2
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '12. От заготовителя- излишек,кг' AS Col_Name
                                      , 12 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.AmountWeight_diff
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc   -- цвет  шрифта
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '13. от заготовщик-цена' AS Col_Name
                                      , 13 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Price_f2
                                      , tmpOperationGroupAll.AmountWeight_diff
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '14. ВСЕГО СУММА' AS Col_Name
                                      , 14 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Summ
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '15. ЦЕНА Ж.В.-ФАКТ' AS Col_Name
                                      , 15 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Price
                                      , tmpOperationGroupAll.Amount_Weight
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '16. ВЫХОД ФАКТ, %' AS Col_Name
                                      , 16 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , CASE WHEN COALESCE (tmpOperationGroupAll.Amount_Weight,0) <> 0 THEN ROUND (tmpOperationGroupAll.Amount_17 / tmpOperationGroupAll.Amount_Weight * 100, 1) ELSE 0 END
                                      , tmpOperationGroupAll.Amount_Weight * 100
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '17. СВИНИНА Н/К' AS Col_Name
                                      , 17 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_17
                                      , 0::TFloat
                                      , 11452916 AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '18. цена СВИНИНА Н/К' AS Col_Name
                                      , 18 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , CASE WHEN COALESCE (tmpOperationGroupAll.Amount_17,0) <>0 THEN tmpOperationGroupAll.SummIn_17 / tmpOperationGroupAll.Amount_17 ELSE 0 END AS Value
                                      , tmpOperationGroupAll.Amount_17
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '19. ГОЛОВЫ СВ.' AS Col_Name
                                      , 19 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_19
                                      , 0::TFloat
                                      , 10733211 AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '20. Горло св.' AS Col_Name
                                      , 20 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_20
                                      , 0::TFloat
                                      , 10733211 AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '21. Трахея св.' AS Col_Name
                                      , 21 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_21
                                      , 0::TFloat
                                      , 10733211 AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '22. Язык св.' AS Col_Name
                                      , 22 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_22
                                      , 0::TFloat
                                      , 10733211 AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '23. Погрузка' AS Col_Name
                                      , 23 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_23
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '24. транс- расх.' AS Col_Name
                                      , 24 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_24
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '25. Такси+командиров.' AS Col_Name
                                      , 25 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_25
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                                UNION
                                 SELECT '26. итого транспорт' AS Col_Name
                                      , 26 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , COALESCE (tmpOperationGroupAll.Amount_23,0) + COALESCE (tmpOperationGroupAll.Amount_24,0) + COALESCE (tmpOperationGroupAll.Amount_25,0)
                                      , 0::TFloat
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_Sum() :: Integer AS SummType
                                 FROM tmpOperationGroupAll
                              /* UNION-- проверка
                                 SELECT '18.1. Проверка сумма СВИНИНА Н/К' AS Col_Name
                                      , 18 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , CASE WHEN COALESCE (tmpOperationGroupAll.Amount_17,0) <> 0 THEN tmpOperationGroupAll.SummIn_17  ELSE 0 END AS Value
                                      , tmpOperationGroupAll.Amount_17
                                      , zc_Color_White() AS Color_calc
                                      , zc_PivotSummartType_AveragePrice() :: Integer AS SummType
                                 FROM tmpOperationGroupAll*/
                                 )

      -- Результат
      SELECT tmpOperationGroup.Num
           , tmpOperationGroup.OperDate   :: TDateTime
           , tmpOperationGroup.Col_Name   :: TVarChar
           , Object_Juridical.ValueData                AS JuridicalName
           , tmpOperationGroup.Value      :: TFloat
           , tmpOperationGroup.ValueAmount:: TFloat
           , tmpOperationGroup.Color_calc :: Integer
           , tmpOperationGroup.SummType   :: Integer
        FROM tmpOperationGroup
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.19         *
 20.02.19         *
*/

-- тест-
 -- select * from gpReport_IncomeKill_Olap(inStartDate := ('02.01.2019')::TDateTime , inEndDate := ('02.01.2019')::TDateTime , inGoodsId := 5225 ,  inSession := '5');
