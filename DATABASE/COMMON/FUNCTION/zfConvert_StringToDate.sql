-- Function: zfConvert_StringToDate

DROP FUNCTION IF EXISTS zfConvert_StringToDate (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToDate (Value TVarChar)
RETURNS TDateTime AS
$BODY$
BEGIN
  RETURN Value :: TDateTime;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN NULL;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToDate (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.15                                        *
*/

-- тест
-- SELECT * FROM zfConvert_StringToDate ('TVarChar')
-- SELECT * FROM zfConvert_StringToDate ('10')
-- SELECT * FROM zfConvert_StringToDate ('01.01.2015')
