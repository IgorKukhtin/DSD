-- Function: lpComplete_Movement_Send_CreateTemp()

DROP FUNCTION IF EXISTS lpComplete_Movement_Send_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DELETE FROM _tmpItem;
         DELETE FROM _tmpItem_Child;
         --
         DELETE FROM _tmpReserveDiff;
         DELETE FROM _tmpReserveRes;
     ELSE
         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , GoodsId Integer
                                   , Amount TFloat
                                   , PartNumber TVarChar
                                   , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , MovementId_order Integer
                                    ) ON COMMIT DROP;
         -- таблица - партии
         CREATE TEMP TABLE _tmpItem_Child (MovementItemId Integer, ParentId Integer
                                         , GoodsId Integer, PartionId Integer
                                         , ContainerId_SummFrom Integer, ContainerId_GoodsFrom Integer
                                         , ContainerId_SummTo   Integer, ContainerId_GoodsTo   Integer
                                         , AccountId_From Integer, AccountId_To Integer
                                         , Amount TFloat
                                         , MovementId_order Integer
                                          ) ON COMMIT DROP;

         -- таблица - сколько осталось переместить из резервов для Заказов клиента
       /*CREATE TEMP TABLE _tmpReserveDiff (MovementId_order Integer, OperDate_order TDateTime
                                          , GoodsId Integer, PartionId Integer
                                          , Amount TFloat
                                           ) ON COMMIT DROP;
         -- таблица - элементы Перемещаем Резерв для Заказов клиента
         CREATE TEMP TABLE _tmpReserveRes (MovementItemId Integer, ParentId Integer
                                         , GoodsId Integer, PartionId Integer
                                         , ContainerId_SummFrom Integer, ContainerId_GoodsFrom Integer
                                         , ContainerId_SummTo   Integer, ContainerId_GoodsTo   Integer
                                         , AccountId_From Integer, AccountId_To Integer
                                         , Amount TFloat
                                         , MovementId_order Integer
                                          ) ON COMMIT DROP;*/
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Send_CreateTemp ()
