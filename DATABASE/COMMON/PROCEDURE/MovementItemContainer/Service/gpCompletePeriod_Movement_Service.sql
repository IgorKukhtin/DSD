-- Function: gpCompletePeriod_Movement_Service (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_Service (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpCompletePeriod_Movement_Service(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompletePeriod_Service());

     -- ������� - ��������� ������� ���� ������� �����������, ����� ��������
     CREATE TEMP TABLE _tmpMovement (MovementId Integer, OperDate TDateTime) ON COMMIT DROP;

     -- ����������� ������ !!!������!! �� ����������� ����������
     INSERT INTO _tmpMovement (MovementId, OperDate)
        SELECT Movement.Id, Movement.OperDate
        FROM Movement
        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId   = zc_Movement_Service()
          AND Movement.StatusId = zc_Enum_Status_Complete();


     -- !!!����������� ���������!!!
     PERFORM lpUnComplete_Movement (inMovementId := _tmpMovement.MovementId
                                  , inUserId     := vbUserId)
     FROM _tmpMovement;


     -- ������� - ��������
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, BranchId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;

     -- !!!�������� ���������!!!
     PERFORM lpComplete_Movement_Service (inMovementId := tmp.MovementId
                                        , inUserId     := vbUserId)
     FROM (SELECT _tmpMovement.MovementId FROM _tmpMovement ORDER BY _tmpMovement.OperDate, _tmpMovement.MovementId) AS tmp;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.13                                        *
*/

-- ����
-- SELECT * FROM gpCompletePeriod_Movement_Service (inStartDate:= '01.10.2013', inEndDate:= '01.10.2013', inSession:= zfCalc_UserAdmin())
