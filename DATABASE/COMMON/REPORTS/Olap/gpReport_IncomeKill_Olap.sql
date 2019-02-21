-- Function: gpReport_IncomeKill_Olap ()

DROP FUNCTION IF EXISTS gpReport_IncomeKill_Olap (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeKill_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsId            Integer   ,
    IN inSession            TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS TABLE (Num Integer
             , OperDate TDateTime
             , Col_Name     TVarChar
             --, PartnerName  TVarChar
             , JuridicalName  TVarChar
             , Value         TFloat
             )   
AS
$BODY$
BEGIN

    -- –ÂÁÛÎ¸Ú‡Ú
    RETURN QUERY
      WITH 
           -- ‰‡ÌÌ˚Â ÔÂ‚Ó„Ó ÔÂËÓ‰‡
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

                              FROM MovementItemContainer AS MIContainer
                                   LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                               ON MIFloat_HeadCount.MovementItemId = MIContainer.MovementItemId
                                                              AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                                              AND MIContainer.DescId = zc_MIContainer_Count()
                                                              AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                              WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                AND MIContainer.MovementDescId = zc_Movement_Income()
                                AND MIContainer.ObjectId_Analyzer = inGoodsId
                                AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- ÔË·˚Î¸ ÚÂÍÛ˘Â„Ó ÔÂËÓ‰‡
                              GROUP BY MIContainer.ContainerId
                                     , MIContainer.MovementId
                                     , MIContainer.ObjectId_analyzer
                                     , MIContainer.ContainerId_analyzer
                                     , MIContainer.ObjectExtId_Analyzer
                                     , MIContainer.OperDate
                                     , MIContainer.WhereObjectId_analyzer
                                     , MIContainer.ContainerIntId_analyzer
                                    )

         , tmpContainer AS (SELECT tmp.*
                                 , MovementLinkObject_From.ObjectId AS JuridicalId
                                 , CASE WHEN tmp.PartnerId <> MovementLinkObject_From.ObjectId THEN tmp.Amount ELSE 0 END AS Amount_f2
                                 , CASE WHEN tmp.PartnerId <> MovementLinkObject_From.ObjectId THEN tmp.Summ   ELSE 0 END AS SUM_f2
                                 , COALESCE (Object_PartionGoods.ValueData, '')                                           AS PartionGoods
                            FROM tmpMIContainer AS tmp
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = tmp.MovementId
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                               ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerIntId_analyzer
                                                              AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = ContainerLO_PartionGoods.ObjectId
                                                                  
                            )

/*
4261;"—¬»Õ»Õ¿ Ì/Í ‚/¯ 2Í‡Ú_*"  17 
2844;"√ŒÀŒ¬€ —¬.*"             19
4183;"√Œ–ÀŒ —¬."               20
4187;"“–¿’≈ﬂ —¬."              21
2550;"ﬂ«»  —¬»ÕÕ»…*"           22
*/
         , tmpGoods AS (SELECT Object.Id
                        FROM Object
                        WHERE Object.Id IN (4261, 2844, 4183, 4187, 2550)
                          AND Object.DescId = zc_Object_Goods() 
                       )

         , tmpSeparate AS (SELECT tmp.PartionGoods
                                , SUM (CASE WHEN MI_Child.ObjectId = 4261 THEN MI_Child.Amount ELSE 0 END) AS Amount_17
                                , SUM (CASE WHEN MI_Child.ObjectId = 2844 THEN MI_Child.Amount ELSE 0 END) AS Amount_19
                                , SUM (CASE WHEN MI_Child.ObjectId = 4183 THEN MI_Child.Amount ELSE 0 END) AS Amount_20
                                , SUM (CASE WHEN MI_Child.ObjectId = 4187 THEN MI_Child.Amount ELSE 0 END) AS Amount_21
                                , SUM (CASE WHEN MI_Child.ObjectId = 2550 THEN MI_Child.Amount ELSE 0 END) AS Amount_22
                           FROM (SELECT DISTINCT tmp.MovementId, tmp.PartionGoods, tmp.LocationId FROM tmpContainer AS tmp) AS tmp
                                 INNER JOIN MovementString AS MovementString_PartionGoods
                                                           ON MovementString_PartionGoods.ValueData = tmp.PartionGoods
                                                          AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                 INNER JOIN Movement ON Movement.Id = MovementString_PartionGoods.MovementId
                                           AND Movement.DescId = zc_Movement_ProductionSeparate()
                                           AND Movement.StatusId = zc_Enum_Status_Complete()

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                       AND MovementLinkObject_From.ObjectId = tmp.LocationId
                                 JOIN MovementItem AS MI_Master
                                                   ON MI_Master.MovementId = Movement.Id
                                                  AND MI_Master.DescId   = zc_MI_Master()
                                                  AND MI_Master.isErased = FALSE
                                                  AND MI_Master.ObjectId = 5225
                                 JOIN MovementItem AS MI_Child
                                                   ON MI_Child.MovementId =  Movement.Id -- 12095222
                                                  AND MI_Child.DescId     = zc_MI_Child()
                                                  AND MI_Child.isErased   = False
                                 JOIN  tmpGoods ON tmpGoods.Id = MI_Child.ObjectId
                           GROUP BY tmp.PartionGoods
                           )

         , tmpGroup AS (SELECT tmpContainer.OperDate                      AS OperDate
                             , tmpContainer.GoodsId                       AS GoodsId
                             , tmpContainer.JuridicalId                   AS JuridicalId
                             , tmpContainer.PartnerId                     AS PartnerId
                             , tmpContainer.PartionGoods                  AS PartionGoods
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
                                , tmpContainer.PartnerId
                                , tmpContainer.JuridicalId
                                , tmpContainer.PartionGoods
                        )

         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
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
                                      , tmpSeparate.Amount_17
                                      , tmpSeparate.Amount_19
                                      , tmpSeparate.Amount_20
                                      , tmpSeparate.Amount_21
                                      , tmpSeparate.Amount_22
                                    FROM (SELECT tmpOperationGroup.OperDate
                                               , tmpOperationGroup.JuridicalId
                                               , tmpOperationGroup.PartionGoods
                                               , SUM (tmpOperationGroup.Amount        * CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END) :: TFloat AS Amount_Weight         -- ∆.¬ ‘¿ “
                                               , SUM ((tmpOperationGroup.AmountPartner - tmpOperationGroup.Amount_f2)  * CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END) :: TFloat AS AmountPartner_Weight  -- ¬≈— Õ¿ À¿ƒ. ¡Õ
                                               , SUM (tmpOperationGroup.Summ - tmpOperationGroup.Summ_ProfitLoss)                                                                 :: TFloat AS Summ
                                               , SUM (tmpOperationGroup.Summ - tmpOperationGroup.SUM_f2 )                                                                         :: TFloat AS TotalSumm
                                               , SUM (tmpOperationGroup.HeadCount)                                                                                                :: TFloat AS HeadCount
                                               , SUM (tmpOperationGroup.SUM_f2)                                                                                                   :: TFloat AS SUM_f2
                                               --, SUM (CASE WHEN COALESCE (tmpOperationGroup.HeadCount, 0) <> 0 THEN (tmpOperationGroup.Amount * CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END) / tmpOperationGroup.HeadCount ELSE 0 END) :: TFloat AS HeadCount_one
                                               , SUM ((tmpOperationGroup.Amount - tmpOperationGroup.AmountPartner + tmpOperationGroup.Amount_f2 ) * CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END) :: TFloat AS AmountWeight_diff  -- ÓÚ Á‡„ÓÚÓ‚ËÚÂÎˇ- ËÁÎË¯ÂÍ,Í„
                                          FROM tmpGroup AS tmpOperationGroup
                                               LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpOperationGroup.GoodsId
                                          GROUP BY tmpOperationGroup.OperDate
                                                 , tmpOperationGroup.JuridicalId
                                                 , tmpOperationGroup.PartionGoods
                                         ) AS tmp
                                         LEFT JOIN tmpSeparate ON tmpSeparate.PartionGoods = tmp.PartionGoods
                                   )

         , tmpOperationGroup AS (SELECT '∆.¬ ‘¿ “' AS Col_Name    
                                      , 1 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_Weight  AS Value
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_Weight <> 0
                                UNION
                                 SELECT ' -‚Ó „ÓÎÓ‚' AS Col_Name
                                      , 2 AS Num      
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.HeadCount
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.HeadCount <> 0
                                UNION
                                 SELECT '—Â‰. ¬ÂÒ 1 „ÓÎÓ‚˚' AS Col_Name
                                      , 3 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_Weight / tmpOperationGroupAll.HeadCount -- tmpOperationGroupAll.HeadCount_one
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_Weight <> 0 AND tmpOperationGroupAll.HeadCount <> 0 --tmpOperationGroupAll.HeadCount_one <> 0
                                UNION
                                 SELECT '¬≈— Õ¿ À¿ƒ. ¡Õ' AS Col_Name
                                      , 4 AS Num    
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.AmountPartner_Weight
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.AmountPartner_Weight <> 0  
                                UNION
                                 SELECT '÷≈Õ¿-Õ¿ À¿ƒ. ¡Õ' AS Col_Name
                                      , 5 AS Num     
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.PricePartner
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.PricePartner <> 0
                                UNION
                                 SELECT '¬—≈√Œ —”ÃÃ¿ ¡Õ' AS Col_Name
                                      , 6 AS Num       
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.TotalSumm                                      
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.TotalSumm <> 0
                                UNION
                                 SELECT '¬—≈√Œ ƒŒœÀ¿“¿ Á‡„ÓÚÓ‚ËÚÂÎ˛' AS Col_Name
                                      , 11 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.SUM_f2
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.SUM_f2 <> 0
                                UNION
                                 SELECT 'ŒÚ Á‡„ÓÚÓ‚ËÚÂÎˇ- ËÁÎË¯ÂÍ,Í„' AS Col_Name
                                      , 12 AS Num      
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.AmountWeight_diff
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.AmountWeight_diff <> 0
                                UNION
                                 SELECT 'ÓÚ Á‡„ÓÚÓ‚˘ËÍ-ˆÂÌ‡' AS Col_Name
                                      , 13 AS Num      
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Price_f2
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Price_f2 <> 0
                                UNION
                                 SELECT '¬—≈√Œ —”ÃÃ¿' AS Col_Name
                                      , 14 AS Num  
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Summ                                    
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Summ <> 0
                                UNION
                                 SELECT '÷≈Õ¿ ∆.¬.-‘¿ “' AS Col_Name
                                      , 15 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Price
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Price <> 0
                                UNION
                                 SELECT '—¬»Õ»Õ¿ Õ/ ' AS Col_Name
                                      , 17 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_17
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_17 <> 0
                                UNION
                                 SELECT 'ˆÂÌ‡ —¬»Õ»Õ¿ Õ/ ' AS Col_Name
                                      , 18 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , 0 :: TFloat AS Value
                                 FROM tmpOperationGroupAll
                                 --WHERE tmpOperationGroupAll.Amount_17 <> 0
                                UNION
                                 SELECT '√ŒÀŒ¬€ —¬.' AS Col_Name
                                      , 19 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_19
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_19 <> 0
                                UNION
                                 SELECT '√ÓÎÓ Ò‚.' AS Col_Name
                                      , 20 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_20
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_20 <> 0
                                UNION
                                 SELECT '“‡ıÂˇ Ò‚.' AS Col_Name
                                      , 21 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_21
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_21 <> 0
                                UNION
                                 SELECT 'ﬂÁ˚Í Ò‚.' AS Col_Name
                                      , 22 AS Num
                                      , tmpOperationGroupAll.OperDate
                                      , tmpOperationGroupAll.JuridicalId
                                      , tmpOperationGroupAll.Amount_22
                                 FROM tmpOperationGroupAll
                                 WHERE tmpOperationGroupAll.Amount_22 <> 0
                                 )

      -- –ÂÁÛÎ¸Ú‡Ú 
      SELECT tmpOperationGroup.Num
           , tmpOperationGroup.OperDate :: TDateTime AS OperDate
           , tmpOperationGroup.Col_Name :: TVarChar
           , Object_Juridical.ValueData              AS JuridicalName
           , tmpOperationGroup.Value    :: TFloat
        FROM tmpOperationGroup
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpOperationGroup.JuridicalId
        ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 20.02.19         *
*/

-- ÚÂÒÚ-
 -- select * from gpReport_IncomeKill_Olap(inStartDate := ('02.01.2019')::TDateTime , inEndDate := ('02.01.2019')::TDateTime , inGoodsId := 5225 ,  inSession := '5');