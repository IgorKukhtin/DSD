-- Function: zfCalc_MonthName_English (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthName_English (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthName_English (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'January'
               WHEN 2 THEN 'February'
               WHEN 3 THEN 'March'
               WHEN 4 THEN 'April'
               WHEN 5 THEN 'May'
               WHEN 6 THEN 'June'
               WHEN 7 THEN 'July'
               WHEN 8 THEN 'August'
               WHEN 9 THEN 'September'
               WHEN 10 THEN 'October'
               WHEN 11 THEN 'November'
               WHEN 12 THEN 'December'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthName_English(TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.01.21         *  
*/

-- тест
-- SELECT zfCalc_MonthName_English (CURRENT_DATE)
