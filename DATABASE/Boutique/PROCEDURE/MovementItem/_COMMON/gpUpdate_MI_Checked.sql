-- Function: gpUpdate_MI_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MI_Checked (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Checked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inisChecked           Boolean  , -- 
   OUT outisChecked          Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale()); --lpGetUserBySession (inSession);

     -- определили признак
     outisChecked:= NOT inisChecked;


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), inId, outisChecked);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.03.18         *
*/

-- тест