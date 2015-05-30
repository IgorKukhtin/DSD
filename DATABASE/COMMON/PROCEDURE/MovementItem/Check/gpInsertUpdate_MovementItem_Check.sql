-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check(Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbAmount TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := inSession;

     -- Находим элемент по документу и товару

     SELECT Id, Amount INTO vbId, vbAmount 
       FROM MovementItem WHERE MovementId = inMovementId AND ObjectId = inGoodsId AND DescId = zc_MI_Master();

     vbAmount := COALESCE(vbAmount, 0) + inAmount;

     -- сохранили <Элемент документа>
     vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Master(), inGoodsId, inMovementId, vbAmount, NULL);

     IF inAmount > 0 THEN
        -- сохранили свойство <Цена>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, inPrice);
     END IF;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.05.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
