-- Function: lpComplete_Movement_WriteOffHouseholdInventory

DROP FUNCTION IF EXISTS lpComplete_Movement_WriteOffHouseholdInventory (Integer, Integer);


CREATE OR REPLACE FUNCTION lpComplete_Movement_WriteOffHouseholdInventory (
    IN inMovementId                   Integer   , -- ���� ������� <��������>
    IN inUserId                       Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN

     IF COALESCE (inMovementId, 0) = 0
     THEN
       RAISE EXCEPTION '������. ��� ��������� ������� �������.';     
     END IF;
     
     -- ����������
    SELECT MovementLinkObject.ObjectId, Movement.OperDate
    INTO vbUnitId, vbOperDate
    FROM MovementLinkObject
        JOIN Movement ON Movement.Id = MovementLinkObject.MovementId                          
    WHERE MovementLinkObject.MovementId = inMovementId 
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     
     -- � ���� ������
     WITH 
       tmpMI AS (SELECT MI_Master.ID
                      , MI_Master.ObjectId AS PartionHouseholdInventoryID
                      , MI_Master.Amount
                 FROM MovementItem AS MI_Master
                 WHERE MI_Master.MovementId = inMovementId
                   AND MI_Master.DescId     = zc_MI_Master()
                   AND MI_Master.Amount     > 0
                   AND MI_Master.IsErased   = FALSE),
       tmpContainer AS (SELECT Container.ID

                             , Container.ObjectId                     AS HouseholdInventoryId
                             , Container.Amount                       AS Amount
                             , Container.WhereobjectId                AS UnitID

                             , ContainerLinkObject.ObjectId           AS PartionHouseholdInventoryID
                             , tmpMI.ID                               AS MovementItemId
                      FROM tmpMI 
                                  
                           INNER JOIN ContainerLinkObject ON tmpMI.PartionHouseholdInventoryID = ContainerLinkObject.ObjectId
                                                        AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                                    
                           INNER JOIN Container ON ContainerId = Container.Id 
                                               AND Container.DescId = zc_Container_CountHouseholdInventory()
                                               AND Container.WhereobjectId = vbUnitId
                                               AND Container.Amount > 0
                     )

    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_CountHouseholdInventory()
              , zc_Movement_WriteOffHouseholdInventory()  
              , inMovementId
              , tmpItem.MovementItemId
              , tmpItem.Id
              , Null
              , -Amount
              , vbOperDate
           FROM tmpContainer AS tmpItem;

     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WriteOffHouseholdInventory()
                                , inUserId     := inUserId
                                 );
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      * 
 */

-- ����
-- 
select * from gpUpdate_Status_WriteOffHouseholdInventory(inMovementId := 19480115  , inStatusCode := 2 ,  inSession := '3');