-- FunctiON: gpReport_ProductionOrder ()

DROP FUNCTION IF EXISTS gpReport_ProductionOrder (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionOrder (
    IN inOperDate            TDateTime ,  
    IN inUnitId              Integer   , 
    IN inSessiON             TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Code Integer, GoodsName TVarChar, GoodsKindName TVarChar, GoodsGroupName  TVarChar, MeasureName TVarChar, 
               MiddleOrderSumm TFloat, Remains TFloat, RemainsInDays TFloat, NotShippedOrder TFloat, TodayOrder TFloat)  
AS
$BODY$
BEGIN

IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
THEN RETURN;
ELSE

    RETURN QUERY
     WITH tmpProductionRemains AS (SELECT ddd.GoodsId, ddd.goodskindid, ddd.partiongoodsid, ObjectDate.valuedata 
                                   FROM (SELECT dd.GoodsId, dd.goodskindid, dd.partiongoodsid, SUM(StartAmount) AS Summ 
                                         FROM (SELECT Container.ObjectId          AS GoodsId
                                                    , Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)  AS StartAmount
                                                    , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                                    , CLO_PartionGoods.ObjectId AS PartionGoodsId  
                                               FROM ContainerLinkObject AS CLO_Unit
                                                    INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() 
                                                    --       AND Container.Amount <> 0
                                                    JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                             ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                                            AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()

                                                    JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                             ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                                            AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                                                    LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                AND MIContainer.OperDate >= CURRENT_DATE
                                               WHERE CLO_Unit.ObjectId IN( 8447, 8448, 8449) 
                                                 AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                               GROUP BY Container.ObjectId, GoodsKindId, Container.Amount, PartionGoodsId  
                                               HAVING (Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)) <>0
                                               ORDER BY 1, 3) AS dd
                                         GROUP BY dd.GoodsId, dd.goodskindid, dd.partiongoodsid
                                         ORDER BY 1, 3) AS ddd
                                      LEFT JOIN ObjectDate ON ObjectDate.descid =  zc_ObjectDate_PartionGoods_Value() AND ObjectDate.ObjectId = ddd.partiongoodsid
                                   WHERE abs(summ) > 0.01
                                   )

     , tmpStoreRemains AS (SELECT dd.GoodsId, dd.goodskindid, SUM(StartAmount) AS Remains 
                           FROM (SELECT Container.ObjectId                                        AS GoodsId
                                         , Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)  AS StartAmount
                                         , COALESCE (CLO_GoodsKind.ObjectId, 0)                      AS GoodsKindId
                                 FROM ContainerLinkObject AS CLO_Unit
                                      INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() 
                                      LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                    ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                      LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                     AND MIContainer.OperDate >= inOperDate
                                 WHERE  CLO_Unit.ObjectId IN (8458 ,8459) AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                 GROUP BY Container.ObjectId, GoodsKindId, Container.Amount 
                                 HAVING (Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)) <>0 
                                 ) AS dd
                           GROUP BY dd.GoodsId, dd.goodskindid
                           )

       SELECT ObjectGoods.ObjectCode       AS Code
            , ObjectGoods.ValueData        AS GoodsName
            , ObjectGoodsKind.ValueData    AS GoodsKindName            
            , Object_GoodsGroup.ValueData  AS GoodsGroupName 
            , Object_Measure.ValueData     AS MeasureName
            , DD.MiddleSumm::TFloat        AS MiddleOrderSumm
            , tmpStoreRemains.Remains::TFloat AS Remains
            , (tmpStoreRemains.Remains/DD.MiddleSumm)::TFloat AS RemainsInDays 
            , NotShipped.NotShippedOrder::TFloat AS NotShippedOrder
            , TodayOrder.TodayOrder::TFloat AS TodayOrder
       FROM
           (SELECT MovementItem.objectid AS GoodsId, MILinkObject_GoodsKind.objectid AS GoodsKindId, SUM(COALESCE(MovementItem.Amount, 0))/56 AS MiddleSumm
            FROM Movement 
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                  JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            WHERE Movement.descid = zc_movement_orderexternal()
              AND Movement.OperDate BETWEEN (inOperDate - interval '57 DAY') and (inOperDate - interval '2 DAY') 
              AND MovementLinkObject_To.objectid IN (8458 ,8459)
               GROUP BY MovementItem.objectid, MILinkObject_GoodsKind.objectid
            ) AS DD
           LEFT JOIN (SELECT MovementItem.objectid AS GoodsId, MILinkObject_GoodsKind.objectid AS GoodsKindId, SUM(COALESCE(MovementItem.Amount, 0)) AS NotShippedOrder
                      FROM Movement 
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                ON MovementLinkObject_To.MovementId = Movement.Id
                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                         JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE Movement.descid = zc_movement_orderexternal()
                        AND Movement.OperDate = (inOperDate - interval '1 DAY') 
                        AND MovementDate_OperDatePartner.valuedata = inOperDate
                        AND MovementLinkObject_To.objectid IN (8458 ,8459)
                      GROUP BY MovementItem.objectid, MILinkObject_GoodsKind.objectid) AS NotShipped ON NotShipped.GoodsId = DD.GoodsId AND NotShipped.GoodsKindId = DD.GoodsKindId
                   LEFT JOIN (SELECT MovementItem.objectid AS GoodsId, MILinkObject_GoodsKind.objectid AS GoodsKindId, SUM(COALESCE(MovementItem.Amount, 0)) AS TodayOrder
                              FROM Movement 
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              WHERE Movement.descid = zc_movement_orderexternal()
                                AND Movement.OperDate = inOperDate 
                                AND MovementLinkObject_To.objectid IN (8458 ,8459)
                              GROUP BY MovementItem.objectid, MILinkObject_GoodsKind.objectid) AS TodayOrder ON TodayOrder.GoodsId = DD.GoodsId AND TodayOrder.GoodsKindId = DD.GoodsKindId
                    LEFT JOIN tmpStoreRemains ON tmpStoreRemains.GoodsId = DD.GoodsId AND tmpStoreRemains.GoodsKindId = DD.GoodsKindId
                    LEFT JOIN OBJECT AS ObjectGoods ON ObjectGoods.Id = DD.GoodsId
                    LEFT JOIN OBJECT AS ObjectGoodsKind ON ObjectGoodsKind.Id = DD.GoodsKindId             
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                         ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectGoods.Id
                                        AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                    LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = ObjectGoods.Id 
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
       WHERE MiddleSumm <> 0;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ProductionOrder (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 12.03.15                         * 
*/
-- òåñò
-- select * from gpReport_ProductionOrder(inOperDate := ('30.06.2014')::TDateTime , inUnitId := 0 ,  inSession := '9458');
