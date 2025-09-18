-- Function: gpReComplete_Movement_StaffListMember(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_StaffListMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_StaffListMember(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_StaffListMember());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_StaffListMember())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- Проводим Документ
     PERFORM lpComplete_Movement_StaffListMember (inMovementId     := inMovementId
                                                , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *
*/

-- тест
-- 