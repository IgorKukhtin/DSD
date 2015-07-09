-- Function: lpComplete_Movement_Inventory_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������������� �������
     CREATE TEMP TABLE _tmpGoods_Complete_Inventory (GoodsId Integer) ON COMMIT DROP;

     -- ������� - �������������� �������
     CREATE TEMP TABLE _tmpRemainsCount (MovementItemId Integer, ContainerId_Goods Integer, GoodsId Integer, OperCount TFloat) ON COMMIT DROP;
     -- ������� - �������� �������
     CREATE TEMP TABLE _tmpRemainsSumm (ContainerId_Goods Integer, ContainerId Integer, AccountId Integer, GoodsId Integer, OperSumm TFloat) ON COMMIT DROP;

     -- ������� - �������� �������� ���������, !!!���!!! ������� ��� ������������ �������� � ��������� (���� ContainerId=0 ����� ������� �� �� _tmpItem)
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;
     -- ������� - �������� �������� ���������, ��� ����������
     CREATE TEMP TABLE _tmpItemSummRePrice (MovementItemId Integer, ContainerId_Active Integer, AccountId_Active Integer, ContainerId_Passive Integer, AccountId_Passive Integer, OperSumm TFloat) ON COMMIT DROP;

     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperSumm TFloat
                               , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer
                               , UnitId_Item Integer, StorageId_Item Integer, UnitId_Partion Integer, Price_Partion TFloat
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Inventory_CreateTemp ()
