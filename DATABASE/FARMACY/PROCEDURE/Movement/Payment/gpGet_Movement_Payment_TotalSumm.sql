-- Function: gpGet_Movement_Payment_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_Payment_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Payment_TotalSumm(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (TotalCount TVarChar
             , TotalSumm TVarChar)
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Payment());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0::TVarChar                                     AS TotalCount
          , 0::TVarChar                                     AS TotalSumm;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Payment.TotalCount::TVarChar
          , Movement_Payment.TotalSumm::TVarChar
        FROM
            Movement_Payment_View AS Movement_Payment
        WHERE Movement_Payment.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Payment_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 29.10.15                                                                        *
*/
