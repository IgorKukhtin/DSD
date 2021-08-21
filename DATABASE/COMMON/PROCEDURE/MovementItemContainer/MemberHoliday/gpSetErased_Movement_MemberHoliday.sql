-- Function: gpSetErased_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MemberHoliday());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     --при распроведении или удалении - в табеле автоматом  удаляется WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_MemberHoliday (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
