-- Function: gpUpdateMI_OrderInternal_AmountRemains()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemainsBasisPack (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountRemainsBasisPack(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- 
    IN inToId                Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- ������, �������� �����������
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- ��� ��������
    -- ������, �������� �����������
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp)); -- ��� �������+���-��


    -- �������
    CREATE TEMP TABLE tmpContainer_Count (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, Amount_next TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;
    
    --
    -- ������ ������ ���-�� ��� ���� ������������� (������ "�� ����" + ������ "����")
    INSERT INTO tmpContainer_Count (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount)
                                 WITH tmpUnit AS (SELECT UnitId, zc_MI_Master() AS MIDescId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup
                                                 UNION
                                                  SELECT UnitId, zc_MI_Child() AS MIDescId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup WHERE UnitId <> inToId)
                                      -- �������� ��������������
                                    , tmpInventory AS (SELECT Movement.Id AS MovementId, Movement.OperDate, MLO_From.ObjectId AS UnitId
                                                       FROM Movement
                                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From() AND MLO_From.ObjectId = inFromId
                                                       WHERE Movement.OperDate < inOperDate
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                                         AND Movement.DescId = zc_Movement_Inventory()
                                                         AND vbIsBasis = TRUE
                                                       ORDER BY Movement.OperDate DESC
                                                       LIMIT 1
                                                      )
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                        , Object_InfoMoney_View.InfoMoneyDestinationId
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                        INNER JOIN (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1917) AS lfSelect) AS tmp ON  tmp.GoodsId = ObjectLink_Goods_InfoMoney.ObjectId -- ������ ��-����� (1917)
                                                   )
                               -- �������� �������������� - ��� (���� ��������� �����) - � ��� ��� ���� ��� � ������� ��������� �� �����, � � ��������� ���� ���� ���
                             , tmpMI_Inventory_all AS (SELECT MovementItem.ObjectId AS GoodsId
                                                            , CASE WHEN tmpGoods.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� �����
                                                                    AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis()
                                                                        THEN 0 
                                                                   ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                              END AS GoodsKindId
                                                            , SUM (MovementItem.Amount) AS Amount
                                                            , MovementItem.isErased
                                                       FROM tmpInventory
                                                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpInventory.MovementId
                                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                                   -- AND MovementItem.isErased   = FALSE
                                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                       GROUP BY MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId, MovementItem.isErased, tmpGoods.InfoMoneyDestinationId
                                                      )
                                   -- �������� �������������� - �� ���
                                 , tmpMI_Inventory AS (SELECT tmp.GoodsId, tmp.GoodsKindId, SUM (tmp.Amount) AS Amount
                                                       FROM 
                                                      (-- �������� ������� ������� �� ������ - ������ ��� ������� � "�����"
                                                       SELECT tmpMI_Inventory_all.GoodsId, tmpMI_Inventory_all.GoodsKindId, tmpMI_Inventory_all.Amount
                                                       FROM tmpMI_Inventory_all
                                                       WHERE tmpMI_Inventory_all.isErased = FALSE AND tmpMI_Inventory_all.GoodsId IN (SELECT tmpMI_Inventory_all.GoodsId FROM tmpMI_Inventory_all WHERE tmpMI_Inventory_all.GoodsKindId > 0)
                                                      UNION ALL
                                                       -- �������� 0 ������� � ������ ����� - ����� � ������ ��� � ������� �� ���� ��������
                                                       SELECT tmpMI_Inventory_all.GoodsId, 0 AS GoodsKindId, 0 AS Amount
                                                       FROM tmpMI_Inventory_all
                                                       WHERE tmpMI_Inventory_all.isErased = FALSE AND tmpMI_Inventory_all.GoodsId IN (SELECT tmpMI_Inventory_all.GoodsId FROM tmpMI_Inventory_all WHERE tmpMI_Inventory_all.GoodsKindId > 0)
                                                      UNION ALL
                                                       -- �������� ��������� c 0 �������� � ����������� � ����� - ��� �����, �.�. ���� ���.=0, �� �� ���������� ��������� ��� ����������
                                                       SELECT tmpMI_Inventory_all.GoodsId, tmpMI_Inventory_all.GoodsKindId AS GoodsKindId, 0 AS Amount
                                                       FROM tmpMI_Inventory_all
                                                       WHERE tmpMI_Inventory_all.GoodsKindId > 0
                                                         AND tmpMI_Inventory_all.isErased = TRUE -- !!!���������!!!
                                                      ) AS tmp
                                                       GROUP BY tmp.GoodsId, tmp.GoodsKindId
                                                      )
                                -- ���������
                                SELECT tmpUnit.MIDescId
                                     , Container.Id                         AS ContainerId
                                     , Container.ObjectId                   AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , Container.Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND Container.ObjectId NOT IN (SELECT tmpMI_Inventory.GoodsId FROM tmpMI_Inventory)
                                     INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId

                                     LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                   ON CLO_Account.ContainerId = Container.Id
                                                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                WHERE CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
                               UNION ALL
                                -- !!!������ ��� ������������!!!
                                SELECT   zc_MI_Master() AS MIDescId
                                       , 0 AS ContainerId
                                       , tmpMI_Inventory.GoodsId
                                       , tmpMI_Inventory.GoodsKindId
                                       , tmpMI_Inventory.Amount
                                FROM tmpMI_Inventory
                               ;

       --
       -- ������� ���-�� ��� ���� �������������
       INSERT INTO tmpContainer (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start, Amount_next)
                                 -- �������� ��������������
                                 WITH tmpInventory AS (SELECT Movement.Id AS MovementId, Movement.OperDate, MLO_From.ObjectId AS UnitId
                                                       FROM Movement
                                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From() AND MLO_From.ObjectId = inFromId
                                                       WHERE Movement.OperDate < inOperDate
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                                         AND Movement.DescId   = zc_Movement_Inventory()
                                                       ORDER BY Movement.OperDate DESC
                                                       LIMIT 1
                                                      )
                                  -- ���������
                                  SELECT   tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_start
                                         , SUM (CASE WHEN vbIsPack  = FALSE -- !!!������ ��� ������������!!!
                                                      AND vbIsBasis = FALSE -- !!!������ ��� ������������!!!
                                                      AND MIContainer.OperDate >= inOperDate
                                                      AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      AND MIContainer.isActive = TRUE
                                                          THEN MIContainer.Amount
                                                     ELSE 0
                                                END)  AS Amount_next
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inOperDate
                                  WHERE tmpContainer_Count.ContainerId > 0
                                  GROUP BY tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  HAVING  (tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                        OR SUM (CASE WHEN vbIsPack  = FALSE -- !!!������ ��� ������������!!!
                                                      AND vbIsBasis = FALSE -- !!!������ ��� ������������!!!
                                                      AND MIContainer.OperDate >= inOperDate
                                                      AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      AND MIContainer.isActive = TRUE
                                                          THEN MIContainer.Amount
                                                     ELSE 0
                                                END) <> 0
                                 UNION ALL
                                  -- !!!������ ��� ������������!!!
                                  SELECT   tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount + COALESCE (SUM (tmpMIContainer.Amount), 0)  AS Amount_start
                                         , 0 AS Amount_next
                                  FROM tmpContainer_Count
                                       LEFT JOIN
                                      (SELECT MovementItem.ObjectId AS GoodsId
                                            , CASE -- !!!���!!! ������� - �����������, �� �������� :)
                                                   WHEN MLO_From.ObjectId = 8445 -- ����� ���������
                                                        THEN 8338 -- �����.
                                                   -- !!!������!!! ���� �� � ����� ������, ����� ������� ��� �������� � GoodsKindId = 0
                                                   WHEN tmpContainer_Count.GoodsKindId > 0
                                                        THEN tmpContainer_Count.GoodsKindId
                                                   ELSE 0
                                              END AS GoodsKindId
                                            , SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MLO_From.ObjectId = tmpInventory.UnitId AND MLO_To.ObjectId <> tmpInventory.UnitId
                                                             THEN -1 * MovementItem.Amount
                                                        WHEN Movement.DescId = zc_Movement_Send() AND MLO_From.ObjectId <> tmpInventory.UnitId AND MLO_To.ObjectId = tmpInventory.UnitId
                                                             THEN  1 * MovementItem.Amount
                                                        WHEN Movement.DescId = zc_Movement_ProductionUnion() AND MovementItem.DescId = zc_MI_Master()
                                                             THEN  1 * MovementItem.Amount
                                                        WHEN Movement.DescId = zc_Movement_ProductionUnion() AND MovementItem.DescId = zc_MI_Child()
                                                             THEN -1 * MovementItem.Amount
                                                        ELSE 0
                                                   END ) AS Amount
                                       FROM tmpInventory
                                            INNER JOIN Movement ON Movement.OperDate BETWEEN tmpInventory.OperDate + INTERVAL '1 DAY' AND inOperDate - INTERVAL '1 DAY'
                                                               AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN MovementLinkObject AS MLO_To   ON MLO_To.MovementId   = Movement.Id AND MLO_To.DescId   = zc_MovementLinkObject_To()
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased   = FALSE
                                                                   AND MovementItem.ObjectId IN (SELECT tmpContainer_Count.GoodsId FROM tmpContainer_Count WHERE tmpContainer_Count.ContainerId = 0)
                                            LEFT JOIN MovementItem AS MI_Master
                                                                   ON MI_Master.MovementId = Movement.Id
                                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                                  AND MI_Master.Id         = MovementItem.ParentId
                                                                  AND MI_Master.isErased   = FALSE	
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN tmpContainer_Count ON tmpContainer_Count.GoodsId     = MovementItem.ObjectId
                                                                        AND tmpContainer_Count.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                                                        AND tmpContainer_Count.ContainerId = 0
                                       WHERE (MLO_From.ObjectId = tmpInventory.UnitId OR MLO_To.ObjectId = tmpInventory.UnitId)
                                         AND (MovementItem.DescId = zc_MI_Master()
                                           OR (MovementItem.DescId = zc_MI_Child() AND MI_Master.Id > 0)
                                             )
                                       GROUP BY MovementItem.ObjectId
                                              , CASE WHEN MLO_From.ObjectId = 8445 -- ����� ���������
                                                          THEN 8338 -- �����.
                                                     WHEN tmpContainer_Count.GoodsKindId > 0
                                                          THEN tmpContainer_Count.GoodsKindId
                                                     ELSE 0
                                                END
                                      ) AS tmpMIContainer ON tmpMIContainer.GoodsId     = tmpContainer_Count.GoodsId
                                                         AND tmpMIContainer.GoodsKindId = tmpContainer_Count.GoodsKindId
                                  WHERE tmpContainer_Count.ContainerId = 0
                                  GROUP BY tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  ;
          --
          -- ����������� ������������ ��������� ��������� + �������
          INSERT INTO tmpAll (MovementItemId, MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start)
                      WITH -- ������������ �������� ���������
                           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                          , MovementItem.DescId                           AS MIDescId
                                          , MovementItem.ObjectId                         AS GoodsId
                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , MovementItem.Amount                           AS Amount
                                          , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId
                                     FROM MovementItem
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                          AND MovementItem.DescId                   = zc_MI_Master()
                                          LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                      ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                                     AND MovementItem.DescId                = zc_MI_Child()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.isErased   = FALSE
                                    )
                         , tmpMI_master AS (SELECT MovementItemId, MIDescId, GoodsId, GoodsKindId, Amount, ContainerId FROM tmpMI WHERE MIDescId = zc_MI_Master())
                         , tmpMI_child AS (SELECT MovementItemId, MIDescId, GoodsId, GoodsKindId, Amount, ContainerId FROM tmpMI WHERE MIDescId = zc_MI_Child())
                         , tmpContainer_master AS (-- ������� ��� zc_MI_Master - ������������
                                                   SELECT tmpContainer.GoodsId
                                                        , tmpContainer.GoodsKindId
                                                        , SUM (tmpContainer.Amount_start) AS Amount_start
                                                   FROM tmpContainer
                                                   WHERE tmpContainer.MIDescId = zc_MI_Master()
                                                   GROUP BY tmpContainer.GoodsId
                                                          , tmpContainer.GoodsKindId
                                                  )
                          , tmpContainer_child AS (-- ������� ��� zc_MI_Child
                                                   SELECT ContainerId, GoodsId, GoodsKindId, Amount_start, Amount_next FROM tmpContainer WHERE MIDescId = zc_MI_Child()
                                                  )
                      -- ��������� - ��� zc_MI_Master
                      SELECT tmpMI.MovementItemId
                           , zc_MI_Master()                                          AS MIDescId
                           , 0                                                       AS ContainerId
                           , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                           , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
                      FROM tmpContainer_master AS tmpContainer
                           FULL JOIN tmpMI_master AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                                          AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
                     UNION ALL
                      -- ��������� - ��� zc_MI_Child
                      SELECT tmpMI.MovementItemId
                           , zc_MI_Child()                                           AS MIDescId
                           , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                           , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                           , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpContainer.Amount_start + tmpContainer.Amount_next, 0) AS Amount_start
                      FROM tmpContainer_child AS tmpContainer
                           FULL JOIN tmpMI_child AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
                     ;


       -- �������� � ������ "�����" ������, �.�. �� ��� ��� ��������
       INSERT INTO tmpAll (MovementItemId, MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start)
          WITH tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1917) AS lfSelect)  -- ������ ��-����� (1917)

          SELECT 0              AS MovementItemId
               , zc_MI_Master() AS MIDescId
               , 0              AS ContainerId
               , Object_GoodsByGoodsKind_View.GoodsId
               , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
               , 0              AS Amount_start
          FROM ObjectBoolean AS ObjectBoolean_Order
               INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
               INNER JOIN tmpGoods ON tmpGoods.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
               LEFT JOIN tmpAll ON tmpAll.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
                               AND tmpAll.GoodsKindId = COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)
          WHERE ObjectBoolean_Order.ValueData = TRUE
            AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
            AND tmpAll.GoodsId IS NULL
            AND vbIsPack  = FALSE -- !!!������ ��� ������������!!!
            AND vbIsBasis = FALSE -- !!!������ ��� ������������!!!
       ;


       -- ��������� zc_MI_Master
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.Amount_start * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountRemains()
                                                 , inAmount_ParamOrder  := NULL
                                                 , inDescId_ParamOrder  := NULL
                                                 , inAmount_ParamSecond := NULL
                                                 , inDescId_ParamSecond := NULL
                                                 , inIsPack             := TRUE
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       WHERE tmpAll.MIDescId = zc_MI_Master();
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.12.19         *
*/

-- ����
--