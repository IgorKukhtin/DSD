-- Function: gpGet_Movement_ZakazInternal()

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
            ('Итого: '||trim(to_char(MovementFloat_TotalSumm.ValueData, '999 999 999 999 999D99')))::TVarChar  AS TotalSumm
       FROM Movement                          
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
          
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.14                         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_ZakazInternal (inMovementId:= 1, inSession:= '2')
