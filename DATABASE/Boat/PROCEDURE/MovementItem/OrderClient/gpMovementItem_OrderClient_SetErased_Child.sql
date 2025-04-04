-- Function: gpMovementItem_OrderClient_SetErased_Child (Integer, Integer, TVarChar)
--удалить zc_MI_Child + zc_MI_Detail
DROP FUNCTION IF EXISTS gpMovementItem_OrderClient_SetErased_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderClient_SetErased_Child(
    IN inMovementId          Integer              , -- ключ объекта <документ>
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderClient());
  vbUserId:= inSession;

  -- устанавливаем новое значение
  --outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);   

   UPDATE MovementItem SET isErased = TRUE
   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.DescId IN (zc_MI_Child(), zc_MI_Detail()) 
     AND MovementItem.isErased = FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.24         *
*/

-- тест
--