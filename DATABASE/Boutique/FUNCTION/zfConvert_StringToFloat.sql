-- Function: zfConvert_StringToFloat

-- DROP FUNCTION IF EXISTS zfConvert_StringToFloat (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToFloat(Number TVarChar)
RETURNS TFloat AS
$BODY$
BEGIN
  RETURN Number :: TFloat;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToFloat (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.18                                        *  
*/

-- тест
-- SELECT * FROM zfConvert_StringToFloat ('TVarChar')
-- SELECT * FROM zfConvert_StringToFloat ('10')
