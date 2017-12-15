-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoCodeSign_Checked (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoCodeSign_Checked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
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
    inId := lpInsertUpdate_MovementItem (inId, zc_MI_Sign(), 0, inMovementId, (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);

    IF vbIsInsert = TRUE
    THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), inId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inId, CURRENT_TIMESTAMP);
    ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);
    END IF;
          
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 15.12.17         *
*/
--