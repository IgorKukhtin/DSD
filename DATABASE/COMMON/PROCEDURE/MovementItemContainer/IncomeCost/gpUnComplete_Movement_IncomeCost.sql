-- Function: gpUnComplete_Movement_IncomeCost (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_IncomeCost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Income());


     -- обнулили <Итого сумма затрат по документу (с учетом НДС)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSpending(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId), 0);

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId
                                   );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.01.19                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_IncomeCost (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
