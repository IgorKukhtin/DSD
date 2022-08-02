-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut22 (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnOut(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MorionCode integer
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , isErased Boolean
             , AmountInIncome TFloat
             , Remains TFloat
             , RemainsAll TFloat
             , AmountCheck TFloat
             , WarningColor Integer
             , ExpirationDate TDateTime
             , PartionGoods TVarChar
             , MakerName TVarChar
             , AmountOther TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementIncomeId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDateEnd TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
    --Номер прихода
    SELECT Movement.ParentId 
         , Movement.OperDate 
         , MovementLinkObject_Unit.ObjectId
         INTO vbMovementIncomeId, vbOperDate, vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
    WHERE Movement.Id = inMovementId;

    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';

    --Результат    
    IF inShowAll THEN

        RETURN QUERY
            WITH 
            tmpIncome AS ( --Остатки по приходу
                           SELECT MovementItem_Income.Id          AS Id
                                , MovementItem_Income.ObjectId    AS GoodsId
                                , Object_Goods.ObjectCode  AS GoodsCode
                                , Object_Goods.Name   AS GoodsName
                                , Object_Goods.MorionCode
                                , MIFloat_Price.ValueData         AS Price
                                , MovementItem_Income.Amount      AS AmountInIncome
                 
                                , MIDate_ExpirationDate.ValueData            AS ExpirationDate
                                , MIString_PartionGoods.ValueData            AS PartionGoods
                                , ObjectString_Goods_Maker.ValueData         AS MakerName
                           FROM MovementItem AS MovementItem_Income
                                 LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem_Income.ObjectId
                                 LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId


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
                            , tmpIncome.MorionCode
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

          , ReturnOther AS (SELECT MI_ReturnOut.ParentId
                                 , SUM(MI_ReturnOut.Amount)::TFloat AS Amount
                            FROM Movement AS Movement_ReturnOut
                                 INNER JOIN MovementItem AS MI_ReturnOut
                                                         ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                                        AND MI_ReturnOut.isErased   = FALSE
                                                        AND MI_ReturnOut.DescId     = zc_MI_Master()
                              WHERE Movement_ReturnOut.Id <> inMovementId
                                AND Movement_ReturnOut.ParentId = vbMovementIncomeId
                                AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
                              GROUP BY MI_ReturnOut.ParentId
                              )

          , tmpCheck AS (SELECT MI_Check.ObjectId               AS GoodsId
                              , SUM (MI_Check.Amount) ::TFloat  AS Amount
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
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

          , ReturnOut AS (SELECT Movement_ReturnOut.StatusId
                               , MI_ReturnOut.Id
                               , MI_ReturnOut.ParentId
                               , MI_ReturnOut.ObjectId       AS GoodsId
                               , Object_Goods.ObjectCode  AS GoodsCode
                               , Object_Goods.Name   AS GoodsName
                               , Object_Goods.MorionCode
                               , MI_ReturnOut.Amount
                               , MIFloat_Price.ValueData  AS Price
                               , (((COALESCE (MI_ReturnOut.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
                               , MI_ReturnOut.isErased
                          FROM Movement AS Movement_ReturnOut
                               INNER JOIN MovementItem AS MI_ReturnOut
                                                       ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                                      AND (MI_ReturnOut.isErased  = FALSE OR inIsErased = TRUE)
                                                      AND MI_ReturnOut.DescId     = zc_MI_Master()
                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_ReturnOut.ObjectId
                               LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                               

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MI_ReturnOut.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          WHERE Movement_ReturnOut.Id = inMovementId
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
         SELECT MovementItem_ReturnOut.Id
              , MovementItem_Income.Id                                                    AS ParentId
              , COALESCE(MovementItem_ReturnOut.GoodsId, MovementItem_Income.GoodsId)     AS GoodsId
              , COALESCE(MovementItem_ReturnOut.GoodsCode, MovementItem_Income.GoodsCode) AS GoodsCode
              , COALESCE(MovementItem_ReturnOut.GoodsName, MovementItem_Income.GoodsName) AS GoodsName
              , COALESCE(MovementItem_ReturnOut.MorionCode, MovementItem_Income.MorionCode) AS MorionCode
              , MovementItem_ReturnOut.Amount                                             AS Amount
              , COALESCE(MovementItem_ReturnOut.Price, MovementItem_Income.Price)         AS Price
              , MovementItem_ReturnOut.AmountSumm                                         AS AmountSumm
              , MovementItem_ReturnOut.isErased                                           AS isErased
              , MovementItem_Income.AmountInIncome                                        AS AmountInIncome
              , (COALESCE(MovementItem_Income.AmountRemains,0)
                  + CASE WHEN MovementItem_ReturnOut.StatusId = zc_Enum_Status_Complete()
                      THEN MovementItem_ReturnOut.Amount
                    ELSE 0
                    END)::TFloat                                                          AS Remains
              , tmpRemainsAll.RemainsStart :: TFloat                                      AS RemainsAll
              , tmpCheck.Amount::TFloat                                                   AS AmountCheck
              , CASE 
                  WHEN MovementItem_ReturnOut.Amount > COALESCE(MovementItem_Income.AmountInIncome,0) or
                       MovementItem_ReturnOut.Amount > COALESCE(MovementItem_Income.AmountRemains,0)
                    THEN 36095
                END                                                                       AS WarningColor

             , MovementItem_Income.ExpirationDate
             , MovementItem_Income.PartionGoods
             , MovementItem_Income.MakerName
             , ReturnOther.Amount                                                         AS AmountOther
         FROM Income AS MovementItem_Income
              FULL JOIN ReturnOut AS MovementItem_ReturnOut 
                                  ON MovementItem_ReturnOut.ParentId = MovementItem_Income.Id
              
              LEFT JOIN tmpCheck ON tmpCheck.GoodsId = COALESCE(MovementItem_ReturnOut.GoodsId, MovementItem_Income.GoodsId)

              LEFT JOIN tmpRemainsAll ON tmpRemainsAll.GoodsId = COALESCE(MovementItem_ReturnOut.GoodsId, MovementItem_Income.GoodsId)
 
              LEFT JOIN ReturnOther ON ReturnOther.ParentId = COALESCE(MovementItem_ReturnOut.ParentId, MovementItem_Income.MovementItemId)

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
                            , tmpIncome.ExpirationDate
                            , tmpIncome.PartionGoods
                            , tmpIncome.MakerName
                            , tmpContainer.Amount                AS AmountRemains
                       FROM tmpIncome
                            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpIncome.Id
                        )

          , ReturnOut AS (SELECT Movement_ReturnOut.StatusId
                               , MI_ReturnOut.Id
                               , MI_ReturnOut.ParentId
                               , MI_ReturnOut.ObjectId    AS GoodsId
                               , Object_Goods.ObjectCode  AS GoodsCode
                               , Object_Goods.Name   AS GoodsName
                               , Object_Goods.MorionCode
                               , MI_ReturnOut.Amount
                               , MIFloat_Price.ValueData  AS Price
                               , (((COALESCE (MI_ReturnOut.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
                               , MI_ReturnOut.isErased
                          FROM Movement AS Movement_ReturnOut
                               INNER JOIN MovementItem AS MI_ReturnOut
                                                       ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                                      AND (MI_ReturnOut.isErased  = FALSE OR inIsErased = TRUE)
                                                      AND MI_ReturnOut.DescId     = zc_MI_Master()
                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_ReturnOut.ObjectId
                               LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                               
                        
                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MI_ReturnOut.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            WHERE Movement_ReturnOut.Id = inMovementId
                            )

          , ReturnOther AS (SELECT MI_ReturnOut.ParentId
                                 , SUM(MI_ReturnOut.Amount)::TFloat AS Amount
                            FROM Movement AS Movement_ReturnOut
                                 INNER JOIN MovementItem AS MI_ReturnOut
                                                         ON MI_ReturnOut.MovementId = Movement_ReturnOut.Id
                                                        AND MI_ReturnOut.isErased   = FALSE
                                                        AND MI_ReturnOut.DescId     = zc_MI_Master()
                              WHERE Movement_ReturnOut.Id <> inMovementId
                                AND Movement_ReturnOut.ParentId = vbMovementIncomeId
                                AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
                              GROUP BY MI_ReturnOut.ParentId
                              )

          , tmpCheck AS (SELECT MI_Check.ObjectId                AS GoodsId
                              , SUM (MI_Check.Amount) ::TFloat   AS Amount
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
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

          -- таблица остатков
          , tmpContainerRemains AS (SELECT Container.Id AS ContainerId
                                  , Container.ObjectId  
                                  , COALESCE (Container.Amount,0) AS Amount 
                             FROM Container 
                                  INNER JOIN ReturnOut ON ReturnOut.GoodsId = Container.ObjectId
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
              , MovementItem.MorionCode
              , MovementItem.Amount
              , MovementItem.Price
              , MovementItem.AmountSumm
              , MovementItem.isErased
              , MovementItem_Income.AmountInIncome
              , (COALESCE(MovementItem_Income.AmountRemains,0)
                  + CASE WHEN MovementItem.StatusId = zc_Enum_Status_Complete()
                      THEN MovementItem.Amount
                    ELSE 0
                    END)::TFloat AS Remains
              , tmpRemainsAll.RemainsStart :: TFloat      AS RemainsAll
              , tmpCheck.Amount::TFloat                   AS AmountCheck
              , CASE 
                  WHEN MovementItem.Amount > COALESCE(MovementItem_Income.AmountInIncome,0) or
                       MovementItem.Amount > COALESCE(MovementItem_Income.AmountRemains,0)
                    THEN 36095
                END AS WarningColor
             , MovementItem_Income.ExpirationDate
             , MovementItem_Income.PartionGoods
             , MovementItem_Income.MakerName
             , ReturnOther.Amount                         AS AmountOther
        FROM ReturnOut AS MovementItem
            LEFT OUTER JOIN Income AS MovementItem_Income
                                   ON MovementItem.ParentId = MovementItem_Income.Id
            LEFT JOIN tmpCheck ON tmpCheck.GoodsId = MovementItem.GoodsId
            LEFT JOIN tmpRemainsAll ON tmpRemainsAll.GoodsId = MovementItem.GoodsId
            LEFT JOIN ReturnOther ON ReturnOther.ParentId = MovementItem.ParentId
            

;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.11.19         *
 16.02.18         *
 27.10.16         *
 14.04.16         *
 10.02.15                         *
 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
--select * from gpSelect_MovementItem_ReturnOut(inMovementId := 885245 , inShowAll := 'TRUE' , inIsErased := 'False' ,  inSession := '3');
--select * from gpSelect_MovementItem_ReturnOut(inMovementId := 8086637 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_ReturnOut(inMovementId := 27709192 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');