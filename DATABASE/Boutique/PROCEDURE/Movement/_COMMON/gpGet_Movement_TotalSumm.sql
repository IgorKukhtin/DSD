-- Function: gpGet_Movement_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TotalSumm(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (TotalSumm TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

     RETURN QUERY
       SELECT
            ('Итого: ' || TRIM (TO_CHAR ( CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN COALESCE (MovementFloat_TotalSummPriceList.ValueData, 0) - COALESCE (MovementFloat_TotalSummChange.ValueData, 0)
                                               WHEN Movement.DescId IN (zc_Movement_GoodsAccount()) THEN COALESCE (MovementFloat_TotalSummPay.ValueData, 0) - COALESCE (MovementFloat_TotalSummChange.ValueData, 0)
                                               ELSE COALESCE (MovementFloat_TotalSumm.ValueData, 0) 
                                          END
                                         , '999 999 999 999 999D99'))
            ) :: TVarChar AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId     = zc_MovementFloat_TotalSummPriceList()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()

       WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSumm (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_TotalSumm (inMovementId:= 1, inSession:= '2')
