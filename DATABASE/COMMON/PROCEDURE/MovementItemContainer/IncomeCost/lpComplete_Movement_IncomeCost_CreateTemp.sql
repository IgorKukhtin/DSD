-- Function: lpComplete_Movement_IncomeCost_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeCost_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeCost_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_From')
     THEN
         DELETE FROM _tmpItem_From;
     ELSE
         -- ������� - �������
         CREATE TEMP TABLE _tmpItem_From (ContainerId Integer, AccountId Integer, InfoMoneyId Integer, OperSumm TFloat);
     END IF;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_To')
     THEN
         DELETE FROM _tmpItem_To;
     ELSE
         -- ������� - �������
         CREATE TEMP TABLE _tmpItem_To (MovementId_cost Integer, MovementId_in Integer, ContainerId Integer, AccountId Integer, InfoMoneyId Integer, OperCount TFloat, OperSumm TFloat, OperSumm_calc TFloat);
     END IF;

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer
                               , OperCount TFloat, OperSumm TFloat, OperSumm_calc TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, ContainerId_Detail Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.15                                        * add _tmpItem_SummPartner.GoodsId
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_IncomeCost_CreateTemp ()
