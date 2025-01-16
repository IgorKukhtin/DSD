-- Function: gpInsert_MovementItem_Inventory_bySend()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_bySend (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_bySend (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_bySend(
    IN inMovementId               Integer   , -- ���� ������� <�������� ��������������>
    IN inMovementId_Send          Integer   , -- ���� ������� <�������� �����������>
    IN inIsAdd                    Boolean   , -- �������� ���-�� �� ��������� ��� ������ 
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_to Integer;
   DECLARE vbKoef Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- ���������� ����� ��������� ��� ���������� ���-�� �� ��������� �����������
     vbKoef := (CASE WHEN inIsAdd = TRUE THEN 1 ELSE -1 END);
     
     -- ����������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     -- ����������
     vbUnitId_from:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Send AND MLO.DescId = zc_MovementLinkObject_From());
     vbUnitId_to:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Send AND MLO.DescId = zc_MovementLinkObject_To());
     
     -- ���������
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE (tmp.MovementItemId, 0)
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmp.GoodsId
                                                  , inAmount             := COALESCE (tmp.Amount,0)
                                                  , inPartionGoodsDate   := CASE WHEN vbUnitId IN (8459 -- ����� ����������
                                                                                                 , 8458 -- ����� ���� ��
                                                                                                  )
                                                                                      THEN NULL
                                                                                  WHEN tmp.PartionGoodsDate = zc_DateStart() THEN NULL
                                                                                  ELSE tmp.PartionGoodsDate
                                                                            END
                                                  , inPrice              := 0
                                                  , inSumm               := 0
                                                  , inHeadCount          := 0
                                                  , inCount              := 0
                                                  , inPartionGoods       := tmp.PartionGoods
                                                  , inPartNumber         := NULL
                                                  , inPartionGoodsId     := NULL
                                                  , inGoodsKindId        := tmp.GoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                  , inAssetId            := NULL
                                                  , inUnitId             := NULL
                                                  , inStorageId          := NULL
                                                  , inPartionModelId     := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (SELECT tmpMI.MovementItemId                                                      AS MovementItemId
                , COALESCE (tmpMI.GoodsId, tmpMI_Send.GoodsId)                              AS GoodsId
                , COALESCE (tmpMI.GoodsKindId, tmpMI_Send.GoodsKindId)                      AS GoodsKindId
                , COALESCE (tmpMI.GoodsKindCompleteId, 0)                                   AS GoodsKindCompleteId
                , COALESCE (tmpMI.PartionGoods, tmpMI_Send.PartionGoods)                    AS PartionGoods
                , COALESCE (tmpMI.PartionGoodsDate, tmpMI_Send.PartionGoodsDate)            AS PartionGoodsDate
                , (COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI_Send.Amount, 0)) :: TFloat  AS Amount

           FROM (SELECT MovementItem.ObjectId                                    AS GoodsId
                        -- 
                      , CASE WHEN vbUnitId_from IN (8445)     -- ����� ��������� 
                              AND vbUnitId_to   IN (8447)  -- ��� ��������� ������
                              AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = zc_GoodsKind_Basis()
                             THEN 8338 -- �����.
                         ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                        END AS GoodsKindId
                        -- 
                      , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                      , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                      , SUM (MovementItem.Amount) * vbKoef                       AS Amount
                 FROM MovementItem
                    LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                               ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                              AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                              AND vbUnitId NOT IN (8459 -- ����� ����������
                                                                 , 8458 -- ����� ���� ��
                                                                  )
                    LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                 ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId_Send
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                 GROUP BY MovementItem.ObjectId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                        , COALESCE (MIString_PartionGoods.ValueData, '')
                        , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                ) tmpMI_Send

                  LEFT JOIN (SELECT MovementItem.Id                                          AS MovementItemId
                                  , MovementItem.ObjectId                                    AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            AS GoodsKindId
                                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)    AS GoodsKindCompleteId
                                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                                  , MovementItem.Amount                                      AS Amount
                                    --  � �/�
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
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
                               WHERE Movement.Id = inMovementId
                               ) AS tmpMI ON tmpMI.GoodsId          = tmpMI_Send.GoodsId
                                         AND tmpMI.GoodsKindId      = tmpMI_Send.GoodsKindId
                                         AND tmpMI.PartionGoods     = tmpMI_Send.PartionGoods
                                         AND tmpMI.PartionGoodsDate = tmpMI_Send.PartionGoodsDate
                                         AND tmpMI.Ord              = 1 -- !!!����� ����������� ������!!!
           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.06.18         * add inIsAdd
 17.10.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_bySend (ioId:= 0, inMovementId:= 10, inMovementId_Send:= 1, inIsAdd := TRUE, inSession:= '2')
