-- Function: gpSelect_MovementItem_SendPartionDate()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendPartionDate (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendPartionDate(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbDate180  TDateTime;
    DECLARE vbDate30   TDateTime;
    DECLARE vbOperDate   TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendPartionDate());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + INTERVAL '180 DAY';
    vbDate30  := CURRENT_DATE + INTERVAL '30 DAY';
    
    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
         , Movement.OperDate
   INTO vbUnitId, vbOperDate
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    -- остатки по подразделению со срокок менее 6 месяцев
    CREATE TEMP TABLE tmpRemains (ContainerId Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO tmpRemains (ContainerId, GoodsId, Amount, ExpirationDate)
           SELECT tmp.ContainerId
                , tmp.GoodsId
                , SUM (tmp.Amount) AS Amount                                                                    -- остаток
                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDate -- Срок годности
           FROM (SELECT Container.Id  AS ContainerId
                      , Container.ObjectId            AS GoodsId
                      , SUM(Container.Amount)::TFloat AS Amount
                 FROM Container
                 WHERE Container.DescId = zc_Container_Count()
                   AND Container.WhereObjectId = vbUnitId
                   AND Container.Amount <> 0
                 GROUP BY Container.Id
                        , Container.ObjectId   
                 HAVING SUM(Container.Amount) <> 0
                 ) AS tmp
              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
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
           WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
           GROUP BY tmp.ContainerId
                  , tmp.GoodsId
                  , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
           ;

    -- Результат
    IF inShowAll THEN
        -- Результат такой
       OPEN Cursor1 FOR
        WITH 
        MI_Master AS (SELECT MovementItem.Id                    AS Id
                           , MovementItem.ObjectId              AS GoodsId
                           , MovementItem.Amount                AS Amount
                           , MIFloat_Price.ValueData            AS Price
                           , COALESCE (MIFloat_PriceExp.ValueData, MIFloat_Price.ValueData) AS PriceExp
                           , MovementItem.isErased              AS isErased
                        FROM  MovementItem
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_PriceExp
                                                         ON MIFloat_PriceExp.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PriceExp.DescId = zc_MIFloat_PriceExp()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Master() 
                          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE) 
                       )

      , tmpPrice AS (SELECT Price_Goods.ChildObjectId                AS GoodsId
                          , ROUND(Price_Value.ValueData, 2) ::TFloat AS Price
                     FROM ObjectLink AS ObjectLink_Price_Unit
                          LEFT JOIN ObjectFloat AS Price_Value
                                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          LEFT JOIN ObjectLink AS Price_Goods
                                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                     WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit() 
                       AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                     )
                                     
        SELECT COALESCE(MI_Master.Id,0)                     AS Id
             , Object_Goods.Id                              AS GoodsId
             , Object_Goods.ObjectCode                      AS GoodsCode
             , Object_Goods.ValueData                       AS GoodsName
             , MI_Master.Amount                             AS Amount
             , tmpRemains.Amount::TFloat                    AS AmountRemains
             , COALESCE(MI_Master.Price, tmpPrice.Price)    AS Price
             , COALESCE(MI_Master.PriceExp, tmpPrice.Price) AS PriceExp
             , COALESCE(MI_Master.IsErased,FALSE)           AS isErased
        FROM (SELECT tmpRemains.GoodsId, SUM (tmpRemains.Amount) AS Amount
              FROM tmpRemains GROUP BY tmpRemains.GoodsId) AS tmpRemains
            FULL OUTER JOIN MI_Master ON MI_Master.GoodsId = tmpRemains.GoodsId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId)
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId)
        WHERE Object_Goods.isErased = FALSE 
           OR MI_Master.Id IS NOT NULL;
    
    RETURN NEXT Cursor1;
    
    OPEN Cursor2 FOR
            WITH
                MI_Master AS (SELECT MovementItem.Id                    AS Id
                                   , MovementItem.ObjectId              AS GoodsId
                              FROM  MovementItem
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId = zc_MI_Master() 
                                AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                              )

              , MI_Child AS (SELECT MovementItem.Id                    AS Id
                                  , MovementItem.ParentId              AS ParentId
                                  , MovementItem.ObjectId              AS GoodsId
                                  , MovementItem.Amount                AS Amount
                                  , MIFloat_ContainerId.ValueData      AS ContainerId
                                  , MIFloat_Expired.ValueData          AS Expired
                                  , MovementItem.isErased              AS isErased
                             FROM  MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Expired
                                                             ON MIFloat_Expired.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Expired.DescId = zc_MIFloat_Expired()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Child() 
                               AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                              )
                                      
            SELECT
                COALESCE (MI_Child.Id, 0)     AS Id
              , COALESCE (MI_Child.ParentId, 0) AS ParentId
              , COALESCE (MI_Child.GoodsId, tmpRemains.GoodsId) AS GoodsId
              , MI_Child.Amount      ::TFloat AS Amount
              , tmpRemains.Amount    ::TFloat AS AmountRemains
              , tmpRemains.ContainerId ::Integer
              , tmpRemains.ExpirationDate
              , COALESCE (tmpRemains.ContainerId, 0)  ::TFloat
              , CASE WHEN tmpRemains.ExpirationDate < vbOperDate THEN 0
                     WHEN tmpRemains.ExpirationDate <= vbDate30 THEN 1
                     ELSE 2
                END ::TVarChar AS Expired

              , CASE WHEN tmpRemains.ExpirationDate < vbOperDate THEN 'Просрочено' 
                     WHEN tmpRemains.ExpirationDate <= vbDate30 THEN 'Меньше 1 месяца'
                     ELSE 'Меньше 6 месяцев'
                END ::TVarChar AS Expired_text

              , COALESCE (MI_Child.IsErased, FALSE) :: Boolean AS isErased
            FROM tmpRemains
                FULL JOIN MI_Child ON MI_Child.GoodsId     = tmpRemains.GoodsId
                                  AND MI_Child.ContainerId = tmpRemains.ContainerId
            ;  

    RETURN NEXT Cursor2;
    
    ELSE
        -- Результат другой
       OPEN Cursor1 FOR
            WITH
                MI_Master AS (SELECT MovementItem.Id                    AS Id
                                   , MovementItem.ObjectId              AS GoodsId
                                   , MovementItem.Amount                AS Amount
                                   , MIFloat_Price.ValueData            AS Price
                                   , COALESCE (MIFloat_PriceExp.ValueData, MIFloat_Price.ValueData) AS PriceExp
                                   , MovementItem.isErased              AS isErased
                              FROM  MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  LEFT JOIN MovementItemFloat AS MIFloat_PriceExp
                                                              ON MIFloat_PriceExp.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceExp.DescId = zc_MIFloat_PriceExp()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId = zc_MI_Master() 
                                AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                              )  
                                      
            SELECT MI_Master.Id          AS Id
                 , MI_Master.GoodsId     AS GoodsId
                 , Object_Goods.ObjectCode       AS GoodsCode
                 , Object_Goods.ValueData        AS GoodsName
                 , MI_Master.Amount              AS Amount
                 , tmpRemains.Amount::TFloat     AS AmountRemains
                 , MI_Master.Price               AS Price
                 , MI_Master.PriceExp            AS PriceExp
                 , MI_Master.IsErased    AS isErased
            FROM MI_Master
                LEFT JOIN (SELECT tmpRemains.GoodsId, SUM (tmpRemains.Amount) AS Amount
                           FROM tmpRemains 
                           GROUP BY tmpRemains.GoodsId
                           ) AS tmpRemains ON tmpRemains.GoodsId = MI_Master.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId);

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
            WITH
                MI_Child AS (SELECT MovementItem.Id                    AS Id
                                  , MovementItem.ParentId              AS ParentId
                                  , MovementItem.ObjectId              AS GoodsId
                                  , MovementItem.Amount                AS Amount
                                  , MIFloat_ContainerId.ValueData      AS ContainerId
                                  , MIFloat_Expired.ValueData          AS Expired
                                  , MovementItem.isErased              AS isErased
                             FROM  MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Expired
                                                             ON MIFloat_Expired.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Expired.DescId = zc_MIFloat_Expired()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Child() 
                               AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                              )
                                      
            SELECT
                COALESCE (MI_Child.Id, 0)     AS Id
              , COALESCE (MI_Child.ParentId, 0) AS ParentId
              , COALESCE (MI_Child.GoodsId, tmpRemains.GoodsId) AS GoodsId
              , MI_Child.Amount      ::TFloat AS Amount
              , tmpRemains.Amount    ::TFloat AS AmountRemains
              , MI_Child.ContainerId ::TFloat
              , MI_Child.Expired
              , CASE WHEN MI_Child.Expired = 0 THEN 'Просрочено'
                     WHEN MI_Child.Expired = 1 THEN 'Меньше 1 месяца'
                     WHEN MI_Child.Expired = 2 THEN 'Меньше 6 месяцев'
                     ELSE ''
                END :: TVarChar AS Expired_text
              , MI_Child.IsErased    AS isErased
            FROM MI_Child
                LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = MI_Child.GoodsId
                                    AND tmpRemains.ContainerId = MI_Child.ContainerId
            ;  

       RETURN NEXT Cursor2;

    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.19         *
*/
--select * from gpSelect_MovementItem_SendPartionDate(inMovementId := 4516628 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');