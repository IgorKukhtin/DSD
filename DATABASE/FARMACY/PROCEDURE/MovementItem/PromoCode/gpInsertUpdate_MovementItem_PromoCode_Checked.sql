-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCode_Checked (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCode_Checked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inIsChecked           Boolean   , -- отмечен
    IN inSession             TVarChar    -- сессия пользователя
)

RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (inId, 0) = 0;
    
    -- сохранили <Элемент документа>
    inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 13.12.17         *
*/