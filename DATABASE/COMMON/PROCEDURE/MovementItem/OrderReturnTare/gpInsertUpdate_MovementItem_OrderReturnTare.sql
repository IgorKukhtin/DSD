-- Function: gpInsertUpdate_MovementItem_OrderReturnTare()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderReturnTare (Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderReturnTare (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderReturnTare(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inPartnerId              Integer   , -- контрагент
    IN inAmount                 TFloat    , -- Количество
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderReturnTare());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_OrderReturnTare (ioId           := ioId
                                                        , inMovementId   := inMovementId
                                                        , inGoodsId      := inGoodsId
                                                        , inPartnerId    := inPartnerId
                                                        , inAmount       := inAmount
                                                        , inUserId       := vbUserId
                                                         ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.01.22         *
*/

-- тест
--