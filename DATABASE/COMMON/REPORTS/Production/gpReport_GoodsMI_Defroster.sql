-- Function: gpReport_GoodsMI_Defroster ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Defroster(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Defroster(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   , 
    IN inSession      TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , PartionGoodsName TVarChar
             , PartnerCode Integer
             , PartnerName TVarChar
             , Amount_Send_in TFloat
             , Amount_Separate_in TFloat
             , Amount_Send_out TFloat
             , Amount_Separate_out TFloat
             , Amount_Loss TFloat
             , Amount_Production TFloat
             , Amount_diff TFloat
             , Tax_diff TFloat
              )
AS
$BODY$
BEGIN

    -- Ðåçóëüòàò
    RETURN QUERY
         -- 
    WITH tmpMI_1 AS  (SELECT MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId

                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.IsActive = TRUE
                                        AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            THEN MIContainer.Amount 
                                       ELSE 0
                                  END) AS Amount_Send_in
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate() AND MIContainer.IsActive = TRUE
                                        AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            THEN MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Separate_in

                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.IsActive = FALSE
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Send_out
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionSeparate() AND MIContainer.IsActive = FALSE
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '1 DAY') AND (inEndDate + INTERVAL '1 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Separate_out

                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Loss()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Loss
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                        AND MIContainer.OperDate BETWEEN (inStartDate + INTERVAL '0 DAY') AND (inEndDate + INTERVAL '0 DAY')
                                            THEN -1 * MIContainer.Amount
                                       ELSE 0
                                  END) AS Amount_Production

                      FROM MovementItemContainer AS MIContainer
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND (inEndDate + INTERVAL '1 DAY')
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inUnitId
                        AND MIContainer.MovementDescId IN (zc_Movement_ProductionSeparate(), zc_Movement_Send(),zc_Movement_Loss() , zc_Movement_ProductionUnion())
                      GROUP BY MIContainer.ContainerId
                             , MIContainer.ObjectId_Analyzer
                      )
       
       , tmpMI_Union AS (SELECT tmpMI_1.GoodsId, CLO_PartionGoods.ObjectId AS PartionGoodsId
                              , SUM (tmpMI_1.Amount_Send_in)      AS Amount_Send_in
                              , SUM (tmpMI_1.Amount_Separate_in)  AS Amount_Separate_in
                              , SUM (tmpMI_1.Amount_Send_out)     AS Amount_Send_out
                              , SUM (tmpMI_1.Amount_Separate_out) AS Amount_Separate_out
                              , SUM (tmpMI_1.Amount_Loss)         AS Amount_Loss
                              , SUM (tmpMI_1.Amount_Production)   AS Amount_Production
                         FROM tmpMI_1
                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = tmpMI_1.ContainerId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                         GROUP BY tmpMI_1.GoodsId, CLO_PartionGoods.ObjectId
                         HAVING SUM (tmpMI_1.Amount_Send_in)      <> 0
                             OR SUM (tmpMI_1.Amount_Separate_in)  <> 0
                             OR SUM (tmpMI_1.Amount_Send_out)     <> 0
                             OR SUM (tmpMI_1.Amount_Separate_out) <> 0
                             OR SUM (tmpMI_1.Amount_Loss)         <> 0
                             OR SUM (tmpMI_1.Amount_Production)   <> 0
                        )

       
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
       
         , Object_Measure.ValueData                   AS MeasureName
         , Object_PartionGoods.ValueData              AS PartionGoodsName
         , Object_Partner.ObjectCode                  AS PartnerCode
         , Object_Partner.ValueData                   AS PartnerName

         , tmpMI_Union.Amount_Send_in       :: TFloat AS Amount_Send_in
         , tmpMI_Union.Amount_Separate_in   :: TFloat AS Amount_Separate_in
         , tmpMI_Union.Amount_Send_out      :: TFloat AS Amount_Send_out
         , tmpMI_Union.Amount_Separate_out  :: TFloat AS Amount_Separate_out
         
         , tmpMI_Union.Amount_Loss          :: TFloat AS Amount_Loss
         , tmpMI_Union.Amount_Production    :: TFloat AS Amount_Production

         , (tmpMI_Union.Amount_Send_in + tmpMI_Union.Amount_Separate_in - tmpMI_Union.Amount_Send_out - tmpMI_Union.Amount_Separate_out) :: TFloat AS Amount_diff
         , CASE WHEN (tmpMI_Union.Amount_Send_in + tmpMI_Union.Amount_Separate_in) <> 0
                     THEN CAST (100 - 100 * (tmpMI_Union.Amount_Send_out + tmpMI_Union.Amount_Separate_out) / (tmpMI_Union.Amount_Send_in + tmpMI_Union.Amount_Separate_in) AS NUMERIC (16, 1))
                WHEN (tmpMI_Union.Amount_Send_out + tmpMI_Union.Amount_Separate_out) <> 0
                     THEN -100
                ELSE 0
           END :: TFloat AS Tax_diff

     FROM tmpMI_Union
          LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI_Union.PartionGoodsId
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpMI_Union.GoodsId

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
                               ON ObjectLink_PartionGoods_Partner.ObjectId = tmpMI_Union.PartionGoodsId
                              AND ObjectLink_PartionGoods_Partner.DescId = zc_ObjectLink_PartionGoods_Partner()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_PartionGoods_Partner.ChildObjectId
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_Defroster (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 28.06.15                                        * all
 25.03.15         *
*/

-- òåñò
-- SELECT * FROM gpReport_GoodsMI_Defroster(inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inUnitId:= 8447, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
