-- Function: gpMovementItem_OrderPartner_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_OrderPartner_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_OrderPartner_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);

      -- устанавливаем новое значение
     outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

     -- при удалении - во всех Заказах клиента - zc_MI_Child - детализация по Поставщикам - убираем что Заказ Поставщику сделан
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), MI_Child_client.Id, 0)
     FROM MovementItem AS MI_Master
          -- ValueData - заказ Поставщику
          INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                       ON MIFloat_MovementId.ValueData = MI_Master.MovementId
                                      AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
          -- zc_MI_Child
          INNER JOIN MovementItem AS MI_Child_client
                                  ON MI_Child_client.Id       = MIFloat_MovementId.MovementItemId
                                 AND MI_Child_client.DescId   = zc_MI_Child()
                                 -- Для одного товара
                                 AND MI_Child_client.ObjectId = MI_Master.ObjectId
                               --AND MI_Child_client.isErased = FALSE
          -- это точно Заказ клиента
          INNER JOIN Movement ON Movement.Id     = MI_Child_client.MovementId
                             AND Movement.DescId = zc_Movement_OrderClient()
     WHERE MI_Master.Id     = inMovementItemId
       AND MI_Master.DescId = zc_MI_Master()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.21         *
*/

-- тест
--