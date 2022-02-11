DROP FUNCTION IF EXISTS lpComplete_Movement_Service (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Service(
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
    
    -- 4.1. �������������� ��������� ������
    INSERT INTO _tmpItem (MovementDescId, OperDate, ServiceDate, OperSumm, MovementItemId,
                          UnitId, InfoMoneyId)
    SELECT
           Movement.DescId                    AS Id
         , Movement.OperDate                  AS OperDate
         , MIDate_ServiceDate.ValueData       AS ServiceDate
         , MovementItem.Amount                AS Amount
         , MovementItem.Id                    AS MovementItemId
         , MovementItem.ObjectId              AS UnitId
         , MILinkObject_InfoMoney.ObjectId    AS InfoMoneyId
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

     WHERE Movement.Id = inMovementId;    
     
    -- 4.2. ��������� ������
    
    UPDATe _tmpItem SET -- 
                        ServiceDateId = CASE WHEN _tmpItem.UnitId > 0 THEN lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate) ELSE NULL END
    ;
     
    -- 4.3. ������� ����������
    
    UPDATE _tmpItem SET -- ��������� ����
                         ContainerId = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId �������� ����
                                                     , inParentId          := NULL                    -- ������� Container
                                                     , inObjectId          := vbAccountId_Debts       -- ������ ������ ���� ��� �������� ����
                                                     , inJuridicalId_basis := NULL                    -- ������� ����������� ����
                                                     , inBusinessId        := NULL                    -- �������
                                                     , inDescId_1          := zc_ContainerLinkObject_Unit() -- DescId ��� 1-�� ���������
                                                     , inObjectId_1        := _tmpItem.UnitId
                                                     , inDescId_2          := zc_ContainerLinkObject_ServiceDate() -- DescId ��� 2-�� ���������
                                                     , inObjectId_2        := _tmpItem.ServiceDateId
                                                     , inDescId_3          := zc_ContainerLinkObject_InfoMoney() -- DescId ��� 3-�� ���������
                                                     , inObjectId_3        := _tmpItem.InfoMoneyId
                                                      )
                         -- ��������� �������
                       , ContainerId_Second  = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId �������� ����
                                                    , inParentId          := NULL                     -- ������� Container
                                                    , inObjectId          := vbAccountId_Profit       -- ������ ������ ���� ��� �������� ����
                                                    , inJuridicalId_basis := NULL                     -- ������� ����������� ����
                                                    , inBusinessId        := NULL                     -- �������
                                                    , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId ��� 1-�� ���������
                                                    , inObjectId_1        := vbProfitLossId           -- ��������, ���� ����� ����� ������������ lpInsertFind_Object_ProfitLoss
                                                     ) 
    ;  

    -- 4.4. ����������� �������� - ����
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId

            -- ���� ��� ���� ��������
          , vbAccountId_Debts  AS AccountId

          , _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- ���������, ��������� �������� ��-��
          , _tmpItem.UnitId                                              AS ObjectId_analyzer 
            -- ���������, ��������� �������� ��-��
          , _tmpItem.ServiceDateId                                       AS WhereObjectId_analyzer

            -- ��������� �� ��������-�������������
          , vbProfitLossId                                               AS ObjectIntId_Analyzer
            -- ��������� �� ��������-�������������
          , 0                                                            AS ObjectExtId_Analyzer

          , CASE WHEN _tmpItem.OperSumm > 0 THEN FALSE ELSE TRUE END     AS  IsActive

     FROM _tmpItem;     
     
     -- 4.3. ����������� �������� - ���� ��� �������
     INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId_Second

            -- ���� ��� ���� ��������
          , vbAccountId_Profit               AS AccountId

          , -1 * _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- ���������, ��������� �������� ��-��
          , vbProfitLossId                                               AS ObjectId_analyzer 
            -- ���������, ��������� �������� ��-��
          , NULL                                                         AS WhereObjectId_analyzer

            -- ��������� �� ��������-�������������
          , _tmpItem.UnitId                                              AS ObjectIntId_Analyzer
            -- ��������� �� ��������-�������������
          , _tmpItem.ServiceDateId                                       AS ObjectExtId_Analyzer

            -- ��� ������� ������ ��� 
          ,  FALSE                                                       AS IsActive

     FROM _tmpItem;   

    -- 5.1. ����� - ����������� ��������� ��������
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
 

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Service()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.22                                                       *
 15.01.22         *
*/

-- ����
-- 
select * from gpComplete_Movement_Service(inMovementId := 30545 ,  inSession := '5');