-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_Remains_byOrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_byOrderExternal(
    IN inMovementId         Integer   , -- 
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromCode Integer, FromName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , Amount             TFloat
             , AmountSecond       TFloat
             , Amount_Prev        TFloat
             , AmountSecond_Prev  TFloat
             , Amount_Next        TFloat
             , AmountSecond_Next  TFloat
             , Remains_8457       TFloat
             , Remains_8446       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
BEGIN
     -- определяется
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
           INTO vbOperDate, vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     RETURN QUERY
     WITH 
            -- хардкодим - ЦЕХ колбаса+дел-сы
            tmpUnit_8446 AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Реализации
          , tmpUnit_8457   AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)

          , _tmpMI_master AS(SELECT vbFromId                                      AS FromId
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , MovementItem.Amount                           AS Amount
                                  , MIFloat_AmountSecond.ValueData                AS AmountSecond
                             FROM MovementItem 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = False
                             )

            -- Остатки
         /* , tmpContainer_Count AS (SELECT Container.Id          AS ContainerId
                                        , CLO_Unit.ObjectId     AS UnitId
                                        , Container.ObjectId    AS GoodsId
                                        , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                        , Container.Amount
                                   FROM _tmpMI_master
                                        INNER JOIN Container ON Container.ObjectId = _tmpMI_master.GoodsId
                                                            AND Container.DescId = zc_Container_Count()
                                                            AND Container.Amount <> 0
                                        INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                       ON CLO_Unit.ContainerId = Container.Id
                                                                      AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                     
                                        LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                                    AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
    
                                        LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                      ON CLO_GoodsKind.ContainerId = Container.Id
                                                                     AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                                                     
                                   WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                                  )
                              
          , tmpRemains_All AS (SELECT tmpContainer_Count.UnitId
                                    , tmpContainer_Count.GoodsId
                                    , tmpContainer_Count.GoodsKindId
                                    , tmpContainer_Count.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                               FROM tmpContainer_Count
                                    LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                  AND MIContainer.OperDate >= vbOperDate
                                                                                  
                               GROUP BY tmpContainer_Count.ContainerId
                                      , tmpContainer_Count.UnitId
                                      , tmpContainer_Count.GoodsId
                                      , tmpContainer_Count.GoodsKindId
                                      , tmpContainer_Count.Amount
                              )
                       */    
         , tmpRemains_All AS (SELECT CLO_Unit.ObjectId     AS UnitId
                                    , _tmpMI_master.GoodsId AS GoodsId
                                    , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
--                                    , Container.Amount      AS Amount
                                    , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                               FROM _tmpMI_master
                                    INNER JOIN Container ON Container.ObjectId = _tmpMI_master.GoodsId
                                                        AND Container.DescId = zc_Container_Count()
                                                        AND Container.Amount <> 0
                                    INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                   ON CLO_Unit.ContainerId = Container.Id
                                                                  AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= '12.12.2016'--vbOperDate
                                                                                     
                                    LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                  ON CLO_GoodsKind.ContainerId = Container.Id
                                                                 AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                    LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                  ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                               WHERE COALESCE (CLO_GoodsKind.ObjectId, 0) = _tmpMI_master.GoodsKindId
                                 AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                               GROUP BY Container.Id
                                      , CLO_Unit.ObjectId 
                                      , _tmpMI_master.GoodsId, COALESCE (CLO_GoodsKind.ObjectId, 0)
                                      , Container.Amount
                              )
                              
          , tmpRemains_8446 AS (SELECT tmpRemains_All.GoodsId
                                     , tmpRemains_All.GoodsKindId
                                     , tmpRemains_All.UnitId       AS FromId
                                     , SUM (tmpRemains_All.Amount) AS Amount
                                FROM tmpRemains_All
                                     INNER JOIN tmpUnit_8446 ON tmpUnit_8446.UnitId = tmpRemains_All.UnitId
                                GROUP BY tmpRemains_All.GoodsId
                                     , tmpRemains_All.GoodsKindId
                                     , tmpRemains_All.UnitId
                                )
                                
          , tmpRemains_8457 AS (SELECT tmpRemains_All.GoodsId
                                     , tmpRemains_All.GoodsKindId
                                     , tmpRemains_All.UnitId       AS FromId
                                     , SUM (tmpRemains_All.Amount) AS Amount
                                FROM tmpRemains_All
                                     INNER JOIN tmpUnit_8457 ON tmpUnit_8457.UnitId = tmpRemains_All.UnitId
                                GROUP BY tmpRemains_All.GoodsId
                                     , tmpRemains_All.GoodsKindId
                                     , tmpRemains_All.UnitId
                                )
                                
          , tmpOrderExternal AS (SELECT MovementLinkObject_From.ObjectId    AS FromId
                                      , Movement.Id                         AS MovementId
                                      , Movement.OperDate 
                                 FROM Movement
                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     WHERE Movement.OperDate >= vbOperDate
                                       AND Movement.DescId = zc_Movement_OrderExternal()
                                       AND Movement.Id <> inMovementId
                                 )
          , tmpOrderExternal_MI AS (SELECT Movement.FromId         AS FromId
                                         , Movement.OperDate       AS OperDate
                                         , MovementItem.Id         AS MovementItemId
                                         , MovementItem.ObjectId   AS GoodsId
                                         , MovementItem.Amount     AS Amount
          
                                    FROM tmpOrderExternal AS Movement
                                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.MovementId
                                                                AND MovementItem.DescId     = zc_MI_Master()
                                                                AND MovementItem.isErased   = False
                                         INNER JOIN _tmpMI_master ON _tmpMI_master.GoodsId = MovementItem.ObjectId
                                    )
                                    
          , tmpGoodsKind AS (SELECT MILinkObject_GoodsKind.*
                             FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                             WHERE MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpOrderExternal_MI.MovementItemId FROM tmpOrderExternal_MI)
                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             )
               
          , tmpMIFloat_AmountSecond AS (SELECT MIFloat_AmountSecond.*
                             FROM MovementItemFloat AS MIFloat_AmountSecond
                             WHERE MIFloat_AmountSecond.MovementItemId IN (SELECT DISTINCT tmpOrderExternal_MI.MovementItemId FROM tmpOrderExternal_MI)
                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                             )

          , tmpOrderExternal_Its AS (SELECT Movement.FromId                               AS FromId
                                          , Movement.GoodsId                              AS GoodsId
                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , SUM (CASE WHEN Movement.OperDate = vbOperDate - INTERVAL '1 DAY' THEN Movement.Amount ELSE 0 END)                AS Amount_Prev
                                          , SUM (CASE WHEN Movement.OperDate = vbOperDate - INTERVAL '1 DAY' THEN MIFloat_AmountSecond.ValueData ELSE 0 END) AS AmountSecond_Prev
                                          , SUM (CASE WHEN Movement.OperDate >= vbOperDate THEN Movement.Amount ELSE 0 END)                                  AS Amount_Next
                                          , SUM (CASE WHEN Movement.OperDate >= vbOperDate THEN MIFloat_AmountSecond.ValueData ELSE 0 END)                   AS AmountSecond_Next                                          
                                    FROM tmpOrderExternal_MI AS Movement
                                          LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                          LEFT JOIN tmpMIFloat_AmountSecond AS MIFloat_AmountSecond
                                                                            ON MIFloat_AmountSecond.MovementItemId = Movement.MovementItemId
                                    GROUP BY Movement.FromId
                                           , Movement.GoodsId 
                                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                    )

          , tmpData AS (SELECT tmp.GoodsId         AS GoodsId
                             , tmp.GoodsKindId     AS GoodsKindId
                             , tmp.FromId          AS FromId
                             , tmp.Amount          AS Amount
                             , tmp.AmountSecond    AS AmountSecond
                             , 0                   AS Amount_Prev
                             , 0                   AS AmountSecond_Prev
                             , 0                   AS Amount_Next
                             , 0                   AS AmountSecond_Next
                             , 0                   AS Remains_8457
                             , 0                   AS Remains_8446
                        FROM _tmpMI_master AS tmp
                      UNION 
                        SELECT tmp.GoodsId           AS GoodsId
                             , tmp.GoodsKindId       AS GoodsKindId
                             , tmp.FromId            AS FromId
                             , 0                     AS Amount
                             , 0                     AS AmountSecond
                             , tmp.Amount_Prev       AS Amount_Prev
                             , tmp.AmountSecond_Prev AS AmountSecond_Prev
                             , tmp.Amount_Next       AS Amount_Next
                             , tmp.AmountSecond_Next AS AmountSecond_Next
                             , 0                     AS Remains_8457
                             , 0                     AS Remains_8446
                        FROM tmpOrderExternal_Its AS tmp
                      UNION 
                        SELECT tmp.GoodsId           AS GoodsId
                             , tmp.GoodsKindId       AS GoodsKindId
                             , tmp.FromId            AS FromId
                             , 0                     AS Amount
                             , 0                     AS AmountSecond
                             , 0                     AS Amount_Prev
                             , 0                     AS AmountSecond_Prev
                             , 0                     AS Amount_Next
                             , 0                     AS AmountSecond_Next
                             , tmp.Amount            AS Remains_8457
                             , 0                     AS Remains_8446
                        FROM tmpRemains_8446 AS tmp
                      UNION 
                        SELECT tmp.GoodsId           AS GoodsId
                             , tmp.GoodsKindId       AS GoodsKindId
                             , tmp.FromId            AS FromId
                             , 0                     AS Amount
                             , 0                     AS AmountSecond
                             , 0                     AS Amount_Prev
                             , 0                     AS AmountSecond_Prev
                             , 0                     AS Amount_Next
                             , 0                     AS AmountSecond_Next
                             , 0                     AS Remains_8457
                             , tmp.Amount            AS Remains_8446
                        FROM tmpRemains_8446 AS tmp
                       )
                       
      -- Результат
       SELECT Object_From.ObjectCode                     AS FromCode
            , Object_From.ValueData                      AS FromName
            
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsGroup.ValueData                AS GoodsGroupName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
 
            , tmpData.Amount                   :: TFloat AS OrderAmount
            , tmpData.AmountSecond             :: TFloat AS OrderAmountSecond
                                               
            , tmpData.Amount_Prev              :: TFloat
            , tmpData.AmountSecond_Prev        :: TFloat
            , tmpData.Amount_Next              :: TFloat
            , tmpData.AmountSecond_Next        :: TFloat
            , tmpData.Remains_8457             :: TFloat
            , tmpData.Remains_8446             :: TFloat
                                      
       FROM tmpData
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.17         *
*/

-- тест
-- SELECT * FROM gpReport_Remains_byOrderExternal (inMovementId:= 4944965 , inSession:= zfCalc_UserAdmin())
-- select * from gpReport_Remains_byOrderExternal(inMovementId := 4944965 ,  inSession := '5'::TVarChar);