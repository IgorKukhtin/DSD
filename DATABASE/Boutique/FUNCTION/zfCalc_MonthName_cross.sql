-- Function: zfCalc_MonthName_cross (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthName_cross (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthName_cross (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN '01-Январь'
               WHEN 2 THEN '02-Февраль'
               WHEN 3 THEN '03-Март'
               WHEN 4 THEN '04-Апрель'
               WHEN 5 THEN '05-Май'
               WHEN 6 THEN '06-Июнь'
               WHEN 7 THEN '07-Июль'
               WHEN 8 THEN '08-Август'
               WHEN 9 THEN '09-Сентябрь'
               WHEN 10 THEN '10-Октябрь'
               WHEN 11 THEN '11-Ноябрь'
               WHEN 12 THEN '12-Декабрь'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthName_cross (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.18                                        *  
*/

-- тест
-- SELECT zfCalc_MonthName_cross (CURRENT_DATE)
