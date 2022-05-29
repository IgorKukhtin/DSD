DROP FUNCTION IF EXISTS lpComplete_Movement_CashSend (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_CashSend(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbAccountId_Cash   Integer;
  --DECLARE vbAccountId_Debts  Integer;
  --DECLARE vbAccountId_Profit Integer;
  --DECLARE vbProfitLossId     Integer;
BEGIN

    -- ����������
    vbAccountId_Cash   := zc_Enum_Account_30101();
    --vbAccountId_Debts  := zc_Enum_Account_30105();
    --vbAccountId_Profit := zc_Enum_Account_30106(); 
    -- ��������
    --vbProfitLossId     := zc_Enum_Account_30106(); 
 
    -- ������� ��������� �������
    PERFORM lpComplete_Movement_Cash_CreateTemp();

    -- !!!�����������!!! �������� ������� ��������
    DELETE FROM _tmpMIContainer_insert;
    -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
    DELETE FROM _tmpItem;
    
    -- 4.1. �������������� ��������� ������
    INSERT INTO _tmpItem (MovementDescId, OperDate, ServiceDate, OperSumm, OperSumm_in, MovementItemId,
                          ObjectId, CashId)
    SELECT
           Movement.DescId                    AS Id
         , Movement.OperDate                  AS OperDate
         , MIDate_ServiceDate.ValueData       AS ServiceDate
           -- ����� (������)
         , MovementItem.Amount                AS Amount
           -- ����� (������)
         , MovementItemFloat_Amount.ValueData AS AmountIn
         , MovementItem.Id                    AS MovementItemId
         , MovementItem.ObjectId              AS CashToId
         , MILinkObject_Cash.ObjectId         AS CashFromId
     FROM Movement
          -- ����� (������)
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Cash
                                           ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Cash.DescId = zc_MILinkObject_Cash()

          LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                     ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

          -- ����� (������)
          LEFT JOIN MovementItemFloat AS MovementItemFloat_Amount
                                      ON MovementItemFloat_Amount.MovementItemId = MovementItem.Id
                                     AND MovementItemFloat_Amount.DescId         = zc_MIFloat_Amount()

     WHERE Movement.Id = inMovementId;    
     
    -- 4.2. ��������� ������
    
/*    UPDATe _tmpItem SET -- 
                        ServiceDateId = CASE WHEN _tmpItem.UnitId > 0 THEN lpInsertFind_Object_ServiceDate (_tmpItem.ServiceDate) ELSE NULL END
    ;*/
     
    -- 4.3. ������� ����������
    
    UPDATE _tmpItem SET -- ��������� �����
                         ContainerId = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()           -- DescId �������� ����
                                                    , inParentId          := NULL                          -- ������� Container
                                                    , inObjectId          := vbAccountId_Cash              -- ������ ������ ���� ��� �������� ����
                                                    , inJuridicalId_basis := NULL                          -- ������� ����������� ����
                                                    , inBusinessId        := NULL                          -- �������
                                                    , inDescId_1          := zc_ContainerLinkObject_Cash() -- DescId ��� 1-�� ���������
                                                    , inObjectId_1        := _tmpItem.ObjectId
                                                      )
                         -- ��������� ���� ��� �������
                       , ContainerId_Second  = 
                              lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()           -- DescId �������� ����
                                                    , inParentId          := NULL                          -- ������� Container
                                                    , inObjectId          := vbAccountId_Cash              -- ������ ������ ���� ��� �������� ����
                                                    , inJuridicalId_basis := NULL                          -- ������� ����������� ����
                                                    , inBusinessId        := NULL                          -- �������
                                                    , inDescId_1          := zc_ContainerLinkObject_Cash() -- DescId ��� 1-�� ���������
                                                    , inObjectId_1        := _tmpItem.CashId
                                                      )
    ;

    -- 4.4. ����������� �������� - ������� �� ����� 1
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId 
            -- ���� ��� ���� ��������
          , vbAccountId_Cash 

          , -1 * _tmpItem.OperSumm
          , _tmpItem.OperDate

            -- ���������, ��������� �������� ��-��
          , _tmpItem.ObjectId               AS ObjectId_analyzer
          , 0                               AS WhereObjectId_analyzer

            -- ��������� �� ��������-�������������
          , _tmpItem.CashId                 AS ObjectIntId_Analyzer
            -- ��������� �� ��������-�������������
          , NULL                            AS ObjectExtId_Analyzer

          , FALSE AS IsActive

     FROM _tmpItem;     

     -- 4.3. ����������� �������� - ������� �� ����� 2
     INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                       , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, IsActive)
     SELECT zc_MIContainer_Summ()
          , _tmpItem.MovementDescId
          , inMovementId
          , _tmpItem.MovementItemId
          , _tmpItem.ContainerId_Second

            -- ���� ��� ���� ��������
          , vbAccountId_Cash                                      AS AccountId

          , 1 * _tmpItem.OperSumm_in
          , _tmpItem.OperDate

            -- ���������, ��������� �������� ��-��
          , _tmpItem.CashId                                       AS ObjectId_analyzer 
            -- ���������, ��������� �������� ��-��
          , NULL                                                  AS WhereObjectId_analyzer

            -- ��������� �� ��������-�������������
          , _tmpItem.ObjectId     AS ObjectIntId_Analyzer
            -- ��������� �� ��������-�������������
          , 0                     AS ObjectExtId_Analyzer

          , TRUE AS IsActive

     FROM _tmpItem;     
     
    -- 5.1. ����� - ����������� ��������� ��������
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_CashSend()
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
-- SELECT * FROM lpComplete_Movement_CashSend (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;