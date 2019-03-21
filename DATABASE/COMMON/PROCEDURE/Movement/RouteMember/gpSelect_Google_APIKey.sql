-- Function: gpSelect_Google_APIKey()

DROP FUNCTION IF EXISTS gpSelect_Google_APIKey (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Google_APIKey (
 OUT outAPIKey          TVarChar,
  IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TVarChar 
AS
$BODY$
BEGIN
  outAPIKey := zc_Google_APIKey();
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Шаблий О.В.
 20.03.19                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Google_APIKey (inSession := '5');
