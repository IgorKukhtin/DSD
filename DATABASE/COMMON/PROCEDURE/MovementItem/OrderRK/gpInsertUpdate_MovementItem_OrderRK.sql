-- Function: gpInsertUpdate_MovementItem_OrderRK()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderRK (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderRK(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inGoodsKindId            Integer   , -- Виды товаров
    IN inAmount                 TFloat    , -- Количество кг
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWeight TFloat;
   DECLARE vbMeasureId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderRK());
 
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_OrderRK (ioId           := ioId
                                                , inMovementId   := inMovementId
                                                , inGoodsId      := inGoodsId
                                                , inGoodsKindId  := inGoodsKindId
                                                , inAmount       := inAmount
                                                , inUserId       := vbUserId
                                                 ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
*/

-- тест
--