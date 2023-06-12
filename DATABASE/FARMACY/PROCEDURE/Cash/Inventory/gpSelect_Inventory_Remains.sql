-- Function: gpSelect_Inventory_Remains()

DROP FUNCTION IF EXISTS gpSelect_Inventory_Remains(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_Remains(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, GoodsId Integer, Remains TFloat, Price TFloat
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 
   WITH tmpContainer AS (SELECT Container.WhereObjectId        AS UnitId
                              , Container.ObjectId             AS GoodsId
                              , SUM(Container.Amount)::TFloat  AS Remains
                            FROM Container
                            WHERE Container.DescId = zc_Container_Count()
                              AND Container.Amount <> 0 
                              AND Container.WhereObjectId in (SELECT ID FROM gpSelect_Object_Unit_Active(0, inSession))
                            GROUP BY Container.WhereObjectId
                                   , Container.ObjectId),
        tmpPrice AS (SELECT Container.UnitId
                          , Container.GoodsId
                          , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                  AND ObjectFloat_Goods_Price.ValueData > 0
                                 THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                 ELSE ROUND (Price_Value.ValueData, 2)
                            END :: TFloat                           AS Price
                     FROM tmpContainer AS Container
                          INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                               AND ObjectLink_Price_Unit.ChildObjectId = Container.UnitId
                          INNER JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                               AND Price_Goods.ChildObjectId = Container.GoodsId
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
                     )


   SELECT Container.UnitId
        , Container.GoodsId
        , Container.Remains
        , tmpPrice.Price
   FROM tmpContainer AS Container
   
        LEFT JOIN tmpPrice ON tmpPrice.UnitId  = Container.UnitId
                          AND tmpPrice.GoodsId = Container.GoodsId
   ;       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 13.07.23                                                      *
*/

-- тест
--     

select * from gpSelect_Inventory_Remains (inSession := '3')