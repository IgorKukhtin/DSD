-- Function: zfConvert_Date_toWMS

DROP FUNCTION IF EXISTS zfConvert_Date_toWMS (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_Date_toWMS (inValue TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (TO_CHAR (inValue, 'DD-MM-YYYY'));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_Date_toWMS (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                        *
*/

-- тест
-- SELECT * FROM zfConvert_Date_toWMS (CURRENT_DATE)
