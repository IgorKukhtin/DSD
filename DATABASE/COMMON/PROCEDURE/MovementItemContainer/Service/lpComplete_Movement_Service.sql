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
  DECLARE vbIsChild         Boolean;
  DECLARE vbIsAccount_50401 Boolean;
  DECLARE vbIsAccount_60301 Boolean;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

     --
     vbIsChild:= EXISTS (SELECT 1 FROM Movement
                                      JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id
                                                                   AND MI_Child.DescId     = zc_MI_Child()
                                                                   AND MI_Child.isErased   = FALSE
                         WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_ProfitLossService()
                           AND inUserId = 5
                        );


     -- ����� ��� ���������, �.�. ���������� ��� ���� ������ ����� ����������
     SELECT Movement.DescId
          , CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                  AND MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                 THEN TRUE
                 ELSE FALSE
            END
          , CASE WHEN Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_30503()) -- ������ �� �����������
                  AND (Movement.DescId = zc_Movement_ProfitIncomeService() OR Movement.OperDate >= '01.03.2021')
                 THEN TRUE
                 ELSE FALSE
            END
            INTO vbMovementDescId
               , vbIsAccount_50401 -- ������� ������� �������� + ������ �� ����������
               , vbIsAccount_60301 -- ������� ������� �������� + ������ �� ����������
     FROM Movement
          JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                           ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
     WHERE Movement.Id = inMovementId;


     -- ������ ��� ����� ���������
     IF vbMovementDescId = zc_Movement_Service()
     THEN
         -- ��-�� ������� ������ �����
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), MovementItem.Id, ObjectLink_Unit_Branch.ChildObjectId)
         FROM Movement
              JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
              LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
              LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                            AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
         WHERE Movement.Id = inMovementId
        ;
     END IF;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency, OperSumm_Asset
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

             , CASE WHEN Movement.OperDate >= zc_DateStart_Asset() AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN 0
                    WHEN vbMovementDescId = zc_Movement_ProfitIncomeService()
                         THEN 1
                    ELSE 1
               END * MovementItem.Amount                                                                              AS OperSumm

             , COALESCE (MovementFloat_AmountCurrency.ValueData, 0)                                                   AS OperSumm_Currency

             , CASE WHEN Movement.OperDate >= zc_DateStart_Asset() AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN 1
                    ELSE 0
               END * MovementItem.Amount                                                                              AS OperSumm_Asset

             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- ���������� �����, ��� ...
             , CASE WHEN vbMovementDescId = zc_Movement_ProfitLossService() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- ������� ������� �������� + ���������
                    WHEN vbMovementDescId = zc_Movement_ProfitIncomeService() AND vbIsAccount_60301 = TRUE
                         THEN zc_Enum_Account_60301() -- ������� ������� �������� + ������ �� �����������

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
             , COALESCE (MILinkObject_JuridicalBasis.ObjectId, ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId -- ����� ������������ (����� ��� ��������� ��������)
             , 0 AS PositionId -- �� ������������

               -- ������ ������:
             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40900() AND Movement.OperDate = '31.12.2014'
                         THEN -- ���������� ������
                              0
                    ELSE -- ������ �� ������������� ��� "������� ������" (����� ��� ��� ������)
                         COALESCE (MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
               END AS BranchId_Balance
               -- ������ ����: ������ �� ������������� ��� "������� ������" (����� �� ������������, ����� ��� ��������� ��������)
             , COALESCE (MILinkObject_Branch.ObjectId, ObjectLink_Unit_Branch.ChildObjectId, 0 /*zc_Branch_Basis()*/) AS BranchId_ProfitLoss

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
             , COALESCE (MLO_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                     ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                    AND MovementFloat_AmountCurrency.DescId     = zc_MovementFloat_AmountCurrency()
             LEFT JOIN MovementLinkObject AS MLO_Currency
                                          ON MLO_Currency.MovementId = Movement.Id
                                         AND MLO_Currency.DescId     = zc_MovementLinkObject_CurrencyPartner()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                             AND Movement.DescId IN (zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService())

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                              ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                              ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                             AND MILinkObject_JuridicalBasis.DescId         = zc_MILinkObject_JuridicalBasis()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService(), zc_Movement_ProfitIncomeService())
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;

     IF vbIsChild = FALSE AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperSumm = 0 AND _tmpItem.OperSumm_Currency = 0 AND _tmpItem.MovementDescId = zc_Movement_ProfitLossService())
     THEN
         RAISE EXCEPTION '������� �����.';
     END IF;

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
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId, PartionGoodsId, AssetId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.2.1. ���� OR ����� ����� (��� ���������� �� ���� ��� zc_Movement_ProfitLossService)
        WITH tmpMI_Child AS (SELECT MI_Child.ParentId, MI_Child.Id AS MovementItemId, MIF_MovementId.ValueData :: Integer AS MovementId_begin, MI_Child.Amount
                             FROM MovementItem AS MI_Child
                                  INNER JOIN MovementItemFloat AS MIF_MovementId ON MIF_MovementId.MovementItemId = MI_Child.Id
                                                                                AND MIF_MovementId.DescId         = zc_MIFloat_MovementId()
                             WHERE MI_Child.MovementId = inMovementId
                               AND MI_Child.DescId = zc_MI_Child()
                               AND MI_Child.isErased = FALSE
                             --AND inUserId = 5
                               AND vbIsChild = TRUE
                            )

        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE -- ������� ������� �������� + ������ �� ����������
                         THEN _tmpItem.ObjectId -- �� ���������� ��������
                    WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_60301 = TRUE -- ������� ������� �������� + ������ �� �����������
                         THEN _tmpItem.ObjectId -- �� ���������� ��������

                    WHEN MILinkObject_Asset.ObjectId > 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                         THEN _tmpItem.ObjectId -- ��������� ��, ������� � ��

                    WHEN vbIsChild = TRUE
                         THEN _tmpItem.ObjectId -- ��������� ��� zc_Movement_ProfitLossService

                    -- ���� ��� ������� � �����������
                    WHEN ObjectLink_Unit_Founder.ChildObjectId >  0
                         THEN ObjectLink_Unit_Founder.ChildObjectId

                    ELSE 0 -- ������ ������� � ���� ��� � ��

               END AS ObjectId

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE -- ������� ������� �������� + ������ �� ����������
                         THEN _tmpItem.ObjectDescId -- �� ���������� ��������

                    WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_60301 = TRUE -- ������� ������� �������� + ������ �� �����������
                         THEN _tmpItem.ObjectDescId -- �� ���������� ��������

                    WHEN MILinkObject_Asset.ObjectId > 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                         THEN zc_Object_InfoMoney() -- ��������� ��, ������� � ��

                    WHEN vbIsChild = TRUE
                         THEN _tmpItem.ObjectDescId -- �� ���������� �������� - ��������� ��� zc_Movement_ProfitLossService

                    -- ���� ��� ������� � �����������
                    WHEN ObjectLink_Unit_Founder.ChildObjectId >  0
                         THEN zc_Object_Founder()

                    ELSE 0 -- ������ ������� � ����

               END AS ObjectDescId

             , CASE WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN 0
                    ELSE -1 * _tmpItem.OperSumm + (-1) * COALESCE (MI_Child.Amount, 0)
               END AS OperSumm

             , CASE WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() AND vbMovementDescId = zc_Movement_Service()
                         THEN -1 * _tmpItem.OperSumm_Asset
                    ELSE 0
               END AS OperSumm_Asset

             , _tmpItem.MovementItemId

             , 0 AS ContainerId    -- ���������� �����
             , 0 AS AccountGroupId -- ���������� �����, ��� ...
             , CASE WHEN MILinkObject_Asset.ObjectId > 0 AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                         THEN -- ������������ ����� �����
                              COALESCE ((SELECT tmp.AccountDirectionId FROM lfGet_Object_Unit_byAccountDirection_Asset (_tmpItem.UnitId) AS tmp), 0)
                    ELSE 0 -- ���������� �����, ��� ...
               END AS AccountDirectionId

             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- ������� ������� �������� - ���������
                    WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_60301 = TRUE
                         THEN zc_Enum_Account_60301() -- ������� ������� �������� + ������ �� �����������
                    WHEN vbIsChild = TRUE
                         THEN zc_Enum_Account_51101() -- ������������� ��������� + ������ �� ���������� + ���������
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

             , CASE WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                         THEN COALESCE (MILinkObject_Asset.ObjectId, 0) -- ���� ��� ������ ����� (�.�. �� ��������� � ����)
                    ELSE 0
               END AS AssetId

             , 0 AS AnalyzerId -- ��������� !!!������!!! ��� ������
             , 0 AS ObjectIntId_Analyzer

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Founder
                                  ON ObjectLink_Unit_Founder.ObjectId = _tmpItem.UnitId
                                 AND ObjectLink_Unit_Founder.DescId   = zc_ObjectLink_Unit_Founder()

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId
                                                                                                          AND NOT (vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE) -- !!!����� ������ ��� ������!!!
                                                                                                          AND vbIsChild = FALSE
                                                                                                          -- ���������� ������������� ��� ����������� ������� + �����������������, ������, �������
                                                                                                          AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_80600()
                                                                                                          
             LEFT JOIN (SELECT tmpMI_Child.ParentId, SUM (tmpMI_Child.Amount) AS Amount FROM tmpMI_Child GROUP BY tmpMI_Child.ParentId) AS MI_Child ON MI_Child.ParentId = _tmpItem.MovementItemId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = NULL -- MI_Child.MovementItemId
                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                             AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
        WHERE (ObjectLink_Unit_Contract.ChildObjectId IS NULL -- !!!���� �� ���������������!!!
           AND (_tmpItem.OperDate < zc_DateStart_Asset() OR _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000() OR vbMovementDescId <> zc_Movement_Service())
              )
           OR MILinkObject_Asset.ObjectId IS NOT NULL        -- !!!���� ��!!!

       UNION ALL
         -- 1.2.2. ��������������� ������ �� �� ����
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * _tmpItem.OperSumm AS OperSumm
             , 0                      AS OperSumm_Asset
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
             , 0 AS ObjectIntId_Analyzer

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
                                             AND _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000()

        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0 -- !!!���� ���������������!!!
          AND MILinkObject_Asset.ObjectId IS NULL        -- !!!���� �� ��!!!
          AND (_tmpItem.OperDate < zc_DateStart_Asset() OR _tmpItem.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_70000() OR vbMovementDescId <> zc_Movement_Service())

       UNION ALL
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , MI_Child.MovementId_begin AS ObjectId

             , -1 * zc_Movement_Sale() AS ObjectDescId

             , 1 * MI_Child.Amount  AS OperSumm

             , 0                    AS OperSumm_Asset

             , _tmpItem.MovementItemId

             , 0 AS ContainerId    -- ���������� �����
             , 0 AS AccountGroupId -- ���������� �����, ��� ...

             , 0 AS AccountDirectionId -- ���������� �����, ��� ...

             , zc_Enum_Account_51201()  AS AccountId -- ������������� ��������� + ��������� � ��������� + ���������

               -- ������ ���� (��� ������)
             , 0 AS ProfitLossGroupId
               -- ��������� ���� - ����������� (��� ������)
             , 0 AS ProfitLossDirectionId

               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyGroupId
               -- �������������� ����������
             , _tmpItem.InfoMoneyDestinationId
               -- �������������� ������ ����������
             , _tmpItem.InfoMoneyId

               -- ������ ������: ������ �� ���������� �������� (� �������� ������=0)
             , _tmpItem.BusinessId_Balance
               -- ������ ����: ObjectLink_Unit_Business
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.���� ������ �� ��������
             , _tmpItem.JuridicalId_Basis

             , 0 AS UnitId     -- �� ������������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: ������ �� ���������� ��������
             , _tmpItem.BranchId_Balance
               -- ������ ����: ������ �� ���������� ��������
             , _tmpItem.BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , _tmpItem.ContractId -- �� ���������� ��������
             , _tmpItem.PaidKindId -- �� ���������� ��������

             , CASE WHEN ObjectFloat.ObjectId > 0 THEN ObjectFloat.ObjectId
                    ELSE lpInsertFind_Object_PartionMovement (inMovementId := MI_Child.MovementId_begin
                                                            , inPaymentDate:= _tmpItem.OperDate
                                                             )
               END AS PartionMovementId                             -- !!! ������������ !!!
             , 0 AS PartionGoodsId                                  -- ���������� �����, ���� ��� ������ ����� (�.�. �� ��������� � ����)
             , 0 AS AssetId                                         -- ���� ��� ������ ����� (�.�. �� ��������� � ����)

             , 0 AS AnalyzerId -- ��������� !!!������!!! ��� ������
             , MILinkObject_BonusKind.ObjectId AS ObjectIntId_Analyzer

             , _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             INNER JOIN tmpMI_Child AS MI_Child ON MI_Child.ParentId = _tmpItem.MovementItemId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                              ON MILinkObject_BonusKind.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_BonusKind.DescId         = zc_MILinkObject_BonusKind()

             LEFT JOIN ObjectFloat ON ObjectFloat.ValueData = MI_Child.MovementId_begin AND ObjectFloat.DescId = zc_ObjectFloat_PartionMovement_MovementId()
           --LEFT JOIN ObjectDate  ON ObjectDate.ObjectId = ObjectFloat.ObjectId AND ObjectDate.DescId = zc_ObjectDate_PartionMovement_Payment()
       ;


     -- �������� 1.1. - ��� ��
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100() -- ����������� ����������
                                                                               , zc_Enum_InfoMoneyDestination_70200() -- ����������� ������
                                                                               , zc_Enum_InfoMoneyDestination_70400() -- ����������� �������������
                                                                                )
               )
     AND NOT EXISTS (SELECT _tmpItem.AssetId FROM _tmpItem WHERE _tmpItem.AssetId > 0)
     THEN
         RAISE EXCEPTION '������.��� �� ������ <%> ���������� ��������� �������� <��� ��������� ��������>.���������� ����������.<%>'
                       , lfGet_Object_ValueData ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem LIMIT 1))
                       , (SELECT COUNT(*) FROM _tmpItem WHERE _tmpItem.AssetId > 0)
                        ;
     END IF;

     -- �������� 1.2. - ��� ��
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyId IN (8945    -- ������������� + ������ ���������� + ������ ������������
                                                                    , 7900450 -- ������������� + ������ ���������� + ������ ������������
                                                                     )
               )
        AND NOT EXISTS (SELECT 1
                        FROM _tmpItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                              ON MILinkObject_Asset.MovementItemId = _tmpItem.MovementItemId
                                                             AND MILinkObject_Asset.DescId         = zc_MILinkObject_Asset()
                        WHERE MILinkObject_Asset.ObjectId > 0
                       )
     THEN
         RAISE EXCEPTION '������.��� �� ������ <%> ���������� ��������� �������� <��� ��������� ��������>.���������� ����������.<%>'
                       , lfGet_Object_ValueData ((SELECT _tmpItem.InfoMoneyId FROM _tmpItem LIMIT 1))
                       , (SELECT COUNT(*) FROM _tmpItem WHERE _tmpItem.AssetId > 0)
                        ;
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
