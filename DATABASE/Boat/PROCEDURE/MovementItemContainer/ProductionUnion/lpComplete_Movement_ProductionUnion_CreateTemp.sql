-- Function: lpComplete_Movement_ProductionUnion_CreateTemp()

DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem')
     THEN
         DELETE FROM _tmpItem_pr;
         DELETE FROM _tmpItem_Child_mi;
         DELETE FROM _tmpItem_Child;
         DELETE FROM _tmpItem_Detail;
     ELSE
         -- таблица - элементы Master
         CREATE TEMP TABLE _tmpItem_pr (MovementItemId Integer
                                      , GoodsId Integer, PartionId Integer
                                      , ContainerId_Summ Integer, ContainerId_Goods Integer
                                      , AccountId Integer
                                      , Amount TFloat
                                      , PartNumber TVarChar
                                      , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                      , MovementId_order Integer
                                       ) ON COMMIT DROP;
         -- таблица - элементы Child
         CREATE TEMP TABLE _tmpItem_Child_mi (MovementItemId Integer, ParentId Integer
                                            , GoodsId Integer
                                            , Amount TFloat
                                            , PartNumber TVarChar
                                            , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                            , MovementId_order Integer
                                            , isId_order Boolean
                                             ) ON COMMIT DROP;
         -- таблица - партии
         CREATE TEMP TABLE _tmpItem_Child (MovementItemId Integer, ParentId Integer
                                         , GoodsId Integer, PartionId Integer
                                         , ContainerId_Summ Integer, ContainerId_Goods Integer
                                         , AccountId Integer
                                         , Amount TFloat
                                         , MovementId_order Integer
                                         , isId_order Boolean
                                          ) ON COMMIT DROP;
         -- таблица - ЗП
         CREATE TEMP TABLE _tmpItem_Detail (MovementItemId Integer, ParentId Integer
                                          , ReceiptServiceId Integer, PersonalId Integer
                                          , ContainerId_Summ Integer
                                          , AccountId Integer
                                          , Amount TFloat
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
-- SELECT * FROM lpComplete_Movement_ProductionUnion_CreateTemp ()
