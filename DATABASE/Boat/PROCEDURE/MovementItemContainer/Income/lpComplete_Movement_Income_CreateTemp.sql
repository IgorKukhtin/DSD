-- Function: lpComplete_Movement_Income_CreateTemp()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income_CreateTemp();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN

         DELETE FROM _tmpItem_SummPartner;
         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         DELETE FROM _tmpItem;
         -- ������� - ������� �������� ��������������� ��� ������� �������
         DELETE FROM _tmpReserveDiff;
         -- ������� - �������� ������ ��� ������� �������
         DELETE FROM _tmpReserveRes;

     ELSE
         -- ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem_SummPartner (MovementItemId Integer, ContainerId Integer, AccountId Integer, ContainerId_VAT Integer, AccountId_VAT Integer
                                               , GoodsId Integer, PartionId Integer
                                               , OperSumm TFloat, OperSumm_VAT TFloat
                                                ) ON COMMIT DROP;

         -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                                   , ContainerId_Summ Integer, ContainerId_Goods Integer
                                   , GoodsId Integer, PartionId Integer
                                   , OperCount TFloat, OperPrice_orig TFloat, OperPrice TFloat, CountForPrice TFloat
                                   , OperSumm TFloat, OperSumm_cost TFloat, OperSumm_VAT TFloat
                                   , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                    ) ON COMMIT DROP;

         -- ������� - ������� �������� ��������������� ��� ������� �������
         CREATE TEMP TABLE _tmpReserveDiff (MovementId_order Integer, OperDate_order TDateTime
                                          , GoodsId Integer
                                          , AmountPartner TFloat
                                           ) ON COMMIT DROP;
         -- ������� - �������� ������ ��� ������� �������
         CREATE TEMP TABLE _tmpReserveRes (MovementItemId Integer, ParentId Integer
                                         , GoodsId Integer
                                         , Amount TFloat
                                         , MovementId_order Integer
                                          ) ON COMMIT DROP;
     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Income_CreateTemp ()
