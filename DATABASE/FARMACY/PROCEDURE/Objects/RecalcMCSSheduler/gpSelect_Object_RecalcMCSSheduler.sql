-- Function: gpSelect_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpSelect_Object_RecalcMCSSheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RecalcMCSSheduler(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     -- возвращаем заголовки столбцов
     OPEN cur1 FOR SELECT tmpWeek.Id, tmpWeek.Name FROM gpSelect_Week(inSession) AS tmpWeek ORDER BY tmpWeek.ID;
     RETURN NEXT cur1;

     OPEN cur2 FOR
       WITH tmpUnit AS (SELECT
                             ROW_NUMBER() OVER (PARTITION BY ObjectFloat_Week.ValueData
                                                ORDER BY Object_RecalcMCSSheduler.IsErased, Object_Unit.Id) AS Ord
                           , Object_RecalcMCSSheduler.Id              AS Id
                           , ObjectFloat_Week.ValueData::Integer      AS Week
                           , Object_Unit.Id                           AS UnitId
                           , Object_Unit.ValueData                    AS UnitName
                           , Object_RecalcMCSSheduler.IsErased        AS IsErased
                           , CASE WHEN Object_RecalcMCSSheduler.IsErased THEN zc_Color_Red() ELSE zc_Color_Black() END AS Color_calc 
                        FROM Object AS Object_RecalcMCSSheduler
                             LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                  ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                             LEFT JOIN Object AS Object_Unit
                                              ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                             LEFT JOIN ObjectFloat AS ObjectFloat_Week
                                                   ON ObjectFloat_Week.ObjectId = Object_RecalcMCSSheduler.Id
                                                  AND ObjectFloat_Week.DescId = zc_ObjectFloat_RecalcMCSSheduler_Week()

                        WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()),
            tmpCountLines AS (SELECT DISTINCT tmpUnit.Ord FROM tmpUnit)

     SELECT
         tmpCountLines.Ord::Integer                              AS Ord,
         tmpUnitWeek1.UnitName                                   AS Value1,
         tmpUnitWeek2.UnitName                                   AS Value2,
         tmpUnitWeek3.UnitName                                   AS Value3,
         tmpUnitWeek4.UnitName                                   AS Value4,
         tmpUnitWeek5.UnitName                                   AS Value5,
         tmpUnitWeek6.UnitName                                   AS Value6,
         tmpUnitWeek7.UnitName                                   AS Value7,
         tmpUnitWeek1.ID                                         AS TypeId1,
         tmpUnitWeek2.ID                                         AS TypeId2,
         tmpUnitWeek3.ID                                         AS TypeId3,
         tmpUnitWeek4.ID                                         AS TypeId4,
         tmpUnitWeek5.ID                                         AS TypeId5,
         tmpUnitWeek6.ID                                         AS TypeId6,
         tmpUnitWeek7.ID                                         AS TypeId7,
         tmpUnitWeek1.Color_calc                                 AS Color_calc1,
         tmpUnitWeek2.Color_calc                                 AS Color_calc2,
         tmpUnitWeek3.Color_calc                                 AS Color_calc3,
         tmpUnitWeek4.Color_calc                                 AS Color_calc4,
         tmpUnitWeek5.Color_calc                                 AS Color_calc5,
         tmpUnitWeek6.Color_calc                                 AS Color_calc6,
         tmpUnitWeek7.Color_calc                                 AS Color_calc7
     FROM tmpCountLines
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 1) AS tmpUnitWeek1
                                                                         ON tmpUnitWeek1.Ord = tmpCountLines.Ord
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 2) AS tmpUnitWeek2
                                                                         ON tmpUnitWeek2.Ord = tmpCountLines.Ord
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 3) AS tmpUnitWeek3
                                                                         ON tmpUnitWeek3.Ord = tmpCountLines.Ord
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 4) AS tmpUnitWeek4
                                                                         ON tmpUnitWeek4.Ord = tmpCountLines.Ord
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 5) AS tmpUnitWeek5
                                                                         ON tmpUnitWeek5.Ord = tmpCountLines.Ord
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 6) AS tmpUnitWeek6
                                                                         ON tmpUnitWeek6.Ord = tmpCountLines.Ord
          LEFT OUTER JOIN (SELECT * FROM tmpUnit WHERE tmpUnit.Week = 7) AS tmpUnitWeek7
                                                                         ON tmpUnitWeek7.Ord = tmpCountLines.Ord
     ORDER BY tmpCountLines.Ord;

     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_RecalcMCSSheduler (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.12.18                                                       *
*/

-- тест
-- select * from gpSelect_Object_RecalcMCSSheduler(inSession := '3');