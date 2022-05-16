-- Function: gpUnComplete_Movement_GoodsSPRegistry_1303 (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_GoodsSPRegistry_1303 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_GoodsSPRegistry_1303(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_GoodsSPRegistry_1303());

    -- проверка - если <Master> Удален, то <Ошибка>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --пересчитываем сумму документа по приходным ценам
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.05.22                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_GoodsSPRegistry_1303 (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
