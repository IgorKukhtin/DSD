-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountCheck TFloat
             , PriceIn TFloat, SumPriceIn TFloat
             , PriceUnitFrom TFloat, PriceUnitTo TFloat
             , SummaUnitFrom TFloat, SummaUnitTo TFloat

             , Price TFloat, Summa TFloat, PriceWithVAT TFloat, SummaWithVAT TFloat
             , AmountManual TFloat, AmountStorage TFloat, AmountDiff TFloat, AmountStorageDiff TFloat
             , ReasonDifferencesId Integer, ReasonDifferencesName TVarChar
             , ConditionsKeepName TVarChar
             , MinExpirationDate TDateTime
             , isErased Boolean
             , GoodsGroupName TVarChar
             , NDSKindName    TVarChar
             , NDS            TFloat
             , IsClose    Boolean
             , isTop      Boolean
             , isFirst    Boolean
             , isSecond   Boolean

              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitFromId Integer;
    DECLARE vbUnitToId Integer;
    DECLARE vbisAuto Boolean;
    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDateEnd TDateTime;
    DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT MovementLinkObject_From.ObjectId
         , MovementLinkObject_To.ObjectId
         , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean
         , date_trunc('day', Movement.OperDate)
    INTO vbUnitFromId
       , vbUnitToId 
       , vbisAuto
       , vbOperDate
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.ID
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                  ON MovementBoolean_isAuto.MovementId = Movement.Id
                                 AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
    WHERE Movement.Id = inMovementId;

    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';

    -- торговая сеть текущей аптеки 
    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     AND ObjectLink_Unit_Juridical.ObjectId = vbUnitFromId);

    -- Результат
    IF inShowAll = TRUE
    THEN

        -- Результат такой
        RETURN QUERY
            WITH 
                tmpRemains AS(  SELECT 
                                    Container.ObjectId                  AS GoodsId
                                  , SUM(Container.Amount)::TFloat       AS Amount
                                  , AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
                                  , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                                FROM Container
                                    INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                   ON Container.Id = ContainerLinkObject_Unit.ContainerId 
                                                                  AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit() 
                                                                  AND ContainerLinkObject_Unit.ObjectId = vbUnitFromId
                                    INNER JOIN ContainerLinkObject AS CLI_MI 
                                                                   ON CLI_MI.ContainerId = Container.Id
                                                                  AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    INNER JOIN OBJECT AS Object_PartionMovementItem 
                                                      ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                           ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                      
                                    LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id) 
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount <> 0
                                 -- AND 1=0
                                GROUP BY Container.ObjectId
                              --  HAVING SUM(Container.Amount) <> 0
                             )
         --
         , tmpCheck AS (SELECT MI_Check.ObjectId               AS GoodsId
                             , SUM (MI_Check.Amount) ::TFloat  AS Amount
                        FROM Movement AS Movement_Check
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                            AND MovementLinkObject_Unit.ObjectId = vbUnitFromId
                               INNER JOIN MovementItem AS MI_Check
                                                       ON MI_Check.MovementId = Movement_Check.Id
                                                      AND MI_Check.DescId = zc_MI_Master()
                                                      AND MI_Check.isErased = FALSE
                         WHERE Movement_Check.OperDate >= vbOperDate - INTERVAL '90 DAY' AND Movement_Check.OperDate < vbOperDateEnd
                           AND Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                         GROUP BY MI_Check.ObjectId 
                         HAVING SUM (MI_Check.Amount) <> 0 
                        )

         , MovementItem_Send AS (SELECT MovementItem_Send.Id
                                      , MovementItem_Send.ObjectId
                                      , MovementItem_Send.Amount
                                      , MovementItem_Send.IsErased 
                                      , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId          
                                      
                                      , SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData)/SUM(MIContainer_Count.Amount)  AS PriceIn
                                      , ABS(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData))                           AS SumPriceIn
                                      , COALESCE(MIFloat_PriceFrom.ValueData,0)     AS PriceFrom
                                      , COALESCE(MIFloat_PriceTo.ValueData,0)       AS PriceTo

                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))/SUM(MIContainer_Count.Amount)),0) ::TFloat  AS Price
                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))),0)                               ::TFloat  AS Summa
                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))/SUM(MIContainer_Count.Amount)),0)   ::TFloat  AS PriceWithVAT
                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))),0)                                 ::TFloat  AS SummaWithVAT
                                      , COALESCE(MIFloat_AmountManual.ValueData,0)   ::TFloat  AS AmountManual
                                      , COALESCE(MIFloat_AmountStorage.ValueData,0)  ::TFloat  AS AmountStorage
                                     
                                   FROM MovementItem AS MovementItem_Send
                                       -- цена подразделений записанная при автоматическом распределении 
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                                         ON MIFloat_PriceFrom.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                                         ON MIFloat_PriceTo.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()

                                       LEFT OUTER JOIN MovementItemContainer AS MIContainer_Count
                                                                             ON MIContainer_Count.MovementItemId = MovementItem_Send.Id 
                                                                            AND MIContainer_Count.DescId = zc_Container_Count()
                                                                            AND MIContainer_Count.isActive = True
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                                   ON MIFloat_AmountManual.MovementItemId = MovementItem_Send.Id
                                                                  AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                                                   ON MIFloat_AmountStorage.MovementItemId = MovementItem_Send.Id
                                                                  AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()

                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                                        ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem_Send.Id
                                                                       AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                       
                                       LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                           ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                                          AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                       LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                                              ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                       LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                         ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                       -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                                       LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                                   ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.ID
                                                                  AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                                       LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                                   ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()     
                                                                     
                                   WHERE MovementItem_Send.MovementId = inMovementId
                                     AND MovementItem_Send.DescId = zc_MI_Master()
                                     AND (MovementItem_Send.isErased = FALSE or inIsErased = TRUE)    
                                   GROUP BY MovementItem_Send.Id
                                          , MovementItem_Send.ObjectId
                                          , MovementItem_Send.Amount
                                          , MovementItem_Send.IsErased 
                                          , MILinkObject_ReasonDifferences.ObjectId           
                                          , COALESCE(MIFloat_PriceFrom.ValueData,0)
                                          , COALESCE(MIFloat_PriceTo.ValueData,0) 
                                          , COALESCE(MIFloat_AmountManual.ValueData,0) 
                                          , COALESCE(MIFloat_AmountStorage.ValueData,0) 
                                )

          , tmpPrice AS (SELECT MovementItem_Send.ObjectId     AS GoodsId
                              , ObjectLink_Unit.ChildObjectId  AS UnitId
                              , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                         FROM MovementItem_Send
                              INNER JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ChildObjectId = MovementItem_Send.ObjectId
                                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_Unit
                                                    ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                   AND ObjectLink_Unit.ChildObjectId in (vbUnitFromId, vbUnitToId)
                                                   AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                    ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                   AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                        )

         , tmpGoodsParam AS (SELECT tmp.GoodsId                                                       AS GoodsId
                                  , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
                                  , Object_NDSKind.ValueData                                          AS NDSKindName
                                  , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS 
                                  , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean  AS isClose
                                  , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean  AS isTOP
                                  , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean  AS isFirst
                                  , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean  AS isSecond
                             FROM (SELECT DISTINCT COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId) AS GoodsId
                                   FROM tmpRemains
                                        FULL OUTER JOIN MovementItem_Send ON tmpRemains.GoodsId = MovementItem_Send.ObjectId) AS tmp
                      
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                  
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                          ON ObjectBoolean_Goods_Close.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
                                                         
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                       ON ObjectLink_Goods_NDSKind.ObjectId = tmp.GoodsId
                                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                                  LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                     
                                  LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
                     
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                          ON ObjectBoolean_Goods_TOP.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                                          ON ObjectBoolean_Goods_First.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                                          ON ObjectBoolean_Goods_Second.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second()
                                 )

            -- результат
            SELECT
                COALESCE(MovementItem_Send.Id,0)                  AS Id
              , Object_Goods.Id                                   AS GoodsId
              , Object_Goods.ObjectCode                           AS GoodsCode
              , Object_Goods.ValueData                            AS GoodsName
              , MovementItem_Send.Amount                          AS Amount
              , tmpRemains.Amount::TFloat                         AS AmountRemains
              , tmpCheck.Amount::TFloat                           AS AmountCheck
              , COALESCE(MovementItem_Send.PriceIn, tmpRemains.PriceIn)::TFloat           AS PriceIn
              , COALESCE(MovementItem_Send.SumPriceIn, (MovementItem_Send.Amount * tmpRemains.PriceIn))      ::TFloat  AS SumPriceIn
              , CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END ::TFloat  AS PriceUnitFrom
              , CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END     ::TFloat  AS PriceUnitTo

              , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END)) ::TFloat  AS SummaUnitFrom
              , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END))     ::TFloat  AS SummaUnitTo

              , MovementItem_Send.Price
              , MovementItem_Send.Summa
              , MovementItem_Send.PriceWithVAT
              , MovementItem_Send.SummaWithVAT

              , MovementItem_Send.AmountManual
              , MovementItem_Send.AmountStorage
              , (COALESCE(MovementItem_Send.AmountManual,0) - COALESCE(MovementItem_Send.Amount,0)) ::TFloat as AmountDiff
              , (COALESCE(MovementItem_Send.AmountStorage,0) - COALESCE(MovementItem_Send.Amount,0)) ::TFloat as AmountStorageDiff
              , Object_ReasonDifferences.Id                               AS ReasonDifferencesId
              , Object_ReasonDifferences.ValueData                        AS ReasonDifferencesName
              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
              , tmpRemains.MinExpirationDate   
              , COALESCE(MovementItem_Send.IsErased,FALSE)                AS isErased

              , tmpGoodsParam.GoodsGroupName                              AS GoodsGroupName
              , tmpGoodsParam.NDSKindName                                 AS NDSKindName
              , tmpGoodsParam.NDS                                         AS NDS
              , COALESCE(tmpGoodsParam.isClose, False)        :: Boolean  AS isClose
              , COALESCE(tmpGoodsParam.isTOP, false)          :: Boolean  AS isTOP
              , COALESCE(tmpGoodsParam.isFirst, FALSE)        :: Boolean  AS isFirst
              , COALESCE(tmpGoodsParam.isSecond, FALSE)       :: Boolean  AS isSecond

            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Send ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                LEFT JOIN tmpPrice AS Object_Price_From
                                   ON Object_Price_From.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                  AND Object_Price_From.UnitId = vbUnitFromId
                LEFT JOIN tmpPrice AS Object_Price_To
                                   ON Object_Price_To.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                  AND Object_Price_To.UnitId = vbUnitToId

                LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MovementItem_Send.ReasonDifferencesId
                                  
                LEFT JOIN tmpCheck ON tmpCheck.GoodsId = Object_Goods.Id
                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

                LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)

            WHERE Object_Goods.isErased = FALSE 
               or MovementItem_Send.id is not null;
    ELSE
        -- Результат другой
        RETURN QUERY
        WITH 
           MovementItem_Send AS (SELECT MovementItem.Id
                                      , MovementItem.ObjectId
                                      , MovementItem.Amount
                                      , MovementItem.IsErased  
                                      , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId 
                                                   
                                      , COALESCE(MIFloat_PriceFrom.ValueData,0)      ::TFloat  AS PriceFrom
                                      , COALESCE(MIFloat_PriceTo.ValueData,0)        ::TFloat  AS PriceTo        
                                      , COALESCE(MIFloat_AmountManual.ValueData,0)   ::TFloat  AS AmountManual
                                      , COALESCE(MIFloat_AmountStorage.ValueData,0)  ::TFloat  AS AmountStorage

                                 FROM MovementItem   
                                     -- цена подразделений записанная при автоматическом распределении 
                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                                       ON MIFloat_PriceFrom.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                                       ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                                 ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                                                 ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                                      ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                                )

         , tmpContainer AS (SELECT Container.Id
                                 , Container.ObjectId    AS GoodsId
                                 , SUM(Container.Amount) AS Amount
                                 , Object_PartionMovementItem.ObjectCode  AS MI_Id  -- AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
                            FROM MovementItem_Send
                                INNER JOIN Container ON Container.ObjectId = MovementItem_Send.ObjectId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                               ON Container.Id = ContainerLinkObject_Unit.ContainerId 
                                                              AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit() 
                                                              AND ContainerLinkObject_Unit.ObjectId = vbUnitFromId
 
                                INNER JOIN ContainerLinkObject AS CLI_MI 
                                                               ON CLI_MI.ContainerId = Container.Id
                                                              AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                INNER JOIN OBJECT AS Object_PartionMovementItem 
                                                  ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                            GROUP BY Container.ObjectId
                                   , Object_PartionMovementItem.ObjectCode, Container.Id
                            )

         , tmpMinExpirationDate AS (SELECT tmpContainer.GoodsId
                                         , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                                    FROM tmpContainer
                                         INNER JOIN MovementItem ON MovementItem.Id = tmpContainer.MI_Id
                                         LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                                           ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                         LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id) 
                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     GROUP BY tmpContainer.GoodsId
                                    )

         , tmpRemains AS (SELECT tmpContainer.GoodsId
                               , SUM(tmpContainer.Amount) AS Amount
                               , AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
                          FROM tmpContainer
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = tmpContainer.MI_Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          GROUP BY tmpContainer.GoodsId
                          )

   
         , tmpMIContainer AS (SELECT MovementItem_Send.Id           AS Id
                                   , COALESCE(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData)/SUM(MIContainer_Count.Amount), 0)                              AS PriceIn
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData)), 0)                                                       AS SumPriceIn
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))/SUM(MIContainer_Count.Amount)),0)   AS Price
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))),0)                                 AS Summa
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))/SUM(MIContainer_Count.Amount)),0)     AS PriceWithVAT
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))),0)                                   AS SummaWithVAT
                                   , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                              FROM MovementItem_Send
                                    LEFT OUTER JOIN MovementItemContainer AS MIContainer_Count
                                                 ON MIContainer_Count.MovementItemId = MovementItem_Send.Id 
                                                AND MIContainer_Count.DescId = zc_Container_Count()
                                                AND MIContainer_Count.isActive = True
                                    LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                 ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                                 ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                    -- элемент прихода
                                    LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                                    LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
       
                                    -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                                    LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                               ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.ID
                                              AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                    -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                                    LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                               ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                              AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
       
                                   -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                          ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                   -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                             
                                   LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                          ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id) 
                                         AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
       
                              GROUP BY MovementItem_Send.Id    
                              )

         , tmpCheck AS (SELECT MI_Check.ObjectId                    AS GoodsId
                             , SUM (MI_Check.Amount) ::TFloat  AS Amount
                        FROM Movement AS Movement_Check
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                            AND MovementLinkObject_Unit.ObjectId = vbUnitFromId
                               INNER JOIN MovementItem AS MI_Check
                                                       ON MI_Check.MovementId = Movement_Check.Id
                                                      AND MI_Check.DescId = zc_MI_Master()
                                                      AND MI_Check.isErased = FALSE
                         WHERE Movement_Check.OperDate >= vbOperDate - INTERVAL '90 DAY' AND Movement_Check.OperDate < vbOperDateEnd
                          AND Movement_Check.DescId = zc_Movement_Check()
                          AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY MI_Check.ObjectId 
                        HAVING SUM (MI_Check.Amount) <> 0 
                        )


         , tmpPrice AS (SELECT MovementItem_Send.ObjectId     AS GoodsId
                             , ObjectLink_Unit.ChildObjectId  AS UnitId
                             , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                        FROM MovementItem_Send
                             INNER JOIN ObjectLink AS ObjectLink_Goods
                                                   ON ObjectLink_Goods.ChildObjectId = MovementItem_Send.ObjectId
                                                  AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                             INNER JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                  AND ObjectLink_Unit.ChildObjectId in (vbUnitFromId, vbUnitToId)
                                                  AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                   ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                  AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                       )
         , tmpGoodsParam AS (SELECT tmp.GoodsId     -- товар сети
                                  , Object_GoodsGroup.ValueData                                       AS GoodsGroupName  
                                  , Object_NDSKind.ValueData                                          AS NDSKindName
                                  , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS 
                                  , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean  AS isClose
                                  , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean  AS isTOP
                                  , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean  AS isFirst
                                  , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean  AS isSecond
                             FROM (SELECT DISTINCT MovementItem_Send.ObjectId AS GoodsId
                                   FROM MovementItem_Send) AS tmp
                      
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                  
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                          ON ObjectBoolean_Goods_Close.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
                                                         
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                       ON ObjectLink_Goods_NDSKind.ObjectId = tmp.GoodsId
                                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                                  LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                     
                                  LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
                     
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                          ON ObjectBoolean_Goods_TOP.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                                          ON ObjectBoolean_Goods_First.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                                          ON ObjectBoolean_Goods_Second.ObjectId = tmp.GoodsId
                                                         AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second()
                                 )

       -- результат
       SELECT
             MovementItem_Send.Id                              AS Id
           , Object_Goods.Id                                   AS GoodsId
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName

           , MovementItem_Send.Amount                          AS Amount
           , tmpRemains.Amount ::TFloat                        AS AmountRemains
           , tmpCheck.Amount   ::TFloat                        AS AmountCheck

           , COALESCE (tmpMIContainer.PriceIn , tmpRemains.PriceIn)                               ::TFloat         AS PriceIn
           , COALESCE (tmpMIContainer.SumPriceIn,(MovementItem_Send.Amount * tmpRemains.PriceIn)) ::TFloat         AS SumPriceIn

           , CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END ::TFloat  AS PriceUnitFrom
           , CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END     ::TFloat  AS PriceUnitTo

           , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END)) ::TFloat  AS SummaUnitFrom
           , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END))     ::TFloat  AS SummaUnitTo

           , tmpMIContainer.Price            ::TFloat  AS Price
           , tmpMIContainer.Summa            ::TFloat  AS Summa
           , tmpMIContainer.PriceWithVAT     ::TFloat  AS PriceWithVAT
           , tmpMIContainer.SummaWithVAT     ::TFloat  AS SummaWithVAT

           , MovementItem_Send.AmountManual
           , MovementItem_Send.AmountStorage
           , (COALESCE(MovementItem_Send.AmountManual,0) - COALESCE(MovementItem_Send.Amount,0)) ::TFloat AS AmountDiff
           , (COALESCE(MovementItem_Send.AmountStorage,0) - COALESCE(MovementItem_Send.Amount,0))::TFloat AS AmountStorageDiff
           , Object_ReasonDifferences.Id                               AS ReasonDifferencesId
           , Object_ReasonDifferences.ValueData                        AS ReasonDifferencesName
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
           --, tmpMIContainer.MinExpirationDate   
           , CASE WHEN MovementItem_Send.Amount <> 0 THEN tmpMIContainer.MinExpirationDate ELSE COALESCE (tmpMinExpirationDate.MinExpirationDate, tmpMIContainer.MinExpirationDate) END AS MinExpirationDate
           , MovementItem_Send.IsErased                                AS isErased

           , tmpGoodsParam.GoodsGroupName                                      AS GoodsGroupName
           , tmpGoodsParam.NDSKindName                                         AS NDSKindName
           , tmpGoodsParam.NDS                                                 AS NDS
           , COALESCE(tmpGoodsParam.isClose, False)                :: Boolean  AS isClose
           , COALESCE(tmpGoodsParam.isTOP, false)                  :: Boolean  AS isTOP
           , COALESCE(tmpGoodsParam.isFirst, FALSE)                :: Boolean  AS isFirst
           , COALESCE(tmpGoodsParam.isSecond, FALSE)               :: Boolean  AS isSecond

       FROM MovementItem_Send
            LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem_Send.ObjectId
            LEFT JOIN tmpPrice AS Object_Price_From
                               ON Object_Price_From.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                              AND Object_Price_From.UnitId = vbUnitFromId
            LEFT JOIN tmpPrice AS Object_Price_To
                               ON Object_Price_To.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                              AND Object_Price_To.UnitId = vbUnitToId

             LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MovementItem_Send.ReasonDifferencesId

            LEFT JOIN tmpMIContainer ON  tmpMIContainer.Id = MovementItem_Send.Id 

            LEFT JOIN tmpCheck ON tmpCheck.GoodsId = Object_Goods.Id
            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            
            LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = MovementItem_Send.ObjectId

            LEFT JOIN tmpMinExpirationDate ON tmpMinExpirationDate.GoodsId = MovementItem_Send.ObjectId
                                          AND MovementItem_Send.Amount = 0
;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   
 05.02.19         * add AmountStorage 
 21.03.17         *
 22.01.17         *
 26.01.17         *
 15.01.17         * без вьюх
 12.11.17         * 
 27.10.16         *
 20.06.16         *
 10.05.16         *
 15.10.14         * add Price, Storage_Partion
 04.08.14                                        * add Object_InfoMoney_View
 04.08.14         * add zc_MILinkObject_Unit
                        zc_MILinkObject_Storage
                        zc_MILinkObject_PartionGoods
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add FuelName and tmpUserTransport
 30.10.13                       *            FULL JOIN
 29.10.13                       *            add GoodsKindId
 22.07.13         * add Count
 18.07.13         * add Object_Asset
 12.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
--select * from gpSelect_MovementItem_Send(inMovementId := 3957473 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');select * from gpSelect_MovementItem_Send(inMovementId := 3722388 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');