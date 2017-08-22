-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_UserUnit (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UserUnit(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(UnitId integer, UnitName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
 
     -- определять магазин по принадлежности пользователя к сотруднику
     vbUnitId:= lpGetUnitBySession (inSession);

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
-- SELECT * FROM gpGet_UserUnit (inSession:= '2')