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

  DECLARE vbMovementItemId   Integer;
  DECLARE vbMovementId_order Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbPartionId        Integer;
  DECLARE vbPartNumber       TVarChar;
  DECLARE vbAmount           TFloat;
  DECLARE vbAmount_partion   TFloat;

  DECLARE curItem            RefCursor;
  DECLARE curPartion         RefCursor;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     -- !!!�����������!!! �������� ������� - ������� �������� ��������������� ��� ������� �������
     --DELETE FROM _tmpReserveDiff;
     -- !!!�����������!!! �������� ������ ��� ������� �������
     --DELETE FROM _tmpReserveRes;


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


     -- ��������� ������� - �������� ���������
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId
                         , Amount
                         , PartNumber
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , MovementId_order
                          )
        -- ���������
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.Amount
             , tmp.PartNumber
               -- ��
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId
               --
             , tmp.MovementId_order

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.Amount              AS Amount
                     --
                   , MIString_PartNumber.ValueData    AS PartNumber
                     -- �������������� ������
                   , View_InfoMoney.InfoMoneyGroupId
                     -- �������������� ����������
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- ������ ����������
                   , View_InfoMoney.InfoMoneyId

                    -- MovementId ����� �������
                  , COALESCE (MIFloat_MovementId.ValueData, 0) AS MovementId_order

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   -- ValueData - MovementId ����� �������
                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                               ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

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




     -- 2.��������� ������� - �������� �� �������

     -- ������1 - �������� ���������
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartNumber, _tmpItem.MovementId_order
                           , _tmpItem.Amount
                      FROM _tmpItem
                     ;
     -- ������ ����� �� �������1 - �������� ���������
     LOOP
     -- ������ �� �������
     FETCH curItem INTO vbMovementItemId, vbGoodsId, vbPartNumber, vbMovementId_order, vbAmount;
     -- ���� ������ �����������, ����� �����
     IF NOT FOUND THEN EXIT; END IF;


     -- ������2 - ������ �������� �� �������
     OPEN curPartion FOR
        SELECT Container.PartionId, Container.Amount - COALESCE (tmp.Amount, 0) AS Amount
        FROM Container
             -- ��-�� ������
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = Container.PartionId
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
             -- ��-�� ������
             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = Container.PartionId
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
             -- ��� �������������� ����������� ������, �� ���� �������
             LEFT JOIN (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.PartionId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.PartionId
                       ) AS tmp ON tmp.GoodsId   = Container.ObjectId
                               AND tmp.PartionId = Container.PartionId

        WHERE Container.ObjectId      = vbGoodsId
          AND Container.WhereObjectId = vbWhereObjectId_Analyzer_From
          AND Container.Amount  - COALESCE (tmp.Amount, 0) > 0
        ORDER BY -- ���� MovementId_order ���������
                 CASE WHEN MIFloat_MovementId.ValueData = vbMovementId_order AND vbMovementId_order <> 0 THEN 0 ELSE 1 END
                 -- ���� PartNumber ���������
               , CASE WHEN MIString_PartNumber.ValueData = vbPartNumber AND vbPartNumber <> '' THEN 0 ELSE 1 END
                 -- ���� MovementId_order �� ����������, ��������� ������� ������ � ������ MovementId_order
               , CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0)  = 0 AND vbMovementId_order = 0 THEN 0 ELSE 1 END
                 -- ���� PartNumber �� ����������, ��������� ������� ������ � ������ PartNumber
               , CASE WHEN COALESCE (MIString_PartNumber.ValueData, '') = '' AND vbPartNumber = '' THEN 0 ELSE 1 END
               , Container.PartionId ASC
       ;
         -- ������ ����� �� �������2. - ������� �� �������
         LOOP
             -- ������ - ������� ���� � ��������
             FETCH curPartion INTO vbPartionId, vbAmount_partion;
             -- ���� ������� �����������, ��� ��� ���-�� ��� ����������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- ���� �� �������� ������ ��� ����
             IF vbAmount_partion > vbAmount
             THEN
                 -- ��������� ������� - �������� zc_MI_Child ���������
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                    AS MovementItemId -- ���������� �����
                         , vbMovementItemId     AS ParentId
                         , vbGoodsId            AS GoodsId
                         , vbPartionId          AS PartionId
                           -- ����� ������ ���-��
                         , vbAmount             AS Amount
                           --
                         , vbMovementId_order   AS MovementId_order
                          ;
                 -- �������� ���-��, ������ �� ���� ������
                 vbAmount:= 0;
             ELSE
                 -- ��������� ������� - �������� zc_MI_Child ���������
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                    AS MovementItemId -- ���������� �����
                         , vbMovementItemId     AS ParentId
                         , vbGoodsId            AS GoodsId
                         , vbPartionId          AS PartionId
                           -- ��������� ���� ������� �� ���� ������
                         , vbAmount_partion     AS Amount
                           --
                         , vbMovementId_order   AS MovementId_order
                          ;
                 -- ��������� ������ ���-�� �� ������� � ���������� ������
                 vbAmount:= vbAmount - vbAmount_partion;
             END IF;


         END LOOP; -- ����� ����� �� �������2. - ������� �� �������
         CLOSE curPartion; -- ������� ������2. - ������� �� �������


     END LOOP; -- ����� ����� �� �������1 - �������� ���������
     CLOSE curItem; -- ������� ������1 - �������� ���������



     -- �������� ������, ������� ���� �������, �.�. �������� �� ��� �� �����
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , Amount
                               , MovementId_order
                                )
        SELECT 0                       AS MovementItemId -- ���������� �����
             , _tmpItem.MovementItemId AS ParentId
             , _tmpItem.GoodsId
               -- !!!������ ��������� ?��������� ����������?
             , _tmpItem.MovementItemId AS PartionId
               -- ������� � ���� ������ �������� �������
             , _tmpItem.Amount - COALESCE (tmp.Amount, 0)
               --
             , _tmpItem.MovementId_order
        FROM _tmpItem
             -- ������� ������ ���������, �� ���� �������
             LEFT JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.ParentId
                       ) AS tmp
                         ON tmp.ParentId = _tmpItem.MovementItemId
        WHERE _tmpItem.Amount - COALESCE (tmp.Amount, 0) > 0
       ;

     -- �������� - ���������� ���-�� _tmpItem + _tmpItem_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.Amount) AS Amount
                                FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                               ) AS tmpRes ON tmpRes.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION '������.���-�� � ��������� = <%> �� ����� ���������� �� ���-�� � ������� = <%> <%>.'
                     , (SELECT _tmpItem.Amount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , COALESCE ((SELECT tmpReserveRes.Amount
                                  FROM _tmpItem
                                       FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                                  FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                                 ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                                  WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                                  ORDER BY _tmpItem.MovementItemId
                                  LIMIT 1
                                 ), 0)
                     , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
               ;
     END IF;


     -- RAISE EXCEPTION 'test.<%> <%>', (SELECT SUM (_tmpItem.Amount) FROM _tmpItem), (SELECT SUM (_tmpReserveRes.Amount) FROM _tmpReserveRes);


     -- ������� ������
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := tmpItem.PartionId
                                               , inMovementId        := inMovementId              -- ���� ���������
                                               , inFromId            := vbUnitId_From             -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbUnitId_From             -- �������������(�������)
                                               , inOperDate          := vbOperDate                -- ���� �������
                                               , inObjectId          := tmpItem.GoodsId           -- ������������� ��� �����
                                               , inAmount            := tmpItem.Amount            -- ���-�� ������
                                                 --
                                               , inEKPrice           := tmpItem.EKPrice_find      -- ���� ��. ��� ���, � ������ ���� ������ + ������� + �������: �������� + �������� + ��������� = inEKPrice_discount + inCostPrice
                                               , inEKPrice_orig      := tmpItem.EKPrice_find      -- ���� ��. ��� ���, � ������ ������ ������ �� ��������
                                               , inEKPrice_discount  := tmpItem.EKPrice_find      -- ���� ��. ��� ���, � ������ ���� ������ (������ ����� ���)
                                               , inCostPrice         := 0                         -- ���� ������ ��� ��� (������� + �������: �������� + �������� + ���������)
                                               , inCountForPrice     := 1                         -- ���� �� ����������
                                                 --
                                               , inEmpfPrice         := tmpItem.EmpfPrice         -- ���� ��������. ��� ���
                                               , inOperPriceList     := 0                         -- ���� �������
                                               , inOperPriceList_old := 0                         -- ���� �������, �� ��������� ������
                                                 -- ��� ��� (!������������!)
                                               , inTaxKindId         := zc_TaxKind_Basis()
                                                 -- �������� ��� (!������������!)
                                               , inTaxKindValue      := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_TaxKind_Basis()  AND OFl.DescId = zc_ObjectFloat_TaxKind_Value())
                                                 --
                                               , inUserId            := inUserId
                                                )
     FROM (WITH --
                tmpItem AS (SELECT _tmpItem_Child.*
                                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0)    AS EKPrice
                                 , COALESCE (ObjectFloat_EmpfPrice .ValueData, 0) AS EmpfPrice
                            FROM _tmpItem_Child
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                       ON ObjectFloat_EKPrice.ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                       ON ObjectFloat_EmpfPrice .ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EmpfPrice .DescId   =  zc_ObjectFloat_Goods_EmpfPrice ()
                            -- ������� - ����� ���� ������� ������
                            WHERE _tmpItem_Child.ParentId = _tmpItem_Child.PartionId
                           )
                -- ����������� ���� ����������
              , tmpItemPrice AS (SELECT tmpItem.GoodsId
                                        -- Dealer_Price ��� Price per Base U.M. ��� Trade Unit Price
                                      , MovementItem.Amount AS EKPrice
                                        -- � �/�
                                      , ROW_NUMBER() OVER (PARTITION BY tmpItem.GoodsId ORDER BY Movement.OperDate DESC) AS Ord
                                 FROM tmpItem
                                      INNER JOIN MovementItem ON MovementItem.ObjectId = tmpItem.GoodsId
                                                             AND MovementItem.DescId   = zc_MI_Master()
                                                             AND MovementItem.isErased = FALSE
                                      INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                         AND Movement.DescId   = zc_Movement_PriceList()
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                 WHERE tmpItem.EKPrice = 0
                                )
           -- ���������
           SELECT tmpItem.*
                , COALESCE (tmpItemPrice.EKPrice, tmpItem.EKPrice) AS EKPrice_find
           FROM tmpItem
                LEFT JOIN tmpItemPrice ON tmpItemPrice.GoodsId = tmpItem.GoodsId
                                      AND tmpItemPrice.Ord     = 1
          ) AS tmpItem
    ;


     -- ������� - ��� - zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE;


     -- ��������� - zc_MI_Child - ������� �����������
     UPDATE _tmpItem_Child SET MovementItemId = lpInsertUpdate_MI_Send_Child (ioId                     := _tmpItem_Child.MovementItemId
                                                                            , inParentId               := _tmpItem_Child.ParentId
                                                                            , inMovementId             := inMovementId
                                                                            , inMovementId_OrderClient := _tmpItem_Child.MovementId_order
                                                                            , inObjectId               := _tmpItem_Child.GoodsId
                                                                            , inPartionId              := _tmpItem_Child.PartionId
                                                                              -- ���-�� ������
                                                                            , inAmount                 := _tmpItem_Child.Amount
                                                                            , inUserId                 := inUserId
                                                                             )
     -- !!!��� ��������
     --WHERE _tmpItem_Child.MovementItemId = 0
    ;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem_Child SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_From
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                          , inPartionId              := _tmpItem_Child.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
                             , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_To
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                          , inPartionId              := _tmpItem_Child.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
     FROM _tmpItem
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem_Child SET AccountId_From = _tmpItem_byAccount.AccountId_From
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
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;


     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpItem_Child SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_From
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpItem_Child.AccountId_From
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpItem_Child.ContainerId_GoodsFrom
                                                                                        , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                        , inPartionId              := _tmpItem_Child.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
                             , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_To
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpItem_Child.AccountId_To
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpItem_Child.ContainerId_GoodsTo
                                                                                        , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                        , inPartionId              := _tmpItem_Child.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
     FROM _tmpItem
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
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
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_From           AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_To             AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_Child.ContainerId_SummTo       AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� ����
            , -1 * _tmpItem_Child.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      UNION ALL
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_To             AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_From           AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_Child.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� �� ����
            , 1 * _tmpItem_Child.Amount               AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Child;


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
            , _tmpItem_Child.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_From           AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_To             AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_Child.ContainerId_SummTo       AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� ����
            , -1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_SummFrom
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_To             AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- �����
            , _tmpItem_Child.PartionId                AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_Child.AccountId_From           AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_Child.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- ��������� - ������������� - �� �������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� �� ����
            , 1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                            THEN Container_Summ.Amount
                       ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                  END                                 AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_SummFrom
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
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 687, inSession:= zfCalc_UserAdmin())
