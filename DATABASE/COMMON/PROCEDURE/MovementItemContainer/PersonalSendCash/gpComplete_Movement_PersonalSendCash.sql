-- Function: gpComplete_Movement_PersonalSendCash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalSendCash (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalSendCash (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalSendCash(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalSendCash());

     -- ������� - !!!��� �����������!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- ������� - ��������
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, OperDate TDateTime, UnitId_ProfitLoss Integer, BranchId_ProfitLoss Integer, UnitId_Route Integer, BranchId_Route Integer
                               , ContainerId_From Integer, AccountId_From Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss Integer, AccountId_ProfitLoss Integer, MemberId_To Integer, CarId_To Integer
                               , OperSumm TFloat
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_PersonalTo Integer, BusinessId_Route Integer
                                ) ON COMMIT DROP;

     -- �������� ��������
     PERFORM lpComplete_Movement_PersonalSendCash (inMovementId := inMovementId
                                                 , inUserId     := vbUserId);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 21.12.13                                        * Personal -> Member
 04.11.13                                        * add OperDate
 02.11.13                                        * add ContainerId_ProfitLoss, AccountId_ProfitLoss
 02.11.13                                        * add BranchId_ProfitLoss, UnitId_Route, BranchId_Route
 26.10.13                                        * add CREATE TEMP TABLE...
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_PersonalSendCash (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
