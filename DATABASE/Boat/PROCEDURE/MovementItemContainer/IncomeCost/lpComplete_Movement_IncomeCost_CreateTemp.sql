-- Function: lpComplete_Movement_IncomeCost_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeCost_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeCost_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������
     CREATE TEMP TABLE _tmpMovement_from (MovementId_from Integer, InfoMoneyId Integer, OperSumm TFloat);
     -- ������� - �������
     CREATE TEMP TABLE _tmpMovement_To (MovementId_cost Integer, MovementId_from Integer, MovementId_to Integer, InfoMoneyId_from Integer, OperSumm TFloat, OperSumm_calc TFloat);

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementId_cost Integer, MovementId_from Integer, MovementId_to Integer, MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, GoodsId Integer, PartionId Integer
                               , Amount TFloat, OperSumm TFloat, OperSumm_calc TFloat
                               , AccountId_50101 Integer, ContainerId_50101 Integer, PartnerId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
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
