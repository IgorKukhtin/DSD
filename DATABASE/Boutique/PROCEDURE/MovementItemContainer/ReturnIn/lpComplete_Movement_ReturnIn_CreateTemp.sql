-- Function: lpComplete_Movement_ReturnIn_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица - Проводки
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- !!!ВРЕМЕННО - DROP!!!
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DROP TABLE _tmpItem;
     END IF;
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPay'))
     THEN
         DROP TABLE _tmpPay;
     END IF;
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_SummClient'))
     THEN
         DROP TABLE _tmpItem_SummClient;
     END IF;


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DELETE FROM _tmpPay;
         DELETE FROM _tmpItem_SummClient;
         DELETE FROM _tmpItem;
     ELSE
         -- таблица - элементы оплаты, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpPay (MovementItemId Integer, ParentId Integer
                                  , ObjectId Integer, ObjectDescId Integer, CurrencyId Integer
                                  , AccountId Integer, ContainerId Integer, ContainerId_Currency Integer
                                  , OperSumm TFloat, OperSumm_Currency TFloat
                                  , ObjectId_from Integer
                                  , AccountId_from Integer, ContainerId_from Integer
                                  , OperSumm_from TFloat
                                   ) ON COMMIT DROP;

         -- таблица - элементы по покупателю, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem_SummClient (MovementItemId Integer, ContainerId_Summ Integer, ContainerId_Summ_20102 Integer, ContainerId_Goods Integer, AccountId Integer, AccountId_20102 Integer
                                              , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                              , GoodsId Integer, PartionId Integer, GoodsSizeId Integer, PartionId_MI Integer
                                              , OperCount TFloat, OperSumm TFloat, OperSumm_ToPay TFloat, TotalPay TFloat
                                              , OperCount_sale TFloat, OperSumm_sale TFloat
                                              , Summ_10501 TFloat, Summ_10502 TFloat
                                              , ContainerId_ProfitLoss_10501 Integer, ContainerId_ProfitLoss_10502 Integer, ContainerId_ProfitLoss_10601 Integer
                                               ) ON COMMIT DROP;

         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer, PartionId_MI Integer, GoodsSizeId Integer
                                   , OperCount TFloat, OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                                   , OperSumm_ToPay TFloat, OperSummPriceList TFloat, TotalChangePercent TFloat, TotalPay TFloat
                                   , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , CurrencyValue TFloat, ParValue TFloat
                                   , isGoods_Debt Boolean
                                    ) ON COMMIT DROP;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ReturnIn_CreateTemp ()
