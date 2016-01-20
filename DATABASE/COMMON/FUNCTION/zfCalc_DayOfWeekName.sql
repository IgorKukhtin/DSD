-- Function: zfCalc_DayOfWeekName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DayOfWeekName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DayOfWeekName (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN 'Понедельник'
               WHEN 2 THEN 'Вторник'
               WHEN 3 THEN 'Среда'
               WHEN 4 THEN 'Четверг'
               WHEN 5 THEN 'Пятница'
               WHEN 6 THEN 'Суббота'
               WHEN 0 THEN 'Воскресенье'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DayOfWeekName (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.16         *  
*/

-- тест
-- SELECT zfCalc_DayOfWeekName (CURRENT_DATE)
