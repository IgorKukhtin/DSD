-- Function: gpReComplete_Movement_Loss(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_LossAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_LossAsset(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossAsset());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_LossAsset())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     -- PERFORM lpComplete_Movement_LossAsset_CreateTemp();
     -- Проводим Документ
     PERFORM gpComplete_Movement_LossAsset (inMovementId     := inMovementId
                                     , inIsLastComplete := NULL
                                     , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.20         *
*/

-- тест
-- 