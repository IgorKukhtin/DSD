 -- Function: lpComplete_Movement_LossDebt (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossDebt (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossDebt(
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
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

    WITH tmpItem AS (
                        SELECT
                            MovementItem_LossDebt_View.Id
                          , MovementItem_LossDebt_View.JuridicalId
                          , Movement_LossDebt_View.JuridicalBasisId
                          , Movement_LossDebt_View.OperDate
                        FROM
                            Movement_LossDebt_View
                            LEFT OUTER JOIN MovementItem_LossDebt_View ON MovementItem_LossDebt_View.MovementId =  Movement_LossDebt_View.Id
                        WHERE 
                            Movement_LossDebt_View.Id =  inMovementId
                            AND
                            MovementItem_LossDebt_View.isErased = FALSE
                            AND
                            MovementItem_LossDebt_View.isCalculated = TRUE
                    ),
         tmpContainer AS (
                            SELECT
                                tmpItem.Id
                              , tmpItem.OperDate
                              , Container.Id AS ContainerId
                              , Container.Amount
                            FROM
                                tmpItem
                                INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                               ON CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                              AND CLO_Juridical.ObjectId = tmpItem.JuridicalId
                                INNER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                               ON CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                              AND CLO_JuridicalBasis.ObjectId = tmpItem.JuridicalBasisId
                                INNER JOIN Container ON Container.DescId = zc_Container_Summ()
                                                    AND Container.Id = CLO_Juridical.ContainerId
                                                    AND Container.Id = CLO_JuridicalBasis.ContainerId
                         ),
         tmpConatinerRemains AS (
                                    SELECT
                                        tmpContainer.Id
                                      , tmpContainer.ContainerId
                                      , tmpContainer.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) AS Amount
                                    FROM
                                        tmpContainer
                                        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = tmpContainer.ContainerId
                                                                             AND MovementItemContainer.OperDate > tmpContainer.OperDate
                                    GROUP BY
                                        tmpContainer.Id
                                      , tmpContainer.ContainerId
                                      , tmpContainer.Amount
                               ),
        tmpRemains AS (
                        SELECT
                            tmpConatinerRemains.Id
                           ,SUM(tmpConatinerRemains.Amount) AS Amount 
                        FROM
                            tmpConatinerRemains
                        GROUP BY
                            tmpConatinerRemains.Id
                      )
   INSERT INTO _tmpItem(MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT MovementItem_LossDebt_View.Id
        , MovementItem_LossDebt_View.JuridicalId
        , CASE 
              WHEN MovementItem_LossDebt_View.isCalculated = TRUE 
                  THEN (MovementItem_LossDebt_View.SummDebet - MovementItem_LossDebt_View.SummKredit)-COALESCE(tmpRemains.Amount,0)
          ELSE MovementItem_LossDebt_View.SummDebet - MovementItem_LossDebt_View.SummKredit
          END
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_LossDebt_View.JuridicalBasisId
        , Movement_LossDebt_View.OperDate
     FROM 
         Movement_LossDebt_View
         LEFT OUTER JOIN MovementItem_LossDebt_View ON MovementItem_LossDebt_View.MovementId = Movement_LossDebt_View.Id
                                                   AND MovementItem_LossDebt_View.isErased = FALSE
         LEFT OUTER JOIN tmpRemains ON MovementItem_LossDebt_View.Id = tmpRemains.Id
    WHERE
        Movement_LossDebt_View.Id =  inMovementId;
    
--     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
  --                                           , AccountId Integer, AnalyzerId Integer, ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
    --                                         , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)

         SELECT 
                zc_Container_Summ()
              , zc_Movement_LossDebt()  
              , inMovementId
              , _tmpItem.MovementItemId
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
                 
    -- � ���� �������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_LossDebt()  
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId �������
                          inParentId        := NULL               , -- ������� Container
                          inObjectId := zc_Enum_Account_100301(), -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId       := NULL) 
              , AccountId
              , - OperSumm
              , OperDate
           FROM _tmpItem;

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
 04.02.14                        * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_LossDebt (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
