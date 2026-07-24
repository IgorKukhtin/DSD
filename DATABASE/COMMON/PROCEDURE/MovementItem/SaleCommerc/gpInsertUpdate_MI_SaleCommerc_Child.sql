-- Function: gpInsertUpdate_MI_SaleCommerc_Child()


DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SaleCommerc_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>   
    IN inParentId            Integer   , -- Ключ
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId             Integer   , -- Товар
    IN inGoodsKindId         Integer   , -- Вид Товар
    IN inAmount              TFloat    , --
    IN inSumm                TFloat    , --
    IN inAmountPromo         TFloat    , --
    IN inSummPromo           TFloat    , --
    IN inAmountNoPromo       TFloat    , --
    IN inSummNoPromo         TFloat    , --
    IN inBonus               TFloat    , --
    IN inPrice               TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleCommerc());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPromo(), ioId, inAmountPromo);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPromo(), ioId, inSummPromo);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNoPromo(), ioId, inAmountNoPromo);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNoPromo(), ioId, inSummNoPromo);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Bonus(), ioId, inBonus);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.26         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_SaleCommerc_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
