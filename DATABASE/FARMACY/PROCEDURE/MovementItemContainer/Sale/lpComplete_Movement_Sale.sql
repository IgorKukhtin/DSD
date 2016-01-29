DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbSaleDate TDateTime;
BEGIN

    -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
    PERFORM lpComplete_Movement_Finance_CreateTemp();

    -- !!!�����������!!! �������� ������� ��������
    DELETE FROM _tmpMIContainer_insert;
    
    -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
    DELETE FROM _tmpItem;

    vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                              , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- C���� 
                                              , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                              , inInfoMoneyId            := NULL
                                              , inUserId                 := inUserId);

    SELECT 
        Movement_Sale.UnitId
       ,ObjectLink_Unit_Juridical.ChildObjectId 
       ,Movement_Sale.OperDate       
    INTO 
        vbUnitId
       ,vbJuridicalId
       ,vbSaleDate
    FROM 
        Movement_Sale_View AS Movement_Sale
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON Movement_Sale.UnitId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE 
        Movement_Sale.Id = inMovementId;

    -- � ���� ������
    WITH 
        Sale AS( -- ������ ��������� �������
                    SELECT 
                        MovementItem.Id       as MovementItemId 
                       ,MovementItem.ObjectId as ObjectId
                       ,MovementItem.Amount   as Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND COALESCE(MovementItem.Amount,0) > 0
                ),
        DD AS  (  -- ������ ��������� ������� ����������� �� �������� �������(�����������) �� �������������
                    SELECT 
                        Sale.MovementItemId 
                      , Sale.Amount 
                      , Container.Amount AS ContainerAmount
                      , Container.ObjectId 
                      , Container.Id
                      , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY Movement.OperDate,Container.Id) 
                    FROM Container 
                        JOIN Sale ON Sale.objectid = Container.objectid 
                        JOIN containerlinkobject AS CLI_MI 
                                                 ON CLI_MI.containerid = Container.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE 
                        Container.Amount > 0 
                        AND
                        Container.DescId = zc_Container_Count()
                        AND
                        Container.WhereObjectId = vbUnitId
                ), 
  
        tmpItem AS ( -- ���������� � ���-��(�����), ������� � ��� ����� ������� (� �������������)
                        SELECT 
                            DD.Id             AS Container_AmountId
                          , Container_Summ.Id AS Container_SummId  
			              , DD.MovementItemId
                          , DD.ObjectId
			              , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount 
                              ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN Container_Summ.Amount
                              ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END AS Summ
                          , TRUE AS IsActive
                        FROM DD
                            LEFT OUTER JOIN Container AS Container_Summ
                                                      ON Container_Summ.ParentId = DD.Id
                                                     AND Container_Summ.DescId = zc_Container_Summ() 
                        WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                    )
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
    SELECT --���������� �� ����������
        zc_Container_Count()
      , zc_Movement_Sale()  
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.Container_AmountId
      , vbAccountId
      , -tmpItem.Amount
      , vbSaleDate
      , tmpItem.IsActive
    FROM tmpItem
    UNION ALL
    SELECT --���������� �� �����
        zc_Container_Summ()
      , zc_Movement_Sale()  
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.Container_SummId
      , vbAccountId
      , -tmpItem.Summ
      , vbSaleDate
      , tmpItem.IsActive
    FROM tmpItem;
    
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Sale()
                               , inUserId     := inUserId
                                );

    --����������� ����� �� ��������� (��� ����� �������, ������� ��������� ����� ���������� ���������)
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 13.10.15                                                                     * 
*/