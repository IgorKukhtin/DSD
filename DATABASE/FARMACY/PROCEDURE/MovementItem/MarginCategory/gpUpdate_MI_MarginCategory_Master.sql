-- Function: gpInsertUpdate_MovementItem_MarginCategory_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Master (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Master (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Master(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inisChecked           Boolean   , -- 
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили свойство <для САУЦ>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, inisChecked);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 21.11.17         *
*/

-- тест