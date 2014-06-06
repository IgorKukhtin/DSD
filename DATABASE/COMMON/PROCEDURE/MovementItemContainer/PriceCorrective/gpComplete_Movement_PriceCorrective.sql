-- Function: gpComplete_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS gpComplete_Movement_PriceCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PriceCorrective(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)                              
 RETURNS VOID

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PriceCorrective());

     -- ������� - !!!��� �����������!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- ������� - ��������� �������
     CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- ������� - ��������� <������� �/�>
     CREATE TEMP TABLE _tmpObjectCost (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- ������� - ��������� <�������� ��� ������>
     CREATE TEMP TABLE _tmpChildReportContainer (AccountKindId Integer, ContainerId Integer, AccountId Integer) ON COMMIT DROP;
     -- ������� - 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10800 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , GoodsId Integer, GoodsKindId Integer
                               , OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , ContainerId_ProfitLoss_10300 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_To Integer) ON COMMIT DROP;

     -- �������� ��������
     PERFORM lpComplete_Movement_PriceCorrective (inMovementId     := inMovementId
                                                , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.06.14                                        * all
 03.06.14         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_PriceCorrective (inMovementId:= 10154, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
