-- Function: gpUpdateObject_Contract_isVat()

DROP FUNCTION IF EXISTS gpUpdateObject_Contract_isVat (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Contract_isVat(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisVAT               Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_isVAT());

     -- меняется признак
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
-- SELECT * FROM gpUpdateObject_Contract_isVat (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
