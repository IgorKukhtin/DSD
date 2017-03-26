-- Function: gpInsertUpdate_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StoreReal (Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_StoreReal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StoreReal());
	    
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_StoreReal (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := inAmount
                                                , inGoodsKindId        := inGoodsKindId
                                                , inUserId             := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 25.03.17         *
*/

-- тест
-- 