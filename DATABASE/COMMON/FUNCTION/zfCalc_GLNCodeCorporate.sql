-- Function: zfCalc_GLNCodeCorporate

DROP FUNCTION IF EXISTS zfCalc_GLNCodeCorporate (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_GLNCodeCorporate(
    IN inGLNCode                  TVarChar, -- 
    IN inGLNCodeCorporate_partner TVarChar, -- 
    IN inGLNCodeCorporate_retail  TVarChar, -- 
    IN inGLNCodeCorporate_main    TVarChar  -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (CASE WHEN inGLNCodeCorporate_partner <> ''
                       THEN inGLNCodeCorporate_partner
                  WHEN inGLNCodeCorporate_retail <> '' AND inGLNCode <> ''
                       THEN inGLNCodeCorporate_retail
                  WHEN inGLNCode <> ''
                       THEN inGLNCodeCorporate_main
                  ELSE ''
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_GLNCodeCorporate (TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.15                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_GLNCodeCorporate (inGLNCode                  := '1'
                                     , inGLNCodeCorporate_partner := '2'
                                     , inGLNCodeCorporate_retail  := '3'
                                     , inGLNCodeCorporate_main    := '4'
                                      )
*/