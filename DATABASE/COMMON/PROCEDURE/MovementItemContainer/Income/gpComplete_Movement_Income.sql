-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Income (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId        Integer                , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT False , -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Complete(), inComment:= '��������');


     -- ������� - !!!��� �����������!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- ������� - ��������
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummPartner (ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, PartionMovementId Integer, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- ������� - �������� �� ���������� (������������), �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummPacker (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Packer TFloat) ON COMMIT DROP;
     -- ������� - �������� �� ���������� (��������), �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummDriver (ContainerId Integer, AccountId Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Driver TFloat) ON COMMIT DROP;
     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , ContainerId_GoodsTicketFuel Integer, GoodsId_TicketFuel Integer
                               , OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                               , AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isCountSupplier Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

     -- �������� ��������
     PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                       , inUserId         := vbUserId
                                       , inIsLastComplete := inIsLastComplete);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 01.11.13                                        * add ...Id_Transit
 29.10.13         * rename process zc_Enum_Process_Complete_Income()
 21.10.13                                        * add TicketFuel
 12.10.13                                        * add lfCheck_Movement_ParentStatus
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 149639, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= '2')
