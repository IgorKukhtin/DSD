-- Function: lpUpdate_MI_ProductionUnion_RealDelicMsg()

DROP FUNCTION IF EXISTS lpUpdate_MI_ProductionUnion_RealDelicMsg  (Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_ProductionUnion_RealDelicMsg(
    IN inId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inAmount                 TFloat    , -- Количество 
    IN inCount                  TFloat    , -- Количество батонов 
    IN inUserId                 Integer     -- пользователя
)                              
RETURNS Integer
AS
$BODY$
BEGIN
   -- проверка
   IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() AND Movement.StatusId = zc_Enum_Status_Complete() WHERE MI.Id = inId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
   THEN
       RAISE EXCEPTION 'Ошибка. Партия производства <%> не найдена.', inId;
   END IF;

   -- сохранили свойство <взвешивание п/ф факт после шприцевания>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightMsg(), inId, inAmount + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_RealWeightMsg()), 0));

   -- сохранили свойство <Количество батонов>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), inId, inCount + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_Count()), 0));

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, inUserId, FALSE);

   -- 
   RETURN inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.11.20                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_ProductionUnion_RealDelicMsg (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
