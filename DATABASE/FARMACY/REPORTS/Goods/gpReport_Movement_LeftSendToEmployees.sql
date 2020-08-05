-- Function: gpReport_Movement_LeftSendToEmployees()

DROP FUNCTION IF EXISTS gpReport_Movement_LeftSendToEmployees (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_LeftSendToEmployees(
    IN inOperDate      TDateTime,  -- Дата
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE ("Номер"        TVarChar
             , "Дата"         TDateTime
             , "% возврата"   TFloat
             , "Откуда"       TVarChar
             , "Куда"         TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- Результат
     RETURN QUERY
       SELECT
             Report.InvNumber
           , Report.OperDate
           , Report.ReturnRate
           , Report.FromName
           , Report.ToName
       FROM gpReport_Movement_LeftSend (inOperDate, inOperDate, inSession) AS Report
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_LeftSendToEmployees (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.08.20                                                       *
*/

-- тест
--
SELECT * FROM gpReport_Movement_LeftSendToEmployees (inOperDate:= '21.09.2019', inSession:= '3')