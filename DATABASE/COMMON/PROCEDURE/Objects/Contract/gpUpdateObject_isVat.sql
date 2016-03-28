-- Function: gpUpdateObject_isVat()

DROP FUNCTION IF EXISTS gpUpdateObject_isVat (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_isVat(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisVAT               Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS  Void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract_VAT());

     -- определили признак
     inisVAT:= NOT inisVAT;

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_VAT(), inId, inisVAT);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.03.16         *
*/


-- тест
-- SELECT * FROM gpUpdateObject_isVat (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
