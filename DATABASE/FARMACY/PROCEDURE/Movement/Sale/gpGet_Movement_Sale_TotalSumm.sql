-- Function: gpGet_Movement_Sale_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_TotalSumm(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummPrimeCost TFloat)
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0::TFloat                                     AS TotalCount
          , 0::TFloat                                     AS TotalSumm
          , 0::TFloat                                     AS TotalSummPrimeCost;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummPrimeCost
        FROM
            Movement_Sale_View AS Movement_Sale
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 13.10.15                                                                        *
*/
