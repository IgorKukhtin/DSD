DROP FUNCTION IF EXISTS lpComplete_Movement_ServiceItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ServiceItem(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId_ServiceItem   Integer;
  DECLARE vbAccountId_Debts  Integer;
  DECLARE vbAccountId_Profit Integer;
  DECLARE vbProfitLossId     Integer;
BEGIN


    -- Создаем временнве таблицы
    --PERFORM lpComplete_Movement_ServiceItem_CreateTemp();

    -- !!!обязательно!!! очистили таблицу проводок

    -- 4.1. предварительно сохранили данные

    -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
    --PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ServiceItem()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.06.22         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ServiceItem (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);