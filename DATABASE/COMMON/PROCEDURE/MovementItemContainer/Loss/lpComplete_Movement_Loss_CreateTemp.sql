-- Function: lpComplete_Movement_Loss_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Loss_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_Goods Integer, ContainerId_ProfitLoss Integer, ContainerDescId Integer, ContainerId Integer, ContainerId_asset Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;
     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_Count Integer, ContainerId_asset Integer, ObjectDescId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, PartionGoodsId_Item Integer
                               , OperCount TFloat, OperCountCount TFloat, Summ_service TFloat
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer, isAsset Boolean
                               , OperCount_start TFloat
                                ) ON COMMIT DROP;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Loss_CreateTemp ()
