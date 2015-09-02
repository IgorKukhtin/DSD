 -- Function: lpComplete_Movement_ReturnOut (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnOut (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnOut(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
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
   SELECT Movement_ReturnOut_View.ToId
        , Movement_ReturnOut_View.TotalSumm
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_ReturnOut_View.JuridicalId
        , Movement_ReturnOut_View.OperDate
     FROM Movement_ReturnOut_View
    WHERE Movement_ReturnOut_View.Id =  inMovementId;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)

         SELECT 
                zc_Container_Summ()
              , zc_Movement_ReturnOut()  
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
                 
           SELECT SUM(OperSumm) INTO vbOperSumm_Partner
             FROM _tmpItem;
             


    -- ����� �������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_SummIncomeMovementPayment()
              , zc_Movement_ReturnOut()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                          inParentId        := NULL               , -- ������� Container
                          inObjectId := lpInsertFind_Object_PartionMovement(Movement_ReturnOut_View.MovementIncomeId), -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId       := NULL) -- <������� �/�> - ��������� ��������� �����) 
              , null
              , - OperSumm
              , _tmpItem.OperDate
           FROM _tmpItem, Movement_ReturnOut_View
         WHERE Movement_ReturnOut_View.Id =  inMovementId;
                 
 /*    CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , AnalyzerId Integer
                               , CurrencyId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
*/
    DELETE FROM _tmpItem;
    INSERT INTO _tmpItem(MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, 
                         OperDate, UnitId, ContainerId)   
    SELECT
        zc_Movement_ReturnOut()
      , MovementItem_ReturnOut_View.Id
      , MovementItem_ReturnOut_View.GoodsId
      , MovementItem_ReturnOut_View.Amount
      , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                   , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- C���� 
                                   , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                   , inInfoMoneyId            := NULL
                                   , inUserId                 := inUserId)
      , Movement_ReturnOut_View.JuridicalId
      , Movement_ReturnOut_View.OperDate
      , Movement_ReturnOut_View.FromId
      , MIContainer_Income.ContainerId
    FROM 
        MovementItem_ReturnOut_View
        INNER JOIN Movement_ReturnOut_View ON MovementItem_ReturnOut_View.MovementId = Movement_ReturnOut_View.Id
        INNER JOIN MovementItem AS MovementItem_Income
                                ON MovementItem_ReturnOut_View.ParentId = MovementItem_Income.Id
        INNER JOIN MovementItemContainer AS MIContainer_Income
                                         ON MIContainer_Income.MovementItemId = MovementItem_Income.Id
                                        AND MIContainer_Income.DescId = zc_Container_Count()                                        
    WHERE  
        Movement_ReturnOut_View.Id =  inMovementId;

    -- � ���� ������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Count()
              , zc_Movement_ReturnOut()  
              , inMovementId
              , _tmpItem.MovementItemId
              , _tmpItem.ContainerId
              -- , lpInsertFind_Container(
                          -- inContainerDescId := zc_Container_Count(), -- DescId �������
                          -- inParentId        := NULL               , -- ������� Container
                          -- inObjectId := ObjectId, -- ������ (���� ��� ����� ��� ...)
                          -- inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          -- inBusinessId := NULL, -- �������
                          -- inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          -- inObjectCostId       := NULL,
                          -- inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                          -- inObjectId_1        := _tmpItem.UnitId) 
              , AccountId
              , - OperSumm
              , OperDate
           FROM _tmpItem;
   

    
--     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
  --                                           , AccountId Integer, AnalyzerId Integer, ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
    --                                         , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

    -- �� � �������-�� �����
    INSERT INTO _tmpMIContainer_insert(AnalyzerId, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, AccountId, Amount, OperDate)
         SELECT 
                0
              , zc_Container_Summ()
              , zc_Movement_ReturnOut()  
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId �������
                          inParentId        := _tmpMIContainer_insert.ContainerId , -- ������� Container
                          inObjectId := _tmpItem.AccountId, -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId       := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Goods(), -- DescId ��� 1-�� ���������
                          inObjectId_1        := _tmpItem.ObjectId,
                          inDescId_2          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                          inObjectId_2        := _tmpItem.UnitId) 
              , nULL
              , _tmpItem.AccountId
              , - CASE WHEN Movement_ReturnOut_View.PriceWithVAT THEN MovementItem_ReturnOut_View.AmountSumm
                      ELSE MovementItem_ReturnOut_View.AmountSumm * (1 + Movement_ReturnOut_View.NDS/100)
                 END::NUMERIC(16, 2)     
              , _tmpItem.OperDate
           FROM _tmpItem 
                JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.MovementItemId = _tmpItem.MovementItemId
                LEFT JOIN MovementItem_ReturnOut_View ON MovementItem_ReturnOut_View.Id = _tmpItem.MovementItemId
                LEFT JOIN Movement_ReturnOut_View ON Movement_ReturnOut_View.Id = MovementItem_ReturnOut_View.MovementId;

     
     SELECT -SUM(Amount) INTO vbOperSumm_Partner_byItem FROM _tmpMIContainer_insert WHERE AnalyzerId = 0;
 
     IF (vbOperSumm_Partner <> vbOperSumm_Partner_byItem) THEN
        UPDATE _tmpMIContainer_insert SET Amount = Amount - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0 
                      AND Amount IN (SELECT MAX (Amount) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0)
                                 );
      END IF;	

     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LossDebt()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.02.14                        * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_ReturnOut (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
