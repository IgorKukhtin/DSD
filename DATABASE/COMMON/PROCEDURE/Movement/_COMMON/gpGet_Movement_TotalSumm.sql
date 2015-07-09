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
            ('Итого: '||trim (to_char (COALESCE (MovementFloat_TotalSummPVAT.ValueData, MovementFloat_TotalSumm.ValueData) , '999 999 999 999 999D99'))
                      || CASE WHEN MovementFloat_TotalSummPacker.ValueData <> 0 THEN  ' + '||trim (to_char (COALESCE (MovementFloat_TotalSummPacker.ValueData, MovementFloat_TotalSummPacker.ValueData) , '999 999 999 999 999D99'))
                              ELSE ''
                         END 
            )::TVarChar  AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                                   AND Movement.DescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPacker
                                    ON MovementFloat_TotalSummPacker.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPacker.DescId = zc_MovementFloat_TotalSummPacker()
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.14                                        * add zc_MovementFloat_TotalSummPVAT
 10.04.14                         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ZakazInternal (inMovementId:= 1, inSession:= '2')
