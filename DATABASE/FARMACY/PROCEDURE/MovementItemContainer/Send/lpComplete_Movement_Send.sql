DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitFromId Integer;
   DECLARE vbUnitToId Integer;
   DECLARE vbJuridicalFromId Integer;
   DECLARE vbJuridicalToId Integer;
   DECLARE vbSendDate TDateTime;
BEGIN

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

   vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- C���� 
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId);

    SELECT 
        MovementLinkObject_From.ObjectId
       ,ObjectLink_Unit_Juridical_From.ChildObjectId 
       ,MovementLinkObject_To.ObjectId
       ,ObjectLink_Unit_Juridical_To.ChildObjectId
       ,Movement.OperDate       
    INTO 
        vbUnitFromId
       ,vbJuridicalFromId
       ,vbUnitToId
       ,vbJuridicalToId
       ,vbSendDate
    FROM 
        Movement
        Inner Join MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() 
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_From
                                   ON MovementLinkObject_From.ObjectId = ObjectLink_Unit_Juridical_From.ObjectId
                                  AND ObjectLink_Unit_Juridical_From.DescId = zc_ObjectLink_Unit_Juridical()
        Inner Join MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To() 
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_To
                                   ON MovementLinkObject_To.ObjectId = ObjectLink_Unit_Juridical_To.ObjectId
                                  AND ObjectLink_Unit_Juridical_To.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE Movement.Id = inMovementId;
      

    -- � ���� ������
    WITH 
        Send AS( -- ������ ��������� �����������
                    SELECT 
                        MovementItem.Id       as MovementItemId 
                       ,MovementItem.ObjectId as ObjectId
                       ,MovementItem.Amount   as Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND COALESCE(MovementItem.Amount,0) > 0
                ),
        DD AS  (  -- ������ ��������� ����������� ����������� �� �������� �������(�����������) �� ������������� "From"
                    SELECT 
                        Send.MovementItemId 
                      , Send.Amount 
                      , Container.Amount AS ContainerAmount
                      , Container.ObjectId 
                      , OperDate 
                      , Container.Id
                      , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY OPERDATE,Container.Id) 
                      , movementitem.Id AS PartionMovementItemId
                    FROM Container 
                        JOIN Send ON Send.objectid = Container.objectid 
                        JOIN containerlinkobject AS CLI_MI 
                                                 ON CLI_MI.containerid = Container.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN containerlinkobject AS CLI_Unit 
			                                     ON CLI_Unit.containerid = Container.Id
                                                AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                AND CLI_Unit.ObjectId = vbUnitFromId
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE Container.Amount > 0
                ), 
  
        tmpItem AS ( -- ���������� � ���-��(�����), ������� � ��� ����� ������� (� ������������� "From")
                        SELECT 
                            DD.Id             AS Container_AmountId
                          , Container_Summ.Id AS Container_SummId 
                          , DD.PartionMovementItemId
			              , DD.MovementItemId
                          , DD.ObjectId
			              , DD.OperDate
			              , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount 
                              ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN Container_Summ.Amount
                              ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END AS Summ
                        FROM DD
                            LEFT OUTER JOIN Container AS Container_Summ
                                                      ON Container_Summ.ParentId = DD.Id
                                                     AND Container_Summ.DescId = zc_Container_Summ() 
                        WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                    ),
        tmpAll AS  ( --���������� � ���������� ������� ����� ������� � ������������� "From"
                        SELECT
                            Container_AmountId
                           ,MovementItemId
                           ,ObjectId
                           ,vbSendDate AS OperDate
                           ,Amount
                           ,True       AS IsActive
                        FROM tmpItem
                        UNION ALL --    + ���������� � ���������� ������� ����� ����������� �� ������������� "To"
                        SELECT 
                            lpInsertFind_Container(
                                                    inContainerDescId   := zc_Container_Count(), -- DescId �������
                                                    inParentId          := NULL  , -- ������� Container
                                                    inObjectId          := tmpItem.ObjectId, -- ������ (���� ��� ����� ��� ...)
                                                    inJuridicalId_basis := vbJuridicalToId, -- ������� ����������� ����
                                                    inBusinessId        := NULL, -- �������
                                                    inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                                                    inObjectId_1        := vbUnitToId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId ��� 2-�� ���������
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId)) as Id
                           ,tmpItem.MovementItemId  AS MovementItemId 
                           ,tmpItem.ObjectId        AS ObjectId 
                           ,vbSendDate              AS OperDate
                           ,-TmpItem.Amount
                           ,False                    AS IsActive
                        FROM tmpItem
                    ),
        tmpSumm AS (  --���������� � ����� ������� ����� ������� � ������������� "From"
                        SELECT
                            Container_SummId
                           ,MovementItemId
                           ,ObjectId
                           ,vbSendDate AS OperDate
                           ,Summ
                           ,True       AS isActive
                        FROM tmpItem
                        UNION ALL  --    + ���������� � ����� ������� ����� ����������� �� ������������� "To"
                        SELECT 
                            lpInsertFind_Container(
                                                    inContainerDescId   := zc_Container_Summ(), -- DescId �������
                                                    inParentId          := lpInsertFind_Container(
                                                                                                    inContainerDescId   := zc_Container_Count(), -- DescId �������
                                                                                                    inParentId          := NULL    , -- ������� Container
                                                                                                    inObjectId          := tmpItem.ObjectId, -- ������ (���� ��� ����� ��� ...)
                                                                                                    inJuridicalId_basis := vbJuridicalToId, -- ������� ����������� ����
                                                                                                    inBusinessId        := NULL, -- �������
                                                                                                    inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                                                                                                    inObjectCostId      := NULL,
                                                                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                                                                                                    inObjectId_1        := vbUnitToId,
                                                                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId ��� 2-�� ���������
                                                                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId))               , -- ������� Container
                                                    inObjectId          := tmpItem.ObjectId, -- ������ (���� ��� ����� ��� ...)
                                                    inJuridicalId_basis := vbJuridicalToId, -- ������� ����������� ����
                                                    inBusinessId        := NULL, -- �������
                                                    inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                                                    inObjectId_1        := vbUnitToId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId ��� 2-�� ���������
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.MovementItemId)) as Id
                           ,tmpItem.MovementItemId  AS MovementItemId 
                           ,tmpItem.ObjectId        AS ObjectId 
                           ,vbSendDate              AS OperDate
                           ,-TmpItem.Summ
                           ,False                   AS isActive
                        FROM tmpItem
                    )

    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
    SELECT --���������� �� ����������
        zc_Container_Count()
      , zc_Movement_Send()  
      , inMovementId
      , tmpAll.MovementItemId
      , tmpAll.Container_AmountId
      , vbAccountId
      , -Amount
      , OperDate
      ,IsActive
    FROM tmpAll
    UNION ALL
    SELECT --���������� �� �����
        zc_Container_Summ()
      , zc_Movement_Send()  
      , inMovementId
      , tmpSumm.MovementItemId
      , tmpSumm.Container_SummId
      , vbAccountId
      , -Summ
      , OperDate
      ,IsActive
    FROM tmpSumm;
    
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Send()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 29.07.15                                                                     * 
*/
