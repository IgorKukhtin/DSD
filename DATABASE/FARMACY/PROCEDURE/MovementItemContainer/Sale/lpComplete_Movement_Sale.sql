DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inMovementItemId    Integer  , -- ���� ������ ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbSaleDate TDateTime;
   DECLARE vbIsDeferred Boolean;
BEGIN

    -- �������
    vbIsDeferred := COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE);

    IF vbIsDeferred = FALSE AND COALESCE (inMovementItemId, 0) <> 0
    THEN
       RAISE EXCEPTION '������. ��������� ���������� ��������� ������ ��� ���������� ������.';
    END IF;

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
        HeldBy AS(-- ��� ���������
                   SELECT MovementItemContainer.MovementItemId   AS MovementItemId
                        , SUM(- MovementItemContainer.Amount)      AS Amount
                   FROM MovementItemContainer
                   WHERE MovementItemContainer.MovementId = inMovementId
                   GROUP BY MovementItemContainer.MovementItemId
                  ),
        Sale AS( -- ������ ��������� �������
                    SELECT
                        MovementItem.Id                                as MovementItemId
                       ,MovementItem.ObjectId                          as ObjectId
                       ,MovementItem.Amount - COALESCE(HeldBy.Amount,0)as Amount
                    FROM MovementItem
                         LEFT OUTER JOIN HeldBy AS HeldBy
                                                ON MovementItem.Id = HeldBy.MovementItemId
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND (COALESCE(MovementItem.Amount,0) - COALESCE(HeldBy.Amount,0)) > 0
                      AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
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
                          -- , Container_Summ.Id AS Container_SummId
                          , DD.MovementItemId
                          , DD.ObjectId
			              , CASE
                              WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount
                              ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , /*CASE
                              WHEN DD.Amount - DD.SUM > 0 THEN Container_Summ.Amount
                              ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END*/ 0 AS Summ
                          , TRUE AS IsActive
                        FROM DD
                            -- !!!�������� �.�. ������ � ����������!!!
                            /*LEFT OUTER JOIN Container AS Container_Summ
                                                      ON Container_Summ.ParentId = DD.Id
                                                     AND Container_Summ.DescId = zc_Container_Summ()*/
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
    /*UNION ALL
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
    FROM tmpItem*/
    ;

      -- �������� ���� ��������� ���������� ������ � ������������� ���������� "To"
    IF EXISTS(SELECT 1 FROM Container WHERE Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                       WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_Count()
                                                                         AND _tmpMIContainer_insert.Amount > 0.0))
    THEN

      WITH DD AS (
         SELECT
            ROW_NUMBER()OVER(PARTITION BY Container.ParentId ORDER BY Container.Id DESC) as ORD
          , _tmpMIContainer_insert.MovementItemId
          , _tmpMIContainer_insert.Amount
          , Container.Amount AS ContainerAmount
          , vbSendDate       AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id)
          FROM Container
               JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
                                          AND _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
          WHERE Container.DescId              = zc_Container_CountPartionDate()
            AND _tmpMIContainer_insert.Amount > 0.0
         )

       , tmpItem AS (SELECT ContainerId     AS Id
                          , MovementItemId  AS MovementItemId
                          , OperDate
                          , Amount
                       FROM DD
                       WHERE ORD = 1)

        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT
                 zc_MIContainer_CountPartionDate()
               , zc_Movement_Sale()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.Id
               , Null
               , Amount
               , OperDate
            FROM tmpItem;
    END IF;

    PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    IF vbIsDeferred = FALSE
    THEN
      -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_Sale()
                                 , inUserId     := inUserId
                                  );
    END IF;

    --����������� ����� �� ��������� (��� ����� �������, ������� ��������� ����� ���������� ���������)
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSaleExactly (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.  ������ �.�.
 01.08.19                                                                                   *
 13.10.15                                                                     *
*/