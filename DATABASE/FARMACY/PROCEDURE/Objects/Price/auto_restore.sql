SELECT *
FROM ObjectLink  AS ObjectLink_Price_Unit

     LEFT JOIN ObjectFloat       AS MCS_Value
             ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
     LEFT JOIN ObjectFloat       AS Price_MCSValueOld
             ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()

     LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
             ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
     LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
             ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()

     
     LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
             ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
     LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
             ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()

     INNER JOIN ObjectBoolean     AS Price_MCSAuto
             ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
            AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
            AND Price_MCSAuto.ValueData = TRUE

WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
  AND MCS_EndDateMCSAuto.ValueData < CURRENT_DATE + INTERVAL '1 DAY'
