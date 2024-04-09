-- FunctiON: gpReport_ProductionOrder ()

DROP FUNCTION IF EXISTS gpReport_ProductionOrder (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionOrder (
    IN inOperDate            TDateTime ,  
    IN inUnitId              Integer   , 
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (Code Integer, GoodsName TVarChar,
               GoodsKindName TVarChar, GoodsGroupName  TVarChar, MeasureName TVarChar, 
               MiddleOrderSumm TFloat, Remains TFloat, RemainsInDays TFloat, NotShippedOrder TFloat, TodayOrder TFloat,
               ToName TVarChar
               )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);

    IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
    THEN RETURN;
    ELSE

    CREATE TEMP TABLE _tmpUnitGroup (UnitId Integer) ON COMMIT DROP;

    IF inUnitId <> 0
    THEN
        INSERT INTO _tmpUnitGroup (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnitGroup (UnitId)
          SELECT Object.Id FROM Object WHERE Object.Id IN (8458, 8459);
    END IF;

    RETURN QUERY
     WITH /*tmpProductionRemains AS(SELECT ddd.GoodsId, ddd.goodskindid, ddd.partiongoodsid, ObjectDate.valuedata 
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

     , */
       tmpStoreRemains AS (SELECT dd.GoodsId, dd.goodskindid, SUM(StartAmount) AS Remains
                                , dd.ToId
                           FROM (SELECT Container.ObjectId                                           AS GoodsId
                                         , Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)  AS StartAmount
                                         , COALESCE (CLO_GoodsKind.ObjectId, 0)                      AS GoodsKindId
                                         , CLO_Unit.ObjectId AS ToId
                                 FROM _tmpUnitGroup
                                      LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ObjectId = _tmpUnitGroup.UnitId
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                      INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() 
                                      LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                    ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                      LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = Container.Id
                                                                     AND MIContainer.OperDate >= inOperDate

                                 GROUP BY Container.ObjectId, GoodsKindId, Container.Amount, CLO_Unit.ObjectId
                                 HAVING (Container.Amount - COALESCE(SUM (MIContainer.Amount), 0)) <>0 
                                 ) AS dd
                           GROUP BY dd.GoodsId, dd.GoodsKindId, dd.ToId
                           )
   --выбираем все документы по периоду и гр.подразд. кому
   , tmpMovAll AS (SELECT Movement.*
                        , MovementLinkObject_To.ObjectId AS ToId
                   FROM Movement 
                        JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        INNER JOIN _tmpUnitGroup ON _tmpUnitGroup.UnitId = MovementLinkObject_To.objectid
                                
                   WHERE Movement.descid = zc_Movement_OrderExternal()
                     AND Movement.OperDate BETWEEN (inOperDate - interval '57 DAY') and (inOperDate) 
                   )
   -- получаем строки для выбранных документов
   , tmpMovementAll AS (SELECT Movement.Id AS MovementId
                             , Movement.OperDate
                             , MovementItem.ObjectId
                             , COALESCE(MovementItem.Amount, 0) AS Amount
                             , MovementItem.Id
                             , Movement.ToId
                        FROM tmpMovAll AS Movement      
                             JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE         
                        )
    -- для оптимиз. отдельно выбираем св-во GoodsKind для всех строк
    , tmpGoodsKind AS (SELECT *
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                        AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)
                       )

    --- дальше берем данные по 3 промежуткам
    , tmpMovement_DD AS (SELECT Movement.ObjectId                     AS GoodsId
                              , MILinkObject_GoodsKind.ObjectId       AS GoodsKindId
                              , SUM (COALESCE(Movement.Amount, 0))/56 AS MiddleSumm
                              , Movement.ToId
                         FROM tmpMovementAll AS Movement
                              LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = Movement.Id
                         WHERE Movement.OperDate BETWEEN (inOperDate - interval '57 DAY') and (inOperDate - interval '2 DAY') 
                           AND COALESCE (Movement.ObjectId,0) <> 0
                         GROUP BY Movement.ObjectId, MILinkObject_GoodsKind.ObjectId, Movement.ToId
                         HAVING SUM (COALESCE(Movement.Amount, 0))/56 <> 0
                        )

    , tmpNotShipped AS (SELECT Movement.ObjectId                  AS GoodsId
                             , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
                             , SUM (COALESCE(Movement.Amount, 0)) AS NotShippedOrder
                             , Movement.ToId
                        FROM tmpMovementAll AS Movement 
                             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                    ON MovementDate_OperDatePartner.MovementId =  Movement.MovementId
                                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                             LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = Movement.Id
                        WHERE Movement.OperDate = (inOperDate - interval '1 DAY') 
                          AND MovementDate_OperDatePartner.valuedata = inOperDate
                        GROUP BY Movement.ObjectId, MILinkObject_GoodsKind.ObjectId, Movement.ToId
                        )
 
     , tmpTodayOrder AS (SELECT Movement.ObjectId                  AS GoodsId
                              , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
                              , SUM (COALESCE(Movement.Amount, 0)) AS TodayOrder
                              , Movement.ToId
                         FROM tmpMovementAll AS Movement
                              LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = Movement.Id
                         WHERE Movement.OperDate = inOperDate
                         GROUP BY Movement.ObjectId, MILinkObject_GoodsKind.ObjectId, Movement.ToId
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

            , Object_To.ValueData  :: TVarChar AS ToName
       FROM tmpMovement_DD AS DD
           LEFT JOIN tmpNotShipped AS NotShipped
                                   ON NotShipped.GoodsId = DD.GoodsId
                                  AND NotShipped.GoodsKindId = DD.GoodsKindId
                                  AND NotShipped.ToId = DD.ToId
           LEFT JOIN tmpTodayOrder AS TodayOrder 
                                   ON TodayOrder.GoodsId = DD.GoodsId
                                  AND TodayOrder.GoodsKindId = DD.GoodsKindId
                                  AND TodayOrder.ToId = DD.ToId

           LEFT JOIN tmpStoreRemains ON tmpStoreRemains.GoodsId = DD.GoodsId
                                    AND tmpStoreRemains.GoodsKindId = DD.GoodsKindId
                                    AND tmpStoreRemains.ToId = DD.ToId

           LEFT JOIN Object AS ObjectGoods ON ObjectGoods.Id = DD.GoodsId
           LEFT JOIN Object AS ObjectGoodsKind ON ObjectGoodsKind.Id = DD.GoodsKindId             
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectGoods.Id
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = ObjectGoods.Id 
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           
           LEFT JOIN Object AS Object_To ON Object_To.Id = DD.ToId
       ;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.20         *
 12.03.15                         * 
*/
-- тест
-- select * from gpReport_ProductionOrder(inOperDate := ('01.07.2020')::TDateTime , inUnitId := 0 ,  inSession := '9458');
