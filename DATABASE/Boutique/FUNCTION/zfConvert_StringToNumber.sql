-- Function: zfConvert_StringToNumber

-- DROP FUNCTION IF EXISTS zfConvert_StringToNumber (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToNumber(Number TVarChar)
RETURNS Integer AS
$BODY$
BEGIN
  RETURN Number :: Integer;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToNumber (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.13                        *  
*/

-- тест
-- SELECT * FROM zfConvert_StringToNumber ('TVarChar')
-- SELECT * FROM zfConvert_StringToNumber ('10')
