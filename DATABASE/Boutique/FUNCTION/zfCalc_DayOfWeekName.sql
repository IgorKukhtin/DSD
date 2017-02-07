-- Function: zfCalc_DayOfWeekName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DayOfWeekName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DayOfWeekName (inOperDate TDateTime)
RETURNS TABLE ( Number integer, DayOfWeekName TVarChar, DayOfWeekName_Full TVarChar) AS
$BODY$
BEGIN
  RETURN QUERY
  SELECT CASE EXTRACT (DOW FROM inOperDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inOperDate) END  ::integer AS Number
       , CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN 'Пн'
               WHEN 2 THEN 'Вт'
               WHEN 3 THEN 'Ср'
               WHEN 4 THEN 'Чт'
               WHEN 5 THEN 'Пт'
               WHEN 6 THEN 'Сб'
               WHEN 0 THEN 'Вс'
               ELSE '???'
          END :: TVarChar AS DayOfWeekName
       , CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN 'Понедельник'
               WHEN 2 THEN 'Вторник'
               WHEN 3 THEN 'Среда'
               WHEN 4 THEN 'Четверг'
               WHEN 5 THEN 'Пятница'
               WHEN 6 THEN 'Суббота'
               WHEN 0 THEN 'Воскресенье'
               ELSE '???'
          END :: TVarChar AS DayOfWeekName_Full
         ;
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
--SELECT zfCalc_DayOfWeekName (CURRENT_DATE)
--SELECT zfCalc_DayOfWeekName ('22.01.2016')
