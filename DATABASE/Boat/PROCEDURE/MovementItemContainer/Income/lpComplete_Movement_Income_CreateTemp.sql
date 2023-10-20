-- Function: lpComplete_Movement_Income_CreateTemp()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN

         DELETE FROM _tmpItem_SummPartner;
         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         DELETE FROM _tmpItem;
         -- таблица - сколько осталось зарезервировать для Заказов клиента
         DELETE FROM _tmpReserveDiff;
         -- таблица - элементы Резерв для Заказов клиента
         DELETE FROM _tmpReserveRes;

     ELSE
         -- таблица - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem_SummPartner (MovementItemId Integer, ContainerId Integer, AccountId Integer, ContainerId_VAT Integer, AccountId_VAT Integer
                                               , GoodsId Integer, PartionId Integer
                                               , OperSumm TFloat, OperSumm_VAT TFloat
                                                ) ON COMMIT DROP;

         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer
                                   , OperCount TFloat, OperPrice_orig TFloat, OperPrice TFloat, CountForPrice TFloat
                                   , OperSumm TFloat, OperSumm_cost TFloat, OperSumm_VAT TFloat
                                   , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    ) ON COMMIT DROP;

         -- таблица - сколько осталось зарезервировать для Заказов клиента
         CREATE TEMP TABLE _tmpReserveDiff (MovementId_order Integer, OperDate_order TDateTime
                                          , GoodsId Integer
                                          , AmountPartner TFloat
                                           ) ON COMMIT DROP;
         -- таблица - элементы Резерв для Заказов клиента
         CREATE TEMP TABLE _tmpReserveRes (MovementItemId Integer, ParentId Integer
                                         , GoodsId Integer
                                         , Amount TFloat
                                         , MovementId_order Integer
                                          ) ON COMMIT DROP;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Income_CreateTemp ()
