-- Function: lpComplete_Movement_ReturnOut_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnOut_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnOut_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_70203 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummPartner_From (MovementItemId Integer, ContainerId_Goods Integer, ContainerId Integer, AccountId Integer, ContainerId_ProfitLoss_70201 Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, GoodsId Integer, OperCount_PartnerFrom TFloat, OperCount TFloat, OperSumm_Partner TFloat, OperSumm_70201 TFloat) ON COMMIT DROP;
     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_Partner TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_PartnerFrom TFloat, OperSumm_PartnerFrom TFloat
                               , ContainerId_ProfitLoss_70203 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ReturnOut_CreateTemp ()
