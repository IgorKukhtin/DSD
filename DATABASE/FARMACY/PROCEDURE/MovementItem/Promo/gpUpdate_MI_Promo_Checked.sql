-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpUpdate_MI_Promo_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Promo_Checked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inIsChecked           Boolean   , -- отмечен
   OUT outIsChecked          Boolean   ,
   OUT outIsReport           Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)

RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
     -- определили признак
     outIsChecked := inIsChecked;
     outIsReport  := NOT outIsChecked;
     

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, outIsChecked);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.11.18         *
*/