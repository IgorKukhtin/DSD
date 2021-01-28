-- Function: lpInsertUpdate_MovementItem_Income20202()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income20202 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income20202(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inPartionNumStart     TFloat    , -- Начальный № для Партии товара
    IN inPartionNumEnd       TFloat    , -- Последний № для Партии товара
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNumStart(), ioId, inPartionNumStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNumEnd(), ioId, inPartionNumEnd);


     IF vbIsInsert = FALSE AND EXISTS (SELECT MovementItemString.MovementItemId FROM MovementItemString WHERE MovementItemString.ValueData = inPartionGoods AND MovementItemString.MovementItemId = ioId AND MovementItemString.DescId = zc_MIString_PartionGoodsCalc())
     THEN
         -- сохранили свойство <Партия товара>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, '');
     ELSE
         -- сохранили свойство <Партия товара>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
     END IF;

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Основные средства (для которых закупается ТМЦ)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- создали объект <Связи Товары и Виды товаров>
     PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.01.21         * 20202
 29.05.15                                        * set lp
 11.05.14                                        * add lpInsert_MovementItemProtocol
 06.10.13                                        * add lfCheck_Movement_Parent
 29.09.13                                        * add recalc inCountForPrice
 12.07.13          * lpInsertUpdate_MovementFloat_TotalSumm было lpInsertUpdate_MovementFloat_Income_TotalSumm    
 07.07.13                                        * add lpInsertUpdate_MovementFloat_Income_TotalSumm
 07.07.13                                        * add lpInsert_Object_GoodsByGoodsKind
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Income20202 (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
