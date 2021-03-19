-- Function: gpSetErased_Movement_Invoice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Invoice(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Invoice());

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- удалить связь с документом приход / заказ если такая есть
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), MLM.MovementId, inMovementId)
    FROM MovementLinkMovement AS MLM
    WHERE MLM.DescId = zc_MovementLinkMovement_Invoice()
      AND MLM.MovementChildId = inMovementId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/
