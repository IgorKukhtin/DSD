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

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendPartionDate());
    vbUserId:= lpGetUserBySession (inSession);
    
       -- Результат другой
       OPEN Cursor1 FOR
            WITH
                MI_Master AS (SELECT MovementItem.Id                    AS Id
                                   , MovementItem.ObjectId              AS GoodsId
                                   , MovementItem.Amount                AS Amount
                                   , MIFloat_AmountRemains.ValueData    AS AmountRemains
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
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                              ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId = zc_MI_Master() 
                                AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                              )  
                                      
            SELECT MI_Master.Id               AS Id
                 , MI_Master.GoodsId          AS GoodsId
                 , Object_Goods.ObjectCode    AS GoodsCode
                 , Object_Goods.ValueData     AS GoodsName
                 , MI_Master.Amount           AS Amount
                 , MI_Master.AmountRemains    AS AmountRemains
                 , MI_Master.Price            AS Price
                 , MI_Master.PriceExp         AS PriceExp
                 , MI_Master.IsErased         AS isErased
            FROM MI_Master
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId;

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
            WITH
                MI_Child AS (SELECT MovementItem.Id                    AS Id
                                  , MovementItem.ParentId              AS ParentId
                                  , MovementItem.ObjectId              AS GoodsId
                                  , MovementItem.Amount                AS Amount
                                  , MIFloat_ContainerId.ValueData      AS ContainerId
                                  , MIFloat_Expired.ValueData          AS Expired
                                  , MIDate_ExpirationDate.ValueData         AS ExpirationDate
                                  , MovementItem.isErased              AS isErased
                             FROM  MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Expired
                                                             ON MIFloat_Expired.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Expired.DescId = zc_MIFloat_Expired()
                                 LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                            ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                           AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()

                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Child() 
                               AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                              )
                                      
            SELECT
                COALESCE (MI_Child.Id, 0)     AS Id
              , COALESCE (MI_Child.ParentId, 0) AS ParentId
              , MI_Child.GoodsId AS GoodsId
              , MI_Child.ExpirationDate ::TDateTime
              , MI_Child.Amount      ::TFloat AS Amount
              , MI_Child.ContainerId ::TFloat
              , MI_Child.Expired
              , CASE WHEN COALESCE (MI_Child.Expired,0) = 0 THEN 'Просрочено'
                     WHEN MI_Child.Expired = 1 THEN 'Меньше 1 месяца'
                     WHEN MI_Child.Expired = 2 THEN 'Меньше 6 месяцев'
                     ELSE ''
                END :: TVarChar AS Expired_text
              , MI_Child.IsErased    AS isErased
            FROM MI_Child
            ;  

       RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.19         *
*/
--select * from gpSelect_MovementItem_SendPartionDate(inMovementId := 4516628 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');