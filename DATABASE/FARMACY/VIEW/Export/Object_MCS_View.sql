-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_Price_View;

CREATE OR REPLACE VIEW Object_MCS_View 
AS
    SELECT
        Object_Unit.Id                          AS UnitId
      , Object_Goods.Id                         AS GoodsId
      , MCS_Value.ValueData                     AS MCSValue
      , MCS_datechange.valuedata                AS MCSDateChange
    FROM Object AS Object_Price
        LEFT JOIN ObjectFloat       AS MCS_Value
                                    ON MCS_Value.ObjectId = Object_Price.Id
                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
        LEFT JOIN ObjectDate        AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = Object_Price.Id
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
        LEFT JOIN ObjectLink        AS Price_Goods
                                    ON Price_Goods.ObjectId = Object_Price.Id
                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
        LEFT JOIN Object            AS Object_Goods 
                                    ON Object_Goods.Id = Price_Goods.ChildObjectId

        LEFT JOIN ObjectLink        AS ObjectLink_Price_Unit
                                    ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
        LEFT JOIN Object            AS Object_Unit 
                                    ON Object_Unit.Id = ObjectLink_Price_Unit.ChildObjectId
        
    WHERE 
        Object_Price.DescId = zc_Object_Price();

ALTER TABLE Object_MCS_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
03.09.15                                                         *
 */

-- тест
-- SELECT * FROM Object_MCS_View
