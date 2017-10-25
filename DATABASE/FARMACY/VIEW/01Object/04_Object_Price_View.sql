-- View: Object_Price_View 

--DROP VIEW IF EXISTS Object_Price_View;
-- удаление вынесено в каскадное

CREATE OR REPLACE VIEW Object_Price_View 
AS
    SELECT
        Object_Price.Id                         AS Id
      , ROUND(Price_Value.ValueData,2)::TFloat AS Price
      , MCS_Value.ValueData                     AS MCSValue

      , Price_Goods.ChildObjectId               AS GoodsId
      , Object_Goods.ObjectCode                 AS GoodsCode
      , Object_Goods.ValueData                  AS GoodsName

      , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
      , Object_Unit.ObjectCode                  AS UnitCode
      , Object_Unit.ValueData                   AS UnitName

      , price_datechange.valuedata              AS DateChange
      , MCS_datechange.valuedata                AS MCSDateChange
      
      , Object_Goods.isErased                   AS isErased

      , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
      , MCSIsClose_DateChange.valuedata         AS MCSIsCloseDateChange

      , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
      , MCSNotRecalc_DateChange.valuedata       AS MCSNotRecalcDateChange
      
      , COALESCE(Price_Fix.ValueData,False)     AS Fix
      , Fix_DateChange.valuedata                AS FixDateChange

      , COALESCE(Price_Top.ValueData,False)     AS isTop
      , Price_TOPDateChange.ValueData           AS TopDateChange

      , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
      , Price_PercentMarkupDateChange.ValueData             AS PercentMarkupDateChange

      , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld
      , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
      , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
      , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
      , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
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
        LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                                    ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                   AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()

        LEFT JOIN ObjectDate        AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = Object_Price.Id
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()

        LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
                                    ON MCS_StartDateMCSAuto.ObjectId = Object_Price.Id
                                   AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
        LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
                                    ON MCS_EndDateMCSAuto.ObjectId = Object_Price.Id
                                   AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()

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
        LEFT JOIN ObjectDate        AS MCSIsClose_DateChange
                                    ON MCSIsClose_DateChange.ObjectId = Object_Price.Id
                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
        LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
        LEFT JOIN ObjectDate        AS MCSNotRecalc_DateChange
                                    ON MCSNotRecalc_DateChange.ObjectId = Object_Price.Id
                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
        LEFT JOIN ObjectBoolean     AS Price_Fix
                                    ON Price_Fix.ObjectId = Object_Price.Id
                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
        LEFT JOIN ObjectDate        AS Fix_DateChange
                                    ON Fix_DateChange.ObjectId = Object_Price.Id
                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
        LEFT JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = Object_Price.Id
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
        LEFT JOIN ObjectDate        AS Price_TOPDateChange
                                    ON Price_TOPDateChange.ObjectId = Object_Price.Id
                                   AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     

        LEFT JOIN ObjectFloat       AS Price_PercentMarkup
                                    ON Price_PercentMarkup.ObjectId = Object_Price.Id
                                   AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        LEFT JOIN ObjectDate        AS Price_PercentMarkupDateChange
                                    ON Price_PercentMarkupDateChange.ObjectId = Object_Price.Id
                                   AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()    

        LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                                    ON Price_MCSAuto.ObjectId = Object_Price.Id
                                   AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
        LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                                    ON Price_MCSNotRecalcOld.ObjectId = Object_Price.Id
                                   AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
    WHERE 
        Object_Price.DescId = zc_Object_Price();

ALTER TABLE Object_Price_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.06.17         *
 29.06.16         *
 29.08.15                                                       * + isClose, NotRecalc
 23.07.14                         *
*/

-- тест
-- SELECT * FROM Object_Price_View
