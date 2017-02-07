-- Function: zfCalc_MonthYearName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthYearName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthYearName (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN

  RETURN (zfCalc_MonthName (inOperDate) || '-' || EXTRACT (YEAR FROM inOperDate));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearName (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.15                                        *  
*/

-- тест
-- SELECT zfCalc_MonthYearName (CURRENT_DATE)
