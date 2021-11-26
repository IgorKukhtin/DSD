-- Function: gpReComplete_Movement_PersonalGroup(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalGroup(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalGroup());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalGroup())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement_PersonalGroup (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- Проводим Документ
     PERFORM lpComplete_Movement_PersonalGroup (inMovementId     := inMovementId
                                              , inUserId         := vbUserId);

     --автоматом проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind - при распроведении или удалении - в табеле удаляется WorkTimeKind
     PERFORM gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup (inMovementId, FALSE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
-- 