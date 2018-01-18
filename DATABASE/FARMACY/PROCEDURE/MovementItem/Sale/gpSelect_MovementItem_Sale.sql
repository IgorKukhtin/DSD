-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountRemains TFloat
             , Price TFloat, PriceSale TFloat, ChangePercent TFloat
             , Summ TFloat
             , isSP Boolean 
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbSPKindId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
                                                                                                                                                                                     
    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
         , MovementLinkObject_SPKind.ObjectId 
    INTO vbUnitId, vbSPKindId
    FROM MovementLinkObject AS MovementLinkObject_Unit
         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                      ON MovementLinkObject_SPKind.MovementId = inMovementId
                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
    WHERE MovementLinkObject_Unit.MovementId = inMovementId
      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH 
                tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                                   , SUM(Container.Amount)::TFloat       AS Amount
                              FROM Container
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId   
                              HAVING SUM(Container.Amount)<>0
                              )
             , MovementItem_Sale AS (SELECT
                                          MovementItem.Id                    AS Id
                                        , MovementItem.ObjectId              AS GoodsId
                                        , MovementItem.Amount                AS Amount
                                        , MIFloat_Price.ValueData            AS Price
                                        , COALESCE (MIFloat_PriceSale.ValueData, MIFloat_Price.ValueData) AS PriceSale
                                        , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                        , MIFloat_Summ.ValueData             AS Summ
                                        , MIBoolean_Sp.ValueData             AS isSp
                                        , MovementItem.isErased              AS isErased
                                     FROM  MovementItem
                                          LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                                                        ON MIBoolean_SP.MovementItemId = MovementItem.Id
                                                                       AND MIBoolean_SP.DescId = zc_MIBoolean_SP()

                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master() 
                                       AND (MovementItem.isErased = FALSE OR inIsErased = TRUE) 
                                    ) 
   , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
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
                                     
            SELECT COALESCE(MovementItem_Sale.Id,0)                     AS Id
                 , Object_Goods.Id                                      AS GoodsId
                 , Object_Goods.ObjectCode                              AS GoodsCode
                 , Object_Goods.ValueData                               AS GoodsName
                 , MovementItem_Sale.Amount                             AS Amount
                 , tmpRemains.Amount::TFloat                            AS AmountRemains
                 , COALESCE(MovementItem_Sale.Price, tmpPrice.Price)    AS Price
                 , COALESCE(MovementItem_Sale.PriceSale, tmpPrice.Price) AS PriceSale
                 , CASE WHEN vbSPKindId = zc_Enum_SPKind_1303() THEN COALESCE (MovementItem_Sale.ChangePercent, 100) ELSE MovementItem_Sale.ChangePercent END :: TFloat AS ChangePercent
                 , MovementItem_Sale.Summ
                 , MovementItem_Sale.isSP
                 , COALESCE(MovementItem_Sale.IsErased,FALSE)           AS isErased
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Sale ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId =  COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                /*LEFT OUTER JOIN Object_Price_View AS Object_Price
                                                  ON Object_Price.GoodsId = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                                                 AND Object_Price.UnitId = vbUnitId*/
            WHERE Object_Goods.isErased = FALSE 
               OR MovementItem_Sale.id is not null;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpRemains AS (SELECT Container.ObjectId                  AS GoodsId
                                    , SUM(Container.Amount)::TFloat       AS Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.Amount <> 0
                               GROUP BY Container.ObjectId 
                               HAVING SUM(Container.Amount)<>0
                              )
              , MovementItem_Sale AS (SELECT MovementItem.Id                    AS Id
                                           , MovementItem.ObjectId              AS GoodsId
                                           , MovementItem.Amount                AS Amount
                                           , MIFloat_Price.ValueData            AS Price
                                           , COALESCE (MIFloat_PriceSale.ValueData, MIFloat_Price.ValueData) AS PriceSale
                                           , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                           , MIFloat_Summ.ValueData             AS Summ
                                           , MIBoolean_Sp.ValueData             AS isSp
                                           , MovementItem.isErased              AS isErased
                                      FROM  MovementItem
                                          LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                                                        ON MIBoolean_SP.MovementItemId = MovementItem.Id
                                                                       AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId = zc_MI_Master() 
                                        AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                      )  
                                      
            SELECT
                MovementItem_Sale.Id          AS Id
              , MovementItem_Sale.GoodsId     AS GoodsId
              , Object_Goods.ObjectCode       AS GoodsCode
              , Object_Goods.ValueData        AS GoodsName
              , MovementItem_Sale.Amount      AS Amount
              , tmpRemains.Amount::TFloat     AS AmountRemains
              , MovementItem_Sale.Price       AS Price
              , MovementItem_Sale.PriceSale
              , MovementItem_Sale.ChangePercent
              , MovementItem_Sale.Summ
              , MovementItem_Sale.isSP
              , MovementItem_Sale.IsErased    AS isErased
            FROM MovementItem_Sale
                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 18.01.17         *
 22.02.17         *   
 13.10.15                                                          *
*/
--select * from gpSelect_MovementItem_Sale(inMovementId := 4516628 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');