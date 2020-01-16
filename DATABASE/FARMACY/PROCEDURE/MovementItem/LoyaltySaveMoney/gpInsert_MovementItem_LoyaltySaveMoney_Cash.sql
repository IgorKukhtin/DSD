-- Function: gpInsert_MovementItem_LoyaltySaveMoney_Cash()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_LoyaltySaveMoney_Cash (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_LoyaltySaveMoney_Cash(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBuyerID             Integer   , -- сумма скидки
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Не звыбрана акция.';
    END IF;
    
    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.ObjectId = vbUserId)
    THEN 
      SELECT MovementItem.ID 
      INTO ioId
      FROM MovementItem 
      WHERE MovementItem.MovementId = inMovementId 
        AND MovementItem.ObjectId = vbUserId;
    ELSE

      -- сохранили
      ioId := lpInsertUpdate_MovementItem_LoyaltySaveMoney  (ioId                 := ioId
                                                           , inMovementId         := inMovementId
                                                           , inBuyerID            := inBuyerID
                                                           , inComment            := ''
                                                           , inUnitID             := vbUnitId
                                                           , inUserId             := vbUserId
                                                           );
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.01.20                                                       *
*/