-- Function: gpUpdate_MI_ReturnOut_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReturnOut_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_ReturnOut_isMask(
    IN inMovementId      Integer      , -- ключ Документа
    IN inMovementMaskId  Integer      , -- ключ Документа маски
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());


      -- Проверка - что б не копировали два раза
      IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные.'; 
      END IF;
    
      -- Результат
       CREATE TEMP TABLE tmpMI (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer
                              , Amount TFloat, AmountPartner TFloat, Price TFloat, CountForPrice TFloat, HeadCount TFloat, PartionGoods TVarChar) ON COMMIT DROP;


      INSERT INTO tmpMI  (MovementItemId, GoodsId, GoodsKindId, AssetId, Amount, AmountPartner, Price, CountForPrice, HeadCount, PartionGoods)

         WITH 
          tmp AS (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                       , MovementItem.ObjectId                         AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  FROM MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  GROUP BY MovementItem.ObjectId
                         , MILinkObject_GoodsKind.ObjectId 
                 )

        SELECT COALESCE (tmp.MovementItemId, 0)              AS MovementItemId
             , Object_Goods.Id                               AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , MILinkObject_Asset.ObjectId                   AS AssetId
             , MovementItem.Amount                           AS Amount
             , MIFloat_AmountPartner.ValueData               AS AmountPartner

             , MIFloat_Price.ValueData                       AS Price
             , MIFloat_CountForPrice.ValueData               AS CountForPrice
             , MIFloat_HeadCount.ValueData                   AS HeadCount
             , COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData, '') AS PartionGoods

       FROM MovementItem 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                       AND MIFloat_AmountPartner.ValueData <> 0

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                        AND MIString_PartionGoods.ValueData <> ''
            LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                         ON MIString_PartionGoodsCalc.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

            LEFT JOIN tmp ON tmp.GoodsId     = MovementItem.ObjectId
                         AND tmp.GoodsKindId =  COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            
      WHERE MovementItem.MovementId = inMovementMaskId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = False
        AND (COALESCE (MovementItem.Amount,0) <> 0 OR COALESCE (MIFloat_AmountPartner.ValueData,0) <> 0);


     --cохраняем                  
     PERFORM lpInsertUpdate_MovementItem_ReturnOut (ioId                 := COALESCE (tmpMI.MovementItemId,0) ::Integer
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmpMI.GoodsId
                                                  , inAmount             := tmpMI.Amount  ::TFloat
                                                  , inAmountPartner      := COALESCE (tmpMI.AmountPartner,tmpMI.Amount,0) ::TFloat
                                                  , inPrice              := COALESCE (tmpMI.Price,0)         ::TFloat
                                                  , inCountForPrice      := COALESCE (tmpMI.CountForPrice,1) ::TFloat
                                                  , inHeadCount          := COALESCE (tmpMI.HeadCount,0)     ::TFloat
                                                  , inPartionGoods       := COALESCE (tmpMI.PartionGoods,'') ::TVarChar
                                                  , inGoodsKindId        := tmpMI.GoodsKindId  ::Integer
                                                  , inAssetId            := tmpMI.AssetId      ::Integer
                                                  , inUserId             := vbUserId
                                                   )
     FROM tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.22         *
*/

-- тест
--