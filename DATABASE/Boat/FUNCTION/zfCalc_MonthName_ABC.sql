-- Function: zfCalc_MonthName_ABC (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthName_ABC (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthName_ABC (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'A'
               WHEN 2 THEN 'B'
               WHEN 3 THEN 'C'
               WHEN 4 THEN 'D'
               WHEN 5 THEN 'E'
               WHEN 6 THEN 'F'
               WHEN 7 THEN 'G'
               WHEN 8 THEN 'H'
               WHEN 9 THEN 'I'
               WHEN 10 THEN 'K'
               WHEN 11 THEN 'L'
               WHEN 12 THEN 'M'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthName_ABC(TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.21         *  
*/

-- тест
-- SELECT zfCalc_MonthName_ABC (CURRENT_DATE)
