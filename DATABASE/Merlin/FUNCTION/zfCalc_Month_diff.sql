-- Function: zfCalc_Month_diff (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_Month_diff (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_Month_diff (inStartDate TDateTime, inEndDate TDateTime)
RETURNS Integer
AS
$BODY$
BEGIN
     IF COALESCE (inStartDate, zc_DateStart()) = zc_DateStart() OR COALESCE (inEndDate, zc_DateEnd()) = zc_DateEnd()
     THEN
         RETURN 0;
     ELSE
         RETURN (EXTRACT (YEAR FROM inEndDate)   * 12 * 30 + EXTRACT (MONTH FROM inEndDate)   * 30 + EXTRACT (DAY FROM inEndDate)
               - EXTRACT (YEAR FROM inStartDate) * 12 * 30 - EXTRACT (MONTH FROM inStartDate) * 30 - EXTRACT (DAY FROM inStartDate)
                ) / 30;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.15                                        *  
*/

-- тест
-- SELECT zfCalc_Month_diff (CURRENT_DATE - INTERVAL '24 MONTH' , CURRENT_DATE)
