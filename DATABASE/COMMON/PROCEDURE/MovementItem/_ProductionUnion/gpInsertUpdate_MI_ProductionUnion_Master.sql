-- Function: gpInsertUpdate_MI_ProductionUnion_Master()

-- DROP FUNCTION gpInsertUpdate_MI_ProductionUnion_Master();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionClose	     Boolean   , -- партия закрыта (да/нет)        	
    IN inComment	         TVarChar  , -- Комментарий	                   
    IN inCount	             TFloat    , -- Количество батонов или упаковок 
    IN inRealWeight	         TFloat    , -- Фактический вес(информативно)   
    IN inCuterCount          TFloat    , -- Количество кутеров	           
    IN inReceiptId           Integer   , -- Рецептуры	                   
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
   vbUserId := inSession;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   -- сохранили связь с <Рецептуры>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioId, inReceiptId);
   -- сохранили свойство <партия закрыта (да/нет)>
   PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_PartionClose(), ioId, inPartionClose);
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
   -- сохранили свойство <Количество батонов или упаковок>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount);
   -- сохранили свойство <Фактический вес(информативно)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- сохранили свойство <Количество кутеров>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_CuterCount(), ioId, inCuterCount);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.13         *              
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
