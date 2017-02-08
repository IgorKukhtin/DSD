-- Function: lpComplete_Movement_MobileBills (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_MobileBills (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_MobileBills(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN
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
        -- 1.1. ���� ���������� ����� - �� ����
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (Object_Object.Id, 0)      AS ObjectId
             , COALESCE (Object_Object.DescId, 0)  AS ObjectDescId
             , 1 * MovementItem.Amount AS OperSumm
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

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , Object_Unit.Id   AS UnitId -- ����� �� ������������ (����� ��� ��������� ��������)
             , 0 AS PositionId            -- �� ������������
             , 0 AS PersonalServiceListId -- �� ������������

               -- ������ ������: (����� ��� ��� ������)
             , zc_Branch_Basis() AS BranchId_Balance
               -- ������ ����: ������ �� ������������� ��� "������� ������" (����� �� ������������, ����� ��� ��������� ��������)
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS AS ServiceDateId

             , COALESCE (MLO_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_FirstForm()        AS PaidKindId -- !!!�����������-��!!!

             , 0 AS AnalyzerId -- �� ����, �.�. ��� ������� ������
               -- ���������:
             , CASE -- 1) ���� ��� ���������� - �� ���� "�����������" �������
                    WHEN Object_ObjectTo.DescId = zc_Object_Founder()
                         THEN Object_ObjectTo.Id
                    -- 2) ���� ��� ��������� - �� ���� "�����������" �������
                    WHEN Object_ObjectTo.DescId = zc_Object_Personal()
                         THEN Object_ObjectTo.Id
                    -- 3) ���������/�������������/���������� ��� �� ���� "�����������" �������
                    ELSE COALESCE (MILinkObject_Employee.ObjectId, Object_ObjectTo.Id)
               END AS ObjectIntId_Analyzer

             , TRUE AS IsActive -- ������ �����
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

             LEFT JOIN MovementLinkObject AS MLO_Contract
                                          ON MLO_Contract.MovementItemId = MovementItem.MovementId
                                         AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = MLO_Contract.ObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney ON ObjectLink_Contract_Juridical.ObjectId = MLO_Contract.ObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MLO_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

             -- ���������/�������������/����������
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee
                                              ON MILinkObject_Employee.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Employee.DescId = zc_MILinkObject_Employee()
             LEFT JOIN Object AS Object_Employee ON Object_Employee.Id = MILinkObject_Employee.ObjectId
             -- ����� ��� ����
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = MILinkObject_Employee.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             -- ���� � ��� ���� ����������� - �� ���� "�����������" ������� � "������ � ��" ��� � "��������� �����"
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id = ObjectLink_Member_ObjectTo.ChildObjectId

             -- ���� "���������" - � ���� ������������ "�������������"
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                  ON ObjectLink_Personal_Unit.ObjectId = COALESCE (Object_ObjectTo.Id, MILinkObject_Employee.ObjectId)
                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE -- ���� �� ���� "�����������" ������� = �������������
                                                                      WHEN Object_ObjectTo.DescId = zc_Object_Unit()
                                                                           THEN Object_ObjectTo.Id
                                                                      -- ���� ����� ���������� ��� ������� �������� � �������������
                                                                      WHEN ObjectLink_Personal_Unit.ChildObjectId > 0 OR Object_Employee.DescId = zc_Object_Unit()
                                                                           THEN COALESCE (ObjectLink_Personal_Unit.ChildObjectId, Object_Employee.Id)
                                                                      -- ����� ����������� - ������������� "����������������"
                                                                      ELSE 8383
                                                                 END
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_MobileBills()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- ��������
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION '� ��������� �� ��������� <�������>. ���������� ����������.';
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
        -- 1.2.1. ���� �� "������ ����������" - ��� ���������/������������� ��� �������� ��������� "�����" - ���� ����� ����� �����
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 *  _tmpItem.OperSumm
               -- !!!��������� �� "���������"
             + CASE WHEN Object_Employee.DescId = zc_Object_Personal()
                         THEN COALESCE (MIFloat_Overlimit.ValueData, 0)
                    ELSE 0
               END AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

               -- ������ ����
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- ��������� ���� - �����������
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����:
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

             , 0 AS AnalyzerId -- �� ����, �.�. ��� ����
             , _tmpItem.ObjectIntId_Analyzer -- ����, �.�. ��� ����

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN Object AS Object_Employee ON Object_Employee.Id = _tmpItem.ObjectIntId_Analyzer

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId

             LEFT JOIN MovementItemFloat AS MIFloat_Overlimit
                                         ON MIFloat_Overlimit.MovementItemId = _tmpItem.MovementItemId
                                        AND MIFloat_Overlimit.DescId = zc_MIFloat_Overlimit()

        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL                                -- ���� �� ���������������
          AND (Object_Employee.Id IS NULL OR Object_Employee.DescId <> zc_Object_Founder()) -- ���� �� ����������

       UNION ALL
         -- 1.2.2. ��������������� ������ �� �� ����
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId                -- �� ������������
             , 0 AS PositionId            -- �� ������������
             , 0 AS PersonalServiceListId -- �� ������������

               -- ������ ������: ������ "������� ������" (����� ��� ��� ������)
             , zc_Branch_Basis() AS BranchId_Balance
               -- ������ ����: ����� �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , ObjectLink_Unit_Contract.ChildObjectId     AS ContractId
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId

             , 0 AS AnalyzerId -- �� ����, �.�. ��� ���������������
             , _tmpItem.ObjectIntId_Analyzer -- ����, �.�. ��� ���������������

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                              AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = _tmpItem.ObjectIntId_Analyzer
                                                AND Object_ObjectTo.DescId = zc_Object_Founder()

        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0
          AND Object_ObjectTo.Id IS NULL

       UNION ALL
         -- 1.2.3. ��������������� ������ �� ����������
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_ObjectTo.Id     AS ObjectId
             , Object_ObjectTo.DescId AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ���������� - �� ������������
             , 0 AS InfoMoneyGroupId
               -- �������������� ���������� - �� ������������
             , 0 AS InfoMoneyDestinationId
               -- �������������� ������ ���������� - �� ������������
             , 0 AS InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId                -- �� ������������
             , 0 AS PositionId            -- �� ������������
             , 0 AS PersonalServiceListId -- �� ������������

               -- ������ ������: �� ������������
             , 0 AS BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , 0 AS AnalyzerId -- �� ����, �.�. ��� ���������������
             , 0  As ObjectIntId_Analyzer -- �� ����, �.�. ��� ���������������
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             INNER JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = _tmpItem.ObjectIntId_Analyzer
                                                 AND Object_ObjectTo.DescId = zc_Object_Founder()

       UNION ALL
        -- 1.3.1. ���� �� ������� - ��������� � �� (��� ����������) - !!!�����!!!
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * MIF.ValueData AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

               -- ������ ����
             , 0 AS ProfitLossGroupId     -- ���������� �����
               -- ��������� ���� - �����������
             , 0 AS ProfitLossDirectionId -- ���������� �����

               -- �������������� ������ ����������
             , View_InfoMoney.InfoMoneyGroupId
               -- �������������� ����������
             , View_InfoMoney.InfoMoneyDestinationId
               -- �������������� ������ ���������� - ��������� ������� �� �� - ����������
             , View_InfoMoney.InfoMoneyId

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

             , 0 AS AnalyzerId -- �� ����, �.�. ��� ����

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem.MovementItemId AND MIF.DescId = zc_MIFloat_SummNalog()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_50101() -- ��������� ������� �� �� - ����������
        WHERE MIF.ValueData <> 0

       UNION
        -- 1.3.2. ���� ���������� �� �� - ��������� � ��
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId
             , 1 * MIF.ValueData AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- ���������� �����
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: �� ����� ����� ����� ���������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����: �� ����� ����� ����� ���������
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId
             , _tmpItem.PositionId
             , _tmpItem.PersonalServiceListId

               -- ������ ������: ������ �� ������������� !!!� ����� � �/����� - ������ ����������!!!
             , _tmpItem.BranchId_Balance
               -- ������ ����: �� ������������ !!!� ����� � �/����� - ������ ����������!!!
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: ����
             , _tmpItem.ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , zc_Enum_AnalyzerId_MobileBills_Nalog() AS AnalyzerId -- ����, �.�. ��� ��������� � ��

             , _tmpItem.IsActive -- ������ �����
             , FALSE AS IsMaster
        FROM _tmpItem
             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem.MovementItemId AND MIF.DescId = zc_MIFloat_SummNalog()

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                AND Object_ObjectTo.DescId = zc_Object_Founder()
        WHERE MIF.ValueData <> 0
          AND Object_ObjectTo.Id IS NULL

       UNION ALL
         -- 1.3.3. ��������������� �� ������� �� ����������
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_ObjectTo.Id     AS ObjectId
             , Object_ObjectTo.DescId AS ObjectDescId
             , 1 * MIF.ValueData AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ���������� - �� ������������
             , 0 AS InfoMoneyGroupId
               -- �������������� ���������� - �� ������������
             , 0 AS InfoMoneyDestinationId
               -- �������������� ������ ���������� - �� ������������
             , 0 AS InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId                -- �� ������������
             , 0 AS PositionId            -- �� ������������
             , 0 AS PersonalServiceListId -- �� ������������

               -- ������ ������: �� ������������
             , 0 AS BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , zc_Enum_AnalyzerId_MobileBills_Nalog() AS AnalyzerId -- ����, �.�. ��� ��������������� - ������
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem.MovementItemId AND MIF.DescId = zc_MIFloat_SummNalog()
             INNER JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             INNER JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                                AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             INNER JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                 AND Object_ObjectTo.DescId = zc_Object_Founder()
        WHERE MIF.ValueData <> 0
       ;

/*
     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     -- 2.1. ���� ���������� �� ���.����
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId
             , -1 * (COALESCE (MIFloat_SummSocialIn.ValueData, 0) + COALESCE (MIFloat_SummSocialAdd.ValueData, 0)) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- ���������� �����
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������
             , View_InfoMoney.InfoMoneyGroupId
               -- �������������� ����������
             , View_InfoMoney.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , View_InfoMoney.InfoMoneyId

               -- ������ ������: �� ����� ����� ����� ���������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����: �� ����� ����� ����� ���������
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId
             , _tmpItem.PositionId

               -- ������ ������: ������ �� �������������
             , _tmpItem.BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: ����
             , _tmpItem.ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , FALSE AS IsActive
             , TRUE AS IsMaster
        FROM _tmpItem
              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                          ON MIFloat_SummSocialIn.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                          ON MIFloat_SummSocialAdd.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()                                     
              LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60103() -- ���������� ����� + ��������
       ;
*/

     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MobileBills()
                                , inUserId     := inUserId
                                 );
     -- 6.1. ����� - ����������� ����� � ������� (���� ���� "������" �������) - �� ���� "�����" <����� ������� - ��������� � ��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), tmpMovement.MovementItemId, -1 * OperSumm
                                                                                                 + COALESCE (MIFloat_SummSocialAdd.ValueData, 0)
                                                                                                 - tmpMovement.SummTransport
                                                                                                 + tmpMovement.SummTransportAdd
                                                                                                 + tmpMovement.SummTransportAddLong
                                                                                                 + tmpMovement.SummTransportTaxi
                                                                                                 - tmpMovement.SummPhone
                                              )
             -- ����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport()       , tmpMovement.MovementItemId, tmpMovement.SummTransport)
             -- ����� ��������������� (�������)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAdd()    , tmpMovement.MovementItemId, tmpMovement.SummTransportAdd)
             -- ����� ������������ (�������, ���� ���������������)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAddLong(), tmpMovement.MovementItemId, tmpMovement.SummTransportAddLong)
             -- ����� �� ����� (�������)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportTaxi()   , tmpMovement.MovementItemId, tmpMovement.SummTransportTaxi)
             -- ����� ���.����� (���������)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPhone()           , tmpMovement.MovementItemId, tmpMovement.SummPhone)
     FROM (SELECT _tmpItem.MovementItemId
                , _tmpItem.OperSumm
                , COALESCE (SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.Amount ELSE 0 END), 0) AS SummTransport
                , COALESCE (SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add()     THEN -1 * MIContainer.Amount ELSE 0 END), 0) AS SummTransportAdd
                , COALESCE (SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_AddLong() THEN -1 * MIContainer.Amount ELSE 0 END), 0) AS SummTransportAddLong
                , COALESCE (SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Taxi()    THEN -1 * MIContainer.Amount ELSE 0 END), 0) AS SummTransportTaxi
                , 0 AS SummPhone
           FROM _tmpItem
                LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId    = _tmpItem.ContainerId
                                                              -- AND MIContainer.MovementDescId = zc_Movement_Income()
           WHERE _tmpItem.IsMaster = TRUE
           GROUP BY _tmpItem.MovementItemId
                  , _tmpItem.OperSumm
          ) AS tmpMovement
          LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                      ON MIFloat_SummSocialAdd.MovementItemId = tmpMovement.MovementItemId
                                     AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()                                     
    ;
     -- 6.2. ����� - ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.09.14                                        *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_MobileBills (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
