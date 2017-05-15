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
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_Goods Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;
     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, PartionGoodsId_Item Integer
                               , OperCount TFloat
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer
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
-- SELECT * FROM lpComplete_Movement_Loss_CreateTemp ()
