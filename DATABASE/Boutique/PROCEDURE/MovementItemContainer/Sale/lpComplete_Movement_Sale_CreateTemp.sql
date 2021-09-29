-- Function: lpComplete_Movement_Sale_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_CreateTemp()
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


     --
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         --
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
                                              , OperCount TFloat, OperSumm      TFloat, OperSumm_ToPay      TFloat, TotalPay      TFloat
                                                                , OperSumm_curr TFloat, OperSumm_ToPay_curr TFloat, TotalPay_curr TFloat
                                              , OperCount_sale TFloat, OperSumm_sale      TFloat, OperSummPriceList_sale     TFloat
                                                                     , OperSumm_sale_curr TFloat, OperSummPriceList_sale_curr TFloat
                                              , Summ_10201      TFloat, Summ_10202      TFloat, Summ_10203      TFloat, Summ_10204      TFloat
                                              , Summ_10201_curr TFloat, Summ_10202_curr TFloat, Summ_10203_curr TFloat, Summ_10204_curr TFloat
                                              , ContainerId_ProfitLoss_10101      Integer, ContainerId_ProfitLoss_10201      Integer, ContainerId_ProfitLoss_10202      Integer, ContainerId_ProfitLoss_10203      Integer, ContainerId_ProfitLoss_10204      Integer, ContainerId_ProfitLoss_10301      Integer
                                              , ContainerId_ProfitLoss_10101_curr Integer, ContainerId_ProfitLoss_10201_curr Integer, ContainerId_ProfitLoss_10202_curr Integer, ContainerId_ProfitLoss_10203_curr Integer, ContainerId_ProfitLoss_10204_curr Integer, ContainerId_ProfitLoss_10301_curr Integer
                                               ) ON COMMIT DROP;

         -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                                   , OperCount TFloat, OperPrice TFloat, CountForPrice TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                                   , OperSumm_ToPay     TFloat, OperSummPriceList     TFloat, TotalChangePercent     TFloat, TotalPay     TFloat
                                   , OperSumm_ToPay_val TFloat, OperSummPriceList_val TFloat, TotalChangePercent_val TFloat, TotalPay_val TFloat
                                   , Summ_10201     TFloat, Summ_10202 TFloat,     Summ_10203 TFloat,     Summ_10204 TFloat
                                   , Summ_10201_val TFloat, Summ_10202_val TFloat, Summ_10203_val TFloat, Summ_10204_val TFloat
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
 12.08.17                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_CreateTemp ()
