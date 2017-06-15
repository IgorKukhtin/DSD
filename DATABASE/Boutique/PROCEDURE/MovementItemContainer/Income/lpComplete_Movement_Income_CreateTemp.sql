-- Function: lpComplete_Movement_Income_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummPartner (MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, AccountId Integer
                                           , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                           , GoodsId Integer, PartionId Integer
                                           , OperSumm TFloat, OperSumm_Currency TFloat
                                            ) ON COMMIT DROP;

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer
                               , GoodsId Integer, PartionId Integer, GoodsSizeId Integer
                               , OperCount TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Income_CreateTemp ()
