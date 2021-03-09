-- Function: gpReComplete_Movement_Send(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ProfitLossResult (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ProfitLossResult(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProfitLossResult());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProfitLossResult())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     -- PERFORM lpComplete_Movement_ProfitLossResult_CreateTemp();
     -- Проводим Документ
     PERFORM gpComplete_Movement_ProfitLossResult (inMovementId     := inMovementId
                                     , inIsLastComplete := NULL
                                     , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- тест
-- 