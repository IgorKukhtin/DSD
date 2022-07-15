-- Function: zfCalc_DayOfWeekName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DayOfWeekNumber (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DayOfWeekNumber (inOperDate TDateTime)
RETURNS Integer
AS
$BODY$
BEGIN
  RETURN 
         CASE EXTRACT (DOW FROM inOperDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inOperDate) END :: Integer
         ;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.07.22                                        *  
*/

-- тест
-- SELECT zfCalc_DayOfWeekNumber (CURRENT_DATE)
