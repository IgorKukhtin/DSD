-- Function: gpMovementItem_ProductionPersonal_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionPersonal_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionPersonal_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_ProductionPersonal());
  vbUserId := lpGetUserBySession (inSession);

  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.21         *
*/

-- тест
--