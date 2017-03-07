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
         DELETE FROM _tmpItem;
         DELETE FROM _tmpItemSumm;
     ELSE
         -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, BranchId_From Integer, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer
                                   , MIContainerId_To BigInt, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime
                                   , OperCount TFloat
                                   , AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , JuridicalId_basis_To Integer, BusinessId_To Integer
                                   , UnitId_Item Integer, StorageId_Item Integer, PartionGoodsId_Item Integer, UnitId_Partion Integer, Price_Partion TFloat
                                   , isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean, isPartionGoodsKind_From Boolean, isPartionGoodsKind_To Boolean
                                   , PartionGoodsId_From Integer, PartionGoodsId_To Integer) ON COMMIT DROP;
         -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, MIContainerId_To BigInt, ContainerId_To Integer, AccountId_To Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat) ON COMMIT DROP;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Send_CreateTemp ()
