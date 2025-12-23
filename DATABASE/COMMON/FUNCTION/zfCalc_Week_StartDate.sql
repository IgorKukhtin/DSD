-- Function: zfCalc_Week_StartDate (TDateTime, TFloat)

DROP FUNCTION IF EXISTS zfCalc_Week_StartDate (TDateTime, Integer);
DROP FUNCTION IF EXISTS zfCalc_Week_StartDate (TDateTime, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Week_StartDate (inOperDate TDateTime, inWeekNumber TFloat)
RETURNS TDateTime
AS
$BODY$
BEGIN
  IF EXTRACT (MONTH FROM inOperDate) = 12 AND inWeekNumber IN (1, 2)
  THEN
      RETURN 
             DATE_TRUNC ('WEEK', DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH');
  ELSE
      RETURN 
             DATE_TRUNC ('WEEK', DATE_TRUNC ('YEAR', inOperDate) + ((((7 * COALESCE (inWeekNumber - 1, 0)) :: Integer) :: TVarChar) || ' DAY' ):: INTERVAL) ::TDateTime;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.25                                        *  
*/

-- тест
-- SELECT zfCalc_Week_StartDate (CURRENT_DATE, 1)
