-- Function: lpComplete_Movement_GoodsAccount_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_GoodsAccount_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_GoodsAccount_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DELETE FROM _tmpPay;
         DELETE FROM _tmpItem_SummClient;
         DELETE FROM _tmpItem;
     ELSE
         -- ������� - �������� ������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpPay (MovementItemId Integer, ParentId Integer
                                  , ObjectId Integer, ObjectDescId Integer, CurrencyId Integer
                                  , AccountId Integer, ContainerId Integer, ContainerId_Currency Integer
                                  , OperSumm TFloat, OperSumm_Currency TFloat
                                  , ObjectId_from Integer
                                  , AccountId_from Integer, ContainerId_from Integer
                                  , OperSumm_from TFloat
                                   ) ON COMMIT DROP;

         -- ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem_SummClient (MovementItemId Integer, ContainerId_Summ Integer, ContainerId_Summ_20102 Integer, ContainerId_Goods Integer, AccountId Integer, AccountId_20102 Integer
                                              , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                              , GoodsId Integer, PartionId Integer, GoodsSizeId Integer, PartionId_MI Integer
                                              , OperCount TFloat, OperSumm TFloat, OperSumm_ToPay TFloat, TotalPay TFloat, TotalPay_curr TFloat
                                              , OperCount_sale TFloat, OperSumm_sale TFloat, OperSummPriceList_sale TFloat
                                              , Summ_10201 TFloat, Summ_10202 TFloat, Summ_10203 TFloat, Summ_10204 TFloat
                                              , ContainerId_ProfitLoss_10101 TFloat, ContainerId_ProfitLoss_10201 TFloat, ContainerId_ProfitLoss_10202 TFloat, ContainerId_ProfitLoss_10203 TFloat, ContainerId_ProfitLoss_10204 TFloat, ContainerId_ProfitLoss_10301 TFloat
                                              , isGoods_Debt Boolean
                                               ) ON COMMIT DROP;

         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer, PartionId_MI Integer, GoodsSizeId Integer
                                   , OperCount TFloat, OperPrice TFloat, CountForPrice TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                                   , OperSumm_ToPay TFloat, OperSummPriceList TFloat, TotalChangePercent TFloat, SummChangePercent_curr TFloat, TotalPay TFloat, TotalPay_curr TFloat
                                   , Summ_10201 TFloat, Summ_10202 TFloat, Summ_10203 TFloat, Summ_10204 TFloat
                                   , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , SummDebt_sale TFloat, SummDebt_return TFloat
                                   , isGoods_Debt Boolean
                                    ) ON COMMIT DROP;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.17                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_GoodsAccount_CreateTemp ()
