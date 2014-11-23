-- Function: gpComplete_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_OrderExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderExternal(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsLastComplete    Boolean DEFAULT False, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
-- RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime, OperCount TFloat, AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, JuridicalId_basis_To Integer, BusinessId_To Integer, isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean, PartionGoodsId_From Integer, PartionGoodsId_To Integer)
-- RETURNS TABLE (MovementItemId Integer, MIContainerId_To Integer, ContainerId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; --lpCheckRight (inSession, zc_Enum_Process_Complete_OrderExternal());

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_OrderExternal()
                                , inUserId     := vbUserId
                                 );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.07.14                                                       *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_OrderExternal (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
