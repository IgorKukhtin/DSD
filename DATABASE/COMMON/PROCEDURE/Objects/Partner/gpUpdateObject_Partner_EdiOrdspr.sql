-- Function: gpUpdateMovement_Checked()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_EdiOrdspr(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_EdiOrdspr (
    IN ioId                  Integer   , -- Ключ объекта <Документ>
 INOUT inValue               Boolean   , -- Проверен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());

     -- определили признак
     inValue:= NOT inValue;
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiOrdspr(), ioId, inValue);
   
  -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.02.15         * 
*/


-- тест
-- SELECT * FROM gpUpdateObject_Partner_EdiOrdspr (ioId:= 275079, inChecked:= 'False', inSession:= '2')
