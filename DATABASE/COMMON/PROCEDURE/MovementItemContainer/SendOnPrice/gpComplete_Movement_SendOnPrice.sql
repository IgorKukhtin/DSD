 -- Function: gpComplete_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpComplete_Movement_SendOnPrice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
 RETURNS VOID
--  RETURNS TABLE (OperSumm_Partner_byItem TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent_byItem TFloat, OperSumm_Partner_ChangePercent TFloat, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat, ExtraChargesPercent TFloat, MemberId_From Integer, PersonalId_From Integer, BranchId_From Integer, AccountDirectionId_From Integer, isPartionDate Boolean, JuridicalId_To Integer, IsCorporate Boolean, MemberId_To Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, InfoMoneyDestinationId_Contract Integer, InfoMoneyId_Contract Integer, PaidKindId Integer, ContractId Integer, JuridicalId_basis Integer)
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, OperCount TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat, AccountId_Partner Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendOnPrice());


     -- ������� - <��������>
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, isLossMaterials Boolean, isRestoreAccount_60000 Boolean, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss_20204 Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_60000 Integer, AccountId_60000 Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat, OperSumm_Account_60000 TFloat) ON COMMIT DROP;
     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, isLossMaterials Boolean
                               , MIContainerId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                               , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer, BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId_From Integer, PartionGoodsId_To Integer) ON COMMIT DROP;

     -- �������� ��������
     PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 3313, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_SendOnPrice (inMovementId:= 3313, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3313, inSession:= '2')
