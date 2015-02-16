-- Function: lpComplete_Movement_BankAccount (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_BankAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_BankAccount(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS void
--  RETURNS TABLE (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, ContainerId Integer, AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, JuridicalId_Basis Integer, UnitId Integer, ContractId Integer, PaidKindId Integer, IsActive Boolean)
AS
$BODY$
BEGIN

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


   -- �������� �� ������ ���������
   
   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT Movement_BankAccount_View.MoneyPlaceId
        , - Movement_BankAccount_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_BankAccount_View.JuridicalId_Basis
        , Movement_BankAccount_View.OperDate
     FROM Movement_BankAccount_View
    WHERE Movement_BankAccount_View.Id =  inMovementId;
     
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_Income()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId �������
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
                
   DELETE FROM _tmpItem;              
   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT Movement_BankAccount_View.BankAccountId
        , Movement_BankAccount_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_40000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_40300()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_BankAccount_View.JuridicalId_Basis
        , Movement_BankAccount_View.OperDate
     FROM Movement_BankAccount_View
    WHERE Movement_BankAccount_View.Id =  inMovementId;
     
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_Income()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId �������
                          inParentId        := NULL               , -- ������� Container
                          inObjectId := _tmpItem.AccountId, -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId       := NULL, -- <������� �/�> - ��������� ��������� ����� 
                          inDescId_1          := zc_ContainerLinkObject_BankAccount(), -- DescId ��� 1-�� ���������
                          inObjectId_1        := _tmpItem.ObjectId) 
              , AccountId
              , OperSumm
              , OperDate
           FROM _tmpItem;

    -- ����� �������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_SummIncomeMovementPayment()
              , zc_Movement_Income()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                          inParentId        := NULL               , -- ������� Container
                          inObjectId := lpInsertFind_Object_PartionMovement(Movement_BankAccount_View.IncomeId), -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId       := NULL) -- <������� �/�> - ��������� ��������� �����) 
              , null
              ,  OperSumm
              , _tmpItem.OperDate
           FROM _tmpItem, Movement_BankAccount_View
         WHERE Movement_BankAccount_View.Id =  inMovementId;

     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_BankAccount()
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.02.15                         * 
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_BankAccount (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
