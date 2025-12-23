-- Function: zfCalc_Week_EndDate (TDateTime, TFloat)

DROP FUNCTION IF EXISTS zfCalc_Week_EndDate (TDateTime, Integer);
DROP FUNCTION IF EXISTS zfCalc_Week_EndDate (TDateTime, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Week_EndDate (inOperDate TDateTime, inWeekNumber TFloat)
RETURNS TDateTime
AS
$BODY$
BEGIN
      RETURN 
             zfCalc_Week_StartDate (inOperDate, inWeekNumber) + INTERVAL '6 DAY';

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
-- SELECT zfCalc_Week_EndDate (CURRENT_DATE, 1)
