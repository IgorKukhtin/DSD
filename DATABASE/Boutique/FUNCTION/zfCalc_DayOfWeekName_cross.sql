-- Function: zfCalc_DayOfWeekName_cross (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DayOfWeekName_cross (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DayOfWeekName_cross (inOperDate TDateTime)
RETURNS TABLE (Ord_dow            Integer
             , Ord                Integer
             , DayOfWeekName      TVarChar
             , DayOfWeekName_Full TVarChar
              )
AS
$BODY$
BEGIN
  RETURN QUERY
  SELECT EXTRACT (DOW FROM inOperDate) :: Integer AS Ord_dow
       , CASE EXTRACT (DOW FROM inOperDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inOperDate) END :: Integer AS Ord
       , CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN '1-Пн'
               WHEN 2 THEN '2-Вт'
               WHEN 3 THEN '3-Ср'
               WHEN 4 THEN '4-Чт'
               WHEN 5 THEN '5-Пт'
               WHEN 6 THEN '6-Сб'
               WHEN 0 THEN '7-Вс'
               ELSE '???'
          END :: TVarChar AS DayOfWeekName
       , CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN '1-Понедельник'
               WHEN 2 THEN '2-Вторник'
               WHEN 3 THEN '3-Среда'
               WHEN 4 THEN '4-Четверг'
               WHEN 5 THEN '5-Пятница'
               WHEN 6 THEN '6-Суббота'
               WHEN 0 THEN '7-Воскресенье'
               ELSE '???'
          END :: TVarChar AS DayOfWeekName_Full
         ;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DayOfWeekName_cross (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.18                                        *  
*/

-- тест
-- SELECT zfCalc.* FROM (SELECT GENERATE_SERIES (CURRENT_DATE, CURRENT_DATE + INTERVAL '6 DAY', '1 DAY' :: INTERVAL) AS OperDate) AS tmp CROSS JOIN zfCalc_DayOfWeekName_cross (tmp.OperDate) AS zfCalc ORDER BY 2
