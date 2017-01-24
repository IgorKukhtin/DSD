-- Function: gpUpdate_MI_Over_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_Over_Amount  (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Over_Amount(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили <Элемент документа>
   PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

   --сохраняем значение строки-чайлд
   PERFORM lpInsertUpdate_MovementItem (ioId           :=  MI.Id
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := MI.ObjectId
                                      , inMovementId   := inMovementId
                                      , inAmount       := 0
                                      , inParentId     := inId
                                      , inUserId       := vbUserId
                                        )
   FROM MovementItem AS MI 
   WHERE MI.MovementId = inMovementId 
     AND MI.ParentId = inId 
     AND MI.DescId = zc_MI_Child() 
     AND MI.isErased = False;

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.01.17         *
*/

-- тест
-- select * from gpUpdate_MI_Over_Amount(ioId := 38654751 , inMovementId := 2333564 , inGoodsId := 361056 ,  inSession := '3');

