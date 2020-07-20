-- Function: gpUpdate_MI_OrderInternalPromo_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromo_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromo_Checked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inisChecked           Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
      
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, inisChecked);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.07.20                                                      *
*/