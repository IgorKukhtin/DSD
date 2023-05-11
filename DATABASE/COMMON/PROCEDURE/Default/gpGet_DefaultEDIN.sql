-- Function: gpGet_DefaultEDIN()

DROP FUNCTION IF EXISTS gpGet_DefaultEDIN(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DefaultEDIN(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Host TVarChar, UserName TVarChar, Password TVarChar)
AS
$BODY$
BEGIN

   RETURN QUERY
    SELECT  'https://edo-v2.edin.ua'    :: TVarChar AS Host
          , 'uaalan'                    :: TVarChar AS UserName
          , '337cd73a'                  :: TVarChar AS Password
           ;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_DefaultEDIN (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.05.23                                                       *
*/

-- тест
-- 
SELECT * FROM gpGet_DefaultEDIN (zfCalc_UserAdmin())
