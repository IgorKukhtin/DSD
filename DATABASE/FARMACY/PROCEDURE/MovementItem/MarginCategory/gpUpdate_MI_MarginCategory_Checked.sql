-- Function: gpUpdate_MI_MarginCategory_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Checked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inIsChecked           Boolean  , -- 
   OUT outisChecked          Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- определили признак
     outisChecked:= NOT inIsChecked;


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, inisChecked);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 24.11.17         *
*/

-- тест