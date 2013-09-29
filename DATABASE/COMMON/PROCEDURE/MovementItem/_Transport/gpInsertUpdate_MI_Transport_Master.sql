-- Function: gpInsertUpdate_MI_Transport_Master()

-- DROP FUNCTION gpInsertUpdate_MI_Transport_Master();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inRouteId             Integer   , -- Маршрут
    IN inWeight	             TFloat    , -- Вес груза
    IN inFreightId           Integer   , -- Название груза
    IN inRouteKindId         Integer   , -- Типы маршрутов
                       
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Transport());
   vbUserId := inSession;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, , NULL);
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Freight(), ioId, inFreightId);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RouteKind(), ioId, inRouteKindId);
  
   -- сохранили свойство <ВЕС ГРУЗА>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Weight(), ioId, inWeight);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
