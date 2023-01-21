-- Function: zfCalc_MonthNameUkr_export (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthNameUkr_export (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthNameUkr_export (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'січня'
               WHEN 2 THEN 'лютого'
               WHEN 3 THEN 'березня'
               WHEN 4 THEN 'квітня'
               WHEN 5 THEN 'травня'
               WHEN 6 THEN 'червеня'
               WHEN 7 THEN 'липня'
               WHEN 8 THEN 'серпня'
               WHEN 9 THEN 'вересня'
               WHEN 10 THEN 'жовтня'
               WHEN 11 THEN 'листопада'
               WHEN 12 THEN 'грудня'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.03.21                                                       *
*/

-- тест
-- SELECT zfCalc_MonthNameUkr_export (CURRENT_DATE)
