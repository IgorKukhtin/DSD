-- Function: gpInsert_MI_Sale_byReturnIn()

DROP FUNCTION IF EXISTS gpInsert_MI_Sale_byReturnIn (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Sale_byReturnIn(
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inMovementId_ReturnIn    Integer   , -- OrderReturnTare
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     IF COALESCE (inMovementId,0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.'; 
     END IF;

     IF COALESCE (inMovementId_ReturnIn,0) = 0 
     THEN
         RETURN; 
     END IF;

     --дата док. продажи
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     --проверка возврат должен быть не позже 1 мес
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_ReturnIn AND Movement.DescId = zc_Movement_ReturnIn() AND Movement.OperDate < vbOperDate - Interval '1 Month')
     THEN
         RAISE EXCEPTION 'Ошибка.Документ Возврата должен быть не позже 1 месяца.'; 
     END IF;

     -- указывать можно только 1 раз, т.е. нельзя 2 док продажи на один и тот же возврат
     IF EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM 
                   INNER JOIN Movement ON Movement.Id = MLM.MovementId
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                WHERE MLM.DescId = zc_MovementLinkMovement_ReturnIn()
                  AND MLM.MovementId <> inMovementId
                  AND MLM.MovementChildId = inMovementId_ReturnIn)
     THEN
         RAISE EXCEPTION 'Ошибка.По выбранному Возврату уже была сформирована Продажа.'; 
     END IF;

     -- теперь ЭТО информативно
     RETURN;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_Sale (ioId                 := 0
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := tmp.GoodsId
                                             , inAmount             := tmp.Amount
                                             , inAmountPartner      := tmp.Amount
                                             , inAmountChangePercent:= NULL :: TFloat
                                             , inChangePercentAmount:= NULL :: TFloat
                                             , ioPrice              := tmp.Price
                                             , ioCountForPrice      := 1
                                             , inCount              := NULL :: TFloat
                                             , inHeadCount          := NULL :: TFloat
                                             , inBoxCount           := NULL :: TFloat
                                             , inPartionGoods       := ''   :: TVarChar
                                             , inGoodsKindId        := tmp.GoodsKindId
                                             , inAssetId            := 0
                                             , inBoxId              := 0
                                             , inCountPack          := NULL :: TFloat
                                             , inWeightTotal        := NULL :: TFloat
                                             , inWeightPack         := NULL :: TFloat
                                             , inIsBarCode          := False ::Boolean
                                             , inUserId             := vbUserId
                                              )
     FROM (SELECT MovementItem.ObjectId AS GoodsId
                , MovementItem.Amount
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
           FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
           WHERE MovementItem.MovementId = inMovementId_ReturnIn
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.03.22         *
*/

-- тест
--