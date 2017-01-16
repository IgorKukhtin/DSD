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
             , Price TFloat, Summa TFloat, PriceWithVAT TFloat, SummaWithVAT TFloat
             , AmountManual TFloat, AmountDiff TFloat
             , ReasonDifferencesId Integer, ReasonDifferencesName TVarChar
             , ConditionsKeepName TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitFromId Integer;
    DECLARE vbUnitToId Integer;
    DECLARE vbisAuto Boolean;
    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDateEnd TDateTime;
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

    -- Результат
    IF inShowAll THEN

        -- Результат такой
        RETURN QUERY
            WITH 
                tmpRemains AS(  SELECT 
                                    Container.ObjectId                  AS GoodsId
                                  , SUM(Container.Amount)::TFloat       AS Amount
                                  , AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
                                      
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
                         WHERE Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                          AND Movement_Check.DescId = zc_Movement_Check()
                          AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY MI_Check.ObjectId 
                        HAVING SUM (MI_Check.Amount) <> 0 
                        )

               ,MovementItem_Send AS (  SELECT 
                                            MovementItem.Id
                                           ,MovementItem.ObjectId
                                           ,MovementItem.Amount
                                           ,MovementItem.IsErased
                                        FROM MovementItem
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId = zc_MI_Master()
                                          AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
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
            -- результат
            SELECT
                COALESCE(MovementItem_Send.Id,0)                  AS Id
              , Object_Goods.Id                                   AS GoodsId
              , Object_Goods.ObjectCode                           AS GoodsCode
              , Object_Goods.ValueData                            AS GoodsName
              , MovementItem_Send.Amount                          AS Amount
              , tmpRemains.Amount::TFloat                         AS AmountRemains
              , tmpCheck.Amount::TFloat                           AS AmountCheck
              , COALESCE(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData)/SUM(MIContainer_Count.Amount)
                        ,tmpRemains.PriceIn)::TFloat           AS PriceIn
              , COALESCE(ABS(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData))
                        ,(MovementItem_Send.Amount
                         *tmpRemains.PriceIn))::TFloat            AS SumPriceIn
              , CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE COALESCE(MIFloat_PriceFrom.ValueData,0) END ::TFloat  AS PriceUnitFrom
              , CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE COALESCE(MIFloat_PriceTo.ValueData,0) END     ::TFloat  AS PriceUnitTo

              , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))/SUM(MIContainer_Count.Amount)),0) ::TFloat  AS Price
              , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))),0)                               ::TFloat  AS Summa
              , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))/SUM(MIContainer_Count.Amount)),0)   ::TFloat  AS PriceWithVAT
              , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))),0)                                 ::TFloat  AS SummaWithVAT

              , COALESCE(MIFloat_AmountManual.ValueData,0)     ::TFloat     AS AmountManual
              , (COALESCE(MIFloat_AmountManual.ValueData,0) - COALESCE(MovementItem_Send.Amount,0))::TFloat as AmountDiff
              , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
              , Object_ReasonDifferences.ValueData      AS ReasonDifferencesName
              , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
              , COALESCE(MovementItem_Send.IsErased,FALSE)        AS isErased

            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Send ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                LEFT JOIN tmpPrice AS Object_Price_From
                                   ON Object_Price_From.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                  AND Object_Price_From.UnitId = vbUnitFromId
                LEFT JOIN tmpPrice AS Object_Price_To
                                   ON Object_Price_To.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                                  AND Object_Price_To.UnitId = vbUnitToId

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
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                 ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem_Send.Id
                                                AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
                                  

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

                LEFT JOIN tmpCheck ON tmpCheck.GoodsId = Object_Goods.Id
                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

            WHERE Object_Goods.isErased = FALSE 
               or MovementItem_Send.id is not null
            GROUP BY
                MovementItem_Send.Id
              , Object_Goods.Id
              , Object_Goods.ObjectCode 
              , Object_Goods.ValueData  
              , MovementItem_Send.Amount
              , tmpRemains.Amount
              , tmpCheck.Amount
              , tmpRemains.PriceIn
              , CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE COALESCE(MIFloat_PriceFrom.ValueData,0) END
              , CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE COALESCE(MIFloat_PriceTo.ValueData,0) END
              , MovementItem_Send.IsErased
              , COALESCE(MIFloat_AmountManual.ValueData,0) 
              , MILinkObject_ReasonDifferences.ObjectId 
              , Object_ReasonDifferences.ValueData
              , COALESCE(Object_ConditionsKeep.ValueData, '');
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH tmpRemains AS (
                                SELECT 
                                    Container.ObjectId    AS GoodsId
                                  , SUM(Container.Amount) AS Amount
                                  , AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
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
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount <> 0
                              --    AND 1=0
                                GROUP BY Container.ObjectId
                              --  HAVING SUM(Container.Amount) <> 0
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
                         WHERE Movement_Check.OperDate >= vbOperDate AND Movement_Check.OperDate < vbOperDateEnd
                          AND Movement_Check.DescId = zc_Movement_Check()
                          AND Movement_Check.StatusId = zc_Enum_Status_UnComplete()
                        GROUP BY MI_Check.ObjectId 
                        HAVING SUM (MI_Check.Amount) <> 0 
                        )

          , MovementItem_Send AS (SELECT MovementItem.Id
                                        ,MovementItem.ObjectId
                                        ,MovementItem.Amount
                                        ,MovementItem.IsErased
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
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
       -- результат
       SELECT
             MovementItem_Send.Id                              AS Id
           , Object_Goods.Id                                   AS GoodsId
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName

           , MovementItem_Send.Amount                          AS Amount
           , tmpRemains.Amount::TFloat                         AS AmountRemains
           , tmpCheck.Amount::TFloat                           AS AmountCheck
           , COALESCE(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData)/SUM(MIContainer_Count.Amount)
                        ,tmpRemains.PriceIn)::TFloat           AS PriceIn
           , COALESCE(ABS(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData))
                        ,(MovementItem_Send.Amount
                         *tmpRemains.PriceIn))::TFloat         AS SumPriceIn
           , CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE COALESCE(MIFloat_PriceFrom.ValueData,0) END ::TFloat  AS PriceUnitFrom
           , CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE COALESCE(MIFloat_PriceTo.ValueData,0) END     ::TFloat  AS PriceUnitTo

           , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))/SUM(MIContainer_Count.Amount)),0) ::TFloat  AS Price
           , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))),0)                               ::TFloat  AS Summa
           , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))/SUM(MIContainer_Count.Amount)),0)   ::TFloat  AS PriceWithVAT
           , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))),0)                                 ::TFloat  AS SummaWithVAT

           , COALESCE(MIFloat_AmountManual.ValueData,0)     ::TFloat     AS AmountManual
           , (COALESCE(MIFloat_AmountManual.ValueData,0) - COALESCE(MovementItem_Send.Amount,0))::TFloat as AmountDiff
           , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
           , Object_ReasonDifferences.ValueData      AS ReasonDifferencesName
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
           , MovementItem_Send.IsErased              AS isErased

       FROM MovementItem_Send
            LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem_Send.ObjectId
            LEFT JOIN tmpPrice AS Object_Price_From
                               ON Object_Price_From.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                              AND Object_Price_From.UnitId = vbUnitFromId
            LEFT JOIN tmpPrice AS Object_Price_To
                               ON Object_Price_To.GoodsId = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)
                              AND Object_Price_To.UnitId = vbUnitToId

            -- цена подразделений записанная при автоматическом распределении 
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                              ON MIFloat_PriceFrom.MovementItemId = MovementItem_Send.ID
                                             AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                              ON MIFloat_PriceTo.MovementItemId = MovementItem_Send.ID
                                             AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                        ON MIFloat_AmountManual.MovementItemId = MovementItem_Send.Id
                                       AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                             ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem_Send.Id
                                            AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
            LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId

            LEFT OUTER JOIN MovementItemContainer AS MIContainer_Count
                                                  ON MIContainer_Count.MovementItemId = MovementItem_Send.Id 
                                                 AND MIContainer_Count.DescId = zc_Container_Count()
                                                 AND MIContainer_Count.isActive = True

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
            LEFT JOIN tmpCheck ON tmpCheck.GoodsId = Object_Goods.Id
            -- условия хранения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
            LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

       GROUP BY
             MovementItem_Send.Id
           , Object_Goods.Id
           , Object_Goods.ObjectCode 
           , Object_Goods.ValueData  
           , MovementItem_Send.Amount
           , tmpRemains.Amount
           , tmpCheck.Amount
           , tmpRemains.PriceIn
           , CASE WHEN vbisAuto = False THEN Object_Price_From.Price ELSE COALESCE(MIFloat_PriceFrom.ValueData,0) END 
           , CASE WHEN vbisAuto = False THEN Object_Price_To.Price ELSE COALESCE(MIFloat_PriceTo.ValueData,0) END     
           , MovementItem_Send.IsErased
           , COALESCE(MIFloat_AmountManual.ValueData,0)
           , MILinkObject_ReasonDifferences.ObjectId 
           , Object_ReasonDifferences.ValueData 
           , COALESCE(Object_ConditionsKeep.ValueData, '') ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
