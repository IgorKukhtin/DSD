-- Function: zfConvert_StringToBigInt

-- DROP FUNCTION IF EXISTS zfConvert_StringToBigInt (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToBigInt (Number TVarChar)
RETURNS BigInt AS
$BODY$
BEGIN
  RETURN Number :: BigInt;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToBigInt (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.15                                        *
*/

-- тест
-- SELECT * FROM zfConvert_StringToBigInt ('TVarChar')
-- SELECT * FROM zfConvert_StringToBigInt ('98635287405961')
