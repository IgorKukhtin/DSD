-- Function: gpUpdate_Object_Juridical_isNotTare()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_isNotTare (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_isNotTare(
    IN inId                  Integer   ,  -- ключ объекта <> 
    IN inisNotTare           Boolean   , 
   OUT outisNotTare          Boolean   , 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_NotTare());

   outisNotTare:= NOT inisNotTare;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isNotTare(), inId, outisNotTare);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.01.22         *
*/

-- тест
--