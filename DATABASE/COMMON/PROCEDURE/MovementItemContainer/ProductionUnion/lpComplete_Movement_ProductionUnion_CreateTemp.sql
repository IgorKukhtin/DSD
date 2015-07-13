-- Function: lpComplete_Movement_ProductionUnion_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , MIContainerId_To Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat
                               , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_To Integer
                               , UnitId_Item Integer, StorageId_Item Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
     -- ������� - �������� Master(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, AccountGroupId_From Integer, AccountDirectionId_From Integer, AccountId_From Integer, ContainerId_From Integer, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, InfoMoneyId_Detail_To Integer, OperSumm TFloat) ON COMMIT DROP;

     -- ������� - �������������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemChild (MovementItemId_Parent Integer, MovementItemId Integer
                                    , ContainerId_GoodsFrom Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                                    , OperCount TFloat
                                    , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    , BusinessId_From Integer
                                    , UnitId_Item Integer, PartionGoodsId_Item Integer
                                    , isPartionCount Boolean, isPartionSumm Boolean
                                    , PartionGoodsId Integer) ON COMMIT DROP;
     -- ������� - �������� Child(������)-�������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSummChild (MovementItemId_Parent Integer, MovementItemId Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;


     -- ������� - 
     CREATE TEMP TABLE _tmpItem_Partion (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, ReceiptId Integer, PartionGoodsDate TDateTime, OperCount TFloat, Count_onCount TFloat) ON COMMIT DROP;
     -- ������� - 
     CREATE TEMP TABLE _tmpItem_Partion_child (MovementItemId_Parent Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsDate TDateTime, OperCount TFloat) ON COMMIT DROP;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ProductionUnion_CreateTemp ()
