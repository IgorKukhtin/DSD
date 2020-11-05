-- Function: gpSetErased_Movement_Payment (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Payment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Payment(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Payment());
    vbUserId := inSession::Integer; 
    -- проверка - если <Master> Проведен, то <Ошибка>
    --PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка
    IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId)
    THEN
        RAISE EXCEPTION 'Ошибка.Документ проведен, удаление запрещено!';
    END IF;
     
     -- проверка - если есть <Child> Проведен, то <Ошибка>
    PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 13.10.15                                                                       *
*/
