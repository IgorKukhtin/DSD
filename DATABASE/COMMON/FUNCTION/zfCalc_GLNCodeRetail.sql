-- Function: zfCalc_GLNCodeRetail

DROP FUNCTION IF EXISTS zfCalc_GLNCodeRetail (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_GLNCodeRetail(
    IN inGLNCode                  TVarChar, -- 
    IN inGLNCodeRetail_partner    TVarChar, -- 
    IN inGLNCodeRetail            TVarChar, -- 
    IN inGLNCodeJuridical         TVarChar  -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (CASE WHEN inGLNCodeRetail_partner <> ''
                       THEN inGLNCodeRetail_partner
                  WHEN inGLNCodeRetail <> '' AND inGLNCode <> ''
                       THEN inGLNCodeRetail
                  WHEN inGLNCode <> ''
                       THEN inGLNCodeJuridical
                  ELSE ''
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_GLNCodeRetail (TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.15                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_GLNCodeRetail (inGLNCode               := '1'
                                  , inGLNCodeRetail_partner := '3'
                                  , inGLNCodeRetail         := '2'
                                  , inGLNCodeJuridical      := '4'
                                   )
*/