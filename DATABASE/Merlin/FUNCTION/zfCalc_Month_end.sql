-- Function: zfCalc_Month_end (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_Month_end (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_Month_end (inOperDate TDateTime)
RETURNS TDateTime
AS
$BODY$
BEGIN
         RETURN (DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                );
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.08.22                                        *
*/

-- тест
-- SELECT zfCalc_Month_end (CURRENT_DATE)
