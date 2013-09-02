-- Function: gpSetErased_Movement (Integer, TVarChar)

-- DROP FUNCTION gpSetErased_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement(
    IN inMovementId          Integer              , -- ключ объекта <Документ>
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS void AS
$BODY$
BEGIN

  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_Movement());

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);

  -- Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- тест
-- SELECT * FROM gpSetErased_Movement (inMovementId:= 55, inSession:= '2')
