-- Function: gpComplete_Movement_Invoice()

DROP FUNCTION IF EXISTS gpComplete_Movement_Invoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Invoice(
    IN inMovementId        Integer                , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT False , -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice());

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Complete(), inComment:= 'провести');


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Invoice_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_Invoice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId
                                            , inIsLastComplete := inIsLastComplete);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.07.16         *
 */

-- тест
--