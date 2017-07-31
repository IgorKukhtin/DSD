-- Function: lpComplete_Movement_Service (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Service (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Service(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS void
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbIsAccount_50401 Boolean;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ����� ��� ���������, �.�. ���������� ��� ���� ������ ����� ����������
     SELECT Movement.DescId
          , CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                 THEN TRUE
                 ELSE FALSE
            END
            INTO vbMovementDescId, vbIsAccount_50401 -- ������� ������� �������� + ������ �� ����������
     FROM Movement
          JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
     WHERE Movement.Id = inMovementId;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId, PartionGoodsId, AssetId
                         , AnalyzerId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        -- 1.1. ���� �� ����
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , COALESCE (MovementFloat_AmountCurrency.ValueData, 0) AS OperSumm_Currency
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- ���������� �����, ��� ...
             , CASE WHEN vbMovementDescId = zc_Movement_ProfitLossService() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- ������� ������� �������� + ���������
                    ELSE 0
               END AS AccountId 

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- �������������� ����������
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- �������������� ������ ����������
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- ������ ������: �� ������������
             , 0  AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId -- ����� ������������ (����� ��� ��������� ��������)
             , 0 AS PositionId -- �� ������������

               -- ������ ������: ������ �� ������������� ��� "������� ������" (����� ��� ��� ������)
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_Balance
               -- ������ ����: ������ �� ������������� ��� "������� ������" (����� �� ������������, ����� ��� ��������� ��������)
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId

             , 0 AS PartionMovementId -- �� ������������
             , 0 AS PartionGoodsId    -- ����� ��������� !!!������!!! ��� ���������
             , 0 AS AssetId           -- ����� ��������� !!!������!!! ��� ���������

             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200()) -- ������ + ��������� OR ������ + ������ �����
                         THEN zc_Enum_AnalyzerId_SaleSumm_10300() -- !!!�����, ����������, ������ ��������������!!!
                    ELSE 0
               END AS AnalyzerId -- ����������� !!!������!!! ��� �������

               -- ������
             , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                     ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                    AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                              ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                              ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- ��������
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId NOT IN (zc_Object_Juridical(), zc_Object_Partner()))
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <����������� ����>.���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <�������>.���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <�� ������ ����������>.���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <����� ������>. ���������� ����������.';
     END IF;
     -- ��������
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION '������.� <��������> �� ����������� <������� ����������� ����>.���������� ����������.';
     END IF;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId, PartionGoodsId, AssetId
                         , AnalyzerId
                         , IsActive, IsMaster
                          )
         -- 1.2.1. ����
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE -- ������� ������� �������� + ������ �� ����������
                         THEN _tmpItem.ObjectId -- �� ���������� ��������
                    WHEN MILinkObject_Asset.ObjectId > 0
                         THEN _tmpItem.ObjectId -- ��������� ��, ������� � ��
                    ELSE 0 -- ������ ������� � ���� ��� � ��
               END AS ObjectId

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE -- ������� ������� �������� + ������ �� ����������
                         THEN _tmpItem.ObjectDescId -- �� ���������� ��������
                    WHEN MILinkObject_Asset.ObjectId > 0
                         THEN zc_Object_InfoMoney() -- ��������� ��, ������� � ��
                    ELSE 0 -- ������ ������� � ����
               END AS ObjectDescId

             , COALESCE (MI_Child.Amount, -1 * _tmpItem.OperSumm)
             , COALESCE (MI_Child.Id, _tmpItem.MovementItemId)

             , 0 AS ContainerId    -- ���������� �����
             , 0 AS AccountGroupId -- ���������� �����, ��� ...
             , CASE WHEN MILinkObject_Asset.ObjectId > 0
                         THEN -- ������������ ����� �����
                              COALESCE ((SELECT tmp.AccountDirectionId FROM lfGet_Object_Unit_byAccountDirection_Asset (_tmpItem.UnitId) AS tmp), 0)
                    ELSE 0 -- ���������� �����, ��� ...
               END AS AccountDirectionId
             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- ������� ������� �������� - ���������
                    ELSE 0
               END AS AccountId 

               -- ������ ���� (��� ������)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- ��������� ���� - ����������� (��� ������)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: ������ �� ���������� �������� (� �������� ������=0)
             , _tmpItem.BusinessId_Balance
               -- ������ ����: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId -- �� ���������� ��������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: ������ �� ���������� ��������
             , _tmpItem.BranchId_Balance
               -- ������ ����: ������ �� ���������� ��������
             , COALESCE (MILinkObject_Branch.ObjectId, _tmpItem.BranchId_ProfitLoss)

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , _tmpItem.ContractId -- �� ���������� ��������
             , _tmpItem.PaidKindId -- �� ���������� ��������

             , 0 AS PartionMovementId                               -- �� ������������
             , 0 AS PartionGoodsId                                  -- ���������� �����, ���� ��� ������ ����� (�.�. �� ��������� � ����)
             , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId -- ���� ��� ������ ����� (�.�. �� ��������� � ����)

             , 0 AS AnalyzerId -- ��������� !!!������!!! ��� ������

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId
                                                                                                          AND NOT (vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE) -- !!!����� ������ ��� ������!!!
             LEFT JOIN MovementItem AS MI_Child ON MI_Child.MovementId = inMovementId
                                               AND MI_Child.DescId = zc_MI_Child()
                                               AND MI_Child.ParentId = _tmpItem.MovementItemId
                                               AND MI_Child.isErased = FALSE
                                               AND _tmpItem.MovementDescId = zc_Movement_ProfitLossService()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MI_Child.Id
                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset() 
        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL -- !!!���� �� ���������������!!!
           OR MILinkObject_Asset.ObjectId IS NOT NULL        -- !!!���� ��!!!
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

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId             -- �� ������������

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

             , 0 AS UnitId     -- �� ������������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: ������ "������� ������" (����� ��� ��� ������)
             , zc_Branch_Basis() AS BranchId_Balance
               -- ������ ����: ����� �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , ObjectLink_Unit_Contract.ChildObjectId     AS ContractId
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId

             , 0 AS PartionMovementId -- �� ������������
             , 0 AS PartionGoodsId    -- ��������� !!!������!!! ��� ����������
             , 0 AS AssetId           -- ��������� !!!������!!! ��� ����������

             , 0 AS AnalyzerId -- ��������� !!!������!!! ��� ������

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

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset() 

        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0 -- !!!���� ���������������!!!
          AND MILinkObject_Asset.ObjectId IS NULL        -- !!!���� �� ��!!!
       ;


     -- ��������1 - ��� ��
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                                               , zc_Enum_InfoMoneyDestination_70200() -- ����������� ������
                                                                               , zc_Enum_InfoMoneyDestination_70400() -- ����������� �������������
                                                                                ))
     AND NOT EXISTS (SELECT _tmpItem.AssetId FROM _tmpItem WHERE _tmpItem.AssetId > 0)
     THEN
         RAISE EXCEPTION '������.��� �� ������ <%> ���������� ��������� �������� <��� ��������� ��������>.���������� ����������.', lfGet_Object_ValueData ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem LIMIT 1));
     END IF;

     -- ��������2 - ��� ��
     IF EXISTS (SELECT _tmpItem.UnitId FROM _tmpItem WHERE _tmpItem.AssetId > 0 AND _tmpItem.AccountDirectionId = 0)
     THEN
         RAISE EXCEPTION '������.������� ����������� ������������� <%> �.�. ������ ���������� ����������� ��� ����� <%>.���������� ����������.', lfGet_Object_ValueData ((SELECT _tmpItem.UnitId FROM _tmpItem WHERE _tmpItem.AssetId > 0 AND _tmpItem.AccountDirectionId = 0 LIMIT 1)), lfGet_Object_ValueData (zc_Enum_AccountGroup_10000()); -- ����������� ������
     END IF;


     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 21.03.14                                        * add zc_Enum_InfoMoneyDestination_21500
 10.03.14                                        * add zc_Movement_ProfitLossService
 22.01.14                                        * add IsMaster
 28.12.13                                        *
*/

-- ����
/*
     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();
 SELECT * FROM lpComplete_Movement_Service (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
*/
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 4139, inSession:= zfCalc_UserAdmin())
