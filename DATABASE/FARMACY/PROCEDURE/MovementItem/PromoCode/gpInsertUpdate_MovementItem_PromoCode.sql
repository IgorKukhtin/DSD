-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCode (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCode (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCode(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inIsChecked           Boolean   , -- отмечен
    IN inComment             TVarChar  , -- примечание
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    
    -- сохранили
    ioId := lpInsertUpdate_MovementItem_PromoCode (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat
                                                 , inComment            := inComment
                                                 , inUserId             := vbUserId
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 13.12.17         *
*/