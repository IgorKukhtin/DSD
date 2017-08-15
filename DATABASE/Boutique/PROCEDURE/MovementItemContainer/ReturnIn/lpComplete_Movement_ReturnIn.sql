DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPartner;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ReturnIn()
                               , inUserId     := inUserId
                                );
    
    -- 6.1. пересчитали "итоговые" суммы по элементам партии продажи - ОБЯЗАТЕЛЬНО после lpComplete
    PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

    -- 6.2. меняются ИТОГОВЫЕ суммы по покупателю
    PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 14.05.17         * 
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ReturnIn (inMovementId:= 1100, inUserId:= zfCalc_UserAdmin() :: Integer)
