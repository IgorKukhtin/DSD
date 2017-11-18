-- Function: gpUpdateMI_OrderInternal_AmountRemainsPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemainsPack (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountRemainsPack(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- �������� ������������
    IF COALESCE(inOperDate, zc_DateStart()) <> COALESCE((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), zc_DateEnd())
    THEN
        RAISE EXCEPTION '������.���� ���������� <%> �� ���������.<%>', inOperDate, (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
    END IF;

    -- !!!�������� ��������, �������� �����������!!!
    PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);

    -- �������
    CREATE TEMP TABLE tmpContainer (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;


    -- ������� ���-�� ��� ���� �������������
    INSERT INTO tmpContainer (ContainerId, GoodsId, GoodsKindId, Amount_start)
       WITH -- ��������� - ��� �������+���-�� (������������)
            tmpUnit_CEH AS (SELECT UnitId, TRUE AS isContainer FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- ��������� - ������ ���� + ����������
          , tmpUnit_SKLAD   AS (SELECT UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
            -- ��������� - ���
          , tmpUnit_all   AS (SELECT UnitId, isContainer FROM tmpUnit_CEH UNION SELECT UnitId, isContainer FROM tmpUnit_SKLAD)
            -- ��������� - ������ ��
          , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                              , Object_InfoMoney_View.InfoMoneyDestinationId
                         FROM Object_InfoMoney_View
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                         WHERE (Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- ������ + ��������� + ������� ���������
                             OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- ������ + ������ ����� + ������ �����
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                               )
                        )
       -- ��������� - ������� ������ ��
       SELECT tmp.ContainerId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , SUM (tmp.Amount_start + CASE WHEN tmp.ContainerId > 0 THEN tmp.Amount_next ELSE 0 END) AS Amount_start
       FROM
      (SELECT CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END AS ContainerId
            , Container.ObjectId                   AS GoodsId
            , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
            , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_start
            , SUM (CASE WHEN MIContainer.OperDate = inOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) AS Amount_next
       FROM tmpGoods
            INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                AND Container.DescId   = zc_Container_Count()
            INNER JOIN ContainerLinkObject AS CLO_Unit 
                                           ON CLO_Unit.ContainerId = Container.Id
                                          AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
            INNER JOIN tmpUnit_all ON tmpUnit_all.UnitId = CLO_Unit.ObjectId

            LEFT JOIN ContainerLinkObject AS CLO_Account
                                          ON CLO_Account.ContainerId = Container.Id
                                         AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                          ON CLO_GoodsKind.ContainerId = Container.Id
                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()

            LEFT JOIN MovementItemContainer AS MIContainer
                                            ON MIContainer.ContainerId = Container.Id
                                           AND MIContainer.OperDate    >= inOperDate

       WHERE CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
       GROUP BY CASE WHEN tmpUnit_all.isContainer = TRUE THEN Container.Id ELSE 0 END
              , Container.ObjectId
              , COALESCE (CLO_GoodsKind.ObjectId, 0)
              , Container.Amount
       HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
           OR SUM (CASE WHEN MIContainer.OperDate = inOperDate AND MIContainer.isActive = TRUE THEN MIContainer.Amount ELSE 0 END) <> 0
      ) AS tmp
       GROUP BY tmp.ContainerId
              , tmp.GoodsId
              , tmp.GoodsKindId
      ;

    --
    -- ����������� ������������ ��������� ��������� + �������
    INSERT INTO tmpAll (MovementItemId, ContainerId, GoodsId, GoodsKindId, Amount_start)
       WITH -- ������������ �������� ���������
            tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                       ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )
       -- ��������� - ��� SKLAD
       SELECT tmpMI.MovementItemId
            , 0                                                       AS ContainerId
            , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
            , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
            , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
       FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId = 0
            ) AS tmpContainer
            FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId = 0
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
      UNION ALL
       -- ��������� - ��� CEH
       SELECT tmpMI.MovementItemId
            , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
            , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
            , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
            , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
       FROM (SELECT * FROM tmpContainer WHERE tmpContainer.ContainerId > 0
            ) AS tmpContainer
            FULL JOIN (SELECT * FROM tmpMI WHERE tmpMI.ContainerId > 0
                      ) AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
      ;

--    RAISE EXCEPTION '<%>', (select count(*) from tmpAll where tmpAll.ContainerId = 0 and tmpAll.GoodsId = 593238 and tmpAll.GoodsKindId = 8335);


    -- ��������� ��-�� ��� zc_MI_Master
    PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := tmpAll.GoodsId
                                              , inGoodsKindId        := tmpAll.GoodsKindId
                                              , inAmount_Param       := tmpAll.Amount_start
                                              , inDescId_Param       := zc_MIFloat_AmountRemains()
                                              , inAmount_ParamOrder  := tmpAll.ContainerId
                                              , inDescId_ParamOrder  := zc_MIFloat_ContainerId()
                                              , inAmount_ParamSecond := NULL
                                              , inDescId_ParamSecond := NULL
                                              , inIsPack             := NULL -- ��� � �� ����������� ��-��
                                              , inUserId             := vbUserId
                                               ) 
    FROM tmpAll;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.10.17                                        *
*/

-- ����
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountRemainsPack (inMovementId:= 7448208, inOperDate:= '31.10.2017', inSession:= zfCalc_UserAdmin());
