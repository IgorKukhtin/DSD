-- Function: lpComplete_Movement_ReturnOut_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnOut_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnOut_CreateTemp()
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
                               , OperCount TFloat, OperPrice TFloat, CountForPrice TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.17                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ReturnOut_CreateTemp ()
