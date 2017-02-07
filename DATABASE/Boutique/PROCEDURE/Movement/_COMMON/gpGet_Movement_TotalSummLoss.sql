DROP FUNCTION IF EXISTS gpGet_Movement_TotalSummLoss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TotalSummLoss(
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
            ('Итого: '||trim (to_char (COALESCE (MovementFloat_TotalCount.ValueData, 0) , '999 999 999 999 999D99')))::TVarChar  AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSummLoss (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 24.07.14                                                          *
 */

-- тест
-- SELECT * FROM gpGet_Movement_TotalSummInventory (inMovementId:= 1, inSession:= '2')
