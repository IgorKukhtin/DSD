-- Function: gpSelect_MovementItem_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_UnnamedEnterprises (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_UnnamedEnterprises(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsNameUkr TVarChar
             , NDSKindId Integer, NDSKindCode Integer, NDSKindName TVarChar
             , Amount TFloat, AmountRemains TFloat, AmountOrder TFloat
             , Price TFloat, Summ TFloat
             , CodeUKTZED TVarChar, ExchangeId Integer, ExchangeCode Integer, ExchangeName TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_UnnamedEnterprises());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
    INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_Unit
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
             , MovementItem_UnnamedEnterprises AS (SELECT
                                          MovementItem.Id                    AS Id
                                        , MovementItem.ObjectId              AS GoodsId
                                        , MovementItem.Amount                AS Amount
                                        , MIFloat_Price.ValueData            AS Price
                                        , MIFloat_Summ.ValueData             AS Summ
                                        , MovementItem.isErased              AS isErased
                                     FROM  MovementItem
                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
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

            SELECT COALESCE(MovementItem_UnnamedEnterprises.Id,0)       AS Id
                 , Object_Goods.Id                                      AS GoodsId
                 , Object_Goods.ObjectCode                              AS GoodsCode
                 , Object_Goods.ValueData                               AS GoodsName
                 , ObjectString_Goods_NameUkr.ValueData                 AS GoodsNameUkr

                 , ObjectLink_Goods_NDSKind.ChildObjectId               AS NDSKindId
                 , Object_NDSKind.ObjectCode                            AS NDSKindCode
                 , Object_NDSKind.ValueData                             AS NDSKindName

                 , MovementItem_UnnamedEnterprises.Amount               AS Amount
                 , tmpRemains.Amount::TFloat                            AS AmountRemains
                 , NULL::TFloat                                         AS AmountOrder
                 , COALESCE(MovementItem_UnnamedEnterprises.Price, tmpPrice.Price)    AS Price
                 , MovementItem_UnnamedEnterprises.Summ                 AS Summ

                 , ObjectString_Goods_CodeUKTZED.ValueData              AS CodeUKTZED

                 , Object_Exchange.Id                                   AS ExchangeId
                 , Object_Exchange.ObjectCode                           AS ExchangeCode
                 , Object_Exchange.ValueData                            AS ExchangeName

                 , COALESCE(MovementItem_UnnamedEnterprises.IsErased,FALSE)           AS isErased
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_UnnamedEnterprises ON tmpRemains.GoodsId = MovementItem_UnnamedEnterprises.GoodsId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_UnnamedEnterprises.GoodsId,tmpRemains.GoodsId)

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                       ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

                LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                       ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                     ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()
                LEFT JOIN Object AS Object_Exchange ON Object_Exchange.Id = ObjectLink_Goods_Exchange.ChildObjectId

                LEFT JOIN tmpPrice ON tmpPrice.GoodsId =  COALESCE(MovementItem_UnnamedEnterprises.GoodsId,tmpRemains.GoodsId)

            WHERE Object_Goods.isErased = FALSE
               OR MovementItem_UnnamedEnterprises.id is not null;
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
              , MovementItem_UnnamedEnterprises AS (SELECT MovementItem.Id                    AS Id
                                           , MovementItem.ObjectId              AS GoodsId
                                           , MovementItem.Amount                AS Amount
                                           , MIFloat_Price.ValueData            AS Price
                                           , MIFloat_Summ.ValueData             AS Summ
                                           , MovementItem.isErased              AS isErased
                                      FROM  MovementItem
                                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                      WHERE MovementItem.MovementId = inMovementId
                                        AND MovementItem.DescId = zc_MI_Master()
                                        AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                      )

            SELECT
                   MovementItem_UnnamedEnterprises.Id          AS Id
                 , Object_Goods.Id                                      AS GoodsId
                 , Object_Goods.ObjectCode                              AS GoodsCode
                 , Object_Goods.ValueData                               AS GoodsName
                 , ObjectString_Goods_NameUkr.ValueData                 AS GoodsNameUkr

                 , ObjectLink_Goods_NDSKind.ChildObjectId               AS NDSKindId
                 , Object_NDSKind.ObjectCode                            AS NDSKindCode
                 , Object_NDSKind.ValueData                             AS NDSKindName

                 , MovementItem_UnnamedEnterprises.Amount               AS Amount
                 , tmpRemains.Amount::TFloat                            AS AmountRemains
                 , NULL::TFloat                                         AS AmountOrder
                 , MovementItem_UnnamedEnterprises.Price                AS Price
                 , MovementItem_UnnamedEnterprises.Summ                 AS Summ

                 , ObjectString_Goods_CodeUKTZED.ValueData              AS CodeUKTZED

                 , Object_Exchange.Id                                   AS ExchangeId
                 , Object_Exchange.ObjectCode                           AS ExchangeCode
                 , Object_Exchange.ValueData                            AS ExchangeName

                 , MovementItem_UnnamedEnterprises.IsErased    AS isErased
            FROM MovementItem_UnnamedEnterprises

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem_UnnamedEnterprises.GoodsId

                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_UnnamedEnterprises.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_NameUkr
                                       ON ObjectString_Goods_NameUkr.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_NameUkr.DescId = zc_ObjectString_Goods_NameUkr()

                LEFT JOIN ObjectString AS ObjectString_Goods_CodeUKTZED
                                       ON ObjectString_Goods_CodeUKTZED.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_CodeUKTZED.DescId = zc_ObjectString_Goods_CodeUKTZED()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Exchange
                                     ON ObjectLink_Goods_Exchange.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Exchange.DescId = zc_ObjectLink_Goods_Exchange()
                LEFT JOIN Object AS Object_Exchange ON Object_Exchange.Id = ObjectLink_Goods_Exchange.ChildObjectId;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 30.09.18         *
*/
-- select * from gpSelect_MovementItem_UnnamedEnterprises(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');