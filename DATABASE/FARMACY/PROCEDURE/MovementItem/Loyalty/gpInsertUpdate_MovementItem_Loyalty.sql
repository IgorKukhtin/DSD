-- Function: gpInsertUpdate_MovementItem_Loyalty()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loyalty (Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loyalty(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- сумма скидки
    IN inCount               Integer   , -- повторов
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    
    -- сохранили
    ioId := lpInsertUpdate_MovementItem_Loyalty  (ioId                 := ioId
                                                , inMovementId         := inMovementId
                                                , inAmount             := inAmount
                                                , inCount              := inCount
                                                , inUserId             := vbUserId
                                                );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.11.19                                                       *
*/