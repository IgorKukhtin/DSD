-- Function: gpInsertUpdate_MI_ProductionUnion_Master_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master_Sybase (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master_Sybase (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master_Sybase(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inIsPartionClose	     Boolean   , -- партия закрыта (да/нет)
    IN inCount	             TFloat    , -- Количество батонов
    IN inRealWeight          TFloat    , -- Фактический вес(информативно)
    IN inCuterCount          TFloat    , -- Количество кутеров
    IN inPartionGoodsDate    TDateTime , -- Партия товара
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inComment             TVarChar  , -- Примечание
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inReceiptId           Integer   , -- Рецептуры
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());


   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   -- сохранили связь с <Рецептуры>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioId, inReceiptId);

   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Виды товаров ГП>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   -- сохранили свойство <партия закрыта (да/нет)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), ioId, inIsPartionClose);

   -- меняем параметр
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_PartionGoods(), ioId, inPartionGoods);

   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
   -- сохранили свойство <Количество батонов>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount);
   -- сохранили свойство <Фактический вес(информативно)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- сохранили свойство <Количество кутеров>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_CuterCount(), ioId, inCuterCount);

   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- сохранили протокол
   -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master_Sybase (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inIsPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
