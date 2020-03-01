-- Function: gpSelect_MovementItem_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TechnicalRediscount (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TechnicalRediscount(
    IN inMovementId   Integer      , -- ключ Документа
    IN inShowAll      Boolean      , --
    IN inIsErased     Boolean      , --
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, DiffSumm TFloat
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar, Explanation TVarChar
             , Price TFloat
             , isErased Boolean
             , Remains_Amount TFloat, Remains_Summ TFloat
             , Remains_FactAmount TFloat, Remains_FactSumm TFloat

--             , Remains_Save TFloat, Remains_SumSave TFloat
             , Deficit TFloat, DeficitSumm TFloat
             , Proficit TFloat, ProficitSumm TFloat
--             , ExpirationDate TDateTime
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;

  vbUnitId Integer;
  vbOperDate TDateTime;
  vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_TechnicalRediscount());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    -- вытягиваем дату и подразделение и ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)  AS OperDate     -- при рассчете остатка добавил 1 день для условия >=
         , MLO_Unit.ObjectId                                        AS UnitId
         , Movement.StatusId
           INTO vbOperDate
              , vbUnitId
              , vbStatusId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF date_part('DAY',  vbOperDate)::Integer <= 15
    THEN
        vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '14 DAY';
    ELSE
        vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
    END IF;


    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                          , MovementItem.ObjectId                                               AS GoodsId
                                          , MovementItem.Amount                                                 AS Amount
                                          , MovementItem.isErased                                               AS isErased
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE))

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , MovementItem.GoodsId                                                AS GoodsId
              , Object_Goods_Main.ObjectCode                                        AS GoodsCode
              , Object_Goods_Main.Name                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount

              , (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, 0)) :: TFloat AS DiffSumm

              , Object_CommentTR.Id                                                 AS CommentTRId
              , Object_CommentTR.ObjectCode                                         AS CommentTRCode
              , Object_CommentTR.ValueData                                          AS CommentTRName
              , MIString_Explanation.ValueData                                      AS Explanation

              , COALESCE(MIFloat_Price.ValueData, 0)::TFloat                        AS Price

              , MovementItem.isErased                                               AS isErased

              , MIFloat_Remains.ValueData  AS Remains_Amount
              , (MIFloat_Remains.ValueData * COALESCE (MIFloat_Price.ValueData, 0)) :: TFloat AS Remains_Summ

              , (COALESCE(MIFloat_Remains.ValueData, 0) +  MovementItem.Amount) :: TFloat      AS Remains_FactAmount
              , ((COALESCE(MIFloat_Remains.ValueData, 0) +  MovementItem.Amount) *
                COALESCE (MIFloat_Price.ValueData, COALESCE (MIFloat_Price.ValueData, 0))) :: TFloat       AS Remains_FactSumm

              , CASE WHEN MovementItem.Amount < 0
                     THEN - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit

              , (CASE WHEN MovementItem.Amount < 0
                      THEN - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, 0)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                     THEN COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                      THEN COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, 0)
                ) :: TFloat                                                         AS ProficitSumm

--              , REMAINS.minExpirationDate :: TDateTime

           FROM tmpMovementItem AS MovementItem

                LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.GoodsId
                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           AND vbStatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                            ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                           AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                           AND vbStatusId = zc_Enum_Status_Complete()

                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                 ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                LEFT JOIN Object AS Object_CommentTR
                                 ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

                LEFT JOIN MovementItemString AS MIString_Explanation
                                             ON MIString_Explanation.MovementItemId = MovementItem.Id
                                            AND MIString_Explanation.DescId = zc_MIString_Explanation()
            ;
    ELSEIF inShowAll = TRUE
    THEN
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                          , MovementItem.ObjectId                                               AS GoodsId
                                          , MovementItem.Amount                                                 AS Amount
                                          , MovementItem.isErased                                               AS isErased
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master())
               , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (SELECT
                                    T0.GoodsId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
--                                   ,MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) )  AS minExpirationDate   -- min срок годности
                             FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id                                                          AS ContainerId
                                           , Container.ObjectId                                                    AS GoodsId
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                    ) as T0

/*                                     -- находим срок годности из прихода
                                    LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                                  ON CLO_PartionMovementItem.Containerid = T0.ContainerId
                                                                 AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
*/                                GROUP BY T0.GoodsId
                                HAVING SUM (T0.Amount) <> 0
                            )

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , REMAINS.GoodsId                                                     AS GoodsId
              , Object_Goods_Main.ObjectCode                                        AS GoodsCode
              , Object_Goods_Main.Name                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount

              , (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS DiffSumm

              , Object_CommentTR.Id                                                 AS CommentTRId
              , Object_CommentTR.ObjectCode                                         AS CommentTRCode
              , Object_CommentTR.ValueData                                          AS CommentTRName
              , MIString_Explanation.ValueData                                      AS Explanation

              , COALESCE(MIFloat_Price.ValueData, tmpPrice.Price)::TFloat           AS Price

              , COALESCE(MovementItem.isErased, FALSE)::Boolean                     AS isErased


              , REMAINS.Amount :: TFloat                                            AS Remains_Amount
              , (COALESCE (REMAINS.Amount, 0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , (COALESCE(REMAINS.Amount, 0) +  MovementItem.Amount) :: TFloat      AS Remains_FactAmount
              , ((COALESCE(REMAINS.Amount, 0) +  MovementItem.Amount) *
                COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat       AS Remains_FactSumm

              , CASE WHEN MovementItem.Amount < 0
                     THEN - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit

              , (CASE WHEN MovementItem.Amount < 0
                      THEN - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                     THEN COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                      THEN COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

---              , REMAINS.minExpirationDate :: TDateTime

           FROM REMAINS

                LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = REMAINS.GoodsId
                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                LEFT JOIN tmpMovementItem AS movementitem
                                          ON movementitem.GoodsId = REMAINS.GoodsId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = REMAINS.GoodsId

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           AND vbStatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                            ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                           AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                           AND vbStatusId = zc_Enum_Status_Complete()

                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                 ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                LEFT JOIN Object AS Object_CommentTR
                                 ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

                LEFT JOIN MovementItemString AS MIString_Explanation
                                             ON MIString_Explanation.MovementItemId = MovementItem.Id
                                            AND MIString_Explanation.DescId = zc_MIString_Explanation()
            ;

    ELSEIF vbOperDate > CURRENT_DATE
    THEN
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                          , MovementItem.ObjectId                                               AS GoodsId
                                          , MovementItem.Amount                                                 AS Amount
                                          , MovementItem.isErased                                               AS isErased
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE))
               , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM tmpMovementItem

                                   LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                        ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                       AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId

                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         AND Price_Goods.ChildObjectId = tmpMovementItem.GoodsId

                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (SELECT
                                    T0.GoodsId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
--                                   ,MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) )  AS minExpirationDate   -- min срок годности
                             FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id                                                          AS ContainerId
                                           , Container.ObjectId                                                    AS GoodsId
                                           , Container.Amount                                                      AS Amount
                                        FROM tmpMovementItem
                                            LEFT OUTER JOIN Container ON Container.ObjectId = tmpMovementItem.GoodsId
                                                                     AND Container.DescID = zc_Container_Count()
                                                                     AND Container.WhereObjectId = vbUnitId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount <> 0
                                    ) as T0

/*                                     -- находим срок годности из прихода
                                    LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                                  ON CLO_PartionMovementItem.Containerid = T0.ContainerId
                                                                 AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
*/                                GROUP BY T0.GoodsId
                                HAVING SUM (T0.Amount) <> 0
                            )

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , MovementItem.GoodsId                                                AS GoodsId
              , Object_Goods_Main.ObjectCode                                        AS GoodsCode
              , Object_Goods_Main.Name                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount

              , (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS DiffSumm

              , Object_CommentTR.Id                                                 AS CommentTRId
              , Object_CommentTR.ObjectCode                                         AS CommentTRCode
              , Object_CommentTR.ValueData                                          AS CommentTRName
              , MIString_Explanation.ValueData                                      AS Explanation

              , COALESCE(MIFloat_Price.ValueData, tmpPrice.Price)::TFloat           AS Price

              , MovementItem.isErased                                               AS isErased

              , REMAINS.Amount :: TFloat                                            AS Remains_Amount
              , (COALESCE (REMAINS.Amount, 0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , (COALESCE(REMAINS.Amount, 0) +  MovementItem.Amount) :: TFloat      AS Remains_FactAmount
              , ((COALESCE(REMAINS.Amount, 0) +  MovementItem.Amount) *
                COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat       AS Remains_FactSumm

/*              , MIFloat_Remains.ValueData  AS Remains_Save
              , (MIFloat_Remains.ValueData * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_SumSave
*/
              , CASE WHEN MovementItem.Amount < 0
                     THEN - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit

              , (CASE WHEN MovementItem.Amount < 0
                      THEN - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                     THEN COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                      THEN COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

--              , REMAINS.minExpirationDate :: TDateTime

           FROM tmpMovementItem AS MovementItem

                LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.GoodsId
                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                LEFT JOIN REMAINS  ON REMAINS.GoodsId = MovementItem.GoodsId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.GoodsId

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           AND vbStatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                            ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                           AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                           AND vbStatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                 ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                LEFT JOIN Object AS Object_CommentTR
                                 ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

                LEFT JOIN MovementItemString AS MIString_Explanation
                                             ON MIString_Explanation.MovementItemId = MovementItem.Id
                                            AND MIString_Explanation.DescId = zc_MIString_Explanation()
            ;

    ELSE
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                          , MovementItem.ObjectId                                               AS GoodsId
                                          , MovementItem.Amount                                                 AS Amount
                                          , MovementItem.isErased                                               AS isErased
                                     FROM MovementItem
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE))
               , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM tmpMovementItem

                                   LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                                        ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                       AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId

                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                         AND Price_Goods.ChildObjectId = tmpMovementItem.GoodsId

                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (SELECT
                                    T0.GoodsId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
--                                   ,MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) )  AS minExpirationDate   -- min срок годности
                             FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id                                                          AS ContainerId
                                           , Container.ObjectId                                                    AS GoodsId
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM tmpMovementItem
                                            LEFT OUTER JOIN Container ON Container.ObjectId = tmpMovementItem.GoodsId
                                                                     AND Container.DescID = zc_Container_Count()
                                                                     AND Container.WhereObjectId = vbUnitId
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                    ) as T0

/*                                     -- находим срок годности из прихода
                                    LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                                  ON CLO_PartionMovementItem.Containerid = T0.ContainerId
                                                                 AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
*/                                GROUP BY T0.GoodsId
                                HAVING SUM (T0.Amount) <> 0
                            )

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , MovementItem.GoodsId                                                AS GoodsId
              , Object_Goods_Main.ObjectCode                                        AS GoodsCode
              , Object_Goods_Main.Name                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount

              , (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS DiffSumm

              , Object_CommentTR.Id                                                 AS CommentTRId
              , Object_CommentTR.ObjectCode                                         AS CommentTRCode
              , Object_CommentTR.ValueData                                          AS CommentTRName
              , MIString_Explanation.ValueData                                      AS Explanation

              , COALESCE(MIFloat_Price.ValueData, tmpPrice.Price)::TFloat           AS Price

              , MovementItem.isErased                                               AS isErased

              , REMAINS.Amount :: TFloat                                            AS Remains_Amount
              , (COALESCE (REMAINS.Amount, 0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , (COALESCE(REMAINS.Amount, 0) +  MovementItem.Amount) :: TFloat      AS Remains_FactAmount
              , ((COALESCE(REMAINS.Amount, 0) +  MovementItem.Amount) *
                COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat       AS Remains_FactSumm

/*              , MIFloat_Remains.ValueData  AS Remains_Save
              , (MIFloat_Remains.ValueData * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_SumSave
*/
              , CASE WHEN MovementItem.Amount < 0
                     THEN - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit

              , (CASE WHEN MovementItem.Amount < 0
                      THEN - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                     THEN COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > 0
                      THEN COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

--              , REMAINS.minExpirationDate :: TDateTime

           FROM tmpMovementItem AS MovementItem

                LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.GoodsId
                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

                LEFT JOIN REMAINS  ON REMAINS.GoodsId = MovementItem.GoodsId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.GoodsId

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           AND vbStatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                            ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                           AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                           AND vbStatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                 ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                LEFT JOIN Object AS Object_CommentTR
                                 ON Object_CommentTR.ID = MILinkObject_CommentTR.ObjectId

                LEFT JOIN MovementItemString AS MIString_Explanation
                                             ON MIString_Explanation.MovementItemId = MovementItem.Id
                                            AND MIString_Explanation.DescId = zc_MIString_Explanation()
            ;

    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TechnicalRediscount (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Шаблий О.В.
 17.02.20                                                                     *
*/

-- тест
-- select * from gpSelect_MovementItem_TechnicalRediscount(inMovementId := 17785885 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');


