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
     ELSE
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , GoodsId Integer
                                   , OperCount TFloat
                                   , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    ) ON COMMIT DROP;
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem_Child (MovementItemId Integer, ParentId Integer
                                         , GoodsId Integer, PartionId Integer
                                         , OperCount TFloat
                                         , MovementId_order Integer
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
