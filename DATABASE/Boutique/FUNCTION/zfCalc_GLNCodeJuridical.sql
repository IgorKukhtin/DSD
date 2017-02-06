-- Function: zfCalc_GLNCodeJuridical

DROP FUNCTION IF EXISTS zfCalc_GLNCodeJuridical (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_GLNCodeJuridical(
    IN inGLNCode                  TVarChar, -- 
    IN inGLNCodeJuridical_partner TVarChar, -- 
    IN inGLNCodeJuridical         TVarChar  -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (CASE WHEN inGLNCodeJuridical_partner <> ''
                       THEN inGLNCodeJuridical_partner
                  WHEN inGLNCode <> ''
                       THEN inGLNCodeJuridical
                  ELSE ''
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_GLNCodeJuridical (TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.15                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_GLNCodeJuridical (inGLNCode                  := '1'
                                     , inGLNCodeJuridical_partner := '2'
                                     , inGLNCodeJuridical         := '3'
                                      )
*/