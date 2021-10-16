-- Function: gpInsert_MovementItem_TechnicalRediscountMasc()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_TechnicalRediscountMasc(Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_TechnicalRediscountMasc(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TechnicalRediscount());
     
     IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.ObjectId = inGoodsId AND MovementItem.MovementId = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка. Товар уже использован в техническом переучете.';     
     END IF;

     ioId := lpInsertUpdate_MovementItem_TechnicalRediscount(0, inMovementId, inGoodsId, inAmount, 0, '', '', False, vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.02.15                        *
*/

-- тест
-- SELECT * FROM gpInsert_MovementItem_TechnicalRediscountMasc (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')ementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')