-- Function: gpInsert_MovementItem_Inventory_bySend()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_bySend (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_bySend (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_bySend(
    IN inMovementId               Integer   , -- Ключ объекта <Документ инвенторизации>
    IN inMovementId_Send          Integer   , -- Ключ объекта <Документ Перемещение>
    IN inIsAdd                    Boolean   , -- добавить кол-во из накладной или отнять 
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbKoef Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- определяем нужно добавлять или минусовать кол-во из накладной перемещения
     vbKoef := (CASE WHEN inIsAdd = True THEN 1 ELSE -1 END);
     
     -- определяем
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE (tmp.MovementItemId, 0)
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmp.GoodsId
                                                  , inAmount             := COALESCE (tmp.Amount,0)
                                                  , inPartionGoodsDate   := CASE WHEN vbUnitId IN (8459 -- Склад Реализации
                                                                                                 , 8458 -- Склад База ГП
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
                                                  , inPartionGoodsId     := NULL
                                                  , inGoodsKindId        := tmp.GoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                  , inAssetId            := NULL
                                                  , inUnitId             := NULL
                                                  , inStorageId          := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (SELECT tmpMI.MovementItemId                                                      AS MovementItemId
                , COALESCE (tmpMI.GoodsId, tmpMI_Send.GoodsId)                              AS GoodsId
                , COALESCE (tmpMI.GoodsKindId, tmpMI_Send.GoodsKindId)                      AS GoodsKindId
                , COALESCE (tmpMI.GoodsKindCompleteId, 0)                                   AS GoodsKindCompleteId
                , COALESCE (tmpMI.PartionGoods, tmpMI_Send.PartionGoods)                    AS PartionGoods
                , COALESCE (tmpMI.PartionGoodsDate, tmpMI_Send.PartionGoodsDate)            AS PartionGoodsDate
                , (COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI_Send.Amount, 0)) :: TFloat  AS Amount

            FROM (SELECT MovementItem.ObjectId                       AS GoodsId
                      , COALESCE (MILinkObject_Asset.ObjectId, 0)     AS AssetId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , SUM (MovementItem.Amount)                     AS Amount
                   FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                       ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   WHERE MovementItem.MovementId = 16528099 --inMovementId_Income
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE
                   GROUP BY MovementItem.ObjectId
                          , COALESCE (MILinkObject_Asset.ObjectId, 0)
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                   ) tmpMI_Income

                  LEFT JOIN (SELECT MovementItem.Id                               AS MovementItemId
                                  , MovementItem.Amount                           AS Amount
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , COALESCE (MILO_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_Complete
       
                                  , MIFloat_Count.ValueData            AS Count
                                  , MIFloat_HeadCount.ValueData        AS HeadCount
                                  , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                                  , MIString_PartionGoods.ValueData    AS PartionGoods
       
                                  , MILinkObject_Asset.ObjectId        AS AssetId
       
                             FROM MovementItem 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                                   ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
       
                                  LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                              ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Count.DescId = zc_MIFloat_Count()
                                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                             ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                               ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
       
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                             WHERE MovementItem.MovementId = 16533973 --inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                                 
                            ) AS tmpMI ON tmpMI.GoodsId          = tmpMI_Income.GoodsId
                                      AND tmpMI.GoodsKindId      = tmpMI_Income.GoodsKindId
                                                 ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.06.18         * add inIsAdd
 17.10.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_bySend (ioId:= 0, inMovementId:= 10, inMovementId_Send:= 1, inIsAdd := TRUE, inSession:= '2')
