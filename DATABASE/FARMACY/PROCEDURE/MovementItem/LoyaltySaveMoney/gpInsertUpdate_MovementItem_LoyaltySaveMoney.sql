-- Function: gpInsertUpdate_MovementItem_LoyaltySaveMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LoyaltySaveMoney (Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LoyaltySaveMoney(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBuyerID             Integer   , -- сумма скидки
    IN inComment             TVarChar  , -- повторов
    IN inUnitID              Integer   , -- повторов
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;


    -- сохранили
    ioId := lpInsertUpdate_MovementItem_LoyaltySaveMoney  (ioId                 := ioId
                                                         , inMovementId         := inMovementId
                                                         , inBuyerID            := inBuyerID
                                                         , inComment            := inComment
                                                         , inUnitID             := inUnitID
                                                         , inUserId             := vbUserId
                                                         );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.12.19                                                       *
