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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice());


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
       CREATE TEMP TABLE tmpMI (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer
                              , AmountPartner TFloat
                              , Price TFloat, CountForPrice TFloat
                               ) ON COMMIT DROP;


      INSERT INTO tmpMI  (MovementItemId, GoodsId, GoodsKindId, AmountPartner
                        , Price, CountForPrice
                        )

         WITH 
          tmp AS (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                       , MovementItem.ObjectId                         AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  FROM MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  WHERE MovementItem.MovementId =  inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  GROUP BY MovementItem.ObjectId
                         , MILinkObject_GoodsKind.ObjectId 
                 )
        , tmpObjectHistory_PriceListItem AS (SELECT lfSelect.GoodsId
                                                  , lfSelect.GoodsKindId
                                                  , COALESCE (lfSelect.ValuePrice, 0) AS Price
                                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect
                                             )

        SELECT COALESCE (tmp.MovementItemId, 0)              AS MovementItemId
             , Object_Goods.Id                               AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
         
             , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner

             , COALESCE (lfObjectHistory_PriceListItem_Kind.Price, lfObjectHistory_PriceListItem.Price, 0) AS Price
             , 1 AS CountForPrice
       FROM MovementItem 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                        AND MIFloat_AmountPartner.ValueData <> 0

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                
            LEFT JOIN tmp ON tmp.GoodsId     = MovementItem.ObjectId
                         AND tmp.GoodsKindId =  COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            
            --привязываем 2 раза с видом и без
            LEFT JOIN tmpObjectHistory_PriceListItem AS lfObjectHistory_PriceListItem 
                                                     ON lfObjectHistory_PriceListItem.GoodsId = Object_Goods.Id
                                                    AND lfObjectHistory_PriceListItem.GoodsKindId IS NULL

            LEFT JOIN tmpObjectHistory_PriceListItem AS lfObjectHistory_PriceListItem_Kind
                                                     ON lfObjectHistory_PriceListItem_Kind.GoodsId = Object_Goods.Id 
                                                    AND COALESCE (lfObjectHistory_PriceListItem_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 

      WHERE MovementItem.MovementId = inMovementMaskId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = False;

     --
     PERFORM lpInsertUpdate_MovementItem_SendOnPrice (ioId                 := MovementItemId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := GoodsId
                                                    , inAmount             := AmountPartner
                                                    , inAmountPartner      := AmountPartner
                                                    , inAmountChangePercent:= AmountPartner
                                                    , inChangePercentAmount:= 0
                                                    , inPrice              := Price :: TFloat
                                                    , ioCountForPrice      := CountForPrice
                                                    , inPartionGoods       := ''
                                                    , inGoodsKindId        := GoodsKindId
                                                    , inUnitId             := NULL
                                                    , inCountPack          := 0 ::TFloat      -- Количество упаковок (расчет)
                                                    , inWeightTotal        := 0 :: TFloat     -- Вес 1 ед. продукции + упаковка
                                                    , inWeightPack         := 0 :: TFloat     -- Вес упаковки для 1-ой ед. продукции
                                                    , inIsBarCode          := FALSE ::Boolean   --
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
-- select * from gpUpdate_MI_SendOnPrice_isMask (inMovementId:= 393522 , inMovementMaskId :=393501 ,  inSession := '5');
