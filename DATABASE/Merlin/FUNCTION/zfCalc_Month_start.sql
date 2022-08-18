-- Function: zfCalc_Month_start (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_Month_start (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_Month_start (inOperDate TDateTime)
RETURNS TDateTime
AS
$BODY$
BEGIN
         RETURN (DATE_TRUNC ('MONTH', inOperDate)
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
-- SELECT zfCalc_Month_start (CURRENT_DATE)
