-- Function: zfCalc_MonthYearNameUkr (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthYearNameUkr (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthYearNameUkr (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN

  RETURN (zfCalc_MonthNameUkr (inOperDate) || ' ' || EXTRACT (YEAR FROM inOperDate));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearNameUkr (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.03.21                                                       *
*/

-- тест
-- SELECT zfCalc_MonthYearNameUkr (CURRENT_DATE)
