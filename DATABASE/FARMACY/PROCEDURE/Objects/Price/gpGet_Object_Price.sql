DROP FUNCTION IF EXISTS gpGet_Object_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Price(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , DateChange tdatetime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , isErased boolean
             ) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Price());

    IF COALESCE (inId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            CAST (0 as Integer)      AS Id
          , CAST (0 as TFloat)       AS Price
          , CAST (0 as TFloat)       AS MCSValue

          , CAST (0 as Integer)      AS GoodsId
          , CAST (0 as Integer)      AS GoodsCode
          , CAST ('' as TVarChar)    AS GoodsName

          , CAST (0 as Integer)      AS UnitId
          , CAST (0 as Integer)      AS UnitCode
          , CAST ('' as TVarChar)    AS UnitName

          , CAST (Null as TDateTime) AS DateChange
          , CAST (Null as TDateTime) AS MCSDateChange

          , CAST (False as Boolean)  AS MCSIsClose
          , CAST (Null as TDateTime) AS MCSIsCloseDateChange
          , CAST (False as Boolean)  AS MCSNotRecalc
          , CAST (Null as TDateTime) AS MCSNotRecalcDateChange
           
          , CAST (False as Boolean)  AS Fix
          , CAST (Null as TDateTime) AS FixDateChange

          , CAST (NULL AS Boolean)   AS isErased;
    ELSE
        RETURN QUERY
        SELECT Object_Price.Id                         AS Id
             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
             , MCS_Value.ValueData                     AS MCSValue

             , Price_Goods.ChildObjectId               AS GoodsId
             , Object_Goods.ObjectCode                 AS GoodsCode
             , Object_Goods.ValueData                  AS GoodsName

             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
             , Object_Unit.ObjectCode                  AS UnitCode
             , Object_Unit.ValueData                   AS UnitName

             , price_datechange.valuedata              AS DateChange
             , MCS_datechange.valuedata                AS MCSDateChange
      
             , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
             , MCSIsClose_DateChange.valuedata         AS MCSIsCloseDateChange

             , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
             , MCSNotRecalc_DateChange.valuedata       AS MCSNotRecalcDateChange
      
             , COALESCE(Price_Fix.ValueData,False)     AS Fix
             , Fix_DateChange.valuedata                AS FixDateChange

             , Object_Goods.isErased                   AS isErased
           FROM Object AS Object_Price
               LEFT JOIN ObjectFloat AS Price_Value
                                     ON Price_Value.ObjectId = Object_Price.Id
                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
               LEFT JOIN ObjectDate AS Price_DateChange
                                    ON Price_DateChange.ObjectId = Object_Price.Id
                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
               LEFT JOIN ObjectFloat AS MCS_Value
                                     ON MCS_Value.ObjectId = Object_Price.Id
                                    AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
               LEFT JOIN ObjectFloat AS Price_MCSValueOld
                                     ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                    AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()

               LEFT JOIN ObjectDate AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = Object_Price.Id
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()

               LEFT JOIN ObjectLink AS Price_Goods
                                    ON Price_Goods.ObjectId = Object_Price.Id
                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Price_Goods.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                    ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Price_Unit.ChildObjectId
               LEFT JOIN ObjectBoolean AS MCS_isClose
                                    ON MCS_isClose.ObjectId = Object_Price.Id
                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
               LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                    ON MCSIsClose_DateChange.ObjectId = Object_Price.Id
                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
               LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
               LEFT JOIN ObjectDate AS MCSNotRecalc_DateChange
                                    ON MCSNotRecalc_DateChange.ObjectId = Object_Price.Id
                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
               LEFT JOIN ObjectBoolean AS Price_Fix
                                    ON Price_Fix.ObjectId = Object_Price.Id
                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
               LEFT JOIN ObjectDate AS Fix_DateChange
                                    ON Fix_DateChange.ObjectId = Object_Price.Id
                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
           WHERE Object_Price.DescId = zc_Object_Price() 
             AND Object_Price.Id = inId;

    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Price (Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
12.06.17          * убрали Object_Price_View
22.12.2015                                                       *
29.08.2015                                                       * + MCSIsClose, MCSNotRecalc
 31.07.15                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Price (497019, '2')
