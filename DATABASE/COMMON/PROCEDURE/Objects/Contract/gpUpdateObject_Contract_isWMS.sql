-- Function: gpUpdate_Object_Contract_isWMS()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_isWMS (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_isWMS(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisWMS               Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_isWMS());

     -- меняется признак
     inisWMS:= NOT inisWMS;

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_isWMS(), inId, inisWMS);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.20         *
*/


-- тест
-- SELECT * FROM gpUpdate_Object_Contract_isWMS (ioId:= 275079, inisWMS:= 'False', inSession:= '2')
