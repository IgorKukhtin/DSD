-- Function: gpUnComplete_Movement_OrderInternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderInternal(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     -- когда распроводится - НЕ обнуляются все его zc_MIFloat_MovementId - во всех Заказ клиента
   /*PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), MIFloat_MovementId.MovementItemId, 0)
     FROM MovementItemFloat AS MIFloat_MovementId
          INNER JOIN MovementItem AS MI_Child_client
                                  ON MI_Child_client.Id      = MIFloat_MovementId.MovementItemId
                                 AND MI_Child_client.DescId  = zc_MI_Child()
          -- это точно Заказ клиента
          INNER JOIN Movement ON Movement.Id     = MI_Child_client.MovementId
                             AND Movement.DescId = zc_Movement_OrderClient()

     WHERE MIFloat_MovementId.ValueData = inMovementId
       AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
    ;*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.12.22         *
*/