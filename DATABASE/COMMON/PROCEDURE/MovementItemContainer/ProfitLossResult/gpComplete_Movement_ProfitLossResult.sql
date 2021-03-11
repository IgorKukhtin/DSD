-- Function: gpComplete_Movement_ProfitLossResult()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProfitLossResult (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProfitLossResult(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean DEFAULT False, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProfitLossResult());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_ProfitLossResult (inMovementId := inMovementId
                                                 , inUserId     := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/
