-- Function: lpInsertUpdate_MovementItem_ReturnIn_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inParentId            Integer   , -- Ключ
    IN inGoodsId             Integer   , -- Товар
    IN inAmount              TFloat    , -- Количество
    IN inMovementId_sale     Integer   , -- 
    IN inMovementItemId_sale Integer   , -- 
    IN inUserId              Integer   , -- пользователь
    IN inIsRightsAll         Boolean     -- 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId, CASE WHEN inIsRightsAll = TRUE THEN -12345 ELSE 0 END);

     -- сохранили свойство <Id документа продажи>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_sale);

     -- сохранили свойство <Id элемента продажи>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMovementItemId_sale);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 27.04.15         * add inMovementId
 11.05.14                                        * change ioCountForPrice
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.04.14                                        * rem создали объект <Связи Товары и Виды товаров>
 14.02.14                                                         * add ioCountForPrice
 13.02.14                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
