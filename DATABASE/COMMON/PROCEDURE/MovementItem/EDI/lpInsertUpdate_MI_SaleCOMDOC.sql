-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SaleCOMDOC(Integer, Integer, Integer, TFloat, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SaleCOMDOC(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , 
    IN inGoodsKindId         Integer   , -- Товар
    IN inAmountPartner       TFloat    , -- Количество
    IN inPricePartner        TFloat      -- Цена
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbMovementItemId Integer;
BEGIN

     vbMovementItemId := COALESCE((SELECT Id  
       FROM MovementItem 
       JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  AND MILinkObject_GoodsKind.ObjectId = inGoodsKindId
  LEFT JOIN MovementItemFloat AS MIFloat_Price
                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.ObjectId = inGoodsId
        AND MovementItem.DescId = zc_MI_Master() 
        AND ((MIFloat_Price.ValueData = inPricePartner) OR (COALESCE(inPricePartner,0) = 0))
         ), 0);

     IF COALESCE(vbMovementItemId, 0) = 0 THEN 
        -- сохранили <Элемент документа>
        vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
        -- сохранили связь с <Виды товаров>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, inGoodsKindId);
     END IF;
     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, inAmountPartner);
     IF COALESCE(inPricePartner, 0) <> 0 THEN
        -- сохранили свойство <Цена>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPricePartner);
     END IF; 
     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
