-- Function: gpSelect_MovementItem_FinalSUA()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_FinalSUA (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_FinalSUA(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Remains TFloat, Amount TFloat
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_FinalSUA());
    vbUserId:= lpGetUserBySession (inSession);

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                         AS Id
                                      , MovementItem.ObjectId                   AS GoodsId
                                      , MILinkObject_Unit.ObjectId              AS UnitId
                                      , MovementItem.Amount                     AS Amount
                                      , MovementItem.isErased                   AS isErased
                                 FROM MovementItem

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                      ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 )
                 , tmpContainer AS (SELECT MI_Master.GoodsId                  AS GoodsId
                                         , MI_Master.UnitId                   AS UnitId
                                         , Sum(Container.Amount)::TFloat      AS Amount
                                    FROM MI_Master
                                      
                                         INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                             AND Container.ObjectId = MI_Master.GoodsId
                                                             AND Container.WhereObjectId = MI_Master.UnitId
                                                             AND Container.Amount <> 0
                                    GROUP BY MI_Master.GoodsId
                                           , MI_Master.UnitId
                                    )


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , Object_Goods.ObjectCode                           AS GoodsCode
                    , Object_Goods.ValueData                            AS GoodsName
                    , Object_Unit.Id                                    AS UnitId
                    , Object_Unit.ObjectCode                            AS UnitCode
                    , Object_Unit.ValueData                             AS UnitName
                    , Container.Amount                                  AS Remains
                    , MI_Master.Amount                                  AS Amount
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId
                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_Master.UnitId

                   LEFT JOIN tmpContainer AS Container
                                          ON Container.GoodsId = MI_Master.GoodsId
                                         AND Container.UnitId = MI_Master.UnitId

                   ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.02.21                                                      *
*/
-- 
select * from gpSelect_MovementItem_FinalSUA(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');