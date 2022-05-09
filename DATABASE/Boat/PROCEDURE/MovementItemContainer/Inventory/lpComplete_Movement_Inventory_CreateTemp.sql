-- Function: lpComplete_Movement_Inventory_CreateTemp()

DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DELETE FROM _tmpItem;
         DELETE FROM _tmpItem_Child;
         DELETE FROM _tmpRemains;
     ELSE
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , GoodsId Integer, PartNumber TVarChar
                                   , OperCount TFloat, OperPrice TFloat
                                   , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    ) ON COMMIT DROP;
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem_Child (MovementItemId Integer, ContainerId Integer, ContainerId_summ Integer, AccountId Integer
                                         , GoodsId Integer, PartionId Integer, PartNumber TVarChar
                                         , OperCount TFloat
                                          ) ON COMMIT DROP;
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpRemains (ContainerId Integer, GoodsId Integer, PartionId Integer, PartNumber TVarChar, OperDate TDateTime
                                      , Amount_container TFloat, Amount TFloat
                                       ) ON COMMIT DROP;

     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.05.22                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Inventory_CreateTemp ()
