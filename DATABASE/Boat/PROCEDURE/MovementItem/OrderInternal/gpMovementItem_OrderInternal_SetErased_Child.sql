-- Function: gpMovementItem_OrderInternal_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderInternal_SetErased_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderInternal_SetErased_Child(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);

     -- устанавливаем новое значение
     outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

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