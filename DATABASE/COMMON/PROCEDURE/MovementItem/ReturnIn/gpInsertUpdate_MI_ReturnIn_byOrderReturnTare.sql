-- Function: gpInsert_MI_ReturnIn_byOrderReturnTare()

DROP FUNCTION IF EXISTS gpInsert_MI_ReturnIn_byOrderReturnTare (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_ReturnIn_byOrderReturnTare(
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inMovementId_Order       Integer   , -- OrderReturnTare
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     --проверка док. выбора OrderReturnTare
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_Order AND Movement.DescId = zc_Movement_OrderReturnTare())
     THEN
         RETURN;
     END IF;

     IF COALESCE (inMovementId,0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.'; 
     END IF;
     
     --
     vbPartnerId := (SELECT MovementLinkObject_From.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_From
                     WHERE MovementLinkObject_From.MovementId = inMovementId
                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     );

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := 0
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmp.GoodsId
                                                 , inAmount             := tmp.Amount
                                                 , inAmountPartner      := tmp.Amount
                                                 , ioPrice              := NULL
                                                 , ioCountForPrice      := 1
                                                 , inCount              := NULL
                                                 , inHeadCount          := NULL
                                                 , inMovementId_Partion := NULL
                                                 , inPartionGoods       := NULL
                                                 , inGoodsKindId        := NULL
                                                 , inAssetId            := NULL
                                                 , ioMovementId_Promo   := NULL
                                                 , ioChangePercent      := NULL
                                                 , inIsCheckPrice       := TRUE
                                                 , inUserId             := vbUserId
                                                  )
     FROM (SELECT MovementItem.ObjectId AS GoodsId
                , MovementItem.Amount
           FROM MovementItem
               INNER JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                 ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                                                AND MILinkObject_Partner.ObjectId = vbPartnerId
           WHERE MovementItem.MovementId = inMovementId_Order
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.01.22         *
*/

-- тест
--