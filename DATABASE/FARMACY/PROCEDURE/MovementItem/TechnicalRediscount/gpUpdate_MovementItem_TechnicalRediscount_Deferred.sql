-- Function: gpUpdate_MovementItem_TechnicalRediscount_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_TechnicalRediscount_Deferred(Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_TechnicalRediscount_Deferred(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- Количество
    IN inisDeferred          Boolean   , -- Отложено в кассе
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TechnicalRediscount());


     IF COALESCE(inAmount, 0) >= 0 and COALESCE (inisDeferred, FALSE) = FALSE OR COALESCE (inId, 0) = 0
     THEN
       RETURN;
     END IF;
     
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Deferred(), inId, not inisDeferred);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.02.15                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_TechnicalRediscount_Deferred (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')