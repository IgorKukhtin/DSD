-- Function: lpComplete_Movement_Inventory (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbTmp Integer;
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbInventoryDate TDateTime;
   DECLARE vbFullInvent Boolean;
   DECLARE vbTechnicalRediscount Boolean;
BEGIN

--raise notice 'Value 0: %', CLOCK_TIMESTAMP();

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

   vbAccountId := lpInsertFind_Object_Account (inAccountGroupId := zc_Enum_AccountGroup_20000()         -- ������
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- C����
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId);

    SELECT date_trunc ('day', Movement.OperDate)
         , COALESCE(MovementBoolean_FullInvent.ValueData,False)
         , MLO_Unit.ObjectId
         , ObjectLink_Unit_Juridical.ChildObjectId 
         , COALESCE(MovementTR.Id, 0) <> 0
    INTO vbInventoryDate, vbFullInvent, vbUnitId, vbJuridicalId, vbTechnicalRediscount
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_FullInvent
                                  ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                 AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
        LEFT JOIN MovementLinkObject AS MLO_Unit
                                     ON MLO_Unit.MovementId = Movement.Id
                                    AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MLO_Unit.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                  
        LEFT JOIN Movement AS MovementTR 
                           ON MovementTR.Id = Movement.ParentId
                          AND MovementTR.DescId = zc_Movement_TechnicalRediscount()

    WHERE Movement.Id = inMovementId;

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    --�������� � �������� ������, ������� ���� �� �������, �� ��� � ���������
    IF vbFullInvent = TRUE
    THEN
        PERFORM
          lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_isAuto(),
                                             lpInsertUpdate_MovementItem_Inventory(ioId := 0
                                                                                 , inMovementId := inMovementId
                                                                                 , inGoodsId := Saldo.ObjectId
                                                                                 , inAmount := 0
                                                                                 , inPrice := COALESCE (Object_Price.Price, 0)
                                                                                 , inSumm := 0
                                                                                 , inComment := ''
                                                                                 , inUserId := inUserId
                                                                                 ),
                                             True
                                            )
        FROM (SELECT T0.ObjectId     AS ObjectId
                   , SUM (T0.Amount) AS Amount

              FROM (SELECT Container.Id
                         , Container.ObjectId --�����
                         , Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) as Amount  --���. ������� - �������� ����� ���� ���������
                    FROM Container
                         JOIN containerlinkObject AS CLI_Unit ON CLI_Unit.containerid = Container.Id
                                                             AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                             AND CLI_Unit.ObjectId = vbUnitId
                         LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                               -- AND date_trunc('day', MovementItemContainer.Operdate) > vbInventoryDate
                                                               AND MovementItemContainer.Operdate >= vbInventoryDate + INTERVAL '1 DAY'
                    WHERE Container.DescID = zc_Container_Count()
                    GROUP BY Container.Id
                           , Container.ObjectId
                    HAVING Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0) <> 0
                   ) AS T0
              GROUP By T0.ObjectId
             ) AS Saldo
             LEFT OUTER JOIN MovementItem AS MovementItem_Inventory
                                          ON MovementItem_Inventory.ObjectId   = Saldo.ObjectId
                                         AND MovementItem_Inventory.MovementId = inMovementId
                                         AND MovementItem_Inventory.DescId     = zc_MI_Master()
                                         AND MovementItem_Inventory.isErased   = FALSE
             LEFT OUTER JOIN (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                                        ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                       AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                                         ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             ) AS Object_Price ON Object_Price.GoodsId = Saldo.ObjectId

        WHERE Saldo.Amount <> 0 -- !!!26.02.2018 - ������� ��� ���� ���� � �������!!!
          AND MovementItem_Inventory.Id IS NULL
       ;
    END IF;

--raise notice 'Value 2: %', CLOCK_TIMESTAMP();

    IF vbTechnicalRediscount = TRUE -- AND False
    THEN 
    
      -- IF inUserId <> 3 THEN RAISE EXCEPTION '�������� ����� ���������� ������.'; END IF;

      WITH -- ����. ������� �� ����� vbInventoryDate (�.�. ����� ���� ���������)
          tmpGoods AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.IsErased = FALSE
                      )
         , tmpContainer AS (SELECT Container.Id
                               , Container.ParentId
                               , Container.DescId
                               , Container.ObjectId -- �����
                               , (Container.Amount - COALESCE (SUM (MovementItemContainer.amount), 0.0)) :: TFloat AS Amount
                          FROM tmpGoods
                          
                               INNER JOIN Container ON Container.DescId in (zc_Container_Count(), zc_Container_CountPartionDate())
                                                   AND Container.WhereObjectId = vbUnitId 
                                                   AND Container.ObjectId = tmpGoods.GoodsId

                               LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                              AND MovementItemContainer.Operdate >= vbInventoryDate + INTERVAL '1 DAY'

                          GROUP BY Container.Id
                                 , Container.ParentId
                                 , Container.DescId
                                 , Container.Amount
                                 , Container.ObjectId
                         )
         , tmpContainerPD AS (SELECT Container.ParentId
                                   , Min(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
                              FROM tmpContainer AS Container 
                                                       
                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ID
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                   LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                        ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                                       AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                       
                              WHERE Container.DescId = zc_Container_CountPartionDate() 
                                AND Container.Amount > 0
                              GROUP BY Container.ParentId
                             )
         , tmpRemains AS (SELECT Container.Id
                               , Container.ObjectId -- �����
                               , Container.Amount
                               , COALESCE(MIFloat_MovementItem.ValueData :: Integer, Object_PartionMovementItem.ObjectCode) AS MovementItemId
                          FROM tmpContainer AS Container
                          
                               JOIN containerlinkObject AS CLI_MI
                                                        ON CLI_MI.containerid = Container.Id
                                                       AND CLI_MI.descid     = zc_ContainerLinkObject_PartionMovementItem()
                               JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                               -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                           ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                                          
                          WHERE Container.DescId = zc_Container_Count() 
                         )
        -- ���������� ��������� + ���������� �������
      , tmpDiffRemains AS (SELECT MovementItem.Id       AS Id
                                , MovementItem.ObjectId AS ObjectId
                                , COALESCE (MovementItem.Amount, 0.0) - COALESCE (Saldo.Amount, 0.0) AS Amount
                                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), MovementItem.Id, COALESCE (Saldo.Amount, 0.0))
                           FROM MovementItem
                                LEFT OUTER JOIN (SELECT T0.ObjectId, SUM (T0.Amount) as Amount FROM tmpRemains AS T0 GROUP BY ObjectId
                                                ) AS Saldo ON Saldo.ObjectId = MovementItem.ObjectId
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.IsErased = FALSE
                          )
        -- ������� � ������� = ��������(����) - ������ : (-)���������, (+)�������
      , DiffRemains AS (SELECT MovementItem.Id       AS MovementItemId
                             , MovementItem.ObjectId AS ObjectId
                             , MovementItem.Amount
                        FROM tmpDiffRemains AS MovementItem
                        WHERE MovementItem.Amount <> 0
                       )
       , DD AS (-- ��� "���������" - ����� ������
           SELECT
              DiffRemains.MovementItemId
            , DiffRemains.Amount
            , Container.Amount AS ContainerAmount
            , vbInventoryDate  AS OperDate
            , Container.Id     AS ContainerId
            , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId 
                                           ORDER BY CASE WHEN COALESCE (tmpContainerPD.ExpirationDate, zc_DateEnd()) < COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                                         THEN COALESCE (tmpContainerPD.ExpirationDate, zc_DateEnd()) 
                                                         ELSE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) END, Container.Id)
            FROM tmpRemains AS Container
            
                 JOIN DiffRemains ON DiffRemains.ObjectId = Container.ObjectId
                 
                 LEFT JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.Id

                 LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                            ON MIDate_ExpirationDate.MovementItemId = Container.MovementItemId
                                           AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

            WHERE Container.Amount > 0.0
              AND DiffRemains.Amount < 0.0
           )

         , tmpItem AS (--
               SELECT ContainerId     AS Id
                    , MovementItemId  AS MovementItemId
                , OperDate
                , CASE WHEN -Amount - SUM > 0.0 THEN ContainerAmount
                                   ELSE -Amount - SUM + ContainerAmount
                              END AS Amount
                       FROM DD
                       WHERE (Amount < 0 AND -Amount - (SUM - ContainerAmount) >= 0)
                      UNION ALL
                       -- ��� "��������" - �������� ������
                       SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Count(), -- DescId �������
                                                      inParentId          := NULL               , -- ������� Container
                                                      inObjectId          := DiffRemains.ObjectId, -- ������ (���� ��� ����� ��� ...)
                                                      inJuridicalId_basis := vbJuridicalId, -- ������� ����������� ����
                                                      inBusinessId        := NULL, -- �������
                                                      inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                                                      inObjectCostId      := NULL,
                                                      inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                                                      inObjectId_1        := vbUnitId,
                                                      inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId ��� 2-�� ���������
                                                      inObjectId_2        := lpInsertFind_Object_PartionMovementItem (DiffRemains.MovementItemId)
                                                     ) AS Id
                            , DiffRemains.MovementItemId AS MovementItemId
                            , vbInventoryDate            AS OperDate
                            , -1 * DiffRemains.Amount
                       FROM DiffRemains
                       WHERE Amount > 0)


      INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
           SELECT
                  zc_Container_Count()
                , zc_Movement_Inventory()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.Id
                , vbAccountId
                , -Amount
                , OperDate
             FROM tmpItem;

    ELSE
      
      WITH -- ����. ������� �� ����� vbInventoryDate (�.�. ����� ���� ���������)
           tmpRemains AS (SELECT Container.Id
                               , Container.ObjectId -- �����
                               , (Container.Amount - COALESCE (SUM (MovementItemContainer.amount), 0.0)) :: TFloat AS Amount
                          FROM Container
                               INNER JOIN containerlinkObject AS CLI_Unit ON CLI_Unit.containerid = Container.Id
                                                                         AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                         AND CLI_Unit.ObjectId = vbUnitId
                               LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                    AND MovementItemContainer.Operdate >= vbInventoryDate + INTERVAL '1 DAY'
                          WHERE Container.DescId = zc_Container_Count()
                          GROUP BY Container.Id
                                 , Container.Amount
                                 , Container.ObjectId
                         )
        -- ���������� ��������� + ���������� �������
      , tmpDiffRemains AS (SELECT MovementItem.Id       AS Id
                                , MovementItem.ObjectId AS ObjectId
                                , COALESCE (MovementItem.Amount, 0.0) - COALESCE (Saldo.Amount, 0.0) AS Amount
                                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), MovementItem.Id, COALESCE (Saldo.Amount, 0.0))
                           FROM MovementItem
                                LEFT OUTER JOIN (SELECT T0.ObjectId, SUM (T0.Amount) as Amount FROM tmpRemains AS T0 GROUP BY ObjectId
                                                ) AS Saldo ON Saldo.ObjectId = MovementItem.ObjectId
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.IsErased = FALSE
                          )
        -- ������� � ������� = ��������(����) - ������ : (-)���������, (+)�������
      , DiffRemains AS (SELECT MovementItem.Id       AS MovementItemId
                             , MovementItem.ObjectId AS ObjectId
                             , MovementItem.Amount
                        FROM tmpDiffRemains AS MovementItem
                        WHERE MovementItem.Amount <> 0
                       )
       , DD AS (-- ��� "���������" - ����� ������
           SELECT
              DiffRemains.MovementItemId
            , DiffRemains.Amount
            , Container.Amount AS ContainerAmount
            , vbInventoryDate  AS OperDate
            , Container.Id     AS ContainerId
            , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId ORDER BY Movement.OperDate, Container.Id)
            FROM tmpRemains AS Container
                 JOIN DiffRemains ON DiffRemains.ObjectId = Container.ObjectId
                 JOIN containerlinkObject AS CLI_MI
                                          ON CLI_MI.containerid = Container.Id
                                         AND CLI_MI.descid     = zc_ContainerLinkObject_PartionMovementItem()
                 JOIN containerlinkObject AS CLI_Unit
                                  ON CLI_Unit.containerid = Container.Id
                                         AND CLI_Unit.descid      = zc_ContainerLinkObject_Unit()
                                         AND CLI_Unit.ObjectId    = vbUnitId
                 JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                 -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                 LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                             ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                            AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                 -- ������ �������
                 JOIN MovementItem ON MovementItem.Id = COALESCE(MIFloat_MovementItem.ValueData :: Integer, Object_PartionMovementItem.ObjectCode)
                 JOIN Movement ON Movement.Id = MovementItem.MovementId

            WHERE Container.Amount > 0.0
              AND DiffRemains.Amount < 0.0
           )

         , tmpItem AS (--
               SELECT ContainerId     AS Id
                    , MovementItemId  AS MovementItemId
                , OperDate
                , CASE WHEN -Amount - SUM > 0.0 THEN ContainerAmount
                                   ELSE -Amount - SUM + ContainerAmount
                              END AS Amount
                       FROM DD
                       WHERE (Amount < 0 AND -Amount - (SUM - ContainerAmount) >= 0)
                      UNION ALL
                       -- ��� "��������" - �������� ������
                       SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Count(), -- DescId �������
                                                      inParentId          := NULL               , -- ������� Container
                                                      inObjectId          := DiffRemains.ObjectId, -- ������ (���� ��� ����� ��� ...)
                                                      inJuridicalId_basis := vbJuridicalId, -- ������� ����������� ����
                                                      inBusinessId        := NULL, -- �������
                                                      inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                                                      inObjectCostId      := NULL,
                                                      inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                                                      inObjectId_1        := vbUnitId,
                                                      inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId ��� 2-�� ���������
                                                      inObjectId_2        := lpInsertFind_Object_PartionMovementItem (DiffRemains.MovementItemId)
                                                     ) AS Id
                            , DiffRemains.MovementItemId AS MovementItemId
                            , vbInventoryDate            AS OperDate
                            , -1 * DiffRemains.Amount
                       FROM DiffRemains
                       WHERE Amount > 0)


      INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
           SELECT
                  zc_Container_Count()
                , zc_Movement_Inventory()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.Id
                , vbAccountId
                , -Amount
                , OperDate
             FROM tmpItem;
             
    END IF;
           
    ANALYSE _tmpMIContainer_insert;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

      -- �������� ���� ��������� ���������� ������
    IF EXISTS(SELECT 1 FROM Container WHERE Container.WhereObjectId = vbUnitId
                                        AND Container.DescId = zc_Container_CountPartionDate()
                                        AND Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert))
    THEN

      WITH DD AS (
         SELECT
            _tmpMIContainer_insert.MovementItemId
          , _tmpMIContainer_insert.Amount
          , Container.Amount AS ContainerAmount
          , vbInventoryDate  AS OperDate
          , Container.Id     AS ContainerId
          , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY Container.Id)
          FROM Container
               JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.ParentId
          WHERE Container.DescId = zc_Container_CountPartionDate()
            AND Container.Amount > 0.0
            AND _tmpMIContainer_insert.Amount < 0.0
         )

       , tmpItem AS (SELECT ContainerId     AS Id
		                    , MovementItemId  AS MovementItemId
                            , OperDate
			                , CASE WHEN -Amount - SUM > 0.0 THEN ContainerAmount
                                 ELSE -Amount - SUM + ContainerAmount
                                 END AS Amount
                       FROM DD
                       WHERE (Amount < 0 AND -Amount - (SUM - ContainerAmount) >= 0))

        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT
                 zc_Container_CountPartionDate()
               , zc_Movement_Inventory()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.Id
               , Null
               , -Amount
               , OperDate
            FROM tmpItem;
            
        ANALYSE _tmpMIContainer_insert;

    END IF;
    
--raise notice 'Value 4: %', CLOCK_TIMESTAMP();    
    
     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := inUserId
                                 );

--raise notice 'Value 5: %', CLOCK_TIMESTAMP();    

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpMIContainer')
     THEN
         DROP TABLE tmpMIContainer;
     END IF;

     CREATE TEMP TABLE tmpMIContainer ON COMMIT DROP AS (
                      SELECT MIContainer.MovementItemId
                           , MIContainer.ContainerId
                           , Container.ObjectId AS GoodsId
                      FROM MovementItemContainer AS MIContainer
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                                                          AND Object_PartionMovementItem.ObjectCode = MIContainer.MovementItemId
                           INNER JOIN Container ON Container.Id = MIContainer.ContainerId
                      WHERE MIContainer.MovementId = inMovementId
                        AND MIContainer.DescId = zc_MIContainer_Count());
                                        
     ANALYSE tmpMIContainer;
                                        
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContainer')
     THEN
         DROP TABLE tmpContainer;
     END IF;

     CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS (
              WITH tmpMIContainer AS
                     (SELECT MIContainer.MovementItemId
                           , MIContainer.ContainerId
                           , Container.ObjectId AS GoodsId
                      FROM MovementItemContainer AS MIContainer
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                                                          AND Object_PartionMovementItem.ObjectCode = MIContainer.MovementItemId
                           INNER JOIN Container ON Container.Id = MIContainer.ContainerId
                      WHERE MIContainer.MovementId = inMovementId
                        AND MIContainer.DescId = zc_MIContainer_Count()
                     )
                 
                                       SELECT tmpMIContainer.MovementItemId
                                            , Container.ObjectId   AS GoodsId
                                            , Container.ID
                                       FROM tmpMIContainer
                                           
                                            INNER JOIN Container ON Container.ObjectId = tmpMIContainer.GoodsId
                                                                AND Container.DescId = zc_Container_Count()
                                                                AND Container.WhereObjectId = vbUnitId
                                                                AND Container.ID NOT IN (SELECT DISTINCT tmpMIContainer.ContainerID FROM tmpMIContainer)

                                        );
                                        
     ANALYSE tmpContainer;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpContainerAll')
     THEN
         DROP TABLE tmpContainerAll;
     END IF;

     CREATE TEMP TABLE tmpContainerAll ON COMMIT DROP AS (
                                       SELECT Container.MovementItemId
                                            , Container.GoodsId
                                            , vbJuridicalId                                                     AS JuridicalId
                                            , COALESCE (MI_Income_find.Id, MI_Income.Id)                        AS MovementItemId_find
                                            , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)        AS IncomeId
                                            , Movement.OperDate
                                       FROM tmpContainer AS Container
                                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                          ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                            -- ������� �������
                                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                            -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                            -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                            LEFT JOIN Movement ON Movement.Id = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                        );
                                        
     ANALYSE tmpContainerAll;

--raise notice 'Value 6: %', CLOCK_TIMESTAMP();    
    
     -- !!!5.3. ����������� �������� <MovementItemId - ��� ��������� ������ ���� ��������������� - ��������� �������� �������, �� �������� ��� ���� ������� ����� ������� �/�> !!!
     vbTmp:= (WITH tmpContainerNotFind AS (SELECT tmpMIContainer.*
                                           FROM tmpMIContainer
                                               
                                                LEFT JOIN tmpContainerAll ON tmpContainerAll.MovementItemId = tmpMIContainer.MovementItemId
                                                
                                           WHERE COALESCE(tmpContainerAll.MovementItemId, 0) = 0
                                            )
                 , tmpIncomeNotFind AS (SELECT MI.Id AS MovementItemId_find
                                             , tmpMIContainer.MovementItemId
                                             , tmpMIContainer.GoodsId
                                             , ObjectLink_Unit_Juridical.ChildObjectId      AS JuridicalId
                                             , Movement.Id                                  AS IncomeId
                                             , Movement.OperDate
                                        FROM tmpContainerNotFind AS tmpMIContainer
                                             INNER JOIN Movement ON Movement.DescId = zc_Movement_Income() AND Movement.StatusId = zc_Enum_Status_Complete()
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                                   ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                                  -- AND ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId - !!!�����!!!
                                             INNER JOIN MovementItem AS MI
                                                                     ON MI.MovementId = Movement.Id
                                                                    AND MI.DescId = zc_MI_Master()
                                                                    AND MI.isErased = FALSE
                                                                    AND MI.ObjectId = tmpMIContainer.GoodsId
                                                                    AND MI.Amount <> 0
                                       )
                 , tmpIncomeAll AS (SELECT tmpContainerAll.MovementItemId_find
                                         , tmpContainerAll.MovementItemId
                                         , tmpContainerAll.GoodsId
                                         , tmpContainerAll.JuridicalId
                                         , tmpContainerAll.IncomeId
                                         , tmpContainerAll.OperDate
                                    FROM tmpContainerAll
                                    UNION ALL
                                    SELECT tmpIncomeNotFind.MovementItemId_find
                                         , tmpIncomeNotFind.MovementItemId
                                         , tmpIncomeNotFind.GoodsId
                                         , tmpIncomeNotFind.JuridicalId
                                         , tmpIncomeNotFind.IncomeId
                                         , tmpIncomeNotFind.OperDate
                                    FROM tmpIncomeNotFind
                                   )

                 , tmpIncome AS
                     (SELECT *
                      FROM
                        (SELECT tmpIncomeAll.MovementItemId_find
                              , tmpIncomeAll.MovementItemId
                              , tmpIncomeAll.GoodsId
                              , ROW_NUMBER() OVER (PARTITION BY tmpIncomeAll.MovementItemId, tmpIncomeAll.GoodsId
                                                   ORDER BY CASE WHEN tmpIncomeAll.JuridicalId = vbJuridicalId THEN 0 ELSE 1 END
                                                          , CASE WHEN tmpIncomeAll.OperDate >= vbInventoryDate 
                                                                 THEN tmpIncomeAll.OperDate - vbInventoryDate ELSE vbInventoryDate - tmpIncomeAll.OperDate END
                                                          , tmpIncomeAll.OperDate
                                                  ) AS myRow
                         FROM tmpIncomeAll

                        ) AS tmp
                      WHERE tmp.myRow = 1
                     )
              SELECT MAX (CASE WHEN TRUE = lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), tmpIncome.MovementItemId, tmpIncome.MovementItemId_find) THEN 1 ELSE 0 END)
              FROM tmpIncome
             );

--raise notice 'Value 6: %', CLOCK_TIMESTAMP();    

    IF inUserId = zfCalc_UserAdmin()::Integer
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%>', inUserId;
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.  ������ �.�.
 03.06.20                                                                                  * ����� ������� ������ �� ����
 12.06.17         * ���� �� Object_Price_View
 14.03.16                                        * !!!5.3. ����������� �������� <MovementItemId - ��� ��������� ������ ���� ��������������� - ��������� �������� �������, �� �������� ��� ���� ������� ����� ������� �/�> !!!
 03.08.15                                                                  *�������� � �������� ������, ������� ���� �� �������, �� ��� � ���������
 11.02.14                        *
 05.02.14                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ���� ���������
--    IN inUserId            Integer    -- ������������
-- SELECT * FROM lpComplete_Movement_Inventory (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671


--SELECT * FROM lpComplete_Movement_Inventory_ (inMovementId:= 30623284, inUserId:= zfCalc_UserAdmin()::Integer)