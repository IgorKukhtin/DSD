-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountUser TFloat, CountUser TFloat
             , Price TFloat, Summ TFloat
             , isErased Boolean
             , Remains_Amount TFloat, Remains_Summ TFloat
             , Deficit TFloat, DeficitSumm TFloat
             , Proficit TFloat, ProficitSumm TFloat, Diff TFloat, DiffSumm TFloat
             , Diff_calc TFloat, DiffSumm_calc TFloat, Diff_diff TFloat, DiffSumm_diff TFloat
             , MIComment TVarChar
             , isAuto Boolean
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;

  vbUnitId Integer;
  vbOperDate TDateTime;
  vbIsFullInvent Boolean;
  vbIsRemains Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    vbIsRemains := True;

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId in (2, 393039, 1915124, 59582))
    THEN
      vbIsRemains := True;
    ELSE
      vbIsRemains := False;
    END IF;

    -- вытягиваем дату и подразделение и ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate) + INTERVAL '1 DAY' AS OperDate     -- при рассчете остатка добавил 1 день для условия >=
         , MLO_Unit.ObjectId                                        AS UnitId
         , COALESCE (MB_FullInvent.ValueData, FALSE)                AS isFullInvent
           INTO vbOperDate
              , vbUnitId
              , vbIsFullInvent
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT OUTER JOIN MovementBoolean AS MB_FullInvent
                                         ON MB_FullInvent.MovementId = Movement.Id
                                        AND MB_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = inMovementId;



    IF inShowAll = FALSE AND vbIsFullInvent = TRUE
    THEN
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (
                                SELECT
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id
                                           , Container.ObjectId  -- Товар
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                                        SELECT
                                             Container.Id
                                           , Container.ObjectId  -- Товар
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
                 -- проводки
               , tmpMI_calc AS (SELECT MIContainer.MovementItemId
                                     , SUM (MIContainer.Amount) AS Diff
                                FROM MovementItemContainer AS MIContainer
                               WHERE MIContainer.MovementId = inMovementId
                                 AND MIContainer.DescId     = zc_MIContainer_Count()
                               GROUP BY MIContainer.MovementItemId
                              )

                 -- строчная часть
               , tmpMI AS (SELECT MovementItem.Id            AS Id
                                , MovementItem.ObjectId      AS ObjectId
                                , MovementItem.Amount        AS Amount
                                , MIFloat_Price.ValueData    AS Price
                                , MIFloat_Summ.ValueData     AS Summ
                                , MovementItem.isErased      AS isErased
                                , MIString_Comment.ValueData AS MIComment
                                , MIBoolean_isAuto.ValueData AS isAuto

                                , COALESCE (tmpMI_calc.Diff, 0) AS Diff_calc
                                , COALESCE (tmpMI_calc.Diff, 0) * COALESCE (MIFloat_Price.ValueData, 0) AS DiffSumm_calc
                                , CASE WHEN tmpMI_calc.Diff < 0 THEN -1 * tmpMI_calc.Diff * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END AS DeficitSumm_calc
                                , CASE WHEN tmpMI_calc.Diff > 0 THEN  1 * tmpMI_calc.Diff * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END AS ProficitSumm_calc

                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                             ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                 LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                                    ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                   AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                               ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
                                 LEFT JOIN tmpMI_calc ON tmpMI_calc.MovementItemId = MovementItem.Id

                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND (MovementItem.isErased  = FALSE
                                OR inIsErased             = TRUE
                                  )
                           )
         -- строчная часть чайлд
         , tmpMI_Child AS (SELECT tmp.ParentId
                                , COUNT (tmp.Num)       AS CountUser
                                , SUM (tmp.AmountUser)  AS AmountUser
                           FROM (SELECT MovementItem.ParentId      AS ParentId
                                      , CASE WHEN MovementItem.ObjectId = vbUserId THEN MovementItem.Amount ELSE 0 END   AS AmountUser
                                      , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId ORDER BY MovementItem.ParentId, MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
                                 FROM MovementItem
                                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased  = FALSE
                                 ) AS tmp
                           WHERE tmp.Num = 1
                           GROUP BY tmp.ParentId
                           )

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.ObjectCode                                             AS GoodsCode
              , (CASE WHEN MovementItem.ObjectId > 0 THEN '' ELSE '***' END || Object_Goods.ValueData) :: TVarChar AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE (tmpMI_Child.AmountUser,0) :: TFloat                       AS AmountUser
              , COALESCE (tmpMI_Child.CountUser, 0) :: TFloat                       AS CountUser

              , CASE WHEN MovementItem.ObjectId > 0 THEN MovementItem.Price ELSE tmpPrice.Price END :: TFloat AS Price
              -- , MovementItem.Summ                                                                          AS Summ
              , (COALESCE (MovementItem.Amount, 0) * COALESCE (MovementItem.Price, tmpPrice.Price)) :: TFloat AS Summ

              , COALESCE (MovementItem.isErased, FALSE) :: Boolean                  AS isErased
              , CASE WHEN vbIsRemains = TRUE THEN REMAINS.Amount ELSE NULL END :: TFloat AS Remains_Amount

              , (COALESCE (REMAINS.Amount,0) * COALESCE (MovementItem.Price, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                     THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit
              , (CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                      THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MovementItem.Price, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                     THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                      THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 END * COALESCE (MovementItem.Price, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)) :: TFloat AS Diff

              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MovementItem.Price, tmpPrice.Price)
                ) :: TFloat                                                         AS DiffSumm

              , MovementItem.Diff_calc                                    :: TFloat AS Diff_calc
              , MovementItem.DiffSumm_calc                                :: TFloat AS DiffSumm_calc

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 - COALESCE (MovementItem.Diff_calc, 0)
                ) :: TFloat                                                         AS Diff_diff
              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MovementItem.Price, tmpPrice.Price)
                 - COALESCE (MovementItem.DiffSumm_calc, 0)
                ) :: TFloat                                                         AS DiffSumm_diff

              , MovementItem.MIComment                                              AS MIComment
              , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MovementItem.isAuto, FALSE) ELSE TRUE END :: Boolean AS isAuto

            FROM REMAINS
                FULL JOIN tmpMI AS MovementItem ON MovementItem.ObjectId = REMAINS.ObjectId

                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)

                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            ;

    ELSEIF inShowAll = FALSE
    THEN
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (
                                SELECT
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id
                                           , Container.ObjectId  -- Товар
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                                        SELECT
                                             Container.Id
                                           , Container.ObjectId  -- Товар
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
                 -- проводки
               , tmpMI_calc AS (SELECT MIContainer.MovementItemId
                                     , SUM (MIContainer.Amount) AS Diff
                                FROM MovementItemContainer AS MIContainer
                               WHERE MIContainer.MovementId = inMovementId
                                 AND MIContainer.DescId = zc_MIContainer_Count()
                               GROUP BY MIContainer.MovementItemId
                              )

         -- строчная часть чайлд
         , tmpMI_Child AS (SELECT tmp.ParentId
                                , COUNT (tmp.Num)       AS CountUser
                                , SUM (tmp.AmountUser)  AS AmountUser
                           FROM (SELECT MovementItem.ParentId      AS ParentId
                                      , CASE WHEN MovementItem.ObjectId = vbUserId THEN MovementItem.Amount ELSE 0 END   AS AmountUser
                                      , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId ORDER BY MovementItem.ParentId, MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
                                 FROM MovementItem
                                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased  = FALSE
                                 ) AS tmp
                           WHERE tmp.Num = 1
                           GROUP BY tmp.ParentId
                           )

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.ObjectCode                                             AS GoodsCode
              , Object_Goods.ValueData                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE (tmpMI_Child.AmountUser,0) :: TFloat                       AS AmountUser
              , COALESCE (tmpMI_Child.CountUser, 0) :: TFloat                       AS CountUser

              , CASE WHEN MovementItem.ObjectId > 0 THEN MIFloat_Price.ValueData ELSE tmpPrice.Price END :: TFloat AS Price
              -- , MovementItem.Summ                                                                          AS Summ
              , (COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Summ

              , COALESCE (MovementItem.isErased, FALSE) :: Boolean                  AS isErased
              , CASE WHEN vbIsRemains = TRUE THEN REMAINS.Amount ELSE NULL END :: TFloat AS Remains_Amount

              , (COALESCE (REMAINS.Amount,0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                     THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit
              , (CASE WHEN COALESCE (REMAINS.Amount, 0) > COALESCE (MovementItem.Amount, 0)
                      THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                     THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN COALESCE (MovementItem.Amount, 0) > COALESCE (REMAINS.Amount, 0)
                      THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)) :: TFloat AS Diff

              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DiffSumm

              , COALESCE (tmpMI_calc.Diff, 0)                                           :: TFloat AS Diff_calc
              , (COALESCE (tmpMI_calc.Diff, 0) * COALESCE (MIFloat_Price.ValueData, 0)) :: TFloat AS DiffSumm_calc

              , (COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 - COALESCE (tmpMI_calc.Diff, 0)
                ) :: TFloat                                                         AS Diff_diff
              , ((COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                 - COALESCE (tmpMI_calc.Diff, 0) * COALESCE (MIFloat_Price.ValueData, 0)
                ) :: TFloat                                                         AS DiffSumm_diff

              , MIString_Comment.ValueData                                          AS MIComment
              , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MIBoolean_isAuto.ValueData, FALSE) ELSE TRUE END :: Boolean AS isAuto

            FROM MovementItem
                LEFT JOIN tmpMI_calc ON tmpMI_calc.MovementItemId = MovementItem.Id
                LEFT JOIN REMAINS ON REMAINS.ObjectId = MovementItem.ObjectId
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = REMAINS.ObjectId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()
                LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND (MovementItem.isErased  = FALSE
                   OR inIsErased          = TRUE
                  );

    ELSE
        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
                 -- остатки на начало следующего дня
               , REMAINS AS (
                                SELECT
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id
                                           , Container.ObjectId  -- Товар
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            /*JOIN ContainerLinkObject AS CLI_Unit
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId*/
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                                        SELECT
                                             Container.Id
                                           , Container.ObjectId  -- Товар
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = inMovementId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP BY ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            )
                 -- проводки
               , tmpMI_calc AS (SELECT MIContainer.MovementItemId
                                     , SUM (MIContainer.Amount) AS Diff
                                FROM MovementItemContainer AS MIContainer
                               WHERE MIContainer.MovementId = inMovementId
                                 AND MIContainer.DescId = zc_MIContainer_Count()
                               GROUP BY MIContainer.MovementItemId
                              )

         -- строчная часть чайлд
         , tmpMI_Child AS (SELECT tmp.ParentId
                                , COUNT (tmp.Num)       AS CountUser
                                , SUM (tmp.AmountUser)  AS AmountUser
                           FROM (SELECT MovementItem.ParentId      AS ParentId
                                      , CASE WHEN MovementItem.ObjectId = vbUserId THEN MovementItem.Amount ELSE 0 END   AS AmountUser
                                      , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId ORDER BY MovementItem.ParentId, MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
                                 FROM MovementItem
                                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased  = FALSE
                                 ) AS tmp
                           WHERE tmp.Num = 1
                           GROUP BY tmp.ParentId
                           )

            -- Результат
            SELECT
                MovementItem.Id                                                     AS Id
              , Object_Goods.Id                                                     AS GoodsId
              , Object_Goods.GoodsCodeInt                                           AS GoodsCode
              , Object_Goods.GoodsName                                              AS GoodsName
              , MovementItem.Amount                                                 AS Amount
              , COALESCE (tmpMI_Child.AmountUser, 0) :: TFloat                      AS AmountUser
              , COALESCE (tmpMI_Child.CountUser, 0) :: TFloat                       AS CountUser

              , CASE WHEN MovementItem.ObjectId > 0 THEN MIFloat_Price.ValueData ELSE tmpPrice.Price END :: TFloat AS Price
              -- , MIFloat_Summ.ValueData                                                                          AS Summ
              , (MovementItem.Amount * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Summ

              , MovementItem.isErased                                               AS isErased
              , CASE WHEN vbIsRemains = TRUE THEN REMAINS.Amount ELSE NULL END :: TFloat AS Remains_Amount

              , (COALESCE (REMAINS.Amount, 0) * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)) :: TFloat AS Remains_Summ

              , CASE WHEN COALESCE (REMAINS.Amount, 0) > MovementItem.Amount
                     THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                END :: TFloat                                                       AS Deficit

              , (CASE WHEN COALESCE (REMAINS.Amount, 0) > MovementItem.Amount
                      THEN COALESCE (REMAINS.Amount, 0) - COALESCE (MovementItem.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DeficitSumm

              , CASE WHEN MovementItem.Amount > COALESCE (REMAINS.Amount, 0)
                     THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                END :: TFloat                                                       AS Proficit
              , (CASE WHEN MovementItem.Amount > COALESCE (REMAINS.Amount, 0)
                      THEN COALESCE (MovementItem.Amount, 0) - COALESCE (REMAINS.Amount, 0)
                 END * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS ProficitSumm

              , (MovementItem.Amount - COALESCE (REMAINS.Amount, 0)) :: TFloat AS Diff

              , ((MovementItem.Amount - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                ) :: TFloat                                                         AS DiffSumm

              , COALESCE (tmpMI_calc.Diff, 0)                                           :: TFloat AS Diff_calc
              , (COALESCE (tmpMI_calc.Diff, 0) * COALESCE (MIFloat_Price.ValueData, 0)) :: TFloat AS DiffSumm_calc

              , (MovementItem.Amount - COALESCE (REMAINS.Amount, 0)
                 - COALESCE (tmpMI_calc.Diff, 0)
                ) :: TFloat                                                         AS Diff_diff
              , ((MovementItem.Amount - COALESCE (REMAINS.Amount, 0))
                 * COALESCE (MIFloat_Price.ValueData, tmpPrice.Price)
                 - COALESCE (tmpMI_calc.Diff, 0) * COALESCE (MIFloat_Price.ValueData, 0)
                ) :: TFloat                                                         AS DiffSumm_diff

              , MIString_Comment.ValueData                                          AS MIComment
              -- , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MIBoolean_isAuto.ValueData, FALSE) WHEN REMAINS.Amount <> 0 THEN TRUE ELSE FALSE END :: Boolean AS isAuto
              , COALESCE (MIBoolean_isAuto.ValueData, FALSE) AS isAuto

           FROM Object_Goods_View AS Object_Goods
                LEFT JOIN REMAINS  ON REMAINS.ObjectId = Object_Goods.Id
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_Goods.Id

                LEFT JOIN MovementItem ON MovementItem.ObjectId   = Object_Goods.Id
                                      AND MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND (MovementItem.isErased  = FALSE
                                        OR inIsErased             = TRUE
                                          )
                LEFT JOIN tmpMI_calc ON tmpMI_calc.MovementItemId = MovementItem.Id
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()
                LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                              ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                             AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

            WHERE Object_Goods.ObjectId  = vbObjectId
              AND (Object_Goods.IsErased = FALSE
                OR MovementItem.Id       > 0
                  );

    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.   Шаблий О.В.
 10.04.19                                                                                      *
 12.06.17         *
 05.01.17         *
 29.06.16         *
 11.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 3443092, inShowAll:= TRUE,  inIsErased:= TRUE,  inSession:= '3')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 3443092, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '3')
