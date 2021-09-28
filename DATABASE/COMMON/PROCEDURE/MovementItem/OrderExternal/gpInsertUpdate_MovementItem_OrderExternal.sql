-- Function: gpInsertUpdate_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, TFloat, TFloat, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountSecond        TFloat    , -- Количество дозаказ
    IN inGoodsKindId         Integer   , -- Виды товаров
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outMovementPromo      TVarChar  , -- 
   OUT outPricePromo         TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Promo Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                WHERE MLO.MovementId = inMovementId 
                  AND MLO.DescId     = zc_MovementLinkObject_From()
               )
     THEN
         -- так для zc_Object_Unit
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());
     ELSE
         -- для остальных 
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());
     END IF;


     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- сохранили
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
          , zfCalc_PromoMovementName (tmp.outMovementId_Promo, NULL, NULL, NULL, NULL)
          , tmp.outPricePromo
            INTO ioId, ioPrice, ioCountForPrice, outAmountSumm, outMovementPromo, outPricePromo
     FROM lpInsertUpdate_MovementItem_OrderExternal (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := inAmount
                                                   , inAmountSecond       := inAmountSecond
                                                   , inGoodsKindId        := inGoodsKindId
                                                   , ioPrice              := ioPrice
                                                   , ioCountForPrice      := ioCountForPrice
                                                   , inUserId             := vbUserId
                                                    ) AS tmp;

     -- дописали св-во <Протокол Дата/время начало>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), ioId, vbOperDate_StartBegin);
     -- дописали св-во <Протокол Дата/время завершение>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), ioId, CLOCK_TIMESTAMP());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderExternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
