-- Function: lpGetUserBySession (TVarChar)

DROP FUNCTION IF EXISTS lpGetUserBySession (TVarChar);

CREATE OR REPLACE FUNCTION lpGetUserBySession (
    IN inSession TVarChar
)
RETURNS Integer
AS
$BODY$  
BEGIN
     IF inSession <> ''
     THEN RETURN to_number (inSession, '00000000000');   
     ELSE RETURN 0;
     END IF;

END;$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION lpGetUserBySession (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.02.14                                        * check inSession <> ''
*/

-- тест
-- SELECT * FROM lpGetUserBySession (inSession:= zfCalc_UserAdmin())
