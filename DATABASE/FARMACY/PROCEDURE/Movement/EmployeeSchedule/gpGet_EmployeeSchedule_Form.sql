-- Function: gpGet_EmployeeSchedule_Form()

DROP FUNCTION IF EXISTS gpGet_EmployeeSchedule_Form (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_EmployeeSchedule_Form(
    IN inMovementId        Integer  , -- ключ документ
    IN inOperDate          TDateTime  , -- ключ
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (FormName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());
     
     IF EXISTS(SELECT OperDate FROM Movement WHERE ID = inMovementID)
     THEN
       SELECT OperDate 
       INTO inOperDate
       FROM Movement 
       WHERE ID = inMovementID;
     END IF;

     RETURN QUERY 
       SELECT CASE WHEN inOperDate < '01.09.2019'::TDateTime THEN 'TEmployeeScheduleForm' ELSE 'TEmployeeScheduleNewForm' END::TVarChar AS FromName;

  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *

*/

-- тест
-- SELECT * FROM gpGet_EmployeeSchedule_Form (inMovementId:= 0, inOperDate := '01.09.2019'::TDateTime , inSession:= zfCalc_UserAdmin())
