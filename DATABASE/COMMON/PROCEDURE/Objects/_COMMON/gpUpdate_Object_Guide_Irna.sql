-- Function: gpUpdate_Object_Guide_Irna()

DROP FUNCTION IF EXISTS gpUpdate_Object_Guide_Irna (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Guide_Irna(
    IN inId                  Integer   , --
    IN inisIrna              Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Guide_Irna());
     vbUserId:= lpGetUserBySession (inSession);

     -- меняется признак
     inisIrna:= NOT inisIrna;

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Guide_Irna(), inId, inisIrna);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.22         *
*/


-- тест
--