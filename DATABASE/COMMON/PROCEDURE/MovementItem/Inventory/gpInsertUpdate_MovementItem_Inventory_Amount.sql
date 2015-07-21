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
                                                  , inPartionGoodsDate   := NULL
                                                  , inPrice              := 0
                                                  , inSumm               := 0
                                                  , inHeadCount          := 0
                                                  , inCount              := 0
                                                  , inPartionGoods       := NULL
                                                  , inGoodsKindId        := tmp.GoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                  , inAssetId            := NULL
                                                  , inUnitId             := NULL
                                                  , inStorageId          := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (SELECT tmpMI.MovementItemId                                   AS MovementItemId
                , COALESCE (tmpContainer.GoodsId, tmpMI.GoodsId)         AS GoodsId
                , COALESCE (tmpContainer.GoodsKindId, tmpMI.GoodsKindId) AS GoodsKindId
                , COALESCE (tmpContainer.GoodsKindCompleteId, tmpMI.GoodsKindCompleteId) AS GoodsKindCompleteId
                , COALESCE (tmpContainer.Amount_End,0)                   AS Amount_End

           FROM (SELECT tmpContainer.GoodsId
                      , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , COALESCE (CLO_GoodsKindComplete.ObjectId, 0) AS GoodsKindCompleteId
                      , SUM (tmpContainer.Amount_End)        AS Amount_End
                 FROM
                (SELECT Container.Id                                                AS ContainerId
                      , Container.ObjectId                                          AS GoodsId
                      , Container.Amount  - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_End
                 FROM Movement
                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      INNER JOIN ContainerLinkObject AS CLO_Unit
                                                     ON CLO_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                                    AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                      INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                          AND Container.DescId = zc_Container_Count()
                      LEFT JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.ContainerId = Container.Id
                                                     AND MIContainer.OperDate > Movement.OperDate -- �.�. ������� �� ���� + 1
                 WHERE Movement.Id =  inMovementId
                 GROUP BY Container.Id
                        , Container.ObjectId
                        , Container.Amount
                 HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                ) tmpContainer
                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                              ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                LEFT JOIN ContainerLinkObject AS CLO_GoodsKindComplete
                                              ON CLO_GoodsKindComplete.ContainerId = tmpContainer.ContainerId
                                             AND CLO_GoodsKindComplete.DescId = zc_ContainerLinkObject_GoodsKindComplete()
                 GROUP BY tmpContainer.GoodsId
                        , COALESCE (CLO_GoodsKind.ObjectId, 0)
                 HAVING SUM (tmpContainer.Amount_End) <> 0
                ) tmpContainer
                                             
                FULL JOIN (SELECT MovementItem.Id                               AS MovementItemId
                                , MovementItem.ObjectId                         AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindCompleteId
                           FROM Movement
                                INNER JOIN MovementItem ON Movement.id = MovementItem.MovementId
                                                       AND MovementItem.isErased = FALSE
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                 ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete() 
                           WHERE Movement.Id =  inMovementId
                          ) AS tmpMI ON tmpMI.GoodsId = tmpContainer.GoodsId
                                    AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
                                    AND tmpMI.GoodsKindCompleteId = tmpContainer.GoodsKindCompleteId
           
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
