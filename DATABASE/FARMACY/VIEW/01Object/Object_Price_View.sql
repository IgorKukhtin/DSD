-- View: Object_Goods_View

DROP VIEW IF EXISTS Object_Price_View;

CREATE OR REPLACE VIEW Object_Price_View 
AS
    SELECT
        Object_Price.Id                         AS Id
      , ROUND(Price_Value.ValueData,2)::TFloat AS Price
      , MCS_Value.ValueData                     AS MCSValue

      , Object_Goods.Id                         AS GoodsId
      , Object_Goods.ObjectCode                 AS GoodsCode
      , Object_Goods.ValueData                  AS GoodsName

      , Object_Unit.Id                          AS UnitId
      , Object_Unit.ObjectCode                  AS UnitCode
      , Object_Unit.ValueData                   AS UnitName

      , price_datechange.valuedata              AS DateChange
      , MCS_datechange.valuedata                AS MCSDateChange
      , Object_Goods.isErased                   AS isErased

      , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
      , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
    FROM Object AS Object_Price
        LEFT JOIN ObjectFloat       AS Price_Value
                                    ON Price_Value.ObjectId = Object_Price.Id
                                   AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
        LEFT JOIN ObjectDate        AS Price_DateChange
                                    ON Price_DateChange.ObjectId = Object_Price.Id
                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
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
        LEFT JOIN ObjectBoolean      AS MCS_isClose
                                    ON MCS_isClose.ObjectId = Object_Price.Id
                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
        LEFT JOIN ObjectBoolean      AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()

    WHERE 
        Object_Price.DescId = zc_Object_Price();

ALTER TABLE Object_Price_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».  ¬ÓÓ·Í‡ÎÓ ¿.¿.
29.08.15                                                         * + isClose, NotRecalc
 23.07.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Price_View
