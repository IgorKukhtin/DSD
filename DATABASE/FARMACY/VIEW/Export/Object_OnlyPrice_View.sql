-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_OnlyPrice_View;

CREATE OR REPLACE VIEW Object_OnlyPrice_View 
AS
    SELECT
        ObjectLink_Price_Unit.ChildObjectId     AS UnitId
      , Price_Goods.ChildObjectId               AS GoodsId
      , Price_Value.ValueData                   AS Price
      , price_datechange.valuedata              AS DateChange
    FROM Object AS Object_Price
        LEFT JOIN ObjectFloat       AS Price_Value
                                    ON Price_Value.ObjectId = Object_Price.Id
                                   AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
        LEFT JOIN ObjectDate        AS Price_DateChange
                                    ON Price_DateChange.ObjectId = Object_Price.Id
                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
        LEFT JOIN ObjectLink        AS Price_Goods
                                    ON Price_Goods.ObjectId = Object_Price.Id
                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

        LEFT JOIN ObjectLink        AS ObjectLink_Price_Unit
                                    ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
    WHERE 
        Object_Price.DescId = zc_Object_Price();

ALTER TABLE Object_OnlyPrice_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
29.08.15                                                         * + isClose, NotRecalc
 23.07.14                         *
*/

-- тест
-- SELECT * FROM Object_OnlyPrice_View
