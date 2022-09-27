-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartionDateKindId Integer, PartionDateKindName TVarChar
             
             , Amount TFloat, AmountRemains TFloat, AmountCheck TFloat
             , PriceIn TFloat, SumPriceIn TFloat
             , PriceUnitFrom TFloat, PriceUnitTo TFloat
             , SummaUnitFrom TFloat, SummaUnitTo TFloat
             , RemainsFrom TFloat, RemainsTo TFloat
             , ValueFrom TFloat, ValueTo TFloat

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
             , AccommodationId Integer, AccommodationName TVarChar
             , DateInsertChild TDateTime , DateInsert TDateTime
             , isPromo Boolean
             , CommentSendId Integer, CommentSendCode Integer, CommentSendName TVarChar
             , TechnicalRediscountID Integer, TechnicalRediscountInvNumber TVarChar, TechnicalRediscountOperDate TDateTime
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitFromId Integer;
    DECLARE vbUnitToId Integer;
    DECLARE vbisAuto Boolean;
    DECLARE vbIsSUN Boolean;
    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDateEnd TDateTime;
    DECLARE vbRetailId Integer;
    DECLARE vbisDeferred Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT MovementLinkObject_From.ObjectId
         , MovementLinkObject_To.ObjectId
         , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean
         , date_trunc('day', Movement.OperDate)
         , (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE) :: Boolean
         , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
    INTO vbUnitFromId
       , vbUnitToId 
       , vbisAuto
       , vbOperDate
       , vbIsSUN
       , vbisDeferred
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

        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
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

         , tmpMIContainerSend AS (SELECT COALESCE(MISend.ParentID, MIContainer_Count.MovementItemId) AS MovementItemId
                                       , MIContainer_Count.Amount                   AS Amount
                                       , COALESCE (MI_Income_find.Id,MovementItem.Id) AS MIIncomeID
                                  FROM MovementItemContainer AS MIContainer_Count
                                 
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem AS MISend
                                                                     ON MISend.Id = MIContainer_Count.MovementItemID
                                                                      
                                        LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                     ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                    AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                                     ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

                                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                               ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
       
                                  WHERE MIContainer_Count.MovementId = inMovementId 
                                    AND MIContainer_Count.DescId = zc_Container_Count()
                                    AND MIContainer_Count.isActive = NOT vbisDeferred)   
         , tmpMIContainerAll AS (SELECT MIContainer_Count.MovementItemId           AS MovementItemId
                                      , MIContainer_Count.Amount                   AS Amount
                                      , MIFloat_Price.ValueData                    AS Price
                                      , MIFloat_JuridicalPrice.ValueData           AS JuridicalPrice
                                      , MIFloat_PriceWithVAT.ValueData             AS PriceWithVAT 
                                      , COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd())::TDateTime AS MinExpirationDate -- Срок годности
                                 FROM tmpMIContainerSend AS MIContainer_Count
                               
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MIContainer_Count.MIIncomeID
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
       
                                       -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                                       LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                  ON MIFloat_JuridicalPrice.MovementItemId = MIContainer_Count.MIIncomeID 
                                                 AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                                       LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                  ON MIFloat_PriceWithVAT.MovementItemId = MIContainer_Count.MIIncomeID
                                                 AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                    
                                      LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = MIContainer_Count.MIIncomeID 
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                 )
         , MovementItem_Send AS (SELECT MovementItem_Send.Id
                                      , MovementItem_Send.ObjectId
                                      , MovementItem_Send.Amount
                                      , MovementItem_Send.IsErased 
                                      , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
                                      , MILinkObject_PartionDateKind.ObjectId   AS PartionDateKindId
                                      
                                      , SUM(MIContainer_Count.Amount * MIContainer_Count.Price)/SUM(MIContainer_Count.Amount)  AS PriceIn
                                      , ABS(SUM(MIContainer_Count.Amount * MIContainer_Count.Price))                           AS SumPriceIn
                                      , COALESCE(MIFloat_PriceFrom.ValueData,0)     AS PriceFrom
                                      , COALESCE(MIFloat_PriceTo.ValueData,0)       AS PriceTo

                                      , SUM (COALESCE(MIFloat_RemainsFrom.ValueData,0))   AS RemainsFrom
                                      , SUM (COALESCE(MIFloat_RemainsTo.ValueData,0))     AS RemainsTo
                                      , SUM (COALESCE(MIFloat_ValueFrom.ValueData,0))     AS ValueFrom
                                      , SUM (COALESCE(MIFloat_ValueTo.ValueData,0))       AS ValueTo

                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.JuridicalPrice, 0))/SUM(MIContainer_Count.Amount)),0) ::TFloat  AS Price
                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.JuridicalPrice, 0))),0)                               ::TFloat  AS Summa
                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.PriceWithVAT, 0))/SUM(MIContainer_Count.Amount)),0)   ::TFloat  AS PriceWithVAT
                                      , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.PriceWithVAT, 0))),0)                                 ::TFloat  AS SummaWithVAT
                                      , COALESCE(MIFloat_AmountManual.ValueData,0)   ::TFloat  AS AmountManual
                                      , COALESCE(MIFloat_AmountStorage.ValueData,0)  ::TFloat  AS AmountStorage
                                      , MIDate_Insert.ValueData                                AS DateInsert

                                      , MovementTR.ID                                          AS TechnicalRediscountID
                                      , MovementTR.InvNumber                                   AS TechnicalRediscountInvNumber
                                      , MovementTR.OperDate                                    AS TechnicalRediscountOperDate
                                      
                                   FROM MovementItem AS MovementItem_Send
                                       -- цена подразделений записанная при автоматическом распределении 
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                                         ON MIFloat_PriceFrom.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                                         ON MIFloat_PriceTo.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()

                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_RemainsFrom
                                                                         ON MIFloat_RemainsFrom.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_RemainsFrom.DescId = zc_MIFloat_RemainsFrom()
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_RemainsTo
                                                                         ON MIFloat_RemainsTo.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_RemainsTo.DescId = zc_MIFloat_RemainsTo()
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_ValueFrom
                                                                         ON MIFloat_ValueFrom.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_ValueFrom.DescId = zc_MIFloat_ValueFrom()
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_ValueTo
                                                                         ON MIFloat_ValueTo.MovementItemId = MovementItem_Send.ID
                                                                        AND MIFloat_ValueTo.DescId = zc_MIFloat_ValueTo()

                                       LEFT OUTER JOIN tmpMIContainerAll AS MIContainer_Count
                                                                         ON MIContainer_Count.MovementItemId = MovementItem_Send.Id 
                                                                         
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                                   ON MIFloat_AmountManual.MovementItemId = MovementItem_Send.Id
                                                                  AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                                                   ON MIFloat_AmountStorage.MovementItemId = MovementItem_Send.Id
                                                                  AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()

                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                                        ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem_Send.Id
                                                                       AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                       -- 
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                        ON MILinkObject_PartionDateKind.MovementItemId = MovementItem_Send.Id
                                                                       AND MILinkObject_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
                                                                     
                                       LEFT JOIN MovementItemDate AS MIDate_Insert
                                                                  ON MIDate_Insert.MovementItemId = MovementItem_Send.Id
                                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()

                                       LEFT JOIN MovementItemFloat AS MIFloat_MITRId
                                                                   ON MIFloat_MITRId.MovementItemId = MovementItem_Send.Id
                                                                   AND MIFloat_MITRId.DescId = zc_MIFloat_MITechnicalRediscountId()
                                                                                                                             
                                       LEFT JOIN MovementItem AS MITR ON MITR.ID = MIFloat_MITRId.ValueData::Integer

                                       LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITR.MovementId

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
                                          , MILinkObject_PartionDateKind.ObjectId
                                          , MIDate_Insert.ValueData  
                                          , MovementTR.ID   
                                          , MovementTR.InvNumber
                                          , MovementTR.OperDate 
                                )

          , tmpPrice AS (SELECT MovementItem_Send.ObjectId     AS GoodsId
                              , ObjectLink_Unit.ChildObjectId  AS UnitId
                              , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                         FROM (SELECT DISTINCT MovementItem_Send.ObjectId
                              FROM MovementItem_Send) AS MovementItem_Send
                              
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
          , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                , ObjectFloat_NDSKind_NDS.ValueData
                           FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                           WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                           )
         , tmpGoodsParam AS (SELECT Object_Goods_Retail.Id                                            AS GoodsId
                                  , Object_Goods_Main.Id                                              AS GoodsMainId
                                  , Object_Goods_Main.ObjectCode                                      AS GoodsCode
                                  , Object_Goods_Main.Name                                            AS GoodsName
                                  , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
                                  , Object_NDSKind.ValueData                                          AS NDSKindName
                                  , Object_ConditionsKeep.ValueData                                   AS ConditionsKeepName
                                  , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS 
                                  , COALESCE(Object_Goods_Main.isClose, False)    :: Boolean          AS isClose
                                  , COALESCE(Object_Goods_Retail.isTOP, false)    :: Boolean          AS isTOP
                                  , COALESCE(Object_Goods_Retail.isFirst, False)  :: Boolean          AS isFirst
                                  , COALESCE(Object_Goods_Retail.isSecond, False) :: Boolean          AS isSecond
                                  , Object_Goods_Retail.isErased
                             FROM Object_Goods_Retail 
                             
                                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                  
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
                                  LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = Object_Goods_Main.NDSKindId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_Retail.Id
                                                      AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                  LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
                                     
                                  LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                     ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                                     
                             WHERE Object_Goods_Retail.RetailId = vbRetailId 
                                 )
         , tmpMI_Child AS (SELECT MovementItem.ParentId
                                , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                                , MAX(DATE_TRUNC ('DAY', MIDate_Insert.ValueData))                   AS DateInsertChild
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_Container
                                                             ON MIFloat_Container.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Container.DescId = zc_MIFloat_ContainerId()
                                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIFloat_Container.ValueData::Integer
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                     ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                    AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                                  ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Child()
                             AND MovementItem.IsErased = FALSE
                           GROUP BY MovementItem.ParentId
                          )
            -- Товары из Маркетинговых контрактов
          , tmpPromo AS (SELECT DISTINCT  Object_Goods_Retail.GoodsMainId  AS GoodsId  
                         FROM Movement
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                     AND MovementDate_StartPromo.ValueData <= vbOperDate
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                     AND MovementDate_EndPromo.ValueData >= vbOperDate
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                              LEFT OUTER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_Goods.ObjectId
                         WHERE Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_Promo()
                        )

          , tmpOL_Goods_ConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.*
                                           FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                           WHERE ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT Object_Goods_Retail.Id FROM Object_Goods_Retail WHERE Object_Goods_Retail.RetailId = vbRetailId)
                                             AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                           )
          , tmpMovementItem_Send AS (SELECT COALESCE(MovementItem_Send.ObjectId, tmpRemains.GoodsId)  AS ObjectId
                                          , MovementItem_Send.Id
                                          , MovementItem_Send.Amount
                                          , MovementItem_Send.IsErased 
                                          , MovementItem_Send.ReasonDifferencesId
                                          , MovementItem_Send.PartionDateKindId
                                                            
                                          , COALESCE (MovementItem_Send.PriceIn, tmpRemains.PriceIn) AS PriceIn
                                          , MovementItem_Send.SumPriceIn
                                          , MovementItem_Send.PriceFrom
                                          , MovementItem_Send.PriceTo

                                          , MovementItem_Send.RemainsFrom
                                          , MovementItem_Send.RemainsTo
                                          , MovementItem_Send.ValueFrom
                                          , MovementItem_Send.ValueTo

                                          , MovementItem_Send.Price
                                          , MovementItem_Send.Summa
                                          , MovementItem_Send.PriceWithVAT
                                          , MovementItem_Send.SummaWithVAT
                                          , MovementItem_Send.AmountManual
                                          , MovementItem_Send.AmountStorage
                                          , MovementItem_Send.DateInsert

                                          , MovementItem_Send.TechnicalRediscountID
                                          , MovementItem_Send.TechnicalRediscountInvNumber
                                          , MovementItem_Send.TechnicalRediscountOperDate      
                                           
                                          , tmpRemains.Amount                         AS AmountRemains
                                          , tmpRemains.MinExpirationDate
                                     FROM tmpRemains
                                          FULL JOIN MovementItem_Send ON tmpRemains.GoodsId = MovementItem_Send.ObjectId)

            -- результат
            SELECT
                COALESCE(MovementItem_Send.Id,0)                  AS Id
              , tmpGoodsParam.GoodsId                             AS GoodsId
              , tmpGoodsParam.GoodsCode                           AS GoodsCode
              , tmpGoodsParam.GoodsName                           AS GoodsName
              , Object_PartionDateKind.Id                         AS PartionDateKindId
              , Object_PartionDateKind.ValueData      :: TVarChar AS PartionDateKindName
              , MovementItem_Send.Amount                          AS Amount
              , MovementItem_Send.AmountRemains::TFloat           AS AmountRemains
              , tmpCheck.Amount::TFloat                           AS AmountCheck
              , MovementItem_Send.PriceIn::TFloat                 AS PriceIn
              , COALESCE (MovementItem_Send.SumPriceIn, (MovementItem_Send.Amount * MovementItem_Send.PriceIn))      ::TFloat  AS SumPriceIn
              , CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END ::TFloat  AS PriceUnitFrom
              , CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END     ::TFloat  AS PriceUnitTo

              , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END)) ::TFloat  AS SummaUnitFrom
              , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END))     ::TFloat  AS SummaUnitTo
              
              , MovementItem_Send.RemainsFrom  ::TFloat
              , MovementItem_Send.RemainsTo    ::TFloat
              , MovementItem_Send.ValueFrom    ::TFloat
              , MovementItem_Send.ValueTo      ::TFloat

              , MovementItem_Send.Price
              , MovementItem_Send.Summa
              , MovementItem_Send.PriceWithVAT
              , MovementItem_Send.SummaWithVAT

              , MovementItem_Send.AmountManual
              , MovementItem_Send.AmountStorage
              , (COALESCE (MovementItem_Send.AmountManual,0) - COALESCE(MovementItem_Send.Amount,0)) ::TFloat as AmountDiff
              , (COALESCE (MovementItem_Send.AmountStorage,0) - COALESCE(MovementItem_Send.Amount,0)) ::TFloat as AmountStorageDiff
              , Object_ReasonDifferences.Id                                AS ReasonDifferencesId
              , Object_ReasonDifferences.ValueData                         AS ReasonDifferencesName
              , tmpGoodsParam.ConditionsKeepName                           AS ConditionsKeepName
              , COALESCE (tmpMI_Child.ExpirationDate, MovementItem_Send.MinExpirationDate)::TDateTime AS MinExpirationDate   

              , COALESCE (MovementItem_Send.IsErased,FALSE)                AS isErased

              , tmpGoodsParam.GoodsGroupName                               AS GoodsGroupName
              , tmpGoodsParam.NDSKindName                                  AS NDSKindName
              , tmpGoodsParam.NDS                                          AS NDS
              , COALESCE(tmpGoodsParam.isClose, False)        :: Boolean   AS isClose
              , COALESCE(tmpGoodsParam.isTOP, false)          :: Boolean   AS isTOP
              , COALESCE(tmpGoodsParam.isFirst, FALSE)        :: Boolean   AS isFirst
              , COALESCE(tmpGoodsParam.isSecond, FALSE)       :: Boolean   AS isSecond

              , Accommodation.AccommodationId                              AS AccommodationId
              , Object_Accommodation.ValueData                             AS AccommodationName
              , tmpMI_Child.DateInsertChild::TDateTime                     AS DateInsertChild
              , MovementItem_Send.DateInsert                               AS DateInsert
   
              , COALESCE(tmpPromo.GoodsId, 0) <> 0                               AS isPromo

              , Object_CommentSend.Id                                                 AS CommentTRId
              , Object_CommentSend.ObjectCode                                         AS CommentTRCode
              , Object_CommentSend.ValueData                                          AS CommentTRName

              , MovementItem_Send.TechnicalRediscountID                             AS TechnicalRediscountID
              , MovementItem_Send.TechnicalRediscountInvNumber                      AS TechnicalRediscountInvNumber
              , MovementItem_Send.TechnicalRediscountOperDate                       AS TechnicalRediscountOperDate

            FROM tmpMovementItem_Send AS MovementItem_Send 

                LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = MovementItem_Send.ObjectId

                LEFT JOIN tmpPrice AS Object_Price_From
                                   ON Object_Price_From.GoodsId = tmpGoodsParam.GoodsId
                                  AND Object_Price_From.UnitId = vbUnitFromId
                LEFT JOIN tmpPrice AS Object_Price_To
                                   ON Object_Price_To.GoodsId = tmpGoodsParam.GoodsId
                                  AND Object_Price_To.UnitId = vbUnitToId

                LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MovementItem_Send.ReasonDifferencesId
                LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementItem_Send.PartionDateKindId
                                  
                LEFT JOIN tmpCheck ON tmpCheck.GoodsId = tmpGoodsParam.GoodsId

                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem_Send.Id 

                LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                       ON Accommodation.UnitId = vbUnitFromId
                                                      AND Accommodation.GoodsId = tmpGoodsParam.GoodsId
                                                      AND Accommodation.isErased = False
                -- Размещение товара
                LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId

                LEFT JOIN tmpPromo ON tmpPromo.GoodsId = tmpGoodsParam.GoodsMainId
                
                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                 ON MILinkObject_CommentSend.MovementItemId = MovementItem_Send.Id
                                                AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                LEFT JOIN Object AS Object_CommentSend
                                 ON Object_CommentSend.ID = MILinkObject_CommentSend.ObjectId

            WHERE tmpGoodsParam.isErased = FALSE 
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
                                      , MILinkObject_PartionDateKind.ObjectId   AS PartionDateKindId
                                                   
                                      , COALESCE(MIFloat_PriceFrom.ValueData,0)      ::TFloat  AS PriceFrom
                                      , COALESCE(MIFloat_PriceTo.ValueData,0)        ::TFloat  AS PriceTo        
                                      , COALESCE(MIFloat_AmountManual.ValueData,0)   ::TFloat  AS AmountManual
                                      , COALESCE(MIFloat_AmountStorage.ValueData,0)  ::TFloat  AS AmountStorage
                                      , MIDate_Insert.ValueData                                AS DateInsert

                                      , COALESCE(MIFloat_RemainsFrom.ValueData,0)   AS RemainsFrom
                                      , COALESCE(MIFloat_RemainsTo.ValueData,0)     AS RemainsTo
                                      , COALESCE(MIFloat_ValueFrom.ValueData,0)     AS ValueFrom
                                      , COALESCE(MIFloat_ValueTo.ValueData,0)       AS ValueTo

                                      , MovementTR.ID                                          AS TechnicalRediscountID
                                      , MovementTR.InvNumber                                   AS TechnicalRediscountInvNumber
                                      , MovementTR.OperDate                                    AS TechnicalRediscountOperDate
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

                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_RemainsFrom
                                                                       ON MIFloat_RemainsFrom.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_RemainsFrom.DescId = zc_MIFloat_RemainsFrom()
                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_RemainsTo
                                                                       ON MIFloat_RemainsTo.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_RemainsTo.DescId = zc_MIFloat_RemainsTo()
                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_ValueFrom
                                                                       ON MIFloat_ValueFrom.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_ValueFrom.DescId = zc_MIFloat_ValueFrom()
                                     LEFT OUTER JOIN MovementItemFloat AS MIFloat_ValueTo
                                                                       ON MIFloat_ValueTo.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_ValueTo.DescId = zc_MIFloat_ValueTo()

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                                      ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                      ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
                                     LEFT JOIN MovementItemDate AS MIDate_Insert
                                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()

                                     LEFT JOIN MovementItemFloat AS MIFloat_MITRId
                                                                 ON MIFloat_MITRId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_MITRId.DescId = zc_MIFloat_MITechnicalRediscountId()
                                                                                                   
                                     LEFT JOIN MovementItem AS MITR ON MITR.ID = MIFloat_MITRId.ValueData::Integer

                                     LEFT JOIN Movement AS MovementTR ON MovementTR.ID = MITR.MovementId
                                     
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                                )
         , MovementItem_Send_All AS (SELECT MovementItem.Id
                                          , MovementItem.ParentId
                                     FROM MovementItem   
                                     WHERE MovementItem.MovementId = inMovementId 
                                       AND MovementItem.isErased = False
                                    )

         , tmpContainer AS (SELECT Container.Id
                                 , Container.ObjectId    AS GoodsId
                                 , SUM(Container.Amount) AS Amount
                                 , Object_PartionMovementItem.ObjectCode ::Integer AS MI_Id  -- AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
                            FROM (SELECT DISTINCT MovementItem_Send.ObjectId
                                  FROM MovementItem_Send) AS MovementItem_Send
                                   
                                INNER JOIN Container ON Container.ObjectId = MovementItem_Send.ObjectId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.WhereObjectId = vbUnitFromId
                                                    AND Container.Amount <> 0
 
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
                          
         , tmpMIContainerSend AS (SELECT COALESCE(MISend.ParentID, MIContainer_Count.MovementItemId) AS MovementItemId
                                       , MIContainer_Count.Amount                   AS Amount
                                       , COALESCE (MI_Income_find.Id,MovementItem.Id) AS MIIncomeID
                                  FROM MovementItemContainer AS MIContainer_Count
                                 
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem AS MISend
                                                                     ON MISend.Id = MIContainer_Count.MovementItemID
                                                                      
                                        LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                     ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                    AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN Object AS Object_PartionMovementItem 
                                                     ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        -- элемент прихода
                                        LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

                                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                               ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
       
                                  WHERE MIContainer_Count.MovementId = inMovementId 
                                    AND MIContainer_Count.DescId = zc_Container_Count()
                                    AND MIContainer_Count.isActive = NOT vbisDeferred
                                  )   

         , tmpMIDate_PartionGoods AS (SELECT MIDate_PartionGoods.*
                                      FROM MovementItemDate AS MIDate_PartionGoods
                                      WHERE MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                        AND MIDate_PartionGoods.MovementItemId IN (SELECT DISTINCT tmpMIContainerSend.MIIncomeID FROM tmpMIContainerSend)
                             )
                             
         , tmpMIContainerAll AS (SELECT MIContainer_Count.MovementItemId           AS MovementItemId
                                      , MIContainer_Count.Amount                   AS Amount
                                      , MIFloat_Price.ValueData                    AS Price
                                      , MIFloat_JuridicalPrice.ValueData           AS JuridicalPrice
                                      , MIFloat_PriceWithVAT.ValueData             AS PriceWithVAT 
                                      , COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd())::TDateTime AS MinExpirationDate -- Срок годности
                                 FROM tmpMIContainerSend AS MIContainer_Count
                               
                                       LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MIContainer_Count.MIIncomeID
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
       
                                       -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                                       LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                  ON MIFloat_JuridicalPrice.MovementItemId = MIContainer_Count.MIIncomeID 
                                                 AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                       -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                                       LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                  ON MIFloat_PriceWithVAT.MovementItemId = MIContainer_Count.MIIncomeID
                                                 AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                    
                                      LEFT JOIN tmpMIDate_PartionGoods  AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = MIContainer_Count.MIIncomeID 
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                 )
         , tmpMIContainer AS (SELECT COALESCE(MovementItem_Send_All.ParentId, MovementItem_Send_All.Id)           AS Id
                                   , COALESCE(SUM(MIContainer_Count.Amount * MIContainer_Count.Price)/SUM(MIContainer_Count.Amount), 0)                              AS PriceIn
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * MIContainer_Count.Price)), 0)                                                       AS SumPriceIn
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.JuridicalPrice, 0))/SUM(MIContainer_Count.Amount)),0)   AS Price
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.JuridicalPrice, 0))),0)                                 AS Summa
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.PriceWithVAT, 0))/SUM(MIContainer_Count.Amount)),0)     AS PriceWithVAT
                                   , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIContainer_Count.PriceWithVAT, 0))),0)                                   AS SummaWithVAT
                                   , MIN(MIContainer_Count.MinExpirationDate)::TDateTime                                                                             AS MinExpirationDate -- Срок годности
                              FROM MovementItem_Send_All
                                    LEFT OUTER JOIN tmpMIContainerAll AS MIContainer_Count
                                                 ON MIContainer_Count.MovementItemId = MovementItem_Send_All.Id 
                              GROUP BY COALESCE(MovementItem_Send_All.ParentId, MovementItem_Send_All.Id)   
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
                        FROM (SELECT DISTINCT MovementItem_Send.ObjectId
                              FROM MovementItem_Send) AS MovementItem_Send
                                   
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
         , tmpMI_Child AS (SELECT MovementItem.ParentId
                                , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                                , MAX(DATE_TRUNC ('DAY', MIDate_Insert.ValueData))                   AS DateInsertChild
                           FROM MovementItem
                                INNER JOIN MovementItemFloat AS MIFloat_Container
                                                             ON MIFloat_Container.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Container.DescId = zc_MIFloat_ContainerId()
                                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIFloat_Container.ValueData::Integer
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                     ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                    AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                LEFT OUTER JOIN MovementItemDate  AS MIDate_Insert
                                                                  ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Child()
                             AND MovementItem.IsErased = FALSE
                           GROUP BY MovementItem.ParentId
                          )
            -- Товары из Маркетинговых контрактов
          , tmpPromo AS (SELECT DISTINCT  Object_Goods_Retail.GoodsMainId  AS GoodsId  
                         FROM Movement
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                     AND MovementDate_StartPromo.ValueData <= vbOperDate
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                     AND MovementDate_EndPromo.ValueData >= vbOperDate
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                              LEFT OUTER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_Goods.ObjectId
                         WHERE Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_Promo()
                        )
                        
       -- результат
       SELECT
             MovementItem_Send.Id                              AS Id
           , Object_Goods.Id                                   AS GoodsId
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName

           , Object_PartionDateKind.Id                         AS PartionDateKindId
           , Object_PartionDateKind.ValueData      :: TVarChar AS PartionDateKindName

           , MovementItem_Send.Amount                          AS Amount
           , tmpRemains.Amount ::TFloat                        AS AmountRemains
           , tmpCheck.Amount   ::TFloat                        AS AmountCheck

           , COALESCE (tmpMIContainer.PriceIn , tmpRemains.PriceIn)                               ::TFloat         AS PriceIn
           , COALESCE (tmpMIContainer.SumPriceIn,(MovementItem_Send.Amount * tmpRemains.PriceIn)) ::TFloat         AS SumPriceIn

           , CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END ::TFloat  AS PriceUnitFrom
           , CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END     ::TFloat  AS PriceUnitTo

           , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_From.Price ELSE MovementItem_Send.PriceFrom END)) ::TFloat  AS SummaUnitFrom
           , (MovementItem_Send.Amount * (CASE WHEN vbisAuto = False OR vbIsSUN = TRUE THEN Object_Price_To.Price ELSE MovementItem_Send.PriceTo END))     ::TFloat  AS SummaUnitTo

           , MovementItem_Send.RemainsFrom  ::TFloat
           , MovementItem_Send.RemainsTo    ::TFloat
           , MovementItem_Send.ValueFrom    ::TFloat
           , MovementItem_Send.ValueTo      ::TFloat

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
           --, CASE WHEN MovementItem_Send.Amount <> 0 THEN tmpMIContainer.MinExpirationDate ELSE COALESCE (tmpMinExpirationDate.MinExpirationDate, tmpMIContainer.MinExpirationDate) END AS MinExpirationDate
           /*, COALESCE (tmpMI_Child.ExpirationDate, 
             CASE WHEN tmpMIContainer.MinExpirationDate = zc_DateEnd() THEN COALESCE (tmpMinExpirationDate.MinExpirationDate, tmpMIContainer.MinExpirationDate, zc_DateEnd()) ELSE tmpMIContainer.MinExpirationDate END)::TDateTime AS MinExpirationDate
           */
           , COALESCE (tmpMI_Child.ExpirationDate, tmpMIContainer.MinExpirationDate, tmpMinExpirationDate.MinExpirationDate, zc_DateEnd() )::TDateTime AS MinExpirationDate
           , MovementItem_Send.IsErased                                AS isErased

           , tmpGoodsParam.GoodsGroupName                                      AS GoodsGroupName
           , tmpGoodsParam.NDSKindName                                         AS NDSKindName
           , tmpGoodsParam.NDS                                                 AS NDS
           , COALESCE(tmpGoodsParam.isClose, False)                :: Boolean  AS isClose
           , COALESCE(tmpGoodsParam.isTOP, false)                  :: Boolean  AS isTOP
           , COALESCE(tmpGoodsParam.isFirst, FALSE)                :: Boolean  AS isFirst
           , COALESCE(tmpGoodsParam.isSecond, FALSE)               :: Boolean  AS isSecond

           , Accommodation.AccommodationId                                     AS AccommodationId
           , Object_Accommodation.ValueData                                    AS AccommodationName

           , tmpMI_Child.DateInsertChild::TDateTime                            AS DateInsertChild
           , MovementItem_Send.DateInsert                                      AS DateInsert
           
           , COALESCE(tmpPromo.GoodsId, 0) <> 0                                AS isPromo

           , Object_CommentSend.Id                                               AS CommentTRId
           , Object_CommentSend.ObjectCode                                       AS CommentTRCode
           , Object_CommentSend.ValueData                                        AS CommentTRName

           , MovementItem_Send.TechnicalRediscountID                             AS TechnicalRediscountID
           , MovementItem_Send.TechnicalRediscountInvNumber                      AS TechnicalRediscountInvNumber
           , MovementItem_Send.TechnicalRediscountOperDate                       AS TechnicalRediscountOperDate
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
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementItem_Send.PartionDateKindId

            LEFT JOIN tmpMIContainer ON  tmpMIContainer.Id = MovementItem_Send.Id 

            LEFT JOIN tmpCheck ON tmpCheck.GoodsId = Object_Goods.Id
            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
            
            LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = MovementItem_Send.ObjectId

            LEFT JOIN tmpMinExpirationDate ON tmpMinExpirationDate.GoodsId = MovementItem_Send.ObjectId
                                         -- AND MovementItem_Send.Amount = 0
                                         
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem_Send.Id 

            LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                   ON Accommodation.UnitId = vbUnitFromId
                                                  AND Accommodation.GoodsId = Object_Goods.Id
                                                  AND Accommodation.isErased = False
                                                  
            -- Размещение товара
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
            
            LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem_Send.ObjectId
            LEFT JOIN tmpPromo ON tmpPromo.GoodsId = Object_Goods_Retail.GoodsMainId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                             ON MILinkObject_CommentSend.MovementItemId = MovementItem_Send.Id
                                            AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
            LEFT JOIN Object AS Object_CommentSend
                             ON Object_CommentSend.ID = MILinkObject_CommentSend.ObjectId;
                             
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.03.20         *
 09.06.19         *
 19.04.19         *
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
-- 
select * from gpSelect_MovementItem_Send(inMovementId := 29429318 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');