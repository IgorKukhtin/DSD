-- Function: gpInsertUpdate_MovementItem_Inventory_Amount (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Amount(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- ���������
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE (tmp.MovementItemId, 0)
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmp.GoodsId
                                                  , inAmount             := COALESCE (tmp.Amount_End,0)
                                                  , inPartionGoodsDate   := CASE WHEN tmp.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmp.PartionGoodsDate END
                                                  , inPrice              := 0
                                                  , inSumm               := 0
                                                  , inHeadCount          := 0
                                                  , inCount              := 0
                                                  , inPartionGoods       := tmp.PartionGoods
                                                  , inGoodsKindId        := tmp.GoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                  , inAssetId            := NULL
                                                  , inUnitId             := NULL
                                                  , inStorageId          := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (SELECT tmpMI.MovementItemId                                                   AS MovementItemId
                , COALESCE (tmpContainer.GoodsId, tmpMI.GoodsId)                         AS GoodsId
                , COALESCE (tmpContainer.GoodsKindId, tmpMI.GoodsKindId)                 AS GoodsKindId
                , COALESCE (tmpContainer.GoodsKindCompleteId, tmpMI.GoodsKindCompleteId) AS GoodsKindCompleteId
                , COALESCE (tmpContainer.PartionGoods, tmpMI.PartionGoods)               AS PartionGoods
                , COALESCE (tmpContainer.PartionGoodsDate, tmpMI.PartionGoodsDate)       AS PartionGoodsDate
                , COALESCE (tmpContainer.Amount_End,0)                                   AS Amount_End

           FROM (SELECT tmpContainer.GoodsId
                      , COALESCE (CLO_GoodsKind.ObjectId, 0)                               AS GoodsKindId
                      , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindCompleteId
                      , COALESCE (Object_PartionGoods.ValueData, '')                       AS PartionGoods
                      , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                      , SUM (tmpContainer.Amount_End)                                      AS Amount_End

                 FROM (SELECT Container.Id                                               AS ContainerId
                            , Container.ObjectId                                         AS GoodsId
                            , Container.Amount  - COALESCE (SUM (MIContainer.Amount), 0) AS Amount_End
                       FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            INNER JOIN ContainerLinkObject AS CLO_Unit
                                                           ON CLO_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                                          AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                            INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                                AND Container.DescId = zc_Container_Count()
                            LEFT JOIN ContainerLinkObject AS CLO_Account
                                                          ON CLO_Account.ContainerId = Container.Id
                                                         AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = Container.Id
                                                           AND MIContainer.OperDate > Movement.OperDate -- �.�. ������� �� ���� + 1
                       WHERE Movement.Id =  inMovementId
                         AND CLO_Account.ContainerId IS NULL -- !!!�.�. ��� ����� �������!!!
                      GROUP BY Container.Id
                              , Container.ObjectId
                              , Container.Amount
                       HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                      ) tmpContainer
                      LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                    ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                    ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                                   AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                      LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                           ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                          AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                           ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                          AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                 GROUP BY tmpContainer.GoodsId
                        , COALESCE (CLO_GoodsKind.ObjectId, 0)
                        , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                        , COALESCE (Object_PartionGoods.ValueData, '')
                        , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart())
                 HAVING SUM (tmpContainer.Amount_End) <> 0
                ) tmpContainer

                  FULL JOIN (SELECT MovementItem.Id                                          AS MovementItemId
                                  , MovementItem.ObjectId                                    AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            AS GoodsKindId
                                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)    AS GoodsKindCompleteId
                                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                                    --  � �/�
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)
                                                                  , COALESCE (MIString_PartionGoods.ValueData, '')
                                                                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                                                       ORDER BY MovementItem.Amount DESC
                                                      ) AS Ord
                             FROM Movement
                                  INNER JOIN MovementItem ON Movement.id = MovementItem.MovementId
                                                         AND MovementItem.isErased = FALSE
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                   ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                             ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                               ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                             WHERE Movement.Id =  inMovementId
                            ) AS tmpMI ON tmpMI.GoodsId             = tmpContainer.GoodsId
                                      AND tmpMI.GoodsKindId         = tmpContainer.GoodsKindId
                                      AND tmpMI.GoodsKindCompleteId = tmpContainer.GoodsKindCompleteId
                                      AND tmpMI.PartionGoods        = tmpContainer.PartionGoods
                                      AND tmpMI.PartionGoodsDate    = tmpContainer.PartionGoodsDate
                                      AND tmpMI.Ord                 = 1 -- !!!����� ����������� ������!!!

           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.04.15                                        * all
 24.04.15          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Amount
