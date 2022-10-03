-- Function: gpInsertUpdate_MovementItem_Sale_Partner()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale_Partner(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmountPartner       TFloat    , -- Количество у контрагента
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная 
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inHeadCount           TFloat    , -- Количество голов
    IN inBoxCount            TFloat    , -- Количество ящиков
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inBoxId               Integer   , -- Ящики 
   OUT outGoodsRealCode      Integer  , -- Товар (факт отгрузка)
   OUT outGoodsRealName      TVarChar  , -- Товар (факт отгрузка)
   OUT outGoodsKindRealName  TVarChar  , -- Вид товара (факт отгрузка)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale_Partner());

     -- Проверка, т.к. эти параметры менять нельзя
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND Amount <> 0 AND isErased = FALSE)
     THEN
         IF NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_CurrencyDocument() AND ObjectId <> zc_Enum_Currency_Basis())
        AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_CurrencyPartner() AND ObjectId <> zc_Enum_Currency_Basis())
        AND NOT EXISTS (SELECT MovementItem.Id
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        WHERE MovementItem.Id = ioId
                          AND MovementItem.ObjectId = inGoodsId
                          AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                          AND (COALESCE (MIFloat_Price.ValueData, 0) = COALESCE (ioPrice, 0)
                            OR vbUserId = 12120 -- Нагорнова Т.С. !!!временно!!!
                              )
                       )
         THEN
             RAISE EXCEPTION 'Ошибка.Нет прав корректировать <Элемент>.';
         END IF;
     END IF;

     -- сохранили
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
          , tmp.outGoodsRealCode, tmp.outGoodsRealName, tmp.outGoodsKindRealName
            INTO ioId, ioCountForPrice, outAmountSumm
               , outGoodsRealCode, outGoodsRealName, outGoodsKindRealName
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId AND DescId = zc_MI_Master()), 0)
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountChangePercent()), 0)
                                          , inChangePercentAmount:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_ChangePercentAmount()), 0)
                                          , ioPrice              := ioPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inCount              := inCount
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          , inCountPack          := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_CountPack()), 0)
                                          , inWeightTotal        := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_WeightTotal()), 0)
                                          , inWeightPack         := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_WeightPack()), 0)
                                          , inIsBarCode          := COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE MovementItemId = ioId AND DescId = zc_MIBoolean_BarCode()), FALSE)
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.07.22         * inCount
 10.10.14                                                       * add box
 19.05.14                                        * add COALESCE
 19.05.14                                        * add COALESCE
 08.02.14                                        * была ошибка с lpInsertUpdate_MovementItem_Sale
 04.02.14                        * add lpInsertUpdate_MovementItem_Sale
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 02.09.13                                        * add zc_MIFloat_ChangePercentAmount
 13.08.13                                        * add RAISE EXCEPTION
 09.07.13                                        * add IF inGoodsId <> 0
 18.07.13         * add inAssetId
 13.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale_Partner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, ioPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
