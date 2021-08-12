-- Function: gpReComplete_Movement_SheetWorkTimeClose(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SheetWorkTimeClose (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SheetWorkTimeClose(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SheetWorkTimeClose());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SheetWorkTimeClose())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- Проводим Документ
     PERFORM lpComplete_Movement_SheetWorkTimeClose (inMovementId     := inMovementId
                                           , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.21         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_SheetWorkTimeClose (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
