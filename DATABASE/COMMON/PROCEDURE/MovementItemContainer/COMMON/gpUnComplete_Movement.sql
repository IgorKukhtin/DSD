-- Function: gpUnComplete_Movement (Integer, TVarChar)

-- DROP FUNCTION gpUnComplete_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement(
    IN inMovementId          Integer              , -- ключ объекта <Документ>
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS void AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);

  -- Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUnComplete_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.13                                        * add lpDelete_MovementItemReport
 08.07.13                                        * rename to zc_Enum_Status_UnComplete
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 55, inSession:= '2')
