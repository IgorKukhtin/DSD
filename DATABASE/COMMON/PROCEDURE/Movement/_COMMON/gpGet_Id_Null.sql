-- Function: gpGet_Id_Nul()

DROP FUNCTION IF EXISTS gpGet_Id_Nul (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Id_Nul(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
       SELECT NULL :: Integer AS Id;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.23         *
*/

-- тест
-- SELECT * FROM gpGet_Id_Nul (inSession:= zfCalc_UserAdmin())
