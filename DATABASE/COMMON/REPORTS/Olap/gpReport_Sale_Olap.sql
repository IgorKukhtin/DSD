-- Function: gpReport_GoodsMI_Sale ()

DROP FUNCTION IF EXISTS gpReport_Sale_Olap (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inStartDate2         TDateTime ,  
    IN inEndDate2           TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inIsPartion          Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inFromId             Integer   ,    -- от кого 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime
             , MonthDate TDateTime
             , PartionGoods TVarChar, PartionGoods_Date TDateTime
             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , Amount TFloat, Summ TFloat

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             )   
AS
$BODY$
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
 
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

    -- ограничения по ОТ КОГО
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;
    END IF;
  
    -- Результат
    RETURN QUERY
      WITH 
           
           -- данные первого периода
           tmpMI_ContainerIn1 AS
                       (SELECT MIContainer.OperDate                                 AS OperDate
                             , MIContainer.MovementId                               AS MovementId
                             , MIContainer.MovementItemId                           AS MovementItemId 
                             , MIContainer.ContainerId                              AS ContainerId
                             , MIContainer.ObjectId_Analyzer                        AS GoodsId
                             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId
                             , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END AS ContainerIntId_analyzer
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN  MIContainer.Amount ELSE 0 END)  AS Amount
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN MIContainer.Amount    ELSE 0 END)  AS Amount_Sum

                        FROM MovementItemContainer AS MIContainer
			     INNER JOIN _tmpFromGroup ON _tmpFromGroup.FromId = MIContainer.WhereObjectId_analyzer
 		             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                        WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          AND (MIContainer.MovementDescId = zc_Movement_Sale() OR MIContainer.MovementDescId = zc_Movement_SendOnPrice())
 --   and MIContainer.MovementId = 9558736 
                          AND MIContainer.isActive = true
                        GROUP BY MIContainer.MovementId
                               , MIContainer.MovementItemId 
                               , COALESCE (MIContainer.AccountId, 0)
                               , MIContainer.ContainerId
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.OperDate
                               , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END
                               , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                              
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

         , tmpOperationGroup1 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                          AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                      AS GoodsKindId
                                       , SUM (tmpMI_ContainerIn.Amount)     AS OperCount
                                       , SUM (tmpMI_ContainerIn.Amount_Sum) AS OperSumm

                                  FROM tmpContainer_in1 AS tmpMI_ContainerIn
                                  --     LEFT JOIN tmpContainer_in1 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
                                 )

           --данные второго периода
         , tmpMI_ContainerIn2 AS
                       (SELECT MIContainer.OperDate                                 AS OperDate
                             , MIContainer.MovementId                               AS MovementId
                             , MIContainer.MovementItemId                           AS MovementItemId 
                             , MIContainer.ContainerId                              AS ContainerId
                             , MIContainer.ObjectId_Analyzer                        AS GoodsId
                             , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)       AS GoodsKindId
                             , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END AS ContainerIntId_analyzer
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN  MIContainer.Amount ELSE 0 END)  AS Amount
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()   THEN MIContainer.Amount     ELSE 0 END)  AS Amount_Sum
                        FROM MovementItemContainer AS MIContainer
			     INNER JOIN _tmpFromGroup ON _tmpFromGroup.FromId = MIContainer.WhereObjectId_analyzer
 		             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                        WHERE MIContainer.OperDate BETWEEN inStartDate2 AND inEndDate2
                          AND (MIContainer.MovementDescId = zc_Movement_Sale() OR MIContainer.MovementDescId = zc_Movement_SendOnPrice())
 --   and MIContainer.MovementId = 9558736 
                          AND MIContainer.isActive = true
                        GROUP BY MIContainer.MovementId
                               , MIContainer.MovementItemId 
                               , COALESCE (MIContainer.AccountId, 0)
                               , MIContainer.ContainerId
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.OperDate
                               , CASE WHEN inIsPartion = TRUE THEN MIContainer.ContainerIntId_analyzer ELSE 0 END
                               , COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
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

         , tmpOperationGroup2 AS (SELECT DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate) AS OperDate
                                       , CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END AS MovementId
                                       , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)     AS PartionGoodsId
                                       , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)        AS InfoMoneyId
                                       , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0) AS InfoMoneyId_Detail
                                       , tmpMI_ContainerIn.GoodsId                          AS GoodsId  
                                       , tmpMI_ContainerIn.GoodsKindId                      AS GoodsKindId
                                       , SUM (tmpMI_ContainerIn.Amount)     AS OperCount
                                       , SUM (tmpMI_ContainerIn.Amount_Sum) AS OperSumm

                                  FROM tmpContainer_in2 AS tmpMI_ContainerIn
                                  --     LEFT JOIN tmpContainer_in2 AS tmpContainer_in ON tmpContainer_in.ContainerId = tmpMI_ContainerIn.ContainerId
                                  GROUP BY CASE WHEN inIsMovement = TRUE THEN tmpMI_ContainerIn.MovementId ELSE 0 END
                                         , COALESCE (tmpMI_ContainerIn.PartionGoodsId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId, 0)
                                         , COALESCE (tmpMI_ContainerIn.InfoMoneyId_Detail, 0)
                                         , tmpMI_ContainerIn.GoodsId       
                                         , tmpMI_ContainerIn.GoodsKindId 
                                         , DATE_TRUNC ('Month', tmpMI_ContainerIn.OperDate)
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
           , Object_PartionGoods.ValueData             AS PartionGoods
           , ObjectDate_PartionGoods_Value.ValueData :: TDateTime AS PartionGoods_Date
           
           , tmpGoodsParam.GoodsGroupName     AS GoodsGroupName 
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName  
           , Object_GoodsKind.ValueData       AS GoodsKindName
           
           , (tmpOperationGroup.OperCount * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS Amount
           , tmpOperationGroup.OperSumm  :: TFloat AS Summ
           
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
             
             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId

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
 17.07.18         *
*/

-- тест-
 --SELECT * FROM gpReport_Sale_Olap (inStartDate:= '01.06.2018', inEndDate:= '01.06.2018', inStartDate2:= '05.06.2017', inEndDate2:= '05.06.2017', inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inFromId:= 0, inSession:= zfCalc_UserAdmin()) limit 1;