-- Function: lpComplete_Movement_SendOnPrice_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_SendOnPrice_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendOnPrice_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpitem')
     THEN
         DELETE FROM _tmpItemSumm;
         DELETE FROM _tmpItem;
     ELSE
         -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, isLossMaterials Boolean, isRestoreAccount_60000 Boolean, MIContainerId_To Integer, ContainerId_Transit Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss_20200 Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_60000 Integer, AccountId_60000 Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat, OperSumm_Account_60000 TFloat) ON COMMIT DROP;
         -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, isLossMaterials Boolean
                                   , MIContainerId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, ContainerId_GoodsTransit Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                                   , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                                   , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , BusinessId_From Integer, BusinessId_To Integer
                                   , isPartionCount Boolean, isPartionSumm Boolean
                                   , PartionGoodsId_From Integer, PartionGoodsId_To Integer) ON COMMIT DROP;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_SendOnPrice_CreateTemp ()
