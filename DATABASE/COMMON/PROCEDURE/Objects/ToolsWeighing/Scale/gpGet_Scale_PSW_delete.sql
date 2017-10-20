-- Function: gpGet_Scale_PSW_delete()

DROP FUNCTION IF EXISTS gpGet_Scale_PSW_delete (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_PSW_delete(
    IN inPSW               TVarChar,
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar, PSW TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpGetUserBySession (inSession); убрал, что б быстрее... :)

     IF EXISTS (SELECT 1)
     THEN
         -- Результат
         RETURN QUERY
           SELECT Id, ObjectCode, ValueData, '' :: TVarChar
           FROM Object 
           WHERE Id = zfCalc_UserAdmin() :: Integer;
     ELSE 
         -- Результат
         RETURN QUERY
           SELECT Id, ObjectCode, ValueData, 'ERROR' :: TVarChar
           FROM Object 
           WHERE Id = zfCalc_UserAdmin() :: Integer;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_PSW_delete (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_PSW_delete (inPSW:= '123', inSession:=zfCalc_UserAdmin())
