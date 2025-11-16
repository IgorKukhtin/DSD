-- Function: gpUpdate_MovementItem_Cash_Personal_SMS (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Cash_Personal_SMS (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Cash_Personal_SMS(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId      Integer   , -- Ключ 
    IN inIsSMS               Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SMS(), inMovementItemId, inIsSMS);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SMS(), inMovementItemId, CURRENT_TIMESTAMP);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.10.25                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Cash_Personal_SMS(ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
