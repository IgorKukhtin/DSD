-- Function: gpGet_Current_Date()

DROP FUNCTION IF EXISTS gpGet_Current_Date (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Current_Date(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TDateTime
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN CURRENT_DATE;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.03.18         *

*/

-- тест
-- SELECT * FROM gpGet_Current_Date (inSession:= '2')