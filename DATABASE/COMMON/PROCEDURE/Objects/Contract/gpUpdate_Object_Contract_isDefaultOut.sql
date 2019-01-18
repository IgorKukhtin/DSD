-- Function: gpUpdateObject_Contract_isVat()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_isDefaultOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_isDefaultOut(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisDefaultOut        Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

     -- меняется признак
     inisDefaultOut:= NOT inisDefaultOut;

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_DefaultOut(), inId, inisDefaultOut);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.16         *
*/


-- тест
-- SELECT * FROM gpUpdate_Object_Contract_isDefaultOut (inId:= 275079, inisDefaultOut:= 'False', inSession:= '2')
