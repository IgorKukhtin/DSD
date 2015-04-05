-- Function: gpReport_GoodsMI_Package ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Package(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , PartionGoods TVarChar

             , Amount_Send_out TFloat
             , Amount_Send_in TFloat
         
             , Amount_ProductionUnion TFloat
             , Calc TFloat
             
              )
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
         -- 
    WITH tmpMI_1 AS  (SELECT MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
   
                           , CASE WHEN (MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.IsActive = TRUE) THEN MIContainer.Amount  ELSE 0 END                     AS Amount_Send_in
                           , CASE WHEN (MIContainer.MovementDescId = zc_Movement_Send()  AND MIContainer.IsActive = False) THEN MIContainer.Amount *(-1) ELSE 0 END              AS Amount_Send_out
                           , CASE WHEN (MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.IsActive = FALSE) THEN MIContainer.Amount *(-1) ELSE 0 END    AS Amount_ProductionUnion

                      FROM MovementItemContainer AS MIContainer
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate   --inStartDate+(interval '1 DAY') AND inEndDate+(interval '1 DAY')
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND (MIContainer.WhereObjectId_Analyzer = inUnitId or inUnitId = 0)
                        AND MIContainer.MovementDescId in (zc_Movement_Send(), zc_Movement_ProductionUnion())
                        AND MIContainer.Amount <> 0
                      )
       
    
       , tmpMI_Union AS (SELECT tmp.GoodsId, tmp.PartionGoodsId

                             , SUM(COALESCE(tmp.Amount_Send_in,0))::tfloat         as Amount_Send_in
                             , SUM(COALESCE(tmp.Amount_Send_out,0))::tfloat        as Amount_Send_out
                             , SUM(COALESCE(tmp.Amount_ProductionUnion,0))::tfloat as Amount_ProductionUnion
                         From (
                               SELECT tmpMI_1.GoodsId,                          tmpMI_1.PartionGoodsId,     
                                      tmpMI_1.Amount_Send_in AS Amount_Send_in, tmpMI_1.Amount_Send_out,
                                      tmpMI_1.Amount_ProductionUnion AS Amount_ProductionUnion
                               FROM tmpMI_1
                           /*  union all
                               SELECT tmpMI_2.GoodsId,            tmpMI_2.PartionGoodsId,       0::TFloat AS Amount_Separate_out
                                    , tmpMI_2.Amount_Separate_in, 0::TFloat AS Amount_Send_in,  tmpMI_2.Amount_Send_out AS Amount_Send_out
                                    , 0::TFloat AS Amount_Loss,   0::TFloat AS Amount_ProductionUnion
                               FROM tmpMI_2*/
                               ) as tmp
                          GROUP BY tmp.GoodsId, tmp.PartionGoodsId
                         )

       
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
       
         , Object_Measure.ValueData               AS MeasureName
         , MovementString_PartionGoods.ValueData      AS PartionGoods

         , tmpMI_Union.Amount_Send_out::TFloat AS Amount_Send_out
         , tmpMI_Union.Amount_Send_in::TFloat  AS Amount_Send_in   
         
         , tmpMI_Union.Amount_ProductionUnion::TFloat  AS Amount_ProductionUnion 
         , 0::TFloat AS Calc 
         

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
ALTER FUNCTION gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.15         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Package(inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inUnitId:= 8447, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
--select * from gpReport_GoodsMI_Package(inStartDate := ('30.05.2014')::TDateTime , inEndDate := ('01.06.2015')::TDateTime , inUnitId := 0 ,  inSession := '5');

