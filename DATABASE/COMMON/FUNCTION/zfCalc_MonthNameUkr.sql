-- Function: zfCalc_DateToVarCharUkr (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthNameUkr (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthNameUkr (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'Січень'
               WHEN 2 THEN 'Лютий'
               WHEN 3 THEN 'Березень'
               WHEN 4 THEN 'Квітень'
               WHEN 5 THEN 'Травень'
               WHEN 6 THEN 'Червень'
               WHEN 7 THEN 'Липень'
               WHEN 8 THEN 'Серпень'
               WHEN 9 THEN 'Вересень'
               WHEN 10 THEN 'Жовтень'
               WHEN 11 THEN 'Листопад'
               WHEN 12 THEN 'Грудень'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthNameUkr (TDateTime) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.03.21                                                       *
*/

-- тест
-- SELECT zfCalc_MonthNameUkr (CURRENT_DATE)
