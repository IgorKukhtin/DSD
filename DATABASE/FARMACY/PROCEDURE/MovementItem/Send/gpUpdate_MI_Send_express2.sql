-- Function: gpUpdate_MI_Send_express2()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_express2 (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_express2(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;
     
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                 := inId
                                             , inMovementId         := inMovementId
                                             , inGoodsId            := inGoodsId
                                             , inAmount             := inAmount
                                             , inAmountManual       := 0  ::TFloat
                                             , inAmountStorage      := 0  ::TFloat
                                             , inReasonDifferencesId:= 0
                                             , inUserId             := vbUserId
                                              );

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
