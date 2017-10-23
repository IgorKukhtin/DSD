-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_Remains_byOrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_byOrderExternal(
    IN inMovementId         Integer   , -- 
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromCode Integer, FromName TVarChar
             , GoodsCode_Main Integer, GoodsName_Main TVarChar, GoodsKindName_Main  TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , PartionGoods TVarChar
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
          , ObjectLink_Juridical_Retail.ChildObjectId --  берем торг.сеть  вместо покупателя  -MovementLinkObject_From.ObjectId
           INTO vbOperDate, vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId --Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
 
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE Movement.Id = inMovementId;

     RETURN QUERY
     WITH 
            -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
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

          -- главный товар
          , tmpReceipt AS (SELECT tmpGoods.GoodsId
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                  END AS ReceiptId_basis
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_1.ObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_2.ObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_3.ObjectId
                                  END AS ReceiptId
                           FROM _tmpMI_master AS tmpGoods
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                     ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                
                                INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                     AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                     AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpGoods.GoodsKindId
                                INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND Object_Receipt.isErased = FALSE
                                INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                         ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                        AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                        AND ObjectBoolean_Main.ValueData = TRUE
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                     ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                    AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()
  
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                     ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_1.DescId = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId = zc_ObjectLink_Receipt_GoodsKind()
  
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                     ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_2.DescId = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId = zc_ObjectLink_Receipt_GoodsKind()
  
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                     ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_3.DescId = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId = zc_ObjectLink_Receipt_GoodsKind()
                          )
                          
          , tmpGoodsBasis AS (SELECT tmp.GoodsId
                                   , ObjectLink_Receipt_Goods_basis.ChildObjectId AS GoodsBasisId
                                   , ObjectLink_Receipt_GoodsKind.ChildObjectId   AS GoodsKindId
                              FROM tmpReceipt AS tmp
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_basis
                                                        ON ObjectLink_Receipt_Goods_basis.ObjectId = tmp.ReceiptId_basis
                                                       AND ObjectLink_Receipt_Goods_basis.DescId = zc_ObjectLink_Receipt_Goods()
           
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId_basis
                                                       AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                             )
                             
          , tmpGoods AS (SELECT _tmpMI_master.GoodsId AS GoodsId
                         FROM _tmpMI_master
                        UNION 
                         SELECT tmpGoodsBasis.GoodsBasisId AS GoodsId
                         FROM tmpGoodsBasis 
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
          , tmpRemains_All AS (SELECT Container.Id         AS ContainerId
                                    , CLO_Unit.ObjectId    AS UnitId
                                    , tmpGoods.GoodsId     AS GoodsId
                                    , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
--                                    , Container.Amount      AS Amount
                                    , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                               FROM tmpGoods
                                    INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                        AND Container.DescId = zc_Container_Count()
                                                        AND Container.Amount <> 0
                                    INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                   ON CLO_Unit.ContainerId = Container.Id
                                                                  AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= vbOperDate
                                                                                     
                                    LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                  ON CLO_GoodsKind.ContainerId = Container.Id
                                                                 AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                    LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                  ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                               WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                               GROUP BY Container.Id
                                      , CLO_Unit.ObjectId 
                                      , tmpGoods.GoodsId, COALESCE (CLO_GoodsKind.ObjectId, 0)
                                      , Container.Amount
                               HAVING  Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                              )
                              
          , tmpRemains_8446 AS (SELECT tmpRemains_All.GoodsId
                                     , tmpRemains_All.GoodsKindId
                                     , tmpRemains_All.UnitId       AS FromId
                                     , COALESCE (ContainerLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                     , SUM (tmpRemains_All.Amount) AS Amount
                                FROM tmpRemains_All
                                     INNER JOIN tmpUnit_8446  ON tmpUnit_8446.UnitId = tmpRemains_All.UnitId
                                     INNER JOIN tmpGoodsBasis ON tmpGoodsBasis.GoodsBasisId = tmpRemains_All.GoodsId
                                  
                                     LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                   ON ContainerLO_PartionGoods.ContainerId = tmpRemains_All.ContainerId
                                                                  AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                GROUP BY tmpRemains_All.GoodsId
                                       , tmpRemains_All.GoodsKindId
                                       , tmpRemains_All.UnitId
                                       , COALESCE (ContainerLO_PartionGoods.ObjectId, 0)
                                )
                                
          , tmpRemains_8457 AS (SELECT tmpRemains_All.GoodsId
                                     , tmpRemains_All.GoodsKindId
                                     , tmpRemains_All.UnitId       AS FromId
                                     , SUM (tmpRemains_All.Amount) AS Amount
                                FROM tmpRemains_All
                                     INNER JOIN tmpUnit_8457 ON tmpUnit_8457.UnitId = tmpRemains_All.UnitId
                                     INNER JOIN _tmpMI_master ON _tmpMI_master.GoodsId = tmpRemains_All.GoodsId
                                                             AND _tmpMI_master.GoodsKindId  = tmpRemains_All.GoodsKindId
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
                                 WHERE Movement.OperDate >= vbOperDate - INTERVAL '1 DAY'
                                   AND Movement.DescId = zc_Movement_OrderExternal()
                                   AND Movement.Id <> inMovementId
                                 )
          , tmpOrderExternal_MI AS (SELECT Movement.FromId         AS FromId
                                         , Movement.OperDate       AS OperDate
                                         , MovementItem.Id         AS MovementItemId
                                         , MovementItem.ObjectId   AS GoodsId
                                         , COALESCE (_tmpMI_master.GoodsKindId, 0)  AS GoodsKindId   -- вид товара исходнойц заявки
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
                                          INNER JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                                 AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (Movement.GoodsKindId, 0)
                                          LEFT JOIN tmpMIFloat_AmountSecond AS MIFloat_AmountSecond
                                                                            ON MIFloat_AmountSecond.MovementItemId = Movement.MovementItemId
                                                            
                                    GROUP BY Movement.FromId
                                           , Movement.GoodsId 
                                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                    )

          , tmpData AS (SELECT tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.GoodsId_Main
                             , tmp.GoodsKindId_Main
                             , tmp.FromId
                             , tmp.PartionGoods
                             , SUM (tmp.Amount)             AS Amount
                             , SUM (tmp.AmountSecond)       AS AmountSecond
                             , SUM (tmp.Amount_Prev)        AS Amount_Prev
                             , SUM (tmp.AmountSecond_Prev)  AS AmountSecond_Prev
                             , SUM (tmp.Amount_Next)        AS Amount_Next
                             , SUM (tmp.AmountSecond_Next)  AS AmountSecond_Next
                             , SUM (tmp.Remains_8457)       AS Remains_8457
                             , SUM (tmp.Remains_8446)       AS Remains_8446
                             
                        FROM (SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , 0                   AS GoodsId_Main
                                   , 0                   AS GoodsKindId_Main
                                   , tmp.FromId          AS FromId
                                   , tmp.Amount          AS Amount
                                   , tmp.AmountSecond    AS AmountSecond
                                   , 0                   AS Amount_Prev
                                   , 0                   AS AmountSecond_Prev
                                   , 0                   AS Amount_Next
                                   , 0                   AS AmountSecond_Next
                                   , 0                   AS Remains_8457
                                   , 0                   AS Remains_8446
                                   , NULL ::TVarChar       AS PartionGoods
                              FROM _tmpMI_master AS tmp
                            UNION 
                              SELECT tmp.GoodsId           AS GoodsId
                                   , tmp.GoodsKindId       AS GoodsKindId
                                   , 0                     AS GoodsId_Main
                                   , 0                     AS GoodsKindId_Main
                                   , tmp.FromId            AS FromId
                                   , 0                     AS Amount
                                   , 0                     AS AmountSecond
                                   , tmp.Amount_Prev       AS Amount_Prev
                                   , tmp.AmountSecond_Prev AS AmountSecond_Prev
                                   , tmp.Amount_Next       AS Amount_Next
                                   , tmp.AmountSecond_Next AS AmountSecond_Next
                                   , 0                     AS Remains_8457
                                   , 0                     AS Remains_8446
                                   , NULL ::TVarChar       AS PartionGoods
                              FROM tmpOrderExternal_Its AS tmp
                            UNION 
                              SELECT tmp.GoodsId           AS GoodsId
                                   , tmp.GoodsKindId       AS GoodsKindId
                                   , 0                     AS GoodsId_Main
                                   , 0                     AS GoodsKindId_Main
                                   , tmp.FromId            AS FromId
                                   , 0                     AS Amount
                                   , 0                     AS AmountSecond
                                   , 0                     AS Amount_Prev
                                   , 0                     AS AmountSecond_Prev
                                   , 0                     AS Amount_Next
                                   , 0                     AS AmountSecond_Next
                                   , tmp.Amount            AS Remains_8457
                                   , 0                     AS Remains_8446
                                   , NULL ::TVarChar       AS PartionGoods
                              FROM tmpRemains_8457 AS tmp
                            UNION 
                              SELECT tmp.GoodsId           AS GoodsId
                                   , tmp.GoodsKindId       AS GoodsKindI
                                   , tmp.GoodsId           AS GoodsId_Main
                                   , tmp.GoodsKindId       AS GoodsKindId_Main
                                   , tmp.FromId            AS FromId
                                   , 0                     AS Amount
                                   , 0                     AS AmountSecond
                                   , 0                     AS Amount_Prev
                                   , 0                     AS AmountSecond_Prev
                                   , 0                     AS Amount_Next
                                   , 0                     AS AmountSecond_Next
                                   , 0                     AS Remains_8457
                                   , tmp.Amount            AS Remains_8446
                                   , Object_PartionGoods.ValueData AS PartionGoods
                              FROM tmpRemains_8446 AS tmp
                                   LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmp.PartionGoodsId
                              ) AS tmp
                        GROUP BY tmp.GoodsId
                               , tmp.GoodsKindId
                               , tmp.GoodsId_Main
                               , tmp.GoodsKindId_Main
                               , tmp.FromId
                               , tmp.PartionGoods
                       )
      , tmpRetail AS (SELECT tmpData.FromId
                           , COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, tmpData.FromId)     AS RetailId
                      FROM (SELECT DISTINCT tmpData.FromId FROM tmpData) AS tmpData
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = tmpData.FromId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                      )         
      , tmpData_Retail AS (SELECT tmpRetail.RetailId                AS FromId
                                , tmpData.GoodsId                   AS GoodsId
                                , tmpData.GoodsKindId               AS GoodsKindId
                                , tmpData.PartionGoods              AS PartionGoods
                                , tmpData.GoodsId_Main              AS GoodsId_Main
                     
                                , SUM (tmpData.Amount)              AS Amount
                                , SUM (tmpData.AmountSecond)        AS AmountSecond
                                , SUM (tmpData.Amount_Prev)         AS Amount_Prev
                                , SUM (tmpData.AmountSecond_Prev)   AS AmountSecond_Prev
                                , SUM (tmpData.Amount_Next)         AS Amount_Next
                                , SUM (tmpData.AmountSecond_Next)   AS AmountSecond_Next
                                , SUM (tmpData.Remains_8457)        AS Remains_8457
                                , SUM (tmpData.Remains_8446)        AS Remains_8446
                           FROM tmpData
                                LEFT JOIN tmpRetail ON tmpRetail.FromId = tmpData.FromId
                           GROUP By tmpRetail.RetailId
                                  , tmpData.GoodsId
                                  , tmpData.GoodsKindId
                                  , tmpData.PartionGoods
                                  , tmpData.GoodsId_Main
                           )
                       
      -- Результат
       SELECT Object_From.ObjectCode                     AS FromCode
            , Object_From.ValueData                      AS FromName
            
            , Object_GoodsBasis.ObjectCode               AS GoodsCode_Main
            , Object_GoodsBasis.ValueData                AS GoodsName_Main
            , Object_GoodsKindBasis.ValueData            AS GoodsKindName_Main

            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            
            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsGroup.ValueData                AS GoodsGroupName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            
            , tmpData.PartionGoods             ::TVarChar
 
            , tmpData.Amount                   :: TFloat AS OrderAmount
            , tmpData.AmountSecond             :: TFloat AS OrderAmountSecond
                                               
            , tmpData.Amount_Prev              :: TFloat
            , tmpData.AmountSecond_Prev        :: TFloat
            , tmpData.Amount_Next              :: TFloat
            , tmpData.AmountSecond_Next        :: TFloat
            , tmpData.Remains_8457             :: TFloat
            , tmpData.Remains_8446             :: TFloat
                                      
       FROM tmpData_Retail AS tmpData
          LEFT JOIN tmpGoodsBasis ON tmpGoodsBasis.GoodsId = tmpData.GoodsId
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
          
          LEFT JOIN Object AS Object_GoodsBasis ON Object_GoodsBasis.Id = COALESCE (tmpGoodsBasis.GoodsBasisId, tmpData.GoodsId_Main)
          LEFT JOIN Object AS Object_GoodsKindBasis ON Object_GoodsKindBasis.Id = COALESCE (tmpGoodsBasis.GoodsKindId, tmpData.GoodsKindId)
          
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
 --select * from gpReport_Remains_byOrderExternal(inMovementId := 7278777 ,  inSession := '5'::TVarChar);