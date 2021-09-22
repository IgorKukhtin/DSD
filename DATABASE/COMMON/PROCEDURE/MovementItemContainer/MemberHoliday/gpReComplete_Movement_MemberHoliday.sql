-- Function: gpReComplete_Movement_MemberHoliday(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_MemberHoliday());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_MemberHoliday())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
         --при распроведении или удалении - в табеле удаляется WorkTimeKind
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);
     END IF;

     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MemberHoliday()
                                , inUserId     := vbUserId
                                 );

     --автоматом проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind - при распроведении или удалении - в табеле удаляется WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, FALSE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpReComplete_Movement_MemberHoliday (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
