DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbUnitId_From              Integer;
  DECLARE vbUnitId_To                Integer;
  DECLARE vbAccountDirectionId_From  Integer;
  DECLARE vbAccountDirectionId_To    Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId               Integer; -- �������� ���� �� ������������

  DECLARE vbWhereObjectId_Analyzer_From Integer; -- ��������� ��� ��������
  DECLARE vbWhereObjectId_Analyzer_To   Integer; -- ��������� ��� ��������

  DECLARE curReserveDiff     RefCursor;
  DECLARE curItem            RefCursor;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbMovementId_order Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbPartionId        Integer;
  DECLARE vbAmount           TFloat;
  DECLARE vbAmount_Reserve   TFloat;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     -- !!!�����������!!! �������� ������� - ������� �������� ��������������� ��� ������� �������
     DELETE FROM _tmpReserveDiff;
     -- !!!�����������!!! �������� ������ ��� ������� �������
     DELETE FROM _tmpReserveRes;


     -- ��������� �� ���������
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.UnitId_From, tmp.UnitId_To
          , tmp.AccountDirectionId_From, tmp.AccountDirectionId_To
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId_From
               , vbUnitId_To
               , vbAccountDirectionId_From
               , vbAccountDirectionId_To
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit() THEN Object_To.Id   ELSE 0 END, 0) AS UnitId_To

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ������
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From
                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ������
                , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100())   AS AccountDirectionId_To

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- �������� - �������������
     IF COALESCE (vbUnitId_From, 0) = COALESCE (vbUnitId_To, 0)
     THEN
         RAISE EXCEPTION '������. �������� <������������� (�� ����)> ������ ���������� �� <������������� (����)>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (vbUnitId_From, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (�� ����)>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (vbUnitId_To, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (����)>.';
     END IF;

     -- ������������ - ��������� ��� ��������
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;
     vbWhereObjectId_Analyzer_To  := CASE WHEN vbUnitId_To   <> 0 THEN vbUnitId_To   END;



     -- ��������� ������� - �������� zc_MI_Child ���������
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , OperCount
                               , MovementId_order
                                )
        SELECT MovementItem.Id, MovementItem.ParentId
             , MovementItem_parent.ObjectId
             , MovementItem.PartionId
             , MovementItem.Amount
             , MIFloat_MovementId.ValueData AS MovementId_order
        FROM MovementItem
             INNER JOIN MovementItem AS MovementItem_parent
                                     ON MovementItem_parent.MovementId = MovementItem.MovementId
                                    AND MovementItem_parent.DescId     = zc_MI_Master()
                                    AND MovementItem_parent.Id         = MovementItem.ParentId
                                    AND MovementItem_parent.isErased   = FALSE
             INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
             -- ValueData - MovementId ����� �������
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
       ;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId
                         , OperCount
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- ���������
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.OperCount
               -- ��
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.Amount              AS OperCount
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

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!��������!!! �������������
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Send()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- �������� - zc_MI_Master + zc_MI_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.OperCount) AS OperCount
                                FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                               ) AS tmpItem_Child ON tmpItem_Child.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.OperCount, 0) < COALESCE (tmpItem_Child.OperCount, 0)
               )
     THEN
         RAISE EXCEPTION '������.���-�� � ������� �� ����� ���� ������ ��� � ���������.';
     END IF;

     -- 1.��������� ������� - ������� �������� ����������� �� �������� ��� ������� �������
     INSERT INTO _tmpReserveDiff (MovementId_order, OperDate_order, GoodsId, PartionId, Amount)
        WITH -- ������ �� ���� �������������
             tmpGoods AS (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem)
             -- ��� �������
           , tmpMI_Child AS (-- ������ ������� - zc_MI_Child - ����������� �� ��������
                             SELECT Movement.OperDate       AS OperDate_order
                                  , MovementItem.MovementId AS MovementId_order
                                  , MovementItem.ObjectId
                                  , MovementItem.PartionId
                                    -- ���-�� - ������ � ������
                                  , MovementItem.Amount
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Child()
                                                         AND MovementItem.isErased   = FALSE
                                                         -- �������� �������, ���� ��� ����� � ���
                                                         --AND MovementItem.ParentId > 0
                                  -- �� ������ ������ - zc_MI_Master �� ������
                                  INNER JOIN MovementItem AS MI_Master
                                                          ON MI_Master.MovementId = Movement.Id
                                                         AND MI_Master.DescId     = zc_MI_Child() -- !!!�� ������!!!
                                                         AND MI_Master.Id         = MovementItem.ParentId
                                                         AND MI_Master.isErased   = FALSE
                                  -- ����������� - ������ �� ���� �������������
                                  INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                  -- ����������� - ������ ��� ����� ������
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                                   AND MILinkObject_Unit.ObjectId       = vbUnitId_From
                             WHERE Movement.DescId   = zc_Movement_OrderClient()
                               -- ��� �� ���������
                               AND Movement.StatusId <> zc_Enum_Status_Erased()
                               -- ���-�� - ������ � ������
                               AND MovementItem.Amount > 0

                            -- ������� �� ���������� - zc_MI_Child - ����������� �� ��������
                            UNION ALL
                             SELECT Movement_OrderClient.OperDate AS OperDate_order
                                  , Movement_OrderClient.Id       AS MovementId_order
                                  , MovementItem.ObjectId
                                  , MovementItem.PartionId
                                    -- ���-�� - ������ � ������
                                  , MovementItem.Amount
                             FROM Movement
                                  -- ����������� - ������ ������ �� ���� �����
                                  INNER JOIN MovementLinkObject AS MLO_To
                                                                ON MLO_To.MovementId = Movement.Id
                                                               AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                               AND MLO_To.ObjectId   = vbUnitId_From
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Child()
                                                         AND MovementItem.isErased   = FALSE
                                  -- zc_MI_Master �� ������
                                  INNER JOIN MovementItem AS MI_Master
                                                          ON MI_Master.MovementId = Movement.Id
                                                         AND MI_Master.DescId     = zc_MI_Master()
                                                         AND MI_Master.Id         = MovementItem.ParentId
                                                         AND MI_Master.isErased   = FALSE
                                  -- ����������� - ������ �� ���� �������������
                                  INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                  -- ValueData - MovementId ����� �������
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                              ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                             AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                  LEFT JOIN Movement Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer
                             WHERE Movement.DescId   = zc_Movement_Income()
                               -- �����������
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                            )
              -- ����������� - ������� ��� ����������� �������� ��� ����� �������
            , tmpMI_Send AS (SELECT MovementItem.MovementId
                                  , MovementItem.ObjectId
                                  , MovementItem.PartionId
                                    -- ������� �����������
                                  , MovementItem.Amount
                                    -- ����� �������
                                  , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                             FROM MovementItemFloat AS MIFloat_MovementId
                                  INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                         AND MovementItem.DescId   = zc_MI_Child()
                                                         AND MovementItem.isErased = FALSE
                                  -- ��� ����� �����������
                                  INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     AND Movement.DescId   = zc_Movement_Send()
                                                     -- ��� �� ���������
                                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                   --AND Movement.StatusId = zc_Enum_Status_Complete()
                                 -- zc_MI_Master �� ������
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                             WHERE MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMI_Child.MovementId_order FROM tmpMI_Child)
                               AND MIFloat_MovementId.DescId   = zc_MIFloat_MovementId()
                            )
        -- ������� �������� ����������� ��� ������� �������
        SELECT tmpMI_Child.MovementId_order
             , tmpMI_Child.OperDate_order
             , tmpMI_Child.ObjectId
             , tmpMI_Child.PartionId
               -- ��������
             , tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) AS Amount

        FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.OperDate_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId, SUM (tmpMI_Child.Amount) AS Amount
              FROM tmpMI_Child
              GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.OperDate_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId
             ) AS tmpMI_Child
             -- ����� ������� �����������
             LEFT JOIN (SELECT tmpMI_Send.MovementId_order
                             , tmpMI_Send.ObjectId
                             , tmpMI_Send.PartionId
                             , SUM (tmpMI_Send.Amount) AS Amount
                        FROM tmpMI_Send
                        -- !!!� ������� ������������
                        --WHERE tmpMI_Send.MovementId <> inMovementId
                        GROUP BY tmpMI_Send.MovementId_order
                               , tmpMI_Send.ObjectId
                               , tmpMI_Send.PartionId
                       ) AS tmpMI_Send
                         ON tmpMI_Send.MovementId_order = tmpMI_Child.MovementId_order
                        AND tmpMI_Send.PartionId        = tmpMI_Child.PartionId
        -- !! �������� ��� ����������!!!
        WHERE tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) > 0
        ;


     -- 2.��������� ������� - �������� ���������� ������ ��� ������� �������

     -- ������1 - �������� �����������
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId
                             -- ����������� - ������� ������ �������� �����
                           , _tmpItem.OperCount- COALESCE (tmpItem_Child.OperCount, 0) AS Amount
                      FROM _tmpItem
                           -- ��� �������������� ����������� ������, �� ���� �������
                           LEFT JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.OperCount) AS OperCount
                                      FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                                     ) AS tmpItem_Child ON tmpItem_Child.ParentId = _tmpItem.MovementItemId
                     ;
     -- ������ ����� �� �������1 - �������
     LOOP
     -- ������ �� ��������
     FETCH curItem INTO vbMovementItemId, vbGoodsId, vbAmount;
     -- ���� ������ �����������, ����� �����
     IF NOT FOUND THEN EXIT; END IF;

     -- ������2. - �������� ��������������� ����� ������� ��� �������������� ��� vbGoodsId
     OPEN curReserveDiff FOR
        SELECT _tmpReserveDiff.MovementId_order, _tmpReserveDiff.PartionId, _tmpReserveDiff.Amount - COALESCE (tmp.Amount, 0)
        FROM _tmpReserveDiff
             LEFT JOIN (SELECT _tmpReserveRes.MovementId_order, _tmpReserveRes.GoodsId, _tmpReserveRes.PartionId, SUM (_tmpReserveRes.Amount) AS Amount FROM _tmpReserveRes GROUP BY _tmpReserveRes.MovementId_order, _tmpReserveRes.GoodsId, _tmpReserveRes.PartionId
                       ) AS tmp ON tmp.MovementId_order = _tmpReserveDiff.MovementId_order
                               AND tmp.GoodsId          = _tmpReserveDiff.GoodsId
                               AND tmp.PartionId        = _tmpReserveDiff.PartionId
        WHERE _tmpReserveDiff.GoodsId = vbGoodsId
          AND _tmpReserveDiff.Amount - COALESCE (tmp.Amount, 0) > 0
        ORDER BY _tmpReserveDiff.OperDate_order ASC
       ;
         -- ������ ����� �� �������2. - �������
         LOOP
             -- ������ - ������� �������� ���������������
             FETCH curReserveDiff INTO vbMovementId_order, vbPartionId, vbAmount_Reserve;
             -- ���� ������ �����������, ��� ��� ���-�� �������������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             --
             IF vbAmount_Reserve > vbAmount
             THEN
                 -- ���������� � zc_MI_Master ������ ��� ���� ������������� - ��������� ������� - �������� ������ ��� ������� �������
                 INSERT INTO _tmpReserveRes (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , ContainerId_SummFrom, ContainerId_GoodsFrom
                                           , ContainerId_SummTo, ContainerId_GoodsTo
                                           , AccountId_From, AccountId_To
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                AS MovementItemId         -- ���������� �����
                         , vbMovementItemId AS ParentId
                         , vbGoodsId        AS GoodsId
                         , vbPartionId      AS PartionId
                         , 0                AS ContainerId_SummFrom   -- ���������� �����
                         , 0                AS ContainerId_GoodsFrom  -- ���������� �����
                         , 0                AS ContainerId_SummTo     -- ���������� �����
                         , 0                AS ContainerId_GoodsTo    -- ���������� �����
                         , 0                AS AccountId_From         -- ����(�����������), ���������� �����
                         , 0                AS AccountId_To           -- ����(�����������), ���������� �����
                         , vbAmount         AS Amount
                         , vbMovementId_order
                          ;
                 -- �������� ���-�� ��� �� ������ �� ������
                 vbAmount:= 0;
             ELSE
                 -- ���������� � zc_MI_Master ������ ��� ���� ������������� - ��������� ������� - �������� ������ ��� ������� �������
                 INSERT INTO _tmpReserveRes (MovementItemId, ParentId
                                           , GoodsId
                                           , PartionId
                                           , ContainerId_SummFrom, ContainerId_GoodsFrom
                                           , ContainerId_SummTo, ContainerId_GoodsTo
                                           , AccountId_From, AccountId_To
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                AS MovementItemId         -- ���������� �����
                         , vbMovementItemId AS ParentId
                         , vbGoodsId        AS GoodsId
                         , vbPartionId      AS PartionId
                         , 0                AS ContainerId_SummFrom   -- ���������� �����
                         , 0                AS ContainerId_GoodsFrom  -- ���������� �����
                         , 0                AS ContainerId_SummTo     -- ���������� �����
                         , 0                AS ContainerId_GoodsTo    -- ���������� �����
                         , 0                AS AccountId_From         -- ����(�����������), ���������� �����
                         , 0                AS AccountId_To           -- ����(�����������), ���������� �����
                         , vbAmount_Reserve AS Amount
                         , vbMovementId_order
                          ;
                 -- ��������� ����������� �� ���-�� ������� ����� � ���������� �����
                 vbAmount:= vbAmount - vbAmount_Reserve;
             END IF;


             -- !!!���� ���� ����� ������ ������, ��� �������!!!
             -- IF vbAmount > 0 THEN
             -- END IF;


         END LOOP; -- ����� ����� �� �������2. - �������
         CLOSE curReserveDiff; -- ������� ������2. - �������


     END LOOP; -- ����� ����� �� �������1 - �������� �������
     CLOSE curItem; -- ������� ������1 - �������� �������


     -- �������� ������, ������� ��� ���� � _tmpItem_Child
     UPDATE _tmpReserveRes SET Amount = _tmpReserveRes.Amount + _tmpItem_Child.OperCount
     FROM _tmpItem_Child
     WHERE _tmpReserveRes.ParentId         = _tmpItem_Child.ParentId
       AND _tmpReserveRes.PartionId        = _tmpItem_Child.PartionId
       AND _tmpReserveRes.MovementId_order = _tmpItem_Child.MovementId_order
       ;

     -- �������� ������, ������� ��� ���� � _tmpItem_Child
     INSERT INTO _tmpReserveRes (MovementItemId, ParentId
                               , GoodsId
                               , PartionId
                               , Amount
                               , MovementId_order
                                )
        SELECT _tmpItem_Child.MovementItemId
             , _tmpItem_Child.ParentId
             , _tmpItem_Child.GoodsId
             , _tmpItem_Child.PartionId
             , _tmpItem_Child.OperCount
             , _tmpItem_Child.MovementId_order
        FROM _tmpItem_Child
             LEFT JOIN _tmpReserveRes ON _tmpReserveRes.ParentId         = _tmpItem_Child.ParentId
                                     AND _tmpReserveRes.PartionId        = _tmpItem_Child.PartionId
                                     AND _tmpReserveRes.MovementId_order = _tmpItem_Child.MovementId_order
        WHERE _tmpReserveRes.PartionId IS NULL
       ;

     -- �������� - ���������� ���-�� zc_MI_Master + _tmpReserveRes
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                               ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION '������.���-�� � ��������� �� ����� ���������� �� ���-�� � ������� <%> <%> <%>.'
                     , (SELECT _tmpItem.OperCount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , (SELECT tmpReserveRes.Amount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
               ;
     END IF;


     -- RAISE EXCEPTION 'test.<%> <%>', (SELECT SUM (_tmpItem.OperCount) FROM _tmpItem), (SELECT SUM (_tmpReserveRes.Amount) FROM _tmpReserveRes);


     -- ��������� - zc_MI_Child - ������� �����������
     UPDATE _tmpReserveRes SET MovementItemId = lpInsertUpdate_MI_Send_Child (ioId                     := _tmpReserveRes.MovementItemId
                                                                            , inParentId               := _tmpReserveRes.ParentId
                                                                            , inMovementId             := inMovementId
                                                                            , inMovementId_OrderClient := _tmpReserveRes.MovementId_order
                                                                            , inObjectId               := _tmpReserveRes.GoodsId
                                                                            , inPartionId              := _tmpReserveRes.PartionId
                                                                              -- ���-�� ������
                                                                            , inAmount                 := _tmpReserveRes.Amount
                                                                            , inUserId                 := inUserId
                                                                             )
     -- !!!��� ��������
     --WHERE _tmpReserveRes.MovementItemId = 0
    ;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpReserveRes SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_From
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                          , inPartionId              := _tmpReserveRes.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
                             , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_To
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                          , inPartionId              := _tmpReserveRes.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
     FROM _tmpItem
     WHERE _tmpReserveRes.ParentId = _tmpItem.MovementItemId
    ;

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpReserveRes SET AccountId_From = _tmpItem_byAccount.AccountId_From
                             , AccountId_To   = _tmpItem_byAccount.AccountId_To
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_From
                , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_To
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
          JOIN _tmpItem ON _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpReserveRes.ParentId = _tmpItem.MovementItemId
    ;


     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpReserveRes SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_From
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpReserveRes.AccountId_From
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpReserveRes.ContainerId_GoodsFrom
                                                                                        , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                        , inPartionId              := _tmpReserveRes.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
                             , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_To
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpReserveRes.AccountId_To
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpReserveRes.ContainerId_GoodsTo
                                                                                        , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                        , inPartionId              := _tmpReserveRes.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
     FROM _tmpItem
     WHERE _tmpReserveRes.ParentId = _tmpItem.MovementItemId
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
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_From           AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpReserveRes.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpReserveRes.AccountId_To             AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpReserveRes.ContainerId_SummTo       AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� ����
            , -1 * _tmpReserveRes.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpReserveRes
      UNION ALL
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_To             AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpReserveRes.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpReserveRes.AccountId_From           AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpReserveRes.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� �� ����
            , 1 * _tmpReserveRes.Amount               AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpReserveRes;


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
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_From           AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpReserveRes.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpReserveRes.AccountId_To             AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpReserveRes.ContainerId_SummTo       AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� ����
            , -1 * CASE WHEN _tmpReserveRes.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpReserveRes.Amount * (Object_PartionGoods.EKPrice + Object_PartionGoods.CostPrice)
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpReserveRes
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpReserveRes.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpReserveRes.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpReserveRes.ContainerId_SummFrom
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_To             AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpReserveRes.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpReserveRes.AccountId_From           AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpReserveRes.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� �� ����
            , 1 * CASE WHEN _tmpReserveRes.Amount = Container_Count.Amount
                            THEN Container_Summ.Amount
                       ELSE _tmpReserveRes.Amount * (Object_PartionGoods.EKPrice + Object_PartionGoods.CostPrice)
                  END                                 AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpReserveRes
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpReserveRes.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpReserveRes.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpReserveRes.ContainerId_SummFrom
      ;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Send()
                                , inUserId     := inUserId
                                 );

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Send (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 589, inSession:= '5');
