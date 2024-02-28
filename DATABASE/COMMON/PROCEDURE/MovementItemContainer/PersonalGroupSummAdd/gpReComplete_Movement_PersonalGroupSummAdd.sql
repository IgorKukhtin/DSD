-- Function: gpReComplete_Movement_PersonalGroupSummAdd(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PersonalGroupSummAdd (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalGroupSummAdd());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalGroupSummAdd())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();
     -- проводим Документ
     PERFORM lpComplete_Movement_PersonalGroupSummAdd (inMovementId := inMovementId
                                             , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.02.24         *
*/

-- тест