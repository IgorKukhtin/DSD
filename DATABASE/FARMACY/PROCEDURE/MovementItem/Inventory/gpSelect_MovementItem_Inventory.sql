-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
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
DECLARE
  vbUserId Integer;
  vbObjectId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
  -- inShowAll:= TRUE;
  vbUserId:= lpGetUserBySession (inSession);
  vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
  IF inShowAll = FALSE THEN
    RETURN QUERY
    SELECT
        MovementItem.Id                    AS Id
      , Object_Goods.Id                    AS GoodsId
      , Object_Goods.ObjectCode            AS GoodsCode
      , Object_Goods.ValueData             AS GoodsName
      , MovementItem.Amount                AS Amount
      , MIFloat_Price.ValueData            AS Price
      , MIFloat_Summ.ValueData             AS Summ
      , MovementItem.isErased              AS isErased
    FROM MovementItem
      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
      LEFT JOIN MovementItemFloat AS MIFloat_Price
          ON MIFloat_Price.MovementItemId = MovementItem.Id
               AND MIFloat_Price.DescId = zc_MIFloat_Price()
      LEFT JOIN MovementItemFloat AS MIFloat_Summ
          ON MIFloat_Summ.MovementItemId = MovementItem.Id
               AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
    WHERE
      MovementItem.MovementId = inMovementId
      AND 
      MovementItem.DescId     = zc_MI_Master()
      AND 
      (
        MovementItem.isErased = False
        or
        inIsErased = TRUE
      );
  ELSE
    RETURN QUERY
    WITH tmpPrice AS (SELECT Object_Price_View.GoodsId
               , Object_Price_View.Price
          FROM 
            Movement AS Movement_Inventory
            Inner Join MovementLinkObject as Inventory_Unit
                  ON Movement_Inventory.Id = Inventory_Unit.MovementId
                 AND Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
            Inner Join Object_Price_View ON Inventory_Unit.ObjectId = Object_Price_View.UnitId
          WHERE Movement_Inventory.Id = inMovementId
         )
         
    SELECT
        MovementItem.Id                    AS Id
      , Object_Goods.Id               AS GoodsId
      , Object_Goods.GoodsCodeInt          AS GoodsCode
      , Object_Goods.GoodsName             AS GoodsName
      , MovementItem.Amount                AS Amount
      , COALESCE(MIFloat_Price.ValueData,tmpPrice.Price) AS Price
      , MIFloat_Summ.ValueData             AS Summ
      , MovementItem.isErased              AS isErased
    FROM 
      Object_Goods_View AS Object_Goods 
      LEFT JOIN MovementItem ON Object_Goods.Id = MovementItem.ObjectId 
                             AND
                             MovementItem.MovementId = inMovementId
                             AND 
                             MovementItem.DescId     = zc_MI_Master()
                             AND 
                             (
                               MovementItem.isErased = False
                               or
                               inIsErased = TRUE
                             )
      LEFT JOIN MovementItemFloat AS MIFloat_Price
          ON MIFloat_Price.MovementItemId = MovementItem.Id
               AND MIFloat_Price.DescId = zc_MIFloat_Price()
      LEFT JOIN MovementItemFloat AS MIFloat_Summ
          ON MIFloat_Summ.MovementItemId = MovementItem.Id
               AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
      LEFT JOIN tmpPrice ON Object_Goods.Id = tmpPrice.GoodsId
    WHERE
      Object_Goods.ObjectId = vbObjectId
      AND
      (
        Object_Goods.IsErased = False
        or
        MovementItem.Id is not null
      );
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.
 11.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
