-- Function: gpGet_Movement_Check_Status_Site()

DROP FUNCTION IF EXISTS gpGet_Movement_Check_Status_Site (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check_Status_Site(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Check());
     vbUserId := inSession;

     RETURN QUERY
     SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
     FROM Movement AS Movement_Check

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

     WHERE Movement_Check.Id = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check_Status_Site (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.08.2                                                        *
*/

-- тест
-- 
select * from gpGet_Movement_Check_Status_Site(inMovementId := 28792987,  inSession := '3');