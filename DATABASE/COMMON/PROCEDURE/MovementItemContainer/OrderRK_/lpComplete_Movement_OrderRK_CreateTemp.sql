-- Function: lpComplete_Movement_OrderRK_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderRK_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderRK_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem')
     THEN
         DELETE FROM _tmpItem;
     ELSE
         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, GoodsId_in Integer, GoodsKindId_in Integer
                                   , OperCount TFloat
                                   , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    ) ON COMMIT DROP;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_OrderRK_CreateTemp ()
