-- Function: gpReport_IncomeKill_Olap ()

DROP FUNCTION IF EXISTS gpReport_IncomeKill_Olap (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeKill_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsId            Integer   ,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime
             , MonthDate TDateTime
             , LocationName TVarChar
             , PartnerName  TVarChar
             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , MeasureName TVarChar
             , Amount                TFloat
             , AmountPartner         TFloat
             , Amount_Weight         TFloat
             , AmountPartner_Weight  TFloat
             , Amount_Sh             TFloat
             , AmountPartner_Sh      TFloat
             , Summ                  TFloat
             , Summ_ProfitLoss       TFloat
             , TotalSumm             TFloat

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer,
              InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar
              , InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             )   
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
      WITH 
           -- данные первого периода
           tmpMIContainer AS (SELECT MIContainer.ContainerId                        AS ContainerId
                                   , MIContainer.OperDate                           AS OperDate
                                   , MIContainer.MovementId                         AS MovementId
                                   , MIContainer.ObjectId_Analyzer                  AS GoodsId
                                   , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                   --, MIContainer.ContainerId_analyzer               AS ContainerId_analyzer
                                   , MIContainer.ObjectExtId_Analyzer               AS PartnerId
                                   , MIContainer.WhereObjectId_analyzer             AS LocationId
                                  
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                    THEN MIContainer.Amount
                                               ELSE 0
                                          END) AS Amount
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                                                    THEN MIContainer.Amount
                                               WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                                AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_Count_40200()
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS AmountPartner
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
                                                    THEN MIContainer.Amount
                                               WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                                AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ProfitLoss()
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS Summ
                                   , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()
                                                AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                                AND ((MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE)
                                                  OR (MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE))
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
                              FROM MovementItemContainer AS MIContainer
                              WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                AND MIContainer.MovementDescId = zc_Movement_Income()
                                AND MIContainer.ObjectId_Analyzer = inGoodsId
                                AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                              GROUP BY MIContainer.ContainerId
                                     , MIContainer.MovementId
                                     , MIContainer.ObjectId_analyzer
                                     , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                     , MIContainer.ContainerId_analyzer
                                     , MIContainer.ObjectExtId_Analyzer
                                     , MIContainer.OperDate
                                     , MIContainer.WhereObjectId_analyzer
                                    )

         , tmpContainer AS (SELECT tmp.*
                                 , CLO_InfoMoney.ObjectId             AS InfoMoneyId
                                 , CLO_InfoMoneyDetail.ObjectId       AS InfoMoneyId_Detail
                            FROM tmpMIContainer AS tmp
                                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                               ON CLO_InfoMoney.ContainerId = tmp.ContainerId
                                                              AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                               ON CLO_InfoMoneyDetail.ContainerId = tmp.ContainerId
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                            )

         , tmpOperationGroup AS (SELECT tmpMI_ContainerIn.OperDate   AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                          AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                      AS GoodsKindId
                                       , tmpMI_ContainerIn.PartnerId                        AS PartnerId
                                       , tmpMI_ContainerIn.LocationId                       AS LocationId
                                       , SUM (tmpMI_ContainerIn.Amount)                     AS Amount
                                       , SUM (tmpMI_ContainerIn.AmountPartner)              AS AmountPartner
                                       , SUM (tmpMI_ContainerIn.Summ)                       AS Summ
                                       , SUM (tmpMI_ContainerIn.Summ_ProfitLoss_partner)    AS Summ_ProfitLoss_partner
                                       , SUM (tmpMI_ContainerIn.Summ_ProfitLoss)            AS Summ_ProfitLoss
                                    
                                  FROM tmpContainer AS tmpMI_ContainerIn
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , tmpMI_ContainerIn.OperDate
                                         , tmpMI_ContainerIn.PartnerId
                                         , tmpMI_ContainerIn.LocationId
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

      -- Результат 
      SELECT Movement.InvNumber
           , Movement.OperDate
           , tmpOperationGroup.OperDate   :: TDateTime AS MonthDate
           , Object_Location.ValueData                 AS LocationName
           , Object_Partner.ValueData                  AS PartnerName
           
           , tmpGoodsParam.GoodsGroupName     AS GoodsGroupName 
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName  
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , Object_Measure.ValueData         AS MeasureName
           
           , tmpOperationGroup.Amount                                                                                           :: TFloat AS Amount
           , tmpOperationGroup.AmountPartner                                                                                    :: TFloat AS AmountPartner
           , (tmpOperationGroup.Amount        * CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END) :: TFloat AS Amount_Weight
           , (tmpOperationGroup.AmountPartner * CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END) :: TFloat AS AmountPartner_Weight
           , CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpOperationGroup.Amount        ELSE 0 END                    :: TFloat AS Amount_Sh
           , CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpOperationGroup.AmountPartner ELSE 0 END                    :: TFloat AS AmountPartner_Sh
           , (tmpOperationGroup.Summ - tmpOperationGroup.Summ_ProfitLoss)                                                       :: TFloat AS Summ
           , (tmpOperationGroup.Summ_ProfitLoss + tmpOperationGroup.Summ_ProfitLoss_partner)                                    :: TFloat AS Summ_ProfitLoss
           , tmpOperationGroup.Summ                                                                                             :: TFloat AS TotalSumm
           
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

        FROM tmpOperationGroup

             LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
             

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = tmpOperationGroup.InfoMoneyId_Detail
        
             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = Object_Goods.Id
             LEFT JOIN Object AS Object_Measure on Object_Measure.Id = tmpGoodsParam.MeasureId
             
             LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpOperationGroup.LocationId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOperationGroup.PartnerId

             LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                  ON ObjectDate_PartionGoods_Value.ObjectId = tmpOperationGroup.PartionGoodsId
                                 AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
        ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.02.19         *
*/

-- тест-
 -- SELECT * FROM gpReport_IncomeKill_Olap 