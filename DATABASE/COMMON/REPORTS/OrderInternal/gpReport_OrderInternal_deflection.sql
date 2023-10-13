-- Function: gpReport_OrderInternal_choice()

DROP FUNCTION IF EXISTS gpReport_OrderInternal_deflection (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_OrderInternal_deflection(
    IN inMovementId        Integer   , --
    IN inIsShowAll          Boolean   , -- свернуть и показать остатки  
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                      Integer
             , GoodsId                 Integer
             , GoodsCode               Integer
             , GoodsName               TVarChar
             , GoodsKindName           TVarChar
             , MeasureName             TVarChar
             , GoodsGroupName          TVarChar
             , GoodsGroupNameFull      TVarChar
             , Amount                  TFloat
             , AmountRemains           TFloat
             , AmountRemains_calc      TFloat
             , AmountRemains_diff      TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbOperDate TDateTime;
   
BEGIN

    vbOperDate :=(SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

    -- остатки
    CREATE TEMP TABLE tmpContainer (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, AmountRK_start TFloat, AmountPrIn TFloat) ON COMMIT DROP;
   
    -- Остатки кол-во для всех подразделений
    INSERT INTO tmpContainer (ContainerId, GoodsId, GoodsKindId, Amount_start, AmountRK_start, AmountPrIn)
       WITH -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
            tmpUnit_CEH AS (SELECT UnitId, TRUE AS isContainer FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Склад Поклейки этикетки
          , tmpUnit_SKLAD   AS (SELECT lfSelect.UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect
                                WHERE lfSelect.UnitId <> 9558031 -- Склад Неликвид
                               UNION
                                -- Склад Поклейки этикетки
                                SELECT 9073781 AS UnitId, FALSE AS isContainer
                               )
            -- Склад Реализации
          , tmpUnit_RK AS (SELECT 8459 AS UnitId)

            -- хардкодим - ВСЕ
          , tmpUnit_all   AS (SELECT UnitId, isContainer FROM tmpUnit_CEH UNION SELECT UnitId, isContainer FROM tmpUnit_SKLAD)
            -- хардкодим - товары ГП
          , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                              , Object_InfoMoney_View.InfoMoneyDestinationId
                              , Object_InfoMoney_View.InfoMoneyId
                         FROM Object_InfoMoney_View
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                         WHERE (Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                             OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- Доходы + Мясное сырье + Мясное сырье
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                        )
       -- Результат - остатки товары ГП
       SELECT tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , SUM (tmp.Amount_start + CASE WHEN tmp.ContainerId > 0 THEN tmp.Amount_next ELSE 0 END) AS Amount_start
            , SUM (tmp.AmountRK_start) AS AmountRK_start
            , SUM (tmp.AmountPrIn) AS AmountPrIn
       FROM (SELECT CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END AS ContainerId
                  , Container.ObjectId                   AS GoodsId
                  , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                    -- 
                  , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_start
                    -- 
                  , CASE WHEN tmpUnit_RK.UnitId > 0 THEN Container.Amount ELSE 0 END - SUM (CASE WHEN tmpUnit_RK.UnitId > 0 THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS AmountRK_start
                    -- 
                  , SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount_next
                  , SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.isActive = TRUE
                               AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                               AND tmpUnit_CEH.UnitId > 0 AND tmpUnit_SKLAD.UnitId > 0
                                   THEN MIContainer.Amount
                              ELSE 0
                         END) AS AmountPrIn
             FROM tmpGoods
                  INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                      AND Container.DescId   = zc_Container_Count()
                  INNER JOIN ContainerLinkObject AS CLO_Unit
                                                 ON CLO_Unit.ContainerId = Container.Id
                                                AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                  INNER JOIN tmpUnit_all ON tmpUnit_all.UnitId = CLO_Unit.ObjectId

                  LEFT JOIN ContainerLinkObject AS CLO_Account
                                                ON CLO_Account.ContainerId = Container.Id
                                               AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                ON CLO_GoodsKind.ContainerId = Container.Id
                                               AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()

                  LEFT JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.ContainerId = Container.Id
                                                 AND MIContainer.OperDate    >= vbOperDate

                  -- ЦЕХ колбаса+дел-сы
                  LEFT JOIN tmpUnit_CEH   ON tmpUnit_CEH.UnitId   = CLO_Unit.ObjectId
                  -- Склады База + Реализации
                  LEFT JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = CLO_Unit.ObjectId
                  -- Склад Реализации
                  LEFT JOIN tmpUnit_RK ON tmpUnit_RK.UnitId = CLO_Unit.ObjectId
                  

             WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
             GROUP BY CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END
                    , Container.ObjectId
                    , COALESCE (CLO_GoodsKind.ObjectId, 0)
                    , Container.Amount
                    , tmpUnit_RK.UnitId
             HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                 OR SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) <> 0
            ) AS tmp
       GROUP BY tmp.ContainerId
              , tmp.GoodsId
              , tmp.GoodsKindId
      ;


     RETURN QUERY
     WITH 
      --Данные из заявки
         tmpMI_master AS (SELECT MovementItem.Id                                AS MovementItemId
                             , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId
                             , MovementItem.ObjectId                          AS GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                             , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0) AS GoodsId_basis
                             , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                       , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                   THEN zc_GoodsKind_Basis()
                                              ELSE 0
                                         END
                                        )                                      AS GoodsKindId_complete
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_AmountSecond.ValueData, 0)    AS AmountSecond
                             , COALESCE (MIFloat_AmountRemains.ValueData, 0)   AS AmountRemains

              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                  
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()  

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                    ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsBasis.DescId = zc_MILinkObject_GoodsBasis()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
              )
 
     , tmpMI_child AS (SELECT MovementItem.Id                                       AS MovementItemId
                            , MovementItem.ObjectId                                 AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId 
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete
                            , MIFloat_ContainerId.ValueData                         AS ContainerId
                            , MovementItem.Amount                                   AS Amount
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       )
       , tmpMI AS (SELECT tmpMI_master.MovementItemId
                      , tmpMI_master.GoodsId
                      , tmpMI_master.GoodsKindId
                      , tmpMI_master.GoodsId_basis
                      , tmpMI_master.ContainerId

                      , tmpMI_master.Amount
                      , (COALESCE (tmpMI_master.AmountRemains,0) + COALESCE (tmpMI_child.Amount,0)) AS AmountRemains 
                 FROM tmpMI_master
                      LEFT JOIN tmpMI_child ON tmpMI_child.GoodsId = tmpMI_master.GoodsId_basis
                                           AND tmpMI_child.GoodsKindId_complete = tmpMI_master.GoodsKindId_complete
                 )

     , tmpData AS (SELECT *
                   FROM (
                  -- результат - для SKLAD
       SELECT tmp.MovementItemId
            , tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , SUM (tmp.Amount_start)   AS AmountRemains_calc
           , SUM (tmp.Amount)                  ::TFloat AS Amount
           , SUM (tmp.AmountRemains)           ::TFloat AS AmountRemains
       FROM (SELECT COALESCE (tmpMI.MovementItemId, 0)                      AS MovementItemId
                  , 0                                                       AS ContainerId
                  , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                  , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                  , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start

           , tmpMI.Amount                  ::TFloat
           , tmpMI.AmountRemains           ::TFloat

             FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId = 0
                  ) AS tmpContainer
                  FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId = 0
                            ) AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                      AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
            ) AS tmp

       GROUP BY tmp.MovementItemId
              , tmp.ContainerId
              , tmp.GoodsId
              , tmp.GoodsKindId
      UNION ALL
       -- результат - для CEH
       SELECT tmpMI.MovementItemId
            , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
            , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
            , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
            , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
            , tmpMI.Amount                  ::TFloat
            , tmpMI.AmountRemains           ::TFloat
       FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId > 0
            ) AS tmpContainer
            FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId > 0
                      ) AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
                  
                   ) AS tmp
           WHERE ( COALESCE (tmp.AmountRemains_calc,0) <> COALESCE (tmp.AmountRemains,0) OR inisShowAll = TRUE)
    AND tmp.MovementItemId > 0
)    

       -- Результат
       SELECT
             tmpData.MovementItemId                     AS Id
           
           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName  
                      
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           --
           , tmpData.Amount                  ::TFloat
           , tmpData.AmountRemains           ::TFloat
           , tmpData.AmountRemains_calc      ::TFloat
           , (COALESCE (tmpData.AmountRemains,0) - COALESCE (tmpData.AmountRemains_calc ,0))  ::TFloat AS AmountRemains_diff


       FROM tmpData
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.23         *
*/

-- тест
--SELECT * FROM gpReport_OrderInternal_deflection (inMovementId:= 26428963::integer , inIsShowAll := true::boolean, inSession:= zfCalc_UserAdmin()::tvarchar)