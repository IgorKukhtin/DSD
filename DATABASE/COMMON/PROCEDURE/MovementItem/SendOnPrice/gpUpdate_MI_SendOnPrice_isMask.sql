-- Function: gpUpdate_MI_SendOnPrice_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_SendOnPrice_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_SendOnPrice_isMask(
    IN inMovementId      Integer      , -- ключ Документа
    IN inMovementMaskId  Integer      , -- ключ Документа маски
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_SendOnPrice());
     vbUserId:= lpGetUserBySession (inSession);


      -- Проверка - что б не копировали два раза
      IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные.'; 
      END IF;

      SELECT Movement.OperDate
           , MLO_To.ObjectId AS ToId 
           , MLO_PriceList.ObjectId AS PriceListId 
       INTO vbOperDate, vbUnitId, vbPriceListId
      FROM Movement
         LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                               AND MLO_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN MovementLinkObject AS MLO_PriceList ON MLO_PriceList.MovementId = Movement.Id
                                                      AND MLO_PriceList.DescId = zc_MovementLinkObject_PriceList()                                                              
      WHERE Movement.Id = inMovementId;
      
      -- Результат
       CREATE TEMP TABLE tmpMI (MovementItemId Integer, GoodsId Integer, MeasureId Integer
                           , Amount TFloat, AmountPartner TFloat
                           , Price TFloat, CountForPrice TFloat, PartionGoods TVarChar, GoodsKindId Integer
                           ) ON COMMIT DROP;
       
       WITH tmp AS (SELECT MAX (MovementItem.Id)                     AS MovementItemId
                           , MovementItem.ObjectId                     AS GoodsId
                           , MILinkObject_GoodsKind.ObjectId           AS GoodsKindId
                      
                      FROM MovementItem 
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.isErased = FALSE
                        AND MovementItem.DescId = zc_MI_Master()
                        AND MovementItem.MovementId =  inMovementId
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId 
                     )

      INSERT INTO tmpMI  (MovementItemId, GoodsId, MeasureId, Amount, AmountPartner
                        , Price, CountForPrice, PartionGoods, GoodsKindId 
                        )
        SELECT COALESCE (tmp.MovementItemId, 0)        AS MovementItemId
             , Object_Goods.Id                           AS GoodsId
             , ObjectLink_Goods_Measure.ChildObjectId    AS MeasureId
         
             , MovementItem.Amount
             , MIFloat_AmountPartner.ValueData   AS AmountPartner

             , COALESCE (lfObjectHistory_PriceListItem.ValuePrice, 0)  AS Price
             , MIFloat_CountForPrice.ValueData AS CountForPrice

           , COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData) :: TVarChar AS PartionGoods

           , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId
         
       FROM MovementItem 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                        AND MIString_PartionGoods.ValueData <> ''
            LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                         ON MIString_PartionGoodsCalc.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

            LEFT JOIN tmp ON tmp.GoodsId  = MovementItem.ObjectId
                                AND tmp.GoodsKindId =  MILinkObject_GoodsKind.ObjectId 

            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                 AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = Object_Goods.Id 
                                     
      WHERE MovementItem.MovementId = inMovementMaskId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = False
;
        

     PERFORM lpInsertUpdate_MovementItem_SendOnPrice (ioId                 := MovementItemId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := GoodsId
                                                    , inAmount             := Amount
                                                    , inAmountPartner      := AmountPartner
                                                    , inAmountChangePercent:= 0--outAmountChangePercent --
                                                    , inChangePercentAmount:= 0--inChangePercentAmount --
                                                    , inPrice              := Price :: TFloat
                                                    , ioCountForPrice      := CountForPrice
                                                    , inPartionGoods       := PartionGoods
                                                    , inGoodsKindId        := GoodsKindId
                                                    , inUnitId             := vbUnitId --
                                                    , inUserId             := vbUserId
                                                 
                                                     )


      FROM tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.09.15         *
*/

-- тест
--select * from gpUpdate_MI_SendOnPrice_isMask (inMovementId:= 393522 , inMovementMaskId :=393501 ,  inSession := '5');
