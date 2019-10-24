-- Function: gpUpdate_Object_Juridical_isBranchAll()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_isBranchAll (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_isBranchAll(
    IN inId                  Integer   ,  -- ключ объекта <> 
    IN inisBranchAll          boolean   , 
   OUT outisBranchAll         boolean   , 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_BranchAll());

   outisBranchAll:= NOT inisBranchAll;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isBranchAll(), inId, outisBranchAll);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.19         *
*/

-- тест
--