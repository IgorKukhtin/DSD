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
     CREATE TEMP TABLE _tmpItem_From (InfoMoneyId Integer, OperSumm TFloat);
     -- ������� - �������
     CREATE TEMP TABLE _tmpItem_To (MovementId Integer, InfoMoneyId Integer, OperSumm TFloat, OperSumm_calc TFloat);


     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, UnitId_Asset Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , ContainerId_GoodsTicketFuel Integer, GoodsId_TicketFuel Integer
                               , OperCount TFloat, OperCount_Partner TFloat, OperCount_Packer TFloat
                               , tmpOperSumm TFloat, OperSumm TFloat
                               , tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Partner_Currency TFloat, OperSumm_Partner_Currency TFloat, Price_Currency TFloat
                               , tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                               , tmpOperSumm_PartnerTo TFloat, OperSumm_PartnerTo TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyGroupId_Detail Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer
                               , ContainerId_ProfitLoss Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
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
