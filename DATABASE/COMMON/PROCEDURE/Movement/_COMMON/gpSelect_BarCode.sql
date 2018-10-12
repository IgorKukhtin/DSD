-- Function: gpSelect_BarCode()

DROP FUNCTION IF EXISTS gpSelect_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_BarCode(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
       SELECT NULL :: TVarChar AS BarCode;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.18         *
*/

-- тест
-- SELECT * FROM gpSelect_BarCode (inSession:= zfCalc_UserAdmin())
