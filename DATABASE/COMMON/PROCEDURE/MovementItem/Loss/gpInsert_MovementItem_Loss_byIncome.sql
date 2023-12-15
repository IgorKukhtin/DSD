-- Function: gpInsert_MovementItem_Loss_byIncome()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Loss_byIncome (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Loss_byIncome(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Income   Integer   , -- Ключ объекта <Документ  приход>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Loss());

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Loss (ioId                  := COALESCE (tmp.MovementItemId, 0)
                                            , inMovementId          := inMovementId
                                            , inGoodsId             := tmp.GoodsId
                                            , inAmount              := COALESCE (tmp.Amount,0)
                                            , inCount               := COALESCE (tmp.Count,0)
                                            , inHeadCount           := COALESCE (tmp.HeadCount,0) 
                                            , inPrice               := COALESCE (tmp.Price,0)
                                            , inPartionGoodsDate    := tmp.PartionGoodsDate
                                            , inPartionGoods        := tmp.PartionGoods
                                            , inPartNumber          := Null ::TVarChar
                                            , inGoodsKindId         := tmp.GoodsKindId
                                            , inGoodsKindCompleteId := tmp.GoodsKindCompleteId
                                            , inAssetId             := tmp.AssetId
                                            , inPartionGoodsId      := 0 
                                            , inStorageId           := 0
                                            , inPartionModelId      := 0
                                            , inUserId              := vbUserId
                                             )
       FROM (SELECT tmpMI.MovementItemId                                                        AS MovementItemId
                  , COALESCE (tmpMI.AssetId, tmpMI_Income.AssetId)                              AS AssetId
                  , COALESCE (tmpMI.GoodsId, tmpMI_Income.GoodsId)                              AS GoodsId
                  , COALESCE (tmpMI.GoodsKindId, tmpMI_Income.GoodsKindId)                      AS GoodsKindId
                  , COALESCE (tmpMI.GoodsKindId_Complete, 0)                                    AS GoodsKindCompleteId
                  , COALESCE (tmpMI.PartionGoods, Null)                                         AS PartionGoods
                  , COALESCE (tmpMI.PartionGoodsDate, NULL)                                     AS PartionGoodsDate
                  , (COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0)) :: TFloat  AS Amount
                  , COALESCE (tmpMI.Count, 0)                                        :: TFloat  AS Count
                  , COALESCE (tmpMI.HeadCount, 0)                                    :: TFloat  AS HeadCount
                  , COALESCE (tmpMI.Price, 0)                                        :: TFloat  AS Price
                  
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
 
                   WHERE MovementItem.MovementId = inMovementId_Income
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
                                  , COALESCE (MIFloat_Price.ValueData,0):: TFloat AS Price
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
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                             ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                               ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
       
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                                 
                            ) AS tmpMI ON tmpMI.GoodsId          = tmpMI_Income.GoodsId
                                      AND tmpMI.GoodsKindId      = tmpMI_Income.GoodsKindId
           ) AS tmp;

       -- сохраняем свойство документа основание
       PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Income(), inMovementId, inMovementId_Income);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.20         *
*/

-- тест
--