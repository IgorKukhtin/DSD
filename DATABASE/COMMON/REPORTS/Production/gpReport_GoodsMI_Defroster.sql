-- Function: gpReport_GoodsMI_Defroster ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Defroster(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Defroster(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName_Complete TVarChar, MeasureName TVarChar
             , PartionGoodsDate TVarChar
             , Amount_Separate_out TFloat
             , Amount_Separate_in TFloat
             , Amount_Send_out TFloat
             , Amount_Send_in TFloat
             
              )
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
         -- расход
    WITH tmpMI_Separate_out AS
                     (SELECT MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                           , MIContainer.Amount                      AS Amount_Separate_out
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                                         AND CLO_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() -- ограничение что это п/ф ГП
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inUnitId
                        AND MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0
                      )
       
       , 
        -- приход
        tmpMI_Separate_in AS
                     (SELECT MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                           , MIContainer.Amount                      AS Amount_Separate_in
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                                         AND CLO_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() -- ограничение что это п/ф ГП
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inUnitId
                        AND MIContainer.MovementDescId = zc_Movement_ProductionSeparate()
                        AND MIContainer.IsActive = False
                        AND MIContainer.Amount <> 0
                      )
       
       , tmpMI_Union AS (SELECT GoodsId, PartionGoodsId, Sum(tmpMI_Separate_Out.Amount_Separate_out) as Amount_Separate_out, 0::TFloat AS Amount_Separate_in
                         FROM tmpMI_Separate_Out
                         GROUP BY GoodsId, PartionGoodsId
                        )

       
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
        -- , Object_GoodsKindComplete.ValueData     AS GoodsKindName_Complete
        ,   ''::TVarChar AS GoodsKindName_Complete
         , Object_Measure.ValueData               AS MeasureName
         , MovementString_PartionGoods.ValueData      AS PartionGoodsDate

         , tmpMI_Union.Amount_Separate_out::TFloat 
         , tmpMI_Union.Amount_Separate_in::TFloat 
           
         , 0::TFloat AS Amount_Send_out
          
         , 0::TFloat AS Amount_Send_in  

     FROM tmpMI_Union
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpMI_Union.GoodsId
         --LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpResult.GoodsKindId_Complete

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN MovementString AS MovementString_PartionGoods
                                 ON MovementString_PartionGoods.MovementId = tmpMI_Union.PartionGoodsId
                                AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_Defroster (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.15         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Defroster(inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inUnitId:= 8447, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
