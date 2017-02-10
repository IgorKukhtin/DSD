-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Income (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Complete(), inComment:= 'провести');


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Income_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                       , inUserId         := vbUserId
                                       , inIsLastComplete := inIsLastComplete);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.10.14                                        * add InfoMoneyGroupId and InfoMoneyGroupId_Detail and UnitId_Asset
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 01.11.13                                        * add ...Id_Transit
 29.10.13         * rename process zc_Enum_Process_Complete_Income()
 21.10.13                                        * add TicketFuel
 12.10.13                                        * add lfCheck_Movement_ParentStatus
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 149639, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= '2')
