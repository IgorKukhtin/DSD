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
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbIsDeferred      Boolean;
BEGIN

     -- �������
     vbIsDeferred := COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

    vbInvNumberPartner:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());


/*    -- �������� �� ������ ���������
   
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
 */             

    /* -- ����� �������
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
         WHERE Movement_ReturnOut_View.Id =  inMovementId; */
                 
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
                                        AND MIContainer_Income.DescId = zc_MIContainer_Count()                                        
    WHERE Movement_ReturnOut_View.Id =  inMovementId
      AND MovementItem_ReturnOut_View.isErased = FALSE;
      
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
              , _tmpItem.AccountId
              , CASE WHEN Container.Amount < _tmpItem.OperSumm THEN Container.Amount ELSE - _tmpItem.OperSumm END
              , _tmpItem.OperDate
           FROM _tmpItem
                INNER JOIN Container ON Container.Id = _tmpItem.ContainerId
                                    AND Container.Amount > 0;

      -- ���� ��������� �� ������� �������          
    IF EXISTS(SELECT 1 FROM 
                  _tmpItem
                  LEFT JOIN Container ON Container.Id = _tmpItem.ContainerId
              WHERE Container.Amount < _tmpItem.OperSumm)
    THEN
    
      vbUnitId := (SELECT Movement_ReturnOut_View.FromId FROM Movement_ReturnOut_View WHERE Movement_ReturnOut_View.Id = inMovementId);
                 
      -- � ���� ������
      WITH ReturnOut AS (SELECT _tmpItem.MovementItemId              as MovementItemId 
                              , _tmpItem.ObjectId                    as ObjectId
                              , _tmpItem.OperDate                    as OperDate
                              , _tmpItem.AccountId                   as AccountId
                              , _tmpItem.OperSumm - COALESCE(Container.Amount, 0)  as Amount
                         FROM _tmpItem
                              LEFT JOIN Container ON Container.Id = _tmpItem.ContainerId
                                                 AND Container.Amount > 0 
                         WHERE COALESCE(Container.Amount, 0) < _tmpItem.OperSumm
                         ),
           REMAINS AS ( --������� 
                       SELECT Container.Id 
                            , Container.ObjectId --�����
                            , Container.Amount   --���. ������� 
                       FROM Container
                            INNER JOIN ReturnOut ON Container.ObjectId = Container.ObjectId
                       WHERE Container.DescID = zc_Container_Count()
                         AND Container.WhereObjectId = vbUnitId
                         AND Container.ID not IN (SELECT _tmpItem.ContainerId FROM _tmpItem)
                         AND Container.Amount > 0
                       ),
           DD AS (SELECT ReturnOut.MovementItemId 
                       , ReturnOut.Amount 
                       , REMAINS.Amount      AS ContainerAmount 
                       , ReturnOut.OperDate  AS OperDate 
                       , ReturnOut.AccountId AS AccountId 
                       , REMAINS.Id
                       , SUM(REMAINS.Amount) OVER (PARTITION BY REMAINS.objectid ORDER BY Movement.OPERDATE, REMAINS.Id)
                  FROM REMAINS 
                       JOIN ReturnOut ON ReturnOut.objectid = REMAINS.objectid 
                       JOIN containerlinkobject AS CLI_MI 
                                                ON CLI_MI.containerid = REMAINS.Id
                                               AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                       JOIN containerlinkobject AS CLI_Unit 
                                                ON CLI_Unit.containerid = REMAINS.Id
                                               AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                               AND CLI_Unit.ObjectId = vbUnitId
                       JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                       JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                       JOIN Movement ON Movement.Id = movementitem.movementid
                   WHERE REMAINS.Amount > 0), 
          
          tmpItem AS (SELECT 
                        Id
                      , MovementItemId
                      , OperDate
                      , AccountId
                      , CASE 
                          WHEN Amount - SUM > 0 THEN ContainerAmount 
                          ELSE Amount - SUM + ContainerAmount
                        END AS Amount
                      FROM DD
                      WHERE (Amount - (SUM - ContainerAmount) >= 0)
                      )

      INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
           SELECT 
                  zc_Container_Count()
                , zc_Movement_ReturnOut() 
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.Id
                , AccountId
                , -Amount
                , OperDate
             FROM tmpItem;
    END IF;
        
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
                LEFT JOIN Movement_ReturnOut_View ON Movement_ReturnOut_View.Id = MovementItem_ReturnOut_View.MovementId
           WHERE vbInvNumberPartner <> ''
             AND vbIsDeferred = FALSE;

     
     SELECT -SUM(Amount) INTO vbOperSumm_Partner_byItem FROM _tmpMIContainer_insert WHERE AnalyzerId = 0;
 
     IF (vbOperSumm_Partner <> vbOperSumm_Partner_byItem) AND vbInvNumberPartner <> ''
     THEN
        UPDATE _tmpMIContainer_insert SET Amount = Amount - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0 
                      AND Amount IN (SELECT MAX (Amount) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0)
                                 );
     END IF;	

     -- ���� ��� ������� �������, �� ��� ����� ���� ������� �������� ������
     IF EXISTS (SELECT 1 FROM Container WHERE Container.DescId   = zc_Container_CountPartionDate()
                                          AND Container.Amount   > 0
                                          AND Container.ParentId IN (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                     WHERE _tmpMIContainer_insert.DescId   = zc_MIContainer_Count()
                                                                     ))
     THEN
       WITH -- ������� �������� ������ - zc_Container_CountPartionDate
           DD AS (SELECT _tmpMIContainer_insert.MovementItemId
                         -- ������� ���� ��������
                       , -1 * _tmpMIContainer_insert.Amount AS Amount
                         -- �������
                       , Container.Amount AS AmountRemains
                       , _tmpMIContainer_insert.OperDate    AS OperDate
                       , Container.Id     AS ContainerId
                         -- ����� "�������������" �������
                       , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id) AS AmountRemains_sum
                         -- ��� ���������� �������� - �� ������� �� �������
                       , ROW_NUMBER() OVER (PARTITION BY _tmpMIContainer_insert.MovementItemId ORDER BY Container.Id DESC) AS DOrd
                   FROM _tmpMIContainer_insert
                        JOIN Container ON Container.ParentId = _tmpMIContainer_insert.ContainerId
                                      AND Container.DescId   = zc_Container_CountPartionDate()
                                      AND Container.Amount   > 0.0
                   WHERE _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
                  )

           -- �������������
         , tmpItem AS (SELECT ContainerId
                            , MovementItemId
                            , OperDate
                            , CASE WHEN DD.Amount - DD.AmountRemains_sum > 0.0 AND DD.DOrd <> 1
                                        THEN DD.AmountRemains
                                   ELSE DD.Amount - DD.AmountRemains_sum + DD.AmountRemains
                              END AS Amount
                         FROM DD
                         WHERE (DD.Amount > 0 AND DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0))
        -- ��������� - �������� �� ������ - ������
        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT zc_MIContainer_CountPartionDate()
               , zc_Movement_ReturnOut()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.ContainerId
               , NULL
               , -1 * Amount
               , OperDate
          FROM tmpItem; 
     END IF;

     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     IF vbIsDeferred = FALSE
     THEN
         -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
         PERFORM lpComplete_Movement (inMovementId := inMovementId
                                    , inDescId     := zc_Movement_ReturnOut()
                                    , inUserId     := inUserId
                                     );
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ������ �.�.
 06.11.19                                                                  *
 11.02.14                        * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_ReturnOut (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
