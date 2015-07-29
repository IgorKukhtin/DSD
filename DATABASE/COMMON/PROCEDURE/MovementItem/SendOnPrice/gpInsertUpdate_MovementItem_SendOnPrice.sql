-- Function: gpInsertUpdate_MovementItem_SendOnPrice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean,Boolean, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendOnPrice(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество

 INOUT ioAmountPartner           TFloat    , -- Количество у контрагента
   OUT outAmountChangePercent    TFloat    , -- Количество c учетом % скидки (!!!расчет!!!)
    IN inChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из грида!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из грида!!!)
    IN inIsChangePercentAmount   Boolean   , -- Признак - будет ли использоваться из контрола <% скидки для кол-ва>
    IN inIsCalcAmountPartner     Boolean   , -- Признак - будет ли расчитано <Количество у контрагента>

    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inUnitId              Integer   , -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice());

     -- !!!из контрола!!! - % скидки для кол-ва
     IF inIsChangePercentAmount = TRUE
     THEN
         IF EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Measure_Kg())
         THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!из контрола!!!
         ELSE ioChangePercentAmount:= 0;
         END IF;
     END IF;

     -- !!!расчет!!! - Количество c учетом % скидки
     outAmountChangePercent:= CAST (inAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));

     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner:= outAmountChangePercent;
     END IF;


     -- сохранили
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_SendOnPrice
                                            (ioId                := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := ioAmountPartner
                                          , inAmountChangePercent:= outAmountChangePercent
                                          , inChangePercentAmount:= inChangePercentAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inUnitId             := inUnitId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.06.15         * add inUnitId
 05.05.14                                                        * надо раскоментить права после отладки
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 05.09.13                                        * add zc_MIFloat_ChangePercentAmount
 12.07.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
