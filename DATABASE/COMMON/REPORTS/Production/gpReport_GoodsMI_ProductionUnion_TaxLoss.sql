-- Function: gpReport_GoodsMI_ProductionUnion_TaxLoss () - <Производство ГП и процент потерь (итоги)>

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionUnion_TaxLoss (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionUnion_TaxLoss (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inFromId       Integer   , 
    IN inToId         Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName_Complete TVarChar, MeasureName TVarChar
             , PartionGoodsDate TDateTime
             , Amount_WorkProgress_in TFloat
             , CuterCount TFloat
             , RealWeight TFloat
             , Amount_GP_in_calc TFloat
             , Amount_GP_in TFloat
             , TaxExit TFloat
             , TaxExit_calc TFloat
             , TaxExit_real TFloat
             , Comment TVarChar
              )
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
         -- приходы ГП с inFromId на inToId
    WITH tmpMI_GP_in AS
                     (SELECT MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , MIContainer.Amount                      AS Amount
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = MIContainer.MovementId
                                                        AND MLO_From.DescId = zc_MovementLinkObject_To()
                                                        AND MLO_From.ObjectId = inFromId
                           INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inToId
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0
                      )
         -- приходы п/ф ГП - сгруппировать
       , tmpMI_GP_in_group AS (SELECT ContainerId, GoodsId, PartionGoodsId FROM tmpMI_GP_in GROUP BY ContainerId, GoodsId, PartionGoodsId)
         -- расходы п/ф ГП в разрезе ParentId
       , tmpMI_WorkProgress_out AS
                     (SELECT MIContainer.ParentId
                           , tmpMI_GP_in_group.GoodsId
                           , tmpMI_GP_in_group.PartionGoodsId
                           , SUM (MIContainer.Amount) AS Amount
                      FROM tmpMI_GP_in_group
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpMI_GP_in_group.ContainerId
                                                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                           AND MIContainer.IsActive = FALSE
                     GROUP BY MIContainer.ParentId
                            , tmpMI_GP_in_group.GoodsId
                            , tmpMI_GP_in_group.PartionGoodsId
                     )
         -- приходы ГП в разрезе GoodsId (п/ф ГП) + GoodsKindId_Complete + !!!если "производство ГП"!!!
       , tmpMI_GP_in AS
                     (SELECT tmpMI_WorkProgress_out.GoodsId
                           , tmpMI_WorkProgress_out.PartionGoodsId
                           , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId_Complete
                           , SUM (MIContainer.Amount)             AS Amount
                      FROM tmpMI_WorkProgress_out
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.Id = tmpMI_WorkProgress_out.ParentId
                                                           AND MIContainer.WhereObjectId_Analyzer <> inUnitId -- !!!если "производство ГП"!!!
                           LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                         ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      GROUP BY tmpMI_WorkProgress_out.GoodsId
                             , tmpMI_WorkProgress_out.PartionGoodsId
                             , CLO_GoodsKind.ObjectId

                     )
         -- результат - группируется
       , tmpResult AS
                     (SELECT tmp.GoodsId
                           , tmp.PartionGoodsId
                           , tmp.GoodsKindId_Complete
                           , SUM (tmp.Amount_WorkProgress_in) AS Amount_WorkProgress_in
                           , SUM (tmp.CuterCount)             AS CuterCount
                           , SUM (tmp.RealWeight)             AS RealWeight
                           , SUM (tmp.Amount_GP_in_calc)      AS Amount_GP_in_calc
                           , SUM (tmp.Amount_GP_in)           AS Amount_GP_in
                           , SUM (tmp.calcIn)                 AS calcIn
                           , SUM (tmp.calcOut)                AS calcOut
                           , MAX (tmp.TaxExit)                AS TaxExit
                           , MAX (tmp.Comment)                AS Comment
                      FROM
                     (SELECT tmpMI_GP_in.GoodsId
                           , tmpMI_GP_in.PartionGoodsId
                           , COALESCE (MILO_GoodsKindComplete.ObjectId, 0)      AS GoodsKindId_Complete
                           , SUM (tmpMI_GP_in.Amount)                 AS Amount_WorkProgress_in
                           , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))   AS CuterCount
                           , SUM (COALESCE (MIFloat_RealWeight.ValueData, 0))   AS RealWeight
                           , SUM (CASE WHEN ObjectFloat_TotalWeight.ValueData <> 0
                                            THEN tmpMI_GP_in.Amount * COALESCE (ObjectFloat_TaxExit.ValueData, 0) / ObjectFloat_TotalWeight.ValueData
                                       ELSE 0
                                  END)                                          AS Amount_GP_in_calc
                           , AVG (COALESCE (ObjectFloat_TaxExit.ValueData, 0))  AS TaxExit
                           , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0) * COALESCE (ObjectFloat_TaxExit.ValueData, 0))     AS calcIn
                           , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0) * COALESCE (ObjectFloat_TotalWeight.ValueData, 0)) AS calcOut
                           , MAX (COALESCE (MIString_Comment.ValueData, ''))    AS Comment
                           , 0                                                  AS Amount_GP_in
                      FROM tmpMI_GP_in
                           LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                       ON MIFloat_CuterCount.MovementItemId = tmpMI_GP_in.MovementItemId
                                                      AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                       ON MIFloat_RealWeight.MovementItemId = tmpMI_GP_in.MovementItemId
                                                      AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                            ON MILO_GoodsKindComplete.MovementItemId = tmpMI_GP_in.MovementItemId
                                                           AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                           LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                            ON MILO_Receipt.MovementItemId = tmpMI_GP_in.MovementItemId
                                                           AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN MovementItemString AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = tmpMI_GP_in.MovementItemId
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                                 ON ObjectFloat_TaxExit.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeight
                                                 ON ObjectFloat_TotalWeight.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TotalWeight.DescId = zc_ObjectFloat_Receipt_TotalWeight()

                           /*LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_GP_in.GoodsId
                                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                                 ON ObjectFloat_Weight.ObjectId = tmpMI_GP_in.GoodsId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/

                      GROUP BY tmpMI_GP_in.GoodsId
                             , tmpMI_GP_in.PartionGoodsId
                             , MILO_GoodsKindComplete.ObjectId
                     UNION ALL
                      SELECT tmpMI_GP_in.GoodsId
                           , tmpMI_GP_in.PartionGoodsId
                           , tmpMI_GP_in.GoodsKindId_Complete
                           , 0 AS Amount_WorkProgress_in
                           , 0 AS CuterCount
                           , 0 AS RealWeight
                           , 0 AS Amount_GP_in_calc
                           , 0 AS TaxExit
                           , 0 AS calcIn
                           , 0 AS calcOut
                           , '' AS Comment
                           , tmpMI_GP_in.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS Amount_GP_in
                      FROM tmpMI_GP_in
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_GP_in.GoodsId
                                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                                 ON ObjectFloat_Weight.ObjectId = tmpMI_GP_in.GoodsId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     ) AS tmp
                      GROUP BY tmp.GoodsId
                             , tmp.PartionGoodsId
                             , tmp.GoodsKindId_Complete
                     )

    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKindComplete.ValueData     AS GoodsKindName_Complete
         , Object_Measure.ValueData               AS MeasureName
         , ObjectDate_PartionGoods.ValueData      AS PartionGoodsDate

         , tmpResult.Amount_WorkProgress_in :: TFloat   AS Amount_WorkProgress_in
         , tmpResult.CuterCount :: TFloat               AS CuterCount
         , tmpResult.RealWeight :: TFloat               AS RealWeight
         , tmpResult.Amount_GP_in_calc :: TFloat        AS Amount_GP_in_calc
         , tmpResult.Amount_GP_in :: TFloat             AS Amount_GP_in
         , tmpResult.TaxExit :: TFloat                  AS TaxExit
         , CASE WHEN tmpResult.CuterCount <> 0 AND tmpResult.calcOut <> 0
                     THEN (tmpResult.Amount_WorkProgress_in / tmpResult.CuterCount)
                        * (tmpResult.calcIn / tmpResult.CuterCount)
                        / (tmpResult.calcOut / tmpResult.CuterCount)
           END :: TFloat AS TaxExit_calc
         /*, CASE WHEN tmpResult.CuterCount <> 0 AND tmpResult.calcOut <> 0
                     THEN (tmpResult.Amount_WorkProgress_in / tmpResult.CuterCount)
                        * (tmpResult.Amount_GP_in / tmpResult.CuterCount)
                        / (tmpResult.calcOut / tmpResult.CuterCount)
           END :: TFloat AS TaxExit_real*/
         , CASE WHEN tmpResult.CuterCount <> 0
                     THEN (tmpResult.Amount_GP_in / tmpResult.CuterCount)
           END :: TFloat AS TaxExit_real

         , tmpResult.Comment :: TVarChar                AS Comment

     FROM tmpResult
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpResult.GoodsId
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpResult.GoodsKindId_Complete

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                               ON ObjectDate_PartionGoods.ObjectId = tmpResult.PartionGoodsId
                              AND ObjectDate_PartionGoods.DescId = zc_ObjectDate_PartionGoods_Value()
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_ProductionUnion_TaxLoss (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_ProductionUnion_TaxLoss (inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inUnitId:= 8447, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
