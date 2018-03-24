-- Function: gpGet_UserUnit()

DROP FUNCTION IF EXISTS gpGet_UserUnit (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UserUnit(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(UnitId integer, UnitName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
 
     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId:= lpGetUnit_byUser (vbUserId);

     -- Результат
     RETURN QUERY
       SELECT Id, ValueData FROM Object WHERE Id = vbUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.08.17         *
*/

-- тест
-- SELECT * FROM gpGet_UserUnit (inSession:= zfCalc_UserAdmin())
