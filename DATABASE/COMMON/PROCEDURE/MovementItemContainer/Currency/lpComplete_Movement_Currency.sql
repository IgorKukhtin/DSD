-- Function: lpComplete_Movement_Currency()

DROP FUNCTION IF EXISTS lpComplete_Movement_Currency (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Currency(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbStatusId Integer;
  DECLARE vbCurrencyId Integer;
  DECLARE vbPaidKindId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��� ��������� ����� ��� ������� Remains
     SELECT Movement.OperDate                AS OperDate
          , Movement.StatusId                AS StatusId
          , MILinkObject_CurrencyTo.ObjectId AS CurrencyId
          , MILinkObject_PaidKind.ObjectId   AS PaidKindId
          , MovementItem.Amount              AS CurrencyValue
          , MIFloat_ParValue.ValueData       AS ParValue
            INTO vbOperDate, vbStatusId, vbCurrencyId, vbPaidKindId
               , vbCurrencyValue, vbParValue
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.ObjectId = zc_Enum_Currency_Basis()
          LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                      ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                     AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                           ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                          AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                       ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                      AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Currency()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
        -- ������ Remains � ������ ��� � zc_MI_Child
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), tmp.MovementItemId, tmp.ContainerId)
        FROM
       (SELECT lpInsertUpdate_MovementItem (COALESCE (MovementItem.Id, 0), zc_MI_Child(), COALESCE (tmpSumm.ObjectId, MovementItem.ObjectId), inMovementId, COALESCE (tmpSumm.OperSumm, 0), NULL) AS MovementItemId
             , COALESCE (tmpSumm.ContainerId, MovementItem.ContainerId) AS ContainerId
        FROM (SELECT MovementItem.Id, MovementItem.ObjectId, MIFloat_ContainerId.ValueData AS ContainerId
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Child()
             ) AS MovementItem
             FULL JOIN (SELECT tmpSumm.ContainerId
                             , tmpSumm.ObjectId
                             , SUM (tmpSumm.OperSumm) AS OperSumm
                         FROM
                         -- ��� ����� � ������ (�� ���� ��������� � ������ ������� � ���������)
                        (SELECT tmpContainer.ContainerId
                              , tmpContainer.AccountId
                              , tmpContainer.ObjectId
                              , CAST ((tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0))
                                       -- ��� ����������� � ������ �������
                                     * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END
                                AS NUMERIC (16, 2)) AS OperSumm
                         FROM (SELECT Container.ParentId                       AS ContainerId
                                    , ContainerLinkObject_Currency.ContainerId AS ContainerId_Currency
                                    , Container.ObjectId                       AS AccountId
                                    , COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Partner.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, 0)))) AS ObjectId
                                    , Container.Amount
                               FROM ContainerLinkObject AS ContainerLinkObject_Currency
                                    INNER JOIN Container ON Container.Id = ContainerLinkObject_Currency.ContainerId
                                                        AND Container.DescId  = zc_Container_SummCurrency()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                                                  ON ContainerLinkObject_Cash.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_Cash.DescId  = zc_ContainerLinkObject_Cash()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                                                  ON ContainerLinkObject_BankAccount.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_BankAccount.DescId  = zc_ContainerLinkObject_BankAccount()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Partner
                                                                  ON ContainerLinkObject_Partner.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_Partner.DescId  = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                                  ON ContainerLinkObject_Juridical.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_Juridical.DescId  = zc_ContainerLinkObject_Juridical()
                               WHERE ContainerLinkObject_Currency.ObjectId = vbCurrencyId
                                 AND ContainerLinkObject_Currency.DescId  = zc_ContainerLinkObject_Currency()
                              ) AS tmpContainer
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = tmpContainer.ContainerId_Currency
                                                             AND MIContainer.OperDate >= vbOperDate
                         GROUP BY tmpContainer.ContainerId
                                , tmpContainer.ContainerId_Currency
                                , tmpContainer.AccountId
                                , tmpContainer.ObjectId
                                , tmpContainer.Amount
                       UNION ALL
                         -- ��� ����� � ������ ������� (�� ���� �������)
                         SELECT tmpContainer.ContainerId
                              , tmpContainer.AccountId
                              , tmpContainer.ObjectId
                              , -1 * (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)) AS OperSumm
                         FROM (SELECT ContainerLinkObject_Currency.ContainerId
                                    , Container.ObjectId AS AccountId
                                    , COALESCE (ContainerLinkObject_Cash.ObjectId, COALESCE (ContainerLinkObject_BankAccount.ObjectId, COALESCE (ContainerLinkObject_Partner.ObjectId, COALESCE (ContainerLinkObject_Juridical.ObjectId, 0)))) AS ObjectId
                                    , Container.Amount
                               FROM ContainerLinkObject AS ContainerLinkObject_Currency
                                    INNER JOIN Container ON Container.Id = ContainerLinkObject_Currency.ContainerId
                                                        AND Container.DescId  = zc_Container_Summ()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Cash
                                                                  ON ContainerLinkObject_Cash.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_Cash.DescId  = zc_ContainerLinkObject_Cash()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_BankAccount
                                                                  ON ContainerLinkObject_BankAccount.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_BankAccount.DescId  = zc_ContainerLinkObject_BankAccount()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Partner
                                                                  ON ContainerLinkObject_Partner.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_Partner.DescId  = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Juridical
                                                                  ON ContainerLinkObject_Juridical.ContainerId  = ContainerLinkObject_Currency.ContainerId
                                                                 AND ContainerLinkObject_Juridical.DescId  = zc_ContainerLinkObject_Juridical()
                               WHERE ContainerLinkObject_Currency.ObjectId = vbCurrencyId
                                 AND ContainerLinkObject_Currency.DescId  = zc_ContainerLinkObject_Currency()
                              ) AS tmpContainer
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = tmpContainer.ContainerId
                                                             AND MIContainer.OperDate >= vbOperDate
                         GROUP BY tmpContainer.ContainerId
                                , tmpContainer.AccountId
                                , tmpContainer.ObjectId
                                , tmpContainer.Amount
                        ) AS tmpSumm
                         GROUP BY tmpSumm.ContainerId
                                , tmpSumm.ObjectId
                        ) AS tmpSumm ON tmpSumm.ContainerId = MovementItem.ContainerId
       ) AS tmp;

     END IF; -- if vbStatusId <> zc_Enum_Status_Complete()


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId           -- ���� ��������
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- �� ������������
             , COALESCE (Container.ObjectId, 0) AS AccountId                        -- ���� ��������
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- �� ������������

               -- �������������� ������ ����������: �� ������������
             , 0 AS InfoMoneyGroupId
               -- �������������� ����������: �� ������������
             , 0 AS InfoMoneyDestinationId
               -- �������������� ������ ����������: �� ������������
             , 0 AS InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����: ������ �� ...
             , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_Basis

             , 0 AS UnitId     -- �� ������������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: �� ������������
             , 0 AS BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster

        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Child()
                                    AND MovementItem.Amount <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                           ON ContainerLinkObject_JuridicalBasis.ContainerId = Container.Id
                                          AND ContainerLinkObject_JuridicalBasis.DescId  = zc_ContainerLinkObject_JuridicalBasis()
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_Currency()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
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
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- ���������� �����

               -- ������ ����: �� ������������
             , 0 AS ProfitLossGroupId
               -- ��������� ���� - �����������: �� ������������
             , 0 AS ProfitLossDirectionId

               -- �������������� ������ ����������: �� ������������
             , 0 AS InfoMoneyGroupId
               -- �������������� ����������: �� ������������
             , 0 AS InfoMoneyDestinationId
               -- �������������� ������ ����������: �� ������������
             , 0 AS InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����: ������ 0
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����: ������ �� ...
             , _tmpItem.JuridicalId_Basis

             , 0 AS UnitId     -- �� ������������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: �� ������������
             , 0 AS BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
       ;


     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

-- RAISE EXCEPTION 'ok' ;
     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Currency()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.11.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Currency (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
