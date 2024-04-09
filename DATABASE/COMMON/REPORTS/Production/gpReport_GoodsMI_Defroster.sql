-- Function: gpReport_GoodsMI_Defroster ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Defroster(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Defroster(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar
             , PartionGoodsName TVarChar
             , PartnerCode Integer
             , PartnerName TVarChar
             , Amount_Send_in TFloat
             , Amount_Separate_in TFloat
             , Amount_Send_out TFloat
             , Amount_Separate_out TFloat
             , Amount_Loss TFloat
             , Amount_Loss_diff TFloat
             , Amount_diff TFloat
             , Tax_diff TFloat

             , Price_in TFloat
             , Price_Separate_in TFloat
             , Price_Send_in TFloat

             , Price_out TFloat
             , Price_Separate_out TFloat
             , Price_Send_out TFloat

             , Summ_Loss_diff TFloat
             , Price_Loss_diff TFloat

             , Tax_Separate_diff TFloat
             , Summ_Production_out TFloat, Amount_Production_out TFloat, Separate_CountIn TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Результат
    RETURN QUERY
         -- 
    WITH tmpMI_1 AS  (SELECT MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , COALESCE (MIContainer.ObjectIntId_Analyzer,8335)   AS GoodsKindId

                             -- документ для расчета приход кол-во для Separate расход с inUnitId
                           , CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                                   AND MIContainer.DescId = zc_MIContainer_Count()
                                   AND MIContainer.IsActive = FALSE
                                   AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                      THEN MIContainer.MovementId
                                  ELSE 0
                             END AS MovementId

                             -- Перемещение приход на inUnitId
                           , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = TRUE
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN MIContainer.Amount 
                                       ELSE 0
                                  END) AS Amount_Send_in
                           , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = TRUE
                                        AND MIContainer.DescId = zc_MIContainer_Summ()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN MIContainer.Amount 
                                       ELSE 0
                                  END) AS Summ_Send_in

                             -- Separate приход на inUnitId
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate() AND MIContainer.IsActive = TRUE
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Separate_in
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate() AND MIContainer.IsActive = TRUE
                                        AND MIContainer.DescId = zc_MIContainer_Summ()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN MIContainer.Amount
                                       ELSE 0
                                  END) AS Summ_Separate_in

                             -- Перемещение расход с inUnitId
                           , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Send_out
                           , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE
                                        AND MIContainer.DescId = zc_MIContainer_Summ()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Summ_Send_out

                             -- Separate расход с inUnitId
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate() AND MIContainer.IsActive = FALSE
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Separate_out
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate() AND MIContainer.IsActive = FALSE
                                        AND MIContainer.DescId = zc_MIContainer_Summ()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Summ_Separate_out

                             -- Loss кол-во с inUnitId
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss()
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Loss

                             -- ProductionUnion на inUnitId - разница кол-во
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Loss_diff
                             -- ProductionUnion на inUnitId - расход кол-во (для суммы потерь)
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                        AND MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.IsActive = FALSE
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Production_out
                             -- ProductionUnion на inUnitId - расход сумма (для суммы потерь)
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                        AND MIContainer.DescId = zc_MIContainer_Summ()
                                        AND MIContainer.IsActive = FALSE
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Summ_Production_out

                      FROM MovementItemContainer AS MIContainer
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND (inEndDate + INTERVAL '1 DAY')
                        AND MIContainer.WhereObjectId_Analyzer = inUnitId
                        AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate(), zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_Loss() , zc_Movement_ProductionUnion())
                      GROUP BY MIContainer.ContainerId
                             , MIContainer.ObjectId_Analyzer
                             , COALESCE (MIContainer.ObjectIntId_Analyzer,8335)
                             , CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                                     AND MIContainer.DescId = zc_MIContainer_Count()
                                     AND MIContainer.IsActive = FALSE
                                     AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                        THEN MIContainer.MovementId
                                    ELSE 0
                               END
                      )
       
                , tmpSeparate AS (SELECT tmpMI_1.ContainerId
                                       , tmpMI_1.GoodsId
                                       , tmpMI_1.GoodsKindId
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count()
                                                    AND MIContainer.IsActive = TRUE
                                                        THEN MIContainer.Amount
                                                   ELSE 0
                                              END) AS CountIn
                                  FROM tmpMI_1
                                       INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId = tmpMI_1.MovementId
                                                                                      AND MIContainer.DescId = zc_MIContainer_Count()
                                                                                      AND MIContainer.IsActive = TRUE
                                                                                      AND MIContainer.ObjectId_Analyzer <> 6451 -- Потери при обвалке
                                  WHERE tmpMI_1.MovementId <> 0
                                  GROUP BY tmpMI_1.ContainerId
                                         , tmpMI_1.GoodsId
                                         , tmpMI_1.GoodsKindId
                                 )
       , tmpMI_All AS (SELECT tmpMI_1.GoodsId
                            , tmpMI_1.GoodsKindId
                            , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                            , SUM (tmpMI_1.Amount_Send_in)        AS Amount_Send_in
                            , SUM (tmpMI_1.Summ_Send_in)          AS Summ_Send_in
                            , SUM (tmpMI_1.Amount_Separate_in)    AS Amount_Separate_in
                            , SUM (tmpMI_1.Summ_Separate_in)      AS Summ_Separate_in
                            , SUM (tmpMI_1.Amount_Send_out)       AS Amount_Send_out
                            , SUM (tmpMI_1.Summ_Send_out)         AS Summ_Send_out
                            , SUM (tmpMI_1.Amount_Separate_out)   AS Amount_Separate_out
                            , SUM (tmpMI_1.Summ_Separate_out)     AS Summ_Separate_out
                            , SUM (tmpMI_1.Amount_Loss)           AS Amount_Loss
                            , SUM (tmpMI_1.Amount_Loss_diff)      AS Amount_Loss_diff
                            , SUM (tmpMI_1.Amount_Production_out) AS Amount_Production_out
                            , SUM (tmpMI_1.Summ_Production_out)   AS Summ_Production_out

                         FROM tmpMI_1
                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = tmpMI_1.ContainerId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                         GROUP BY tmpMI_1.GoodsId, CLO_PartionGoods.ObjectId
                                , tmpMI_1.GoodsKindId
                         HAVING SUM (tmpMI_1.Amount_Send_in)      <> 0
                             OR SUM (tmpMI_1.Amount_Separate_in)  <> 0
                             OR SUM (tmpMI_1.Amount_Send_out)     <> 0
                             OR SUM (tmpMI_1.Amount_Separate_out) <> 0
                             OR SUM (tmpMI_1.Amount_Loss)         <> 0
                             OR SUM (tmpMI_1.Amount_Loss_diff)   <> 0
                        )
   , tmpMI_Separate AS (SELECT tmpSeparate.GoodsId
                             , tmpSeparate.GoodsKindId
                             , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                             , SUM (tmpSeparate.CountIn)               AS CountIn
                         FROM tmpSeparate
                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = tmpSeparate.ContainerId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                         GROUP BY tmpSeparate.GoodsId, COALESCE (CLO_PartionGoods.ObjectId, 0)
                                , tmpSeparate.GoodsKindId
                        )
       
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         
         , Object_GoodsKind.ValueData                 AS GoodsKindName
       
         , Object_Measure.ValueData                   AS MeasureName
         , Object_PartionGoods.ValueData              AS PartionGoodsName
         , Object_Partner.ObjectCode                  AS PartnerCode
         , Object_Partner.ValueData                   AS PartnerName

         , tmpMI_All.Amount_Send_in       :: TFloat AS Amount_Send_in
         , tmpMI_All.Amount_Separate_in   :: TFloat AS Amount_Separate_in
         , tmpMI_All.Amount_Send_out      :: TFloat AS Amount_Send_out
         , tmpMI_All.Amount_Separate_out  :: TFloat AS Amount_Separate_out
         
         , tmpMI_All.Amount_Loss          :: TFloat AS Amount_Loss
         , tmpMI_All.Amount_Loss_diff     :: TFloat AS Amount_Loss_diff

         , (tmpMI_All.Amount_Send_in + tmpMI_All.Amount_Separate_in - tmpMI_All.Amount_Send_out - tmpMI_All.Amount_Separate_out) :: TFloat AS Amount_diff
         , CASE WHEN (tmpMI_All.Amount_Send_in + tmpMI_All.Amount_Separate_in) <> 0
                     THEN CAST (100 - 100 * (tmpMI_All.Amount_Send_out + tmpMI_All.Amount_Separate_out) / (tmpMI_All.Amount_Send_in + tmpMI_All.Amount_Separate_in) AS NUMERIC (16, 1))
                WHEN (tmpMI_All.Amount_Send_out + tmpMI_All.Amount_Separate_out) <> 0
                     THEN -100
                ELSE 0
           END :: TFloat AS Tax_diff

         , CASE WHEN tmpMI_All.Amount_Separate_in + tmpMI_All.Amount_Send_in <> 0 THEN (tmpMI_All.Summ_Separate_in + tmpMI_All.Summ_Send_in) / (tmpMI_All.Amount_Separate_in + tmpMI_All.Amount_Send_in) ELSE 0 END :: TFloat AS Price_in
         , CASE WHEN tmpMI_All.Amount_Separate_in <> 0 THEN tmpMI_All.Summ_Separate_in / tmpMI_All.Amount_Separate_in ELSE 0 END :: TFloat AS Price_Separate_in
         , CASE WHEN tmpMI_All.Amount_Send_in     <> 0 THEN tmpMI_All.Summ_Send_in     / tmpMI_All.Amount_Send_in     ELSE 0 END :: TFloat AS Price_Send_in

         , CASE WHEN tmpMI_All.Amount_Separate_out + tmpMI_All.Amount_Send_out <> 0 THEN (tmpMI_All.Summ_Separate_out + tmpMI_All.Summ_Send_out) / (tmpMI_All.Amount_Separate_out + tmpMI_All.Amount_Send_out) ELSE 0 END :: TFloat AS Price_out
         , CASE WHEN tmpMI_All.Amount_Separate_out <> 0 THEN tmpMI_All.Summ_Separate_out / tmpMI_All.Amount_Separate_out ELSE 0 END :: TFloat AS Price_Separate_out
         , CASE WHEN tmpMI_All.Amount_Send_out     <> 0 THEN tmpMI_All.Summ_Send_out     / tmpMI_All.Amount_Send_out     ELSE 0 END :: TFloat AS Price_Send_out

         , CASE WHEN tmpMI_All.Amount_Production_out <> 0 THEN tmpMI_All.Amount_Loss_diff * tmpMI_All.Summ_Production_out / tmpMI_All.Amount_Production_out ELSE 0 END :: TFloat AS Summ_Loss_diff
         , CASE WHEN tmpMI_All.Amount_Production_out <> 0 THEN tmpMI_All.Summ_Production_out / tmpMI_All.Amount_Production_out ELSE 0 END :: TFloat AS Price_Loss_diff

         , CASE WHEN tmpMI_All.Amount_Separate_out <> 0 THEN 100 - 100 * COALESCE (tmpMI_Separate.CountIn, 0) / tmpMI_All.Amount_Separate_out ELSE 0 END :: TFloat AS Tax_Separate_diff
         , tmpMI_All.Summ_Production_out   :: TFloat AS Summ_Production_out
         , tmpMI_All.Amount_Production_out :: TFloat AS Amount_Production_out
         , COALESCE (tmpMI_Separate.CountIn, 0) :: TFloat AS Separate_CountIn
     FROM tmpMI_All
          LEFT JOIN tmpMI_Separate ON tmpMI_Separate.GoodsId = tmpMI_All.GoodsId
                                  AND tmpMI_Separate.PartionGoodsId = tmpMI_All.PartionGoodsId
                                  AND tmpMI_Separate.GoodsKindId = tmpMI_All.GoodsKindId

          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI_All.PartionGoodsId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_All.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_All.GoodsKindId

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

          LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Partner
                               ON ObjectLink_PartionGoods_Partner.ObjectId = tmpMI_All.PartionGoodsId
                              AND ObjectLink_PartionGoods_Partner.DescId = zc_ObjectLink_PartionGoods_Partner()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_PartionGoods_Partner.ChildObjectId
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_Defroster (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         * zc_Movement_SendAsset
 28.06.15                                        * all
 25.03.15         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Defroster(inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inUnitId:= 8440, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
