-- Function: gpMovementItem_OrderInternal_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderInternal_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderInternal_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_OrderInternal());
  vbUserId := lpGetUserBySession (inSession);

  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/

-- тест
--