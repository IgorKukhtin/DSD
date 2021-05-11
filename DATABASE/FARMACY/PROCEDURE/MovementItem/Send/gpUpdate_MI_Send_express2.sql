-- Function: gpUpdate_MI_Send_express2()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_express2 (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Send_express2 (Integer, Integer, Integer, TFloat,  TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_express2(
     IN inId                  Integer   , -- Ключ объекта <Элемент документа>
     IN inMovementId          Integer   , -- Ключ объекта <Документ>
     IN inGoodsId             Integer   , -- Товары
     IN inAmount              TFloat    , -- Количество

  INOUT ioAmountExcess        TFloat,  -- факт. излишек с учетом перемещения (от кого)
  INOUT ioAmountNeed          TFloat,  -- факт. потребность с учетом перемещения (кому)
  INOUT ioAmountSend_out      TFloat,  -- Перемещ. расх. (ожидается)   - 1-ый грид
  INOUT ioAmountSend_in       TFloat,  -- Перемещ. приход. (ожидается) - 2-ый грид
  
    IN inSession             TVarChar    -- пользователь
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount     Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;
     
     -- получаем сохраненное значение
     vbAmount := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inId);
     
     -- проверка переместить можно не больше чем есть
     inAmount := (CASE WHEN COALESCE (ioAmountExcess,0) + COALESCE (vbAmount,0) < inAmount THEN COALESCE (ioAmountExcess,0) + COALESCE (vbAmount,0) ELSE inAmount END) :: TFloat;
     
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                 := inId
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := inGoodsId
                                             , inAmount             := inAmount
                                             , inAmountManual       := 0  ::TFloat
                                             , inAmountStorage      := 0  ::TFloat
                                             , inReasonDifferencesId:= 0
                                             , inCommentSendID      := 0
                                             , inUserId             := vbUserId
                                              );

     -- рассчитываем данные для 1-го и 2-го грида (убираем из учета предыдущее значение, и учитываем только текущее)
     ioAmountNeed     := (COALESCE (ioAmountNeed,0)     - COALESCE (inAmount,0) + COALESCE (vbAmount,0)) ::TFloat;
     ioAmountExcess   := (COALESCE (ioAmountExcess,0)   - COALESCE (inAmount,0) + COALESCE (vbAmount,0)) ::TFloat;
     ioAmountSend_out := (COALESCE (ioAmountSend_out,0) + COALESCE (inAmount,0) - COALESCE (vbAmount,0)) ::TFloat;
     ioAmountSend_in  := (COALESCE (ioAmountSend_in,0)  + COALESCE (inAmount,0) - COALESCE (vbAmount,0)) ::TFloat;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  15.04.20        *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Send_express2 (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inUserId:= 2)
