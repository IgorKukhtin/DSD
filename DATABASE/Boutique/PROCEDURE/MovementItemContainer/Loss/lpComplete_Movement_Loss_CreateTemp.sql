-- Function: lpComplete_Movement_Loss_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Loss_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         DELETE FROM _tmpItem;
     ELSE
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                                   , OperCount TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                                   , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                   , ProfitLossId_30200 Integer, ContainerId_ProfitLoss_30200 Integer
                                    ) ON COMMIT DROP;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Loss_CreateTemp ()
