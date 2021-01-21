-- Function: zfCalc_Color ()

DROP FUNCTION IF EXISTS zfCalc_Color (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Color (inR Integer, inG Integer, inB Integer, inIntensity Integer = 100)
RETURNS Integer AS
$BODY$
BEGIN

   RETURN inR + (255 - inR) * (100 - inIntensity) / 100 +
          (inG  + (255 - inG) * (100 - inIntensity) / 100 ) * 256 +
          (inB  + (255 - inB) * (100 - inIntensity) / 100 ) * 256 * 256;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_Color (Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.01.21                                                       *
*/

-- тест
--
SELECT zfCalc_Color(255, 255, 255)