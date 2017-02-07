-- Function: zfCalc_MonthName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthName (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'Январь'
               WHEN 2 THEN 'Февраль'
               WHEN 3 THEN 'Март'
               WHEN 4 THEN 'Апрель'
               WHEN 5 THEN 'Май'
               WHEN 6 THEN 'Июнь'
               WHEN 7 THEN 'Июль'
               WHEN 8 THEN 'Август'
               WHEN 9 THEN 'Сентябрь'
               WHEN 10 THEN 'Октябрь'
               WHEN 11 THEN 'Ноябрь'
               WHEN 12 THEN 'Декабрь'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthName (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.15                                        *  
*/

-- тест
-- SELECT zfCalc_MonthName (CURRENT_DATE)
