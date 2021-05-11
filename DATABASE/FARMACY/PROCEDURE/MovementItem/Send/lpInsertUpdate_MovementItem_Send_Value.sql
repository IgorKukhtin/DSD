-- Function: lpInsertUpdate_MovementItem_Send_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- сохранили
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_MovementItem_Send (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountManual       := 0  ::TFloat
                                          , inAmountStorage      := 0  ::TFloat
                                          , inReasonDifferencesId:= 0
                                          , inCommentSendID      := 0
                                          , inUserId             := inUserId
                                           ) AS tmp);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 29.07.15                                                                       *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Send_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inUserId:= 2)
