-- Function: lpComplete_Movement_LossPersonal (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossPersonal (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossPersonal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- ��������
     IF NOT EXISTS (SELECT 1
                    FROM Movement
                    WHERE Movement.Id     = inMovementId
                      AND Movement.DescId = zc_Movement_LossPersonal()
                      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                   )
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

  
     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.1. ���� ���������� �� ��
        SELECT Movement.DescId
             , Movement.OperDate
             , MovementItem.ObjectId     AS ObjectId
             , Object.DescId             AS ObjectDescId
             , -1 * MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- ���������� �����
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- �������������� ����������
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- �������������� ������ ����������
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- ������ ������: �� ����� ����� ����� ���������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����: �� ����� ����� ����� ���������
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)                AS UnitId
             , COALESCE (MILinkObject_Position.ObjectId, 0)            AS PositionId
             , COALESCE (MILinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId

               -- ������ ������: ������ �� ������������� !!!� ����� � �/����� - ������ ����������!!!
             , COALESCE (MILinkObject_Branch.ObjectId, 0) AS BranchId_Balance
               -- ������ ����: �� ������������ !!!� ����� � �/����� - ������ ����������!!!
             , 0 AS BranchId_ProfitLoss

               -- ����� ���������� - ����
             , lpInsertFind_Object_ServiceDate (inOperDate:= MovementDate_ServiceDate.ValueData) AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , 0                     AS AnalyzerId           -- �� ����, �.�. ��� ������� ��
             , MovementItem.ObjectId AS ObjectIntId_Analyzer -- ����, �������� "��������"

             -- , CASE WHEN -1 * MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsActive -- ������ �����
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

             LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                    ON MovementDate_ServiceDate.MovementId = Movement.Id
                                   AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Branch.DescId         = zc_MILinkObject_Branch()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                              ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

        WHERE Movement.Id         = inMovementId
          AND Movement.DescId     = zc_Movement_LossPersonal()
          AND Movement.StatusId   IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          AND MovementItem.Amount <> 0
       ;

     -- ��������
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION '� ��������� �� ��������� <���������>. ���������� ����������.';
     END IF;

     -- ��������
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION '� �� ����������� <������� �� ����.> ���������� ����������.';
     END IF;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.2.1. ���� �� �� (����� ��������������� � ����������)
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

               -- ������ ���� - �������������� �������
             , zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId
               -- ��������� ���� - ����������� - �������� ������������� �� ��
             , zc_Enum_ProfitLossDirection_70500() AS ProfitLossDirectionId

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- ������� ��.����: �� ����� ����� ����� ���������
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId            -- ������������, ��� ��������� WhereObjectId_Analyzer
             , 0 AS PositionId            -- �� ������������
             , 0 AS PersonalServiceListId -- �� ������������

               -- ������ ������: �� ������������
             , 0 AS BranchId_Balance
               -- ������ ����: ������ �� �������������
             , _tmpItem.BranchId_Balance AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , 0 AS AnalyzerId               -- �� ����, �.�. ��� ����
             , _tmpItem.ObjectIntId_Analyzer -- ����, �.�. ��� ����
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId

       ;

     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);


     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LossPersonal()
                                , inUserId     := inUserId
                                 );
                                 
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.02.18         * 
*/
