-- Function: gpGet_Movement_Wages_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_Wages_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Wages_TotalSumm(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (TotalSumm  TFloat
              )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_EmployeeSchedule());

    RETURN QUERY
    SELECT
        0::TFloat                                     AS TotalSumm;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Wages_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.19                                                        *
*/
