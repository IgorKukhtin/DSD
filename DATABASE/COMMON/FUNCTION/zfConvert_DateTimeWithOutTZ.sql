-- Function: zfConvert_DateTimeWithOutTZ

DROP FUNCTION IF EXISTS zfConvert_DateTimeWithOutTZ (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateTimeWithOutTZ (Value TDateTime)
RETURNS TIMESTAMP WITHOUT TIME ZONE
AS
$BODY$
BEGIN
  RETURN Value;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateTimeWithOutTZ (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.18                                        *
*/

-- тест
-- SELECT * FROM zfConvert_DateTimeWithOutTZ (CURRENT_TIMESTAMP)
