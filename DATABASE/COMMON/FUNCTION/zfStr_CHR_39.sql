-- Function: zfStr_CHR_39 (TVarChar)

DROP FUNCTION IF EXISTS zfStr_CHR_39 (TVarChar);

CREATE OR REPLACE FUNCTION zfStr_CHR_39 (inValue TVarChar)
RETURNS TVarChar AS
$BODY$
BEGIN

     RETURN CHR (39) || inValue || CHR (39);

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.07.20                                        * 
*/

-- тест
-- SELECT * FROM zfStr_CHR_39 ('2')
