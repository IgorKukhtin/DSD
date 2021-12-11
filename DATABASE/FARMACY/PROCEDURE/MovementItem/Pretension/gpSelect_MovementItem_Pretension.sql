-- Function: gpSelect_MovementItem_Pretension()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Pretension (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Pretension(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , ReasonDifferencesId Integer
             , ReasonDifferencesName TVarChar
             , AmountIncome TFloat
             , AmountManual TFloat
             , AmountDiff TFloat
             , isChecked Boolean
             , CheckedName TVarChar
             , Price TFloat
             , Summ TFloat
             , isErased Boolean
             , AmountInIncome TFloat
             , Remains TFloat
             , RemainsAll TFloat
             , WarningColor Integer
             , ExpirationDate TDateTime
             , PartionGoods TVarChar
             , MakerName TVarChar
             , AmountOther TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbMovementIncomeId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
    --Номер прихода
    SELECT MovementLinkMovement_Income.MovementChildId 
         , Movement.OperDate 
         , MovementLinkObject_Unit.ObjectId
         INTO vbMovementIncomeId, vbOperDate, vbUnitId
    FROM Movement
         INNER JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                         ON MovementLinkMovement_Income.MovementId = Movement.Id
                                        AND MovementLinkMovement_Income.DescId = zc_MovementLinkMovement_Income()
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
    WHERE Movement.Id = inMovementId;

    --Результат    
    IF inShowAll THEN

        RETURN QUERY
            WITH 
            tmpIncome AS ( --Остатки по приходу
                           SELECT MovementItem_Income.Id          AS Id
                                , MovementItem_Income.ObjectId    AS GoodsId
                                , Object_Goods.ObjectCode         AS GoodsCode
                                , Object_Goods.ValueData          AS GoodsName
                                , MIFloat_Price.ValueData         AS Price
                                , MovementItem_Income.Amount      AS AmountInIncome
                 
                                , MIDate_ExpirationDate.ValueData            AS ExpirationDate
                                , MIString_PartionGoods.ValueData            AS PartionGoods
                                , ObjectString_Goods_Maker.ValueData         AS MakerName
                           FROM MovementItem AS MovementItem_Income
                                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem_Income.ObjectId

                                  LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = MovementItem_Income.Id
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                               ON MIString_PartionGoods.MovementItemId = MovementItem_Income.Id
                                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem_Income.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem_Income.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                                        ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId 
                                                       AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() 
                           WHERE MovementItem_Income.DescId     = zc_MI_Master()
                             AND MovementItem_Income.MovementId = vbMovementIncomeId
                             AND MovementItem_Income.isErased   = FALSE
                           )

          , tmpContainer AS ( --Остатки по приходу
                           SELECT MovementItemContainer.MovementItemId
                                , Container.Amount
                           FROM MovementItemContainer 
                                  LEFT JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                     AND Container.DescId = zc_Container_Count()

                         WHERE MovementItemContainer.DescId = zc_MIContainer_Count()
                           AND MovementItemContainer.MovementItemId IN (SELECT DISTINCT tmpIncome.Id FROM tmpIncome)
                         )

          , Income AS ( --Остатки по приходу
                       SELECT tmpIncome.Id
                            , tmpIncome.GoodsId
                            , tmpIncome.GoodsCode
                            , tmpIncome.GoodsName
                            , tmpIncome.Price
                            , tmpIncome.AmountInIncome
                            , tmpIncome.ExpirationDate
                            , tmpIncome.PartionGoods
                            , tmpIncome.MakerName
                            , tmpContainer.Amount     AS AmountRemains
                            , tmpContainer.MovementItemId
                       FROM tmpIncome
                              LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpIncome.Id
                       )

          , ReturnOther AS (SELECT MI_Pretension.ParentId
                                 , SUM(MI_Pretension.Amount)::TFloat AS Amount
                            FROM Movement AS Movement_Pretension
                                 INNER JOIN MovementItem AS MI_Pretension
                                                         ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                        AND MI_Pretension.isErased   = FALSE
                                                        AND MI_Pretension.DescId     = zc_MI_Master()
                              WHERE Movement_Pretension.Id <> inMovementId
                                AND Movement_Pretension.ParentId = vbMovementIncomeId
                                AND Movement_Pretension.StatusId <> zc_Enum_Status_Erased()
                              GROUP BY MI_Pretension.ParentId
                              )

          , Pretension AS (SELECT Movement_Pretension.StatusId
                               , MI_Pretension.Id
                               , MIFloat_MovementItemId.ValueData::Integer   AS ParentId
                               , MI_Pretension.ObjectId           AS GoodsId
                               , Object_Goods.ObjectCode          AS GoodsCode
                               , Object_Goods.ValueData           AS GoodsName
                               , MI_Pretension.Amount             AS Amount
                               , Object_ReasonDifferences.Id          AS ReasonDifferencesId
                               , Object_ReasonDifferences.ValueData   AS ReasonDifferencesName
                               , MIFloat_Amount.ValueData         AS AmountIncome
                               , MIFloat_AmountManual.ValueData   AS AmountManual
                               , (COALESCE(MIFloat_AmountManual.ValueData, 0) - COALESCE( MIFloat_Amount.ValueData,0))::TFloat AS AmountDiff
                               , MIBoolean_Checked.ValueData      AS isChecked
                               , MI_Pretension.isErased
                          FROM Movement AS Movement_Pretension
                               INNER JOIN MovementItem AS MI_Pretension
                                                       ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                      AND (MI_Pretension.isErased  = FALSE OR inIsErased = TRUE)
                                                      AND MI_Pretension.DescId     = zc_MI_Master()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Pretension.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                           ON MIFloat_MovementItemId.MovementItemId = MI_Pretension.Id
                                                          AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                               LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                                           ON MIFloat_Amount.MovementItemId = MI_Pretension.Id
                                                          AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                           ON MIFloat_AmountManual.MovementItemId = MI_Pretension.Id
                                                          AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

                               LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                             ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                            AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                                ON MILinkObject_ReasonDifferences.MovementItemId = MI_Pretension.Id
                                                               AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                               LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
                          WHERE Movement_Pretension.Id = inMovementId
                         )

          -- таблица остатков
          , tmpContainerRemains AS (SELECT Container.Id AS ContainerId
                                  , Container.ObjectId  
                                  , Container.Amount 
                             FROM Container 
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.WhereObjectId = vbUnitid
                               AND Container.Amount <> 0
                             GROUP BY Container.Id, Container.ObjectId, Container.Amount
                             )

          , tmpRemainsAll AS (SELECT tmp.GoodsId
                                   , SUM (tmp.RemainsStart)       AS RemainsStart
                              FROM (SELECT tmpContainer.ObjectId  AS GoodsId
                                         , tmpContainer.Amount - (SUM (COALESCE(MIContainer.Amount, 0)))  AS RemainsStart
                                    FROM tmpContainerRemains AS tmpContainer
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                        AND MIContainer.OperDate >= vbOperDate
                                                                        AND MIContainer.DescId = zc_Container_Count()
                                    GROUP BY tmpContainer.ContainerId
                                           , tmpContainer.ObjectId
                                           , tmpContainer.Amount
                                    HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                    ) AS tmp
                              GROUP BY tmp.GoodsId
                             )

         ----
         SELECT MovementItem_Pretension.Id
              , MovementItem_Income.Id                                                     AS ParentId
              , COALESCE(MovementItem_Pretension.GoodsId, MovementItem_Income.GoodsId)     AS GoodsId
              , COALESCE(MovementItem_Pretension.GoodsCode, MovementItem_Income.GoodsCode) AS GoodsCode
              , COALESCE(MovementItem_Pretension.GoodsName, MovementItem_Income.GoodsName) AS GoodsName
              , MovementItem_Pretension.Amount                                             AS Amount
              , MovementItem_Pretension.ReasonDifferencesId
              , MovementItem_Pretension.ReasonDifferencesName
              , MovementItem_Pretension.AmountIncome
              , MovementItem_Pretension.AmountManual
              , MovementItem_Pretension.AmountDiff
              , MovementItem_Pretension.isChecked
              , CASE WHEN MovementItem_Pretension.isChecked THEN 'Актуальна' ELSE 'Неактуальна' END::TVarChar AS CheckedName
              , MovementItem_Income.Price                                                  AS Price
              , ROUND(COALESCE(MovementItem_Pretension.Amount , 0) * MovementItem_Income.Price, 2 )::TFloat AS Summ
              , MovementItem_Pretension.isErased                                           AS isErased
              , MovementItem_Income.AmountInIncome                                         AS AmountInIncome
              , (COALESCE(MovementItem_Income.AmountRemains,0)
                  + CASE WHEN MovementItem_Pretension.StatusId = zc_Enum_Status_Complete()
                      THEN MovementItem_Pretension.Amount
                    ELSE 0
                    END)::TFloat                                                          AS Remains
              , tmpRemainsAll.RemainsStart :: TFloat                                      AS RemainsAll
              , CASE 
                  WHEN MovementItem_Pretension.Amount > COALESCE(MovementItem_Income.AmountInIncome,0) or
                       MovementItem_Pretension.Amount > COALESCE(MovementItem_Income.AmountRemains,0)
                    THEN 36095
                END                                                                       AS WarningColor

             , MovementItem_Income.ExpirationDate
             , MovementItem_Income.PartionGoods
             , MovementItem_Income.MakerName
             , ReturnOther.Amount                                                         AS AmountOther
         FROM Income AS MovementItem_Income
              FULL JOIN Pretension AS MovementItem_Pretension 
                                  ON MovementItem_Pretension.ParentId = MovementItem_Income.Id
              
              LEFT JOIN tmpRemainsAll ON tmpRemainsAll.GoodsId = COALESCE(MovementItem_Pretension.GoodsId, MovementItem_Income.GoodsId)
 
              LEFT JOIN ReturnOther ON ReturnOther.ParentId = COALESCE(MovementItem_Pretension.ParentId, MovementItem_Income.MovementItemId)

;

    ELSE
        RETURN QUERY
            WITH 
            tmpIncome AS ( --приход
                           SELECT MovementItem_Income.Id          AS Id
                                , MovementItem_Income.ObjectId    AS GoodsId
                                , Object_Goods.ObjectCode         AS GoodsCode
                                , Object_Goods.ValueData          AS GoodsName
                                , MovementItem_Income.Amount      AS AmountInIncome
                                , MIFloat_Price.ValueData         AS Price             
                                , MIDate_ExpirationDate.ValueData            AS ExpirationDate
                                , MIString_PartionGoods.ValueData            AS PartionGoods
                                , ObjectString_Goods_Maker.ValueData         AS MakerName
                           FROM MovementItem AS MovementItem_Income
                                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem_Income.ObjectId

                                  LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = MovementItem_Income.Id
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                               ON MIString_PartionGoods.MovementItemId = MovementItem_Income.Id
                                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem_Income.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem_Income.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                                         ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId 
                                                        AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() 
                         WHERE MovementItem_Income.DescId     = zc_MI_Master()
                             AND MovementItem_Income.MovementId = vbMovementIncomeId
                             AND MovementItem_Income.isErased = FALSE
                         )

          , tmpContainer AS (--Остатки по приходу
                             SELECT MovementItemContainer.MovementItemId
                                  , Container.Amount
                             FROM MovementItemContainer 
                                    LEFT JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                       AND Container.DescId = zc_Container_Count()
  
                             WHERE MovementItemContainer.DescId = zc_MIContainer_Count()
                             AND MovementItemContainer.MovementItemId IN (SELECT DISTINCT tmpIncome.Id FROM tmpIncome)
                         )

          , Income AS ( --
                       SELECT tmpIncome.Id
                            , tmpIncome.GoodsId
                            , tmpIncome.GoodsCode
                            , tmpIncome.GoodsName
                            , tmpIncome.AmountInIncome
                            , tmpIncome.Price
                            , tmpIncome.ExpirationDate
                            , tmpIncome.PartionGoods
                            , tmpIncome.MakerName
                            , tmpContainer.Amount                AS AmountRemains
                       FROM tmpIncome
                            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpIncome.Id
                        )

          , Pretension AS (SELECT Movement_Pretension.StatusId
                               , MI_Pretension.Id
                               , MIFloat_MovementItemId.ValueData::Integer   AS ParentId
                               , MI_Pretension.ObjectId           AS GoodsId
                               , Object_Goods.ObjectCode          AS GoodsCode
                               , Object_Goods.ValueData           AS GoodsName
                               , MI_Pretension.Amount             AS Amount
                               , Object_ReasonDifferences.Id          AS ReasonDifferencesId
                               , Object_ReasonDifferences.ValueData   AS ReasonDifferencesName
                               , MIFloat_Amount.ValueData         AS AmountIncome
                               , MIFloat_AmountManual.ValueData   AS AmountManual
                               , (COALESCE(MIFloat_AmountManual.ValueData, 0) - COALESCE( MIFloat_Amount.ValueData,0))::TFloat AS AmountDiff
                               , MIBoolean_Checked.ValueData      AS isChecked
                               , MI_Pretension.isErased
                          FROM Movement AS Movement_Pretension
                               INNER JOIN MovementItem AS MI_Pretension
                                                       ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                      AND (MI_Pretension.isErased  = FALSE OR inIsErased = TRUE)
                                                      AND MI_Pretension.DescId     = zc_MI_Master()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Pretension.ObjectId

                               LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                           ON MIFloat_MovementItemId.MovementItemId = MI_Pretension.Id
                                                          AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                               LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                                           ON MIFloat_Amount.MovementItemId = MI_Pretension.Id
                                                          AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                           ON MIFloat_AmountManual.MovementItemId = MI_Pretension.Id
                                                          AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

                               LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                             ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                            AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                                ON MILinkObject_ReasonDifferences.MovementItemId = MI_Pretension.Id
                                                               AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
                               LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
                          WHERE Movement_Pretension.Id = inMovementId
                         )

          , ReturnOther AS (SELECT MI_Pretension.ParentId
                                 , SUM(MI_Pretension.Amount)::TFloat AS Amount
                            FROM Movement AS Movement_Pretension
                                 INNER JOIN MovementItem AS MI_Pretension
                                                         ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                        AND MI_Pretension.isErased   = FALSE
                                                        AND MI_Pretension.DescId     = zc_MI_Master()
                              WHERE Movement_Pretension.Id <> inMovementId
                                AND Movement_Pretension.ParentId = vbMovementIncomeId
                                AND Movement_Pretension.StatusId <> zc_Enum_Status_Erased()
                              GROUP BY MI_Pretension.ParentId
                              )

          -- таблица остатков
          , tmpContainerRemains AS (SELECT Container.Id AS ContainerId
                                  , Container.ObjectId  
                                  , COALESCE (Container.Amount,0) AS Amount 
                             FROM Container 
                                  INNER JOIN Pretension ON Pretension.GoodsId = Container.ObjectId
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.WhereObjectId = vbUnitid
                               AND COALESCE (Container.Amount,0) <> 0
                             GROUP BY Container.Id, Container.ObjectId, Container.Amount
                             )
          , tmpRemainsAll AS (SELECT tmp.GoodsId
                                   , SUM (tmp.RemainsStart)       AS RemainsStart
                              FROM (SELECT tmpContainer.ObjectId  AS GoodsId
                                         , tmpContainer.Amount - (SUM (COALESCE(MIContainer.Amount, 0)))  AS RemainsStart
                                    FROM tmpContainerRemains AS tmpContainer
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                        AND MIContainer.OperDate >= vbOperDate
                                                                        AND MIContainer.DescId = zc_Container_Count()
                                    GROUP BY tmpContainer.ContainerId
                                           , tmpContainer.ObjectId
                                           , tmpContainer.Amount
                                    HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                    ) AS tmp
                              GROUP BY tmp.GoodsId
                             )


            SELECT
                MovementItem.Id
              , MovementItem.ParentId  
              , MovementItem.GoodsId
              , MovementItem.GoodsCode
              , MovementItem.GoodsName
              , MovementItem.Amount
              , MovementItem.ReasonDifferencesId
              , MovementItem.ReasonDifferencesName
              , MovementItem.AmountIncome
              , MovementItem.AmountManual
              , MovementItem.AmountDiff
              , MovementItem.isChecked
              , CASE WHEN MovementItem.isChecked THEN 'Актуальна' ELSE 'Неактуальна' END::TVarChar AS CheckedName
              , MovementItem_Income.Price
              , ROUND(COALESCE(MovementItem.Amount , 0) * MovementItem_Income.Price, 2 )::TFloat AS Summ
              , MovementItem.isErased
              , MovementItem_Income.AmountInIncome
              , (COALESCE(MovementItem_Income.AmountRemains,0)
                  + CASE WHEN MovementItem.StatusId = zc_Enum_Status_Complete()
                      THEN MovementItem.Amount
                    ELSE 0
                    END)::TFloat AS Remains
              , tmpRemainsAll.RemainsStart :: TFloat      AS RemainsAll
              , CASE 
                  WHEN MovementItem.Amount > COALESCE(MovementItem_Income.AmountInIncome,0) or
                       MovementItem.Amount > COALESCE(MovementItem_Income.AmountRemains,0)
                    THEN 36095
                END AS WarningColor
             , MovementItem_Income.ExpirationDate
             , MovementItem_Income.PartionGoods
             , MovementItem_Income.MakerName
             , ReturnOther.Amount                         AS AmountOther
        FROM Pretension AS MovementItem
            LEFT OUTER JOIN Income AS MovementItem_Income
                                   ON MovementItem.ParentId = MovementItem_Income.Id
            LEFT JOIN tmpRemainsAll ON tmpRemainsAll.GoodsId = MovementItem.GoodsId
            LEFT JOIN ReturnOther ON ReturnOther.ParentId = MovementItem.ParentId
            

;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.12.21                                                       *
 
*/

-- тест


select * from gpSelect_MovementItem_Pretension(inMovementId := 26008006 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');