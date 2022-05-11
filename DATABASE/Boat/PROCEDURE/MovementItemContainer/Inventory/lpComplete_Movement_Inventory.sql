DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbIsList                   Boolean;
  DECLARE vbUnitId                   Integer;
  DECLARE vbAccountDirectionId       Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId               Integer; -- �������� ���� �� ������������

  DECLARE vbWhereObjectId_Analyzer   Integer; -- ��������� ��� ��������

  DECLARE curItem             RefCursor;
  DECLARE curRemainsCalc      RefCursor;
  DECLARE vbMovementItemId    Integer;
  DECLARE vbContainerId       Integer;
  DECLARE vbGoodsId           Integer;
  DECLARE vbPartionId         Integer;
  DECLARE vbPartNumber        TVarChar;
  DECLARE vbOperCount         TFloat;
  DECLARE vbAmount_remains    TFloat;
  DECLARE vbContainerId_start Integer;
  DECLARE vbPartionId_start   Integer;

BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     DELETE FROM _tmpRemains;


     -- ��������� �� ���������
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.isList, tmp.UnitId
          , tmp.AccountDirectionId
            INTO vbMovementDescId
               , vbOperDate
               , vbIsList
               , vbUnitId
               , vbAccountDirectionId

     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (MovementBoolean_List.Valuedata, FALSE) isList
                , COALESCE (CASE WHEN Object_Unit.DescId = zc_Object_Unit() THEN Object_Unit.Id ELSE 0 END, 0) AS UnitId

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ������
                , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId

           FROM Movement
                LEFT JOIN MovementBoolean AS MovementBoolean_List
                                          ON MovementBoolean_List.MovementId = Movement.Id
                                         AND MovementBoolean_List.DescId     = zc_MovementBoolean_List()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                            AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_Unit.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()
           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Inventory()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- �������� - �������������
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (�� ����)>.';
     END IF;

     -- ������������ - ��������� ��� ��������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId END;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId, PartNumber
                         , OperCount, OperPrice
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- ���������
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.PartNumber
             , tmp.OperCount
             , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (inOperDate:= vbOperDate, inGoodsId:= tmp.GoodsId, inUserId:= inUserId) AS lpGet) AS OperPrice
               -- ��
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                     -- ���� �������
                   , MovementItem.Amount              AS OperCount
                     --
                   , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                     -- �������������� ������
                   , View_InfoMoney.InfoMoneyGroupId
                     -- �������������� ����������
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- ������ ����������
                   , View_InfoMoney.InfoMoneyId

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!��������!!! �������������
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Inventory()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;

     -- �������� -
     IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������.������� ������������ <������>%<%><%>.'
                        , CHR (13)
                        , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId    FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1))
                        ,                         (SELECT _tmpItem.PartNumber FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1)
                         ;
     END IF;

     -- ��������� �������
     INSERT INTO _tmpRemains (ContainerId, GoodsId, PartionId, PartNumber, OperDate, Amount_container, Amount)
        WITH -- ��� ������ �� vbUnitId
             tmpContainer_Count AS (SELECT Container.Id            AS ContainerId
                                         , Container.ObjectId      AS GoodsId
                                         , COALESCE (Container.PartionId, 0)            AS PartionId
                                         , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                                         , Container.Amount AS Amount_container
                                         , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                                    FROM Container
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = Container.Id
                                                                        AND MIContainer.OperDate    > vbOperDate
                                         LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                      ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                                     AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                    WHERE Container.WhereObjectId = vbUnitId
                                      AND Container.DescId        = zc_Container_Count()
                                      AND (Container.ObjectId IN (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem)
                                           OR vbIsList = FALSE)
                                    GROUP BY Container.Id
                                           , Container.ObjectId
                                           , Container.PartionId
                                           , MIString_PartNumber.ValueData
                                    HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                                   )
             -- ����� ���� PartionId - MAX
           , tmpContainer_find AS (SELECT _tmpItem.GoodsId
                                        , _tmpItem.PartNumber
                                        , Object_PartionGoods.MovementItemId AS PartionId
                                        , Object_PartionGoods.OperDate       AS OperDate
                                          -- � �/�
                                        , ROW_NUMBER() OVER (PARTITION BY _tmpItem.GoodsId, _tmpItem.PartNumber ORDER BY COALESCE (Container.Amount, 0) DESC, Object_PartionGoods.OperDate DESC) AS Ord
                                   FROM _tmpItem
                                        LEFT JOIN tmpContainer_Count ON tmpContainer_Count.GoodsId    = _tmpItem.GoodsId
                                                                    AND tmpContainer_Count.PartNumber = _tmpItem.PartNumber
                                        INNER JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = _tmpItem.GoodsId
                                        LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                     ON MIString_PartNumber.MovementItemId = Object_PartionGoods.MovementItemId
                                                                    AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                        -- ���� ���� ������� �� "������" �������������
                                        LEFT JOIN Container ON Container.PartionId = Object_PartionGoods.MovementItemId
                                                           AND Container.Amount > 0
                                   WHERE tmpContainer_Count.GoodsId IS NULL
                                     AND COALESCE (MIString_PartNumber.ValueData, '') = _tmpItem.PartNumber
                                     AND _tmpItem.OperCount > 0
                                  )
            -- ��������� ������� �� ����
            SELECT tmpContainer_Count.ContainerId
                 , tmpContainer_Count.GoodsId
                 , tmpContainer_Count.PartionId
                 , tmpContainer_Count.PartNumber
                 , Object_PartionGoods.OperDate
                 , tmpContainer_Count.Amount_container
                 , tmpContainer_Count.Amount
            FROM tmpContainer_Count
                 LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpContainer_Count.PartionId
           UNION
            -- ������� ������ PartionId, �� ������� = 0
            SELECT 0 AS ContainerId
               , tmpContainer_find.GoodsId
               , tmpContainer_find.PartionId
               , tmpContainer_find.PartNumber
               , tmpContainer_find.OperDate
               , 0 AS Amount_container
               , 0 AS Amount
            FROM tmpContainer_find
           ;

     -- ������1 - ���� �������
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartNumber, _tmpItem.OperCount
                      FROM _tmpItem
                     ;
     -- ������ ����� �� �������1 - ���� �������
     LOOP
         -- ������ - ���� �������
         FETCH curItem INTO vbMovementItemId, vbGoodsId, vbPartNumber, vbOperCount;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ��������
         vbContainerId_start:= 0;
         vbPartionId_start  := 0;

         -- ������2. - ������� ���������
         OPEN curRemainsCalc FOR
            SELECT _tmpRemains.ContainerId, _tmpRemains.PartionId, _tmpRemains.Amount
            FROM _tmpRemains
            WHERE _tmpRemains.GoodsId    = vbGoodsId
              AND _tmpRemains.PartNumber = vbPartNumber
            ORDER BY _tmpRemains.OperDate DESC, _tmpRemains.ContainerId DESC
           ;

             -- ������ ����� �� �������2. - ��������� �������
             LOOP
                 -- ������ - ��������� �������
                 FETCH curRemainsCalc INTO vbContainerId, vbPartionId, vbAmount_remains;
                 -- ���� ������ �����������, ����� �����
                 IF NOT FOUND THEN EXIT; END IF;

                 -- ��������� "������"  ������
                 IF vbPartionId_start = 0
                 THEN
                    vbContainerId_start:= vbContainerId;
                    vbPartionId_start  := vbPartionId;
                 END IF;

                 --
                 IF vbAmount_remains > vbOperCount OR vbAmount_remains < 0
                 THEN
                     -- ��������� ������� - ���� �������
                     INSERT INTO _tmpItem_Child (MovementItemId, ContainerId, ContainerId_summ
                                               , GoodsId, PartionId, PartNumber
                                               , OperCount
                                                )
                        SELECT vbMovementItemId AS MovementItemId
                             , vbContainerId    AS ContainerId
                             , 0                AS ContainerId_summ
                             , vbGoodsId        AS GoodsId
                             , vbPartionId      AS PartionId
                             , vbPartNumber     AS PartNumber
                             , -1 * (vbAmount_remains - CASE WHEN vbAmount_remains > 0 THEN vbOperCount ELSE 0 END) AS OperCount
                              ;
                     --
                     IF vbAmount_remains > 0 THEN vbOperCount:= 0; END IF;
                 ELSE
                     -- ��������� � ������ ������
                     vbOperCount:= vbOperCount - vbAmount_remains;
                 END IF;


             END LOOP; -- ����� ����� �� �������2. - ��������� �������
             CLOSE curRemainsCalc; -- ������� ������2. - ��������� �������

             -- ���� ���� ������ ����������
             IF vbOperCount <> 0
             THEN
                     -- ��������� ������� ���� ����������� - �� "���������" ������ ��� "������"
                     INSERT INTO _tmpItem_Child (MovementItemId, ContainerId, ContainerId_summ
                                               , GoodsId, PartionId, PartNumber
                                               , OperCount
                                                )
                        SELECT vbMovementItemId       AS MovementItemId
                             , vbContainerId_start    AS ContainerId
                             , 0                      AS ContainerId_summ
                             , vbGoodsId              AS GoodsId
                             , vbPartionId_start      AS PartionId
                             , vbPartNumber           AS PartNumber
                             , 1 * vbOperCount        AS OperCount
                              ;
             END IF;

     END LOOP; -- ����� ����� �� �������1 - ���� �������
     CLOSE curItem; -- ������� ������1 - ���� �������


     -- ��������� ��������� ������� - ���� ������� + ������� MovementItemId
     INSERT INTO _tmpItem_Child (MovementItemId, ContainerId, ContainerId_summ
                               , GoodsId, PartionId, PartNumber
                               , OperCount
                                )
        SELECT 0                          AS MovementItemId
             , _tmpRemains.ContainerId    AS ContainerId
             , 0                          AS ContainerId_summ
             , _tmpRemains.GoodsId        AS GoodsId
             , _tmpRemains.PartionId      AS PartionId
             , _tmpRemains.PartNumber     AS PartNumber
             , -1 * _tmpRemains.Amount    AS OperCount
        FROM _tmpRemains
             LEFT JOIN _tmpItem ON _tmpItem.GoodsId    = _tmpRemains.GoodsId
                               AND _tmpItem.PartNumber = _tmpRemains.PartNumber
        WHERE _tmpItem.GoodsId IS NULL
       ;

     -- ������� ��������
     UPDATE _tmpItem_Child SET MovementItemId = tmp.MovementItemId
     FROM (SELECT tmp.GoodsId, tmp.PartNumber
                , (SELECT tmp.ioId
                   FROM lpInsertUpdate_MovementItem_Inventory (ioId              := 0
                                                             , inMovementId      := inMovementId
                                                             , inGoodsId         := tmp.GoodsId
                                                             , ioAmount          := 0
                                                             , inTotalCount      := 0
                                                             , inTotalCount_old  := 0
                                                             , ioPrice           := 0
                                                             , inPartNumber      := tmp.PartNumber
                                                             , inComment         := ''
                                                             , inUserId          := inUserId
                                                              ) AS tmp) AS MovementItemId

           FROM (SELECT DISTINCT _tmpItem_Child.GoodsId, _tmpItem_Child.PartNumber
                 FROM _tmpItem_Child
                 WHERE _tmpItem_Child.MovementItemId = 0
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_Child.MovementItemId = 0
       AND _tmpItem_Child.GoodsId        = tmp.GoodsId
       AND _tmpItem_Child.PartNumber     = tmp.PartNumber
      ;


     -- ���������-2 ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId, PartNumber
                         , OperCount, OperPrice
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- ���������
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.PartNumber
             , tmp.OperCount
             , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (inOperDate:= vbOperDate, inGoodsId:= tmp.GoodsId, inUserId:= inUserId) AS lpGet) AS OperPrice
               -- ��
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                     -- ���� �������
                   , MovementItem.Amount              AS OperCount
                     --
                   , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                     -- �������������� ������
                   , View_InfoMoney.InfoMoneyGroupId
                     -- �������������� ����������
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- ������ ����������
                   , View_InfoMoney.InfoMoneyId

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!��������!!! �������������
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

                   LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = MovementItem.Id

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Inventory()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                AND _tmpItem.MovementItemId IS NULL
             ) AS tmp
            ;

     -- �������� - 2
     IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION '������-2.������� ������������ <�������������>.<%><%>'
                        , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId    FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1))
                        ,                         (SELECT _tmpItem.PartNumber FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1)
                         ;
     END IF;


     -- ������� ������ - ��� ����
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := _tmpItem_Child.MovementItemId        -- ���� ������
                                               , inMovementId        := inMovementId                         -- ���� ���������
                                               , inFromId            := vbUnitId                             -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbUnitId                             -- �������������(�������)
                                               , inOperDate          := vbOperDate                           -- ���� �������
                                               , inObjectId          := _tmpItem_Child.GoodsId               -- ������������� ��� �����
                                               , inAmount            := _tmpItem_Child.OperCount             -- ���-�� ������
                                               , inEKPrice           := _tmpItem.OperPrice                   -- ���� ��. ��� ���, !!!� ������ ������!!!
                                               , inCountForPrice     := 1                                    -- ���� �� ����������
                                               , inEmpfPrice         := 0                                    -- ���� ��������. ��� ���
                                               , inOperPriceList     := 0                                    -- ���� �������
                                               , inOperPriceList_old := 0                                    -- ���� �������, �� ��������� ������
                                               , inTaxKindId         := 0                                    -- ��� ��� (!������������!)
                                               , inTaxKindValue      := 0                                    -- �������� ��� (!������������!)
                                               , inUserId            := inUserId                             --
                                                )
     FROM _tmpItem_Child
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_Child.MovementItemId
     WHERE _tmpItem_Child.PartionId = 0;


     -- �������� ������
     UPDATE _tmpItem_Child SET PartionId = _tmpItem_Child.MovementItemId WHERE _tmpItem_Child.PartionId = 0;


     -- 1. ������������ ContainerId ��� ��������������� ����� - ��� ����
     UPDATE _tmpItem_Child SET ContainerId = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                , inPartionId              := _tmpItem_Child.PartionId
                                                                                , inIsReserve              := FALSE
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId    = _tmpItem_Child.MovementItemId
       AND _tmpItem_Child.ContainerId = 0
    ;

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem_Child SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
          JOIN _tmpItem ON _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpItem_Child.MovementItemId = _tmpItem.MovementItemId
    ;



     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpItem_Child SET ContainerId_summ = CASE WHEN Container.Id > 0
                                                            THEN Container.Id
                                                       ELSE lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                              , inUnitId                 := vbUnitId
                                                                                              , inMemberId               := NULL
                                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                              , inBusinessId             := vbBusinessId
                                                                                              , inAccountId              := _tmpItem_Child.AccountId
                                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                              , inContainerId_Goods      := _tmpItem_Child.ContainerId
                                                                                              , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                              , inPartionId              := _tmpItem_Child.PartionId
                                                                                              , inIsReserve              := FALSE
                                                                                               )
                                                  END

                           , ContainerId_ProfitLoss = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId �������� ����
                                                                            , inParentId          := NULL                     -- ������� Container
                                                                            , inObjectId          := zc_Enum_Account_90301()  -- ������ ������ ���� ��� �������� ����
                                                                            , inPartionId         := NULL
                                                                            , inIsReserve         := FALSE
                                                                            , inJuridicalId_basis := vbJuridicalId_Basis      -- ������� ����������� ����
                                                                            , inBusinessId        := vbBusinessId             -- �������
                                                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId ��� 1-�� ���������
                                                                            , inObjectId_1        := zc_Enum_Account_90301()  -- ��������, ���� ����� ����� ������������ lpInsertFind_Object_ProfitLoss
                                                                             )

                             , OperSumm = CASE WHEN -- ���� ������� �������
                                                    _tmpRemains.Amount_container = -1 * _tmpItem_Child_find.OperCount
                                                    THEN -- ������ ����� �������
                                                         -1 * COALESCE (Container.Amount, 0)
                                               -- ����� ������ �� ������
                                               ELSE _tmpItem_Child_find.OperCount * Object_PartionGoods.EKPrice
                                          END
     FROM _tmpItem_Child AS _tmpItem_Child_find
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_Child_find.MovementItemId
          LEFT JOIN _tmpRemains ON _tmpRemains.ContainerId = _tmpItem_Child_find.ContainerId
          LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child_find.PartionId
          LEFT JOIN Container ON Container.ParentId = _tmpItem_Child_find.ContainerId
                             AND Container.DescId   = zc_Container_Summ()
     WHERE _tmpItem_Child_find.ContainerId = _tmpItem_Child.ContainerId
    ;



     -- 3.1. ����������� �������� - ������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ��������� ������� ���-��
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����� �����
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- ���� - ������������� - �������
            , _tmpItem_Child.ContainerId_ProfitLoss   AS ContainerId_Analyzer   -- ��������� - ������������� - �������
            , 0                                       AS ContainerExtId_Analyzer-- ��� - ��������� - �������������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , 0                                       AS ObjectExtId_Analyzer   -- ������������� ����������
            , 1 * _tmpItem_Child.OperCount            AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      ;


     -- 3.2. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����� �����
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- ���� - ������������� - �������
            , _tmpItem_Child.ContainerId_ProfitLoss   AS ContainerId_Analyzer   -- ��������� - ������������� - �������
            , 0                                       AS ContainerExtId_Analyzer-- ��� - ��������� - �������������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , 0                                       AS ObjectExtId_Analyzer   -- ������������� ����������
            , _tmpItem_Child.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child

      UNION ALL
       -- �������� - ����
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_ProfitLoss
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����� �����
            , 0                                       AS AccountId_Analyzer     -- � ���� �� �����
            , 0                                       AS ContainerId_Analyzer   -- � ���� �� �����
            , 0                                       AS ContainerExtId_Analyzer-- ��� - ��������� - �������������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , 0                                       AS ObjectExtId_Analyzer   -- ������������� ����������
            , -1 * _tmpItem_Child.OperSumm            AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      ;


     -- 5.0. ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), _tmpItem.MovementItemId, COALESCE (_tmpItem.OperPrice, 0))
     FROM _tmpItem;

     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := inUserId
                                 );

   /* RAISE EXCEPTION '������. <%>  <%>  <%>  <%>', (select count() from _tmpItem  where _tmpItem.MovementItemId = 56225)
                  , (select count() from _tmpItem_Child  where _tmpItem_Child.MovementItemId = 56225)
                  , (select count() from _tmpRemains  where _tmpRemains.GoodsId = 14982)
                  , (select count() from _tmpMIContainer_insert)
                                       ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 25.04.17         *
*/

-- ����
-- select * from lpComplete_Movement_Inventory (inMovementId:= 604, inUserId:= '5');
