-- Function: lpComplete_Movement_Send_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Send_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         --DELETE FROM _tmpItem;
         --DELETE FROM _tmpItemSumm;
         DROP TABLE _tmpItem;
     END IF;

     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, CarId_From Integer, BranchId_From Integer, UnitId_To Integer, MemberId_To Integer, CarId_To Integer, BranchId_To Integer
                               , ContainerDescId Integer, MIContainerId_To BigInt, MIContainerId_count_To BigInt, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, ContainerId_countFrom Integer, ContainerId_countTo Integer, ObjectDescId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_to Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime
                               , OperCount TFloat, OperCountCount TFloat
                               , AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , JuridicalId_basis_To Integer, BusinessId_To Integer
                               , StorageId_mi Integer, PartionGoodsId_mi Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean, isPartionGoodsKind_From Boolean, isPartionGoodsKind_To Boolean
                               , PartionGoodsId_From Integer, PartionGoodsId_To Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, UnitId_ProfitLoss Integer, BranchId_ProfitLoss Integer, BusinessId_ProfitLoss Integer
                               , PartNumber TVarChar, PartionModelId Integer, isAsset Boolean
                               , OperCount_start TFloat
                                ) ON COMMIT DROP;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_PartionCell'))
     THEN
         DELETE FROM _tmpItem_PartionCell;

     ELSE
         -- ������� - 
         CREATE TEMP TABLE _tmpItem_PartionCell (MovementItemId Integer
                                               , MIContainerId_To BigInt, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer
                                               , PartionCellId Integer, DescId_PartionCell Integer
                                               , PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime
                                               , OperCount TFloat
                                               , PartionGoodsId_From Integer, PartionGoodsId_To Integer
                                               , Ord Integer
                                                ) ON COMMIT DROP;
     END IF;


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItemSumm'))
     THEN
         --DELETE FROM _tmpItem;
         --DELETE FROM _tmpItemSumm;
         DROP TABLE _tmpItemSumm;
     END IF;

     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerDescId Integer, MIContainerId_To BigInt, ContainerId_GoodsTo Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss Integer, ContainerId_GoodsFrom Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Send_CreateTemp ()
