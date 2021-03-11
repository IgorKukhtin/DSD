-- Function: lpComplete_Movement_ProfitLossResult (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_ProfitLossResult (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProfitLossResult(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

     -- 1.1. ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate
                         , OperSumm
                         , MovementItemId
                         , ContainerId
                         , AccountId
                         , ObjectId
                         , BusinessId_Balance, JuridicalId_Basis, BranchId_Balance
                         , AnalyzerId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
               -- �������� ���� �������
             , -1 * MovementItem.Amount AS OperSumm

             , MovementItem.Id    AS MovementItemId
             , Container.Id       AS ContainerId
             , Container.ObjectId AS AccountId

              -- ���� - ������
             , COALESCE (CLO_ProfitLoss.ObjectId, 0) AS ObjectId

              -- ������ ������
             , COALESCE (CLO_Business.ObjectId, 0) AS BusinessId_Balance

               -- ������� ��.����
             , COALESCE (CLO_JuridicalBasis.ObjectId, 0) AS JuridicalId_Basis

               -- ������ ������
             , COALESCE (CLO_Branch.ObjectId, 0)  AS BranchId_Balance


             , 0 AS AnalyzerId

             , TRUE AS IsActive
             , TRUE AS IsMaster

        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.Amount     <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
             LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData :: Integer

             LEFT JOIN ContainerLinkObject AS CLO_ProfitLoss
                                           ON CLO_ProfitLoss.ContainerId = Container.Id
                                          AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
             LEFT JOIN ContainerLinkObject AS CLO_Branch
                                           ON CLO_Branch.ContainerId = Container.Id
                                          AND CLO_Branch.DescId      = zc_ContainerLinkObject_Branch()
             LEFT JOIN ContainerLinkObject AS CLO_Business
                                           ON CLO_Business.ContainerId = Container.Id
                                          AND CLO_Business.DescId      = zc_ContainerLinkObject_Branch()
             LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                           ON CLO_JuridicalBasis.ContainerId = Container.Id
                                          AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()

        WHERE Movement.Id       = inMovementId
          AND Movement.DescId   = zc_Movement_ProfitLossResult()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- ��������
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperSumm = 0)
     THEN
         RAISE EXCEPTION '������.������� �����.';
     END IF;

     -- 1.2. ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementDescId, OperDate
                         , OperSumm
                         , MovementItemId
                         , ContainerId
                         , AccountId
                         , ObjectId
                         , BusinessId_Balance, JuridicalId_Basis, BranchId_Balance
                         , AnalyzerId
                         , IsActive, IsMaster
                          )
        -- 1. � �������
        WITH tmpAccount_100501 AS (SELECT tmpItem.JuridicalId_Basis
                                        , tmpItem.AccountId
                                        , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                , inParentId          := NULL
                                                                , inObjectId          := tmpItem.AccountId
                                                                , inJuridicalId_basis := tmpItem.JuridicalId_Basis
                                                                , inBusinessId        := NULL
                                                                , inObjectCostDescId  := NULL
                                                                , inObjectCostId      := NULL
                                                                 ) AS ContainerId
                    
                                   FROM (SELECT DISTINCT
                                                _tmpItem.JuridicalId_Basis
                                                 -- ������� �����������
                                               , zc_Enum_Account_100501() AS AccountId
                                         FROM _tmpItem
                                        ) AS tmpItem
                                  )
        -- 
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , -1 * _tmpItem.OperSumm AS OperSumm

             , _tmpItem.MovementItemId

               -- ������� �����������
             , tmpAccount_100501.ContainerId
               -- ������� �����������
             , tmpAccount_100501.AccountId

               -- ����
             , _tmpItem.ObjectId

               -- ������ ������
             , _tmpItem.BusinessId_Balance
               -- ������� ��.���� - ��� ���� �������� ����
             , tmpAccount_100501.JuridicalId_Basis

               -- ������ ������
             , _tmpItem.BranchId_Balance

             , 0 AS AnalyzerId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN tmpAccount_100501 ON tmpAccount_100501.JuridicalId_Basis = _tmpItem.JuridicalId_Basis
       ;


     -- 4. ����������� �������� + !!!���� MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ObjectIntId_Analyzer
                                       , ContainerId_Analyzer, AccountId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive
                                        )
       SELECT 0
            , zc_MIContainer_Summ()       AS DescId
            , _tmpItem.MovementDescId
            , inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId

            , _tmpItem.AccountId          AS AccountId

            , 0                           AS AnalyzerId

            , _tmpItem.ObjectId           AS ObjectId_Analyzer
            , _tmpItem.JuridicalId_Basis  AS WhereObjectId_Analyzer
            , _tmpItem.BusinessId_Balance AS ObjectIntId_Analyzer

            , tmpFind.ContainerId         AS ContainerId_Analyzer -- ��������� - �������������
            , tmpFind.AccountId           AS AccountId_Analyzer   -- ���� - �������������

            , 0                           AS ParentId
            , _tmpItem.OperSumm
            , _tmpItem.OperDate
            , _tmpItem.IsActive

       FROM _tmpItem
            LEFT JOIN _tmpItem AS tmpFind ON tmpFind.MovementItemId = _tmpItem.MovementItemId
                                         AND tmpFind.IsActive       = NOT _tmpItem.IsActive
      ;

     -- 5.1.����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ProfitLossResult()
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.14                                        * add zc_ObjectLink_Founder_InfoMoney
 09.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 22.01.14                                        * add IsMaster
 28.12.13                                        * rename to zc_ObjectLink_ProfitLossResult_JuridicalBasis
 26.12.13                                        *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_ProfitLossResult (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
