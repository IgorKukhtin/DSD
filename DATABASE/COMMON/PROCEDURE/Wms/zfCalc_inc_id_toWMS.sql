-- Function: zfCalc_inc_id_toWMS

DROP FUNCTION IF EXISTS zfCalc_inc_id_toWMS (Integer);
DROP FUNCTION IF EXISTS zfCalc_inc_id_toWMS (TDateTime, Integer);

CREATE OR REPLACE FUNCTION zfCalc_inc_id_toWMS (inOperDate TDateTime, in_sku_id Integer)
RETURNS BigInt
AS
$BODY$
BEGIN
  RETURN (in_sku_id :: BigInt * 10000 * 1000 * 10
        + (EXTRACT (YEAR FROM inOperDate) * 1000) :: BigInt
        + (EXTRACT (DAY  FROM (inOperDate - DATE_TRUNC ('YEAR', inOperDate)) :: INTERVAL)) :: BigInt
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_inc_id_toWMS (TDateTime, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                        *
*/

-- тест
-- SELECT * FROM zfCalc_inc_id_toWMS (CURRENT_DATE, 38391842)
