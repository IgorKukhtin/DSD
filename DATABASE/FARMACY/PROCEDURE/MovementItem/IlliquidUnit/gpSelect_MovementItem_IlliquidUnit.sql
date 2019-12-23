-- Function: gpSelect_MovementItem_IlliquidUnit()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_IlliquidUnit (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_IlliquidUnit(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar

             , Amount TFloat, Price TFloat, Summ TFloat
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
         , Movement.OperDate
    INTO vbUnitId
       , vbOperDate
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    -- Результат
        RETURN QUERY
        WITH
            tmpPrice AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                      AND ObjectFloat_Goods_Price.ValueData > 0
                                     THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                     ELSE ROUND (Price_Value.ValueData, 2)
                                END :: TFloat                           AS Price
                              , Price_Goods.ChildObjectId               AS GoodsId
                         FROM ObjectLink AS ObjectLink_Price_Unit
                            LEFT JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            -- Фикс цена для всей Сети
                            LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                   ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                    ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                   AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                         WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                         )

       -- результат
       SELECT
             MovementItem.Id                                                     AS Id
           , Object_Goods.Id                                                     AS GoodsId
           , Object_Goods.ObjectCode                                             AS GoodsCode
           , Object_Goods.ValueData                                              AS GoodsName

           , MovementItem.Amount                                                 AS Amount
           , Object_Price.Price                                                  AS Price
           , Round(MovementItem.Amount * Object_Price.Price, 2)::TFloat          AS Price
           , MovementItem.IsErased                                               AS isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN tmpPrice AS Object_Price
                               ON Object_Price.GoodsId = MovementItem.ObjectId
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master()
         AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.19         *

*/

-- тест
-- select * from gpSelect_MovementItem_IlliquidUnit(inMovementId := 15183090 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');