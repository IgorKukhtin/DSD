-- Function: gpSetErased_MovementItem (Integer, TVarChar)

-- DROP FUNCTION gpSetErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem(
    IN inMovementItemId          Integer              , -- ключ объекта <Документ>
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS void AS
$BODY$
BEGIN

  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_MovementItem());

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemItemContainer (inMovementItemId);

  -- Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemItemReport (inMovementItemId);

  -- Обязательно меняем статус документа
  UPDATE MovementItem SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementItemId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.13                                        * add lpDelete_MovementItemItemReport
*/

-- тест
-- SELECT * FROM gpSetErased_MovementItem (inMovementItemId:= 55, inSession:= '2')
