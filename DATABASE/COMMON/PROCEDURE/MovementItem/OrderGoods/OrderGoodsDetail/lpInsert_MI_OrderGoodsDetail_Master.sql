-- Function: lpInsert_MI_OrderGoodsDetail_Master()
DROP FUNCTION IF EXISTS lpInsert_MI_OrderGoodsDetail_Master (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_MI_OrderGoodsDetail_Master(
    IN inId                        Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                Integer   , -- Ключ объекта
    IN inParentId                  Integer   , -- 
    IN inObjectId                  Integer   , -- Товары
    IN inGoodsKindId               Integer   , 
    IN inAmount                    TFloat    , -- Количество кг
    IN inAmountForecast            TFloat    , -- Количество шт
    IN inAmountForecastOrder       TFloat    , --
    IN inAmountForecastPromo       TFloat    , --
    IN inAmountForecastOrderPromo  TFloat    , --
    IN inUserId                    Integer     -- сессия пользователя                                                
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbId_child Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- сохранили <Элемент документа>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inObjectId, inMovementId, inAmount, NULL); --inParentId

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecast(), inId, inAmountForecast);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecastOrder(), inId, inAmountForecastOrder);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecastPromo(), inId, inAmountForecastPromo);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecastOrderPromo(), inId, inAmountForecastOrderPromo);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
--