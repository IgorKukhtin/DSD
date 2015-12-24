 -- Function: lpComplete_Movement_ChangeIncomePayment (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangeIncomePayment (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangeIncomePayment(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
BEGIN

    -- !!!�����������!!! �������� ������� ��������
    DELETE FROM _tmpMIContainer_insert;
    -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
    DELETE FROM _tmpItem;

    -- �������� �� ������ ���������
    INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, AnalyzerId)   
    SELECT 
        Movement_ChangeIncomePayment_View.FromId
      , Movement_ChangeIncomePayment_View.TotalSumm
      , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                   , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                   , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                   , inInfoMoneyId            := NULL
                                   , inUserId                 := inUserId)
      , Movement_ChangeIncomePayment_View.JuridicalId
      , Movement_ChangeIncomePayment_View.OperDate
      , Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindId
     FROM Movement_ChangeIncomePayment_View
    WHERE Movement_ChangeIncomePayment_View.Id =  inMovementId;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_Summ()
      , zc_Movement_ChangeIncomePayment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId := zc_Container_Summ(), -- DescId �������
                               inParentId        := NULL               , -- ������� Container
                               inObjectId := _tmpItem.AccountId, -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                               inBusinessId := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId       := NULL, -- <������� �/�> - ��������� ��������� ����� 
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId ��� 1-�� ���������
                               inObjectId_1        := _tmpItem.ObjectId) 
      , AccountId
      , OperSumm
      , OperDate
    FROM _tmpItem;
                 
    -- ����� ������ / �������� / �������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_ChangeIncomePayment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := _tmpItem.AnalyzerId, -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL, -- <������� �/�> - ��������� ��������� �����
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId ��� 1-�� ���������
                               inObjectId_1        := _tmpItem.ObjectId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId ��� 2-�� ���������
                               inObjectId_2        := _tmpItem.JuridicalId_Basis) 
      , null
      , OperSumm
      , OperDate
    FROM _tmpItem;

    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ChangeIncomePayment()
                               , inUserId     := inUserId
                                 );
                                 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 21.12.15                                                                      * 
*/
