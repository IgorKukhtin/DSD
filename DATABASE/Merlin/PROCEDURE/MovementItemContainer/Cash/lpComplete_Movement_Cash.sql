DROP FUNCTION IF EXISTS lpComplete_Movement_Cash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Cash(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId_Cash   Integer;
  DECLARE vbAccountId_Debts  Integer;
  DECLARE vbAccountId_Profit Integer;
  DECLARE vbProfitLossId     Integer;
BEGIN

 
    -- ����������
    vbAccountId_Cash   := zc_Enum_Account_30101();
    vbAccountId_Debts  := zc_Enum_Account_30105();
    vbAccountId_Profit := zc_Enum_Account_30106(); 
    -- ��������
    vbProfitLossId     := zc_Enum_Account_30106(); 

    -- ������� ��������� �������
    PERFORM lpComplete_Movement_Cash_CreateTemp();

    -- !!!�����������!!! �������� ������� ��������
    DELETE FROM _tmpMIContainer_insert;
    -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
    DELETE FROM _tmpItem;
    
    -- �������������� ��������� ������
    INSERT INTO _tmpItem (MovementDescId, OperDate, ServiceDate, OperSumm, MovementItemId,
                          ObjectId, UnitId, InfoMoneyId)
    SELECT
           Movement.DescId                    AS Id
         , Movement.OperDate                  AS OperDate
         , MIDate_ServiceDate.ValueData       AS ServiceDate
         , MovementItem.Amount                AS Amount
         , MovementItem.Id                    AS MovementItemId
         , MovementItem.ObjectId              AS CashId
         , MILinkObject_Unit.ObjectId         AS UnitId
         , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

     WHERE Movement.Id = inMovementId;    
     
     
     -- 4.3. ����������� �������� - ������� �� �����
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()           -- DescId �������� ����
                                  , inParentId          := NULL                          -- ������� Container
                                  , inObjectId          := vbAccountId_Cash              -- ������ ������ ���� ��� �������� ����
                                  , inJuridicalId_basis := NULL                          -- ������� ����������� ����
                                  , inBusinessId        := NULL                          -- �������
                                  , inDescId_1          := zc_ContainerLinkObject_Cash() -- DescId ��� 1-�� ���������
                                  , inObjectId_1        := _tmpItem.ObjectId
                                    ) AS ContainerId 
            -- ���� ��� ���� ��������
          , vbAccountId_Cash

          , _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- ���������, ��������� �������� ��-��
          , _tmpItem.ObjectId               AS ObjectId_analyzer
          , 0                               AS WhereObjectId_analyzer

            -- ��������� �� ��������-�������������
          , _tmpItem.UnitId                 AS ObjectIntId_Analyzer
            -- ��������� �� ��������-�������������
          , CASE WHEN _tmpItem.UnitId > 0 THEN lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate) ELSE NULL END AS ObjectExtId_Analyzer

          , CASE WHEN _tmpItem.OperSumm > 0 THEN TRUE ELSE FALSE END AS IsActive

     FROM _tmpItem;     

     -- 4.3. ����������� �������� - ���� ��� �������
     INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , CASE WHEN _tmpItem.UnitId > 0
                      -- ��� ��� ������
                      THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()     -- DescId �������� ����
                                                 , inParentId          := NULL                    -- ������� Container
                                                 , inObjectId          := vbAccountId_Debts       -- ������ ������ ���� ��� �������� ����
                                                 , inJuridicalId_basis := NULL                    -- ������� ����������� ����
                                                 , inBusinessId        := NULL                    -- �������
                                                 , inDescId_1          := zc_ContainerLinkObject_Unit() -- DescId ��� 1-�� ���������
                                                 , inObjectId_1        := _tmpItem.UnitId
                                                 , inDescId_2          := zc_ContainerLinkObject_ServiceDate() -- DescId ��� 2-�� ���������
                                                 , inObjectId_2        := lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate)
                                                 , inDescId_3          := zc_ContainerLinkObject_InfoMoney() -- DescId ��� 3-�� ���������
                                                 , inObjectId_3        := _tmpItem.InfoMoneyId
                                                  )
                                                   
                 -- ����� ��� ������ "�������"
                 ELSE
                      lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId �������� ����
                                            , inParentId          := NULL                     -- ������� Container
                                            , inObjectId          := vbAccountId_Profit       -- ������ ������ ���� ��� �������� ����
                                            , inJuridicalId_basis := NULL                     -- ������� ����������� ����
                                            , inBusinessId        := NULL                     -- �������
                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId ��� 1-�� ���������
                                            , inObjectId_1        := vbProfitLossId           -- ��������, ���� ����� ����� ������������ lpInsertFind_Object_ProfitLoss
                                             ) 
            END AS ContainerId

            -- ���� ��� ���� ��������
          , CASE WHEN _tmpItem.UnitId > 0 THEN vbAccountId_Debts ELSE vbAccountId_Profit END AS AccountId

          , -1 * _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- ���������, ��������� �������� ��-��
          , CASE WHEN COALESCE (_tmpItem.UnitId, 0) = 0 THEN vbProfitLossId ELSE _tmpItem.UnitId                END AS ObjectId_analyzer 
            -- ���������, ��������� �������� ��-��
          , CASE WHEN _tmpItem.UnitId > 0 THEN lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate) ELSE NULL END AS WhereObjectId_analyzer

            -- ��������� �� ��������-�������������
          , _tmpItem.ObjectId     AS ObjectIntId_Analyzer
            -- ��������� �� ��������-�������������
          , 0                     AS ObjectExtId_Analyzer

          , CASE WHEN COALESCE (_tmpItem.UnitId, 0) = 0
                      THEN FALSE -- ��� ������� ������ ���

                 ELSE -- �������� ��������
                      CASE WHEN _tmpItem.OperSumm > 0 THEN FALSE ELSE TRUE END
            END AS  IsActive

     FROM _tmpItem;     
     
    -- 5.1. ����� - ����������� ��������� ��������
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Cash()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.22                                                       *
 15.01.22         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Cash (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);
