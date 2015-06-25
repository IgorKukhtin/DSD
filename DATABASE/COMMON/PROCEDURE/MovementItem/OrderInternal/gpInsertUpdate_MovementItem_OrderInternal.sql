-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- 
    IN inCuterCount          TFloat    , -- Количество
 INOUT ioAmount              TFloat    , -- Количество
    IN inCuterCountSecond    TFloat    , -- Количество дозаказ
 INOUT ioAmountSecond        TFloat    , -- Количество дозаказ
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inReceiptId_basis     Integer   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Товар>.';
     END IF;
     -- проверка
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Вид товара>.';
     END IF;
     -- проверка
     IF ioId > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Отключите режим <Показать все товары>.';
     END IF;


     -- поиск
     IF inReceiptId_basis > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = ioId AND MovementItemLinkObject.DescId = zc_MILinkObject_ReceiptBasis())
     vbMovementItemId:= (SELECT
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND (MovementItem.Amount     <> 0 OR MIFloat_AmountSecond.ValueData <> 0)
                           AND MovementItem.isErased   = FALSE)


     -- расчет
     IF inReceiptId_basis > 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId = ioId AND MovementItemLinkObject.DescId = zc_MILinkObject_ReceiptBasis())
     THEN
         -- расчет <Количество>
         SELECT COALESCE (ObjectFloat_Value.ValueData, 0) * inCuterCount
              , COALESCE (ObjectFloat_Value.ValueData, 0) * inCuterCountSecond
                INTO ioAmount, ioAmountSecond
         FROM (SELECT inReceiptId_basis AS ReceiptId) AS tmpReceipt
              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                    ON ObjectFloat_Value.ObjectId = inReceiptId_basis
                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
        ;
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);


     -- сохранили свойство <Количество дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);

     -- сохранили свойство <Количество кутеров>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), ioId, inCuterCount);

     -- сохранили свойство <Количество кутеров дозаказ>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCountSecond(), ioId, inCuterCountSecond);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Рецептуры>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, inReceiptId_basis);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
