-- Function: gpInsertUpdate_MovementItem_ContractGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ContractGoods(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inGoodsKindId            Integer   , -- Виды товаров
    IN inAmount                 TFloat    , -- Количество
    IN inPrice                  TFloat    , --
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWeight TFloat;
   DECLARE vbMeasureId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());
 
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_ContractGoods (ioId           := ioId
                                                      , inMovementId   := inMovementId
                                                      , inGoodsId      := inGoodsId
                                                      , inGoodsKindId  := inGoodsKindId
                                                      , inAmount       := inAmount
                                                      , inPrice        := inPrice
                                                      , inComment      := inComment
                                                      , inUserId       := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.21         *
*/

-- тест
--