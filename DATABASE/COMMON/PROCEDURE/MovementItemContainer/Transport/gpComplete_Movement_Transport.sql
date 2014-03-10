-- Function: gpComplete_Movement_Transport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Transport());
     -- �������� �������� ��������
     PERFORM lpCheckPeriodClose(vbUserId, inMovementId);

     -- ������� - �������� 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- ������� ������� (�������) ���������/���������
     CREATE TEMP TABLE _tmpPropertyRemains (Kind Integer, FuelId Integer, Amount TFloat) ON COMMIT DROP;
     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_Transport (MovementItemId Integer, MovementItemId_parent Integer, UnitId_ProfitLoss Integer, BranchId_ProfitLoss Integer, RouteId_ProfitLoss Integer, UnitId_Route Integer, BranchId_Route Integer
                                         , ContainerId_Goods Integer, GoodsId Integer, AssetId Integer
                                         , OperCount TFloat
                                         , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                         , BusinessId_Car Integer, BusinessId_Route Integer
                                          ) ON COMMIT DROP;
     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_TransportSumm_Transport (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;


     -- �������� ��������
     PERFORM lpComplete_Movement_Transport (inMovementId := inMovementId
                                          , inUserId     := vbUserId);

/*
     -- !!!������� ��� ����������� ����������!!!

     -- ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummPartner (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, PartionMovementId Integer, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- ������� - �������� �� ���������� (������������), �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummPacker (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Packer TFloat) ON COMMIT DROP;

     -- ������� - �������� �� ���������� (��������), �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummDriver (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Driver TFloat) ON COMMIT DROP;

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                               , AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isCountSupplier Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

     -- �������� ����������� ���������
     PERFORM lpComplete_Movement_Income (inMovementId     := Movement.Id
                                       , inUserId         := vbUserId
                                       , inIsLastComplete := TRUE)
     FROM Movement
     WHERE Movement.ParentId = inMovementId
       AND Movement.DescId   = zc_Movement_Income()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete());
*/

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.13                        * lpCheckPeriodClose                
 03.11.13                                        * add RouteId_ProfitLoss
 02.11.13                                        * add BranchId_ProfitLoss, UnitId_Route, BranchId_Route
 26.10.13                                        * add CREATE TEMP TABLE...
 12.10.13                                        * del lpComplete_Movement_Income
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Transport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
