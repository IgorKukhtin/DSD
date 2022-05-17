-- Function: zfCalc_Article_all (TVarChar)

DROP FUNCTION IF EXISTS zfCalc_Article_all (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_Article_all (inValueData TVarChar)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (inValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '') :: TVarChar
             );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22                                        *
*/

-- тест
-- SELECT zfCalc_Article_all ('123')
