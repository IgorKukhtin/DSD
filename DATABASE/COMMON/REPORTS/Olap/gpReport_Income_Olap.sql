-- Function: gpReport_GoodsMI_Income ()

DROP FUNCTION IF EXISTS gpReport_Income_Olap (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Income_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inStartDate2         TDateTime ,  
    IN inEndDate2           TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inIsPartion          Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inUnitId             Integer   ,    -- от кого 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime
             , MonthDate TDateTime
             , PartionGoods TVarChar, PartionGoods_Date TDateTime
             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Name_Scale TVarChar
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

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , PartnerName TVarChar
             )   
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpunit (UnitId Integer) ON COMMIT DROP;
 
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

    -- ограничения по подразделению
    IF inUnitId <> 0
    THEN
        INSERT INTO _tmpunit (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpunit (UnitId)
          SELECT Id FROM Object_Unit_View;
    END IF;

    -- Результат
    RETURN QUERY
      WITH 
           -- данные первого периода
           tmpMI_ContainerIn1 AS (SELECT MIContainer.ContainerId                        AS ContainerId
                                       , MIContainer.OperDate                           AS OperDate
                                       , MIContainer.MovementId                         AS MovementId
                                       , MIContainer.ObjectId_Analyzer                  AS GoodsId
                                       , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                       --, MIContainer.ContainerId_analyzer               AS ContainerId_analyzer
                                       , MIContainer.ObjectExtId_Analyzer               AS PartnerId
                                       , MIContainer.WhereObjectId_analyzer             AS LocationId
                                       , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END AS ContainerIntId_analyzer
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
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
                                       INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                       INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                    AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                                    AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101()-- товар в пути
                                  GROUP BY MIContainer.ContainerId
                                         , MIContainer.MovementId
                                         , MIContainer.ObjectId_analyzer
                                         , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                         , MIContainer.ContainerId_analyzer
                                         , MIContainer.ObjectExtId_Analyzer
                                         , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END
                                         , MIContainer.OperDate
                                         , MIContainer.WhereObjectId_analyzer
                                        )

         , tmpContainer_in1 AS (SELECT tmp.*
                                     , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                                     , CLO_InfoMoney.ObjectId             AS InfoMoneyId
                                     , CLO_InfoMoneyDetail.ObjectId       AS InfoMoneyId_Detail
                                FROM tmpMI_ContainerIn1 AS tmp
                                     LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                   ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerIntId_analyzer
                                                                  AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                  AND inIsPartion = TRUE
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                   ON CLO_InfoMoney.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                                   ON CLO_InfoMoneyDetail.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                )

         , tmpOperationGroup1 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)   AS OperDate
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
                                    
                                  FROM tmpContainer_in1 AS tmpMI_ContainerIn
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                         , tmpMI_ContainerIn.PartnerId
                                         , tmpMI_ContainerIn.LocationId
                                 )

           --данные второго периода
         , tmpMI_ContainerIn2 AS (SELECT MIContainer.ContainerId                        AS ContainerId
                                       , MIContainer.OperDate                           AS OperDate
                                       , MIContainer.MovementId                         AS MovementId
                                       , MIContainer.ObjectId_Analyzer                  AS GoodsId
                                       , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                       --, MIContainer.ContainerId_analyzer               AS ContainerId_analyzer
                                       , MIContainer.ObjectExtId_Analyzer               AS PartnerId
                                       , MIContainer.WhereObjectId_analyzer             AS LocationId
                                       , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END AS ContainerIntId_analyzer
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Income() AND MIContainer.isActive = TRUE
                                                        THEN MIContainer.Amount
                                                   WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_ReturnOut() AND MIContainer.isActive = FALSE
                                                        THEN -1 * MIContainer.Amount
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
                                       INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                       INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                                    AND MIContainer.MovementDescId = zc_Movement_Income()
                                    AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_100301() -- прибыль текущего периода
                                    AND COALESCE (MIContainer.AccountId, 0) <> zc_Enum_Account_110101()-- товар в пути
                                  GROUP BY MIContainer.ContainerId
                                         , MIContainer.MovementId
                                         , MIContainer.ObjectId_analyzer
                                         , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                         , MIContainer.ContainerId_analyzer
                                         , MIContainer.ObjectExtId_Analyzer
                                         , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END
                                         , MIContainer.OperDate
                                         , MIContainer.WhereObjectId_analyzer
                                  )

         , tmpContainer_in2 AS (SELECT tmp.*
                                     , CASE WHEN inIsPartion = TRUE THEN COALESCE (ContainerLO_PartionGoods.ObjectId, 0) ELSE 0 END AS PartionGoodsId
                                     , CLO_InfoMoney.ObjectId             AS InfoMoneyId
                                     , CLO_InfoMoneyDetail.ObjectId       AS InfoMoneyId_Detail
                                FROM tmpMI_ContainerIn2 AS tmp
                                     LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                   ON ContainerLO_PartionGoods.ContainerId = tmp.ContainerIntId_analyzer
                                                                  AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                  AND inIsPartion = TRUE
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                   ON CLO_InfoMoney.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                                   ON CLO_InfoMoneyDetail.ContainerId = tmp.ContainerId
                                                                  AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                )

         , tmpOperationGroup2 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)   AS OperDate
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
                                    
                                  FROM tmpContainer_in2 AS tmpMI_ContainerIn
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                         , tmpMI_ContainerIn.PartnerId
                                         , tmpMI_ContainerIn.LocationId
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
                                  , COALESCE (zfCalc_Text_replace (ObjectString_Goods_Scale.ValueData, CHR (39), '`' ), '') :: TVarChar AS Name_Scale
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

                                  LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                                         ON ObjectString_Goods_Scale.ObjectId = tmpGoods.GoodsId
                                                        AND ObjectString_Goods_Scale.DescId = zc_ObjectString_Goods_Scale()

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
           , Object_PartionGoods.ValueData             AS PartionGoods
           , ObjectDate_PartionGoods_Value.ValueData :: TDateTime AS PartionGoods_Date
           
           , tmpGoodsParam.GoodsGroupName     AS GoodsGroupName 
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , tmpGoodsParam.Name_Scale  ::TVarChar AS Name_Scale
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

            , Object_Partner.ValueData ::TVarChar AS PartnerName

        FROM tmpOperationGroup

             LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId
             

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = tmpOperationGroup.InfoMoneyId_Detail
        
             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = Object_Goods.Id
             LEFT JOIN Object AS Object_Measure on Object_Measure.Id = tmpGoodsParam.MeasureId
             
             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

             LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                  ON ObjectDate_PartionGoods_Value.ObjectId = tmpOperationGroup.PartionGoodsId
                                 AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()

             LEFT JOIN Object AS Object_Partner on Object_Partner.Id = tmpOperationGroup.PartnerId
        ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.18         *
*/

-- тест-
 -- SELECT * FROM gpReport_Income_Olap (inStartDate:= '01.06.2018'::TDateTime, inEndDate:= '01.06.2018'::TDateTime, inStartDate2:= '05.06.2017'::TDateTime, inEndDate2:= '05.06.2017'::TDateTime, inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitId:= 0, inSession:= zfCalc_UserAdmin())--// limit 1;