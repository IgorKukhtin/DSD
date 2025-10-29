-- Function: gpMovementItem_LossPersonal_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_LossPersonal_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_LossPersonal_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_LossPersonal());

  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.01.14                                        *
*/

-- тест
-- SELECT * FROM gpMovementItem_LossPersonal_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
