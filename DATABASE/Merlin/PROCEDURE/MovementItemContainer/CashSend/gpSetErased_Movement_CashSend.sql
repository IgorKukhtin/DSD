-- Function: gpSetErased_Movement_CashSend (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_CashSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_CashSend(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_CashSend());
    vbUserId:= lpGetUserBySession (inSession);

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- когда распроводится или удаляется - обнуляются все его zc_MIFloat_MovementId    
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), MIFloat_MovementId.MovementItemId, 0)

    FROM MovementItemFloat AS MIFloat_MovementId
       INNER JOIN MovementItem AS MI_Child_client
                               ON MI_Child_client.Id = MIFloat_MovementId.MovementItemId
                              AND MI_Child_client.DescId   = zc_MI_Child()
                              AND MI_Child_client.isErased = FALSE
    WHERE MIFloat_MovementId.ValueData ::Integer = inMovementId
      AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.22         *
*/
