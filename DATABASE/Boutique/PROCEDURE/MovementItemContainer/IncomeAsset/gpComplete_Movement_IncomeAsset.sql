-- Function: gpComplete_Movement_IncomeAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_IncomeAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_IncomeAsset(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_IncomeAsset());

     -- Проводим Документ
     PERFORM lpComplete_Movement_IncomeAsset (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.08.16         *
 */

-- тест
--