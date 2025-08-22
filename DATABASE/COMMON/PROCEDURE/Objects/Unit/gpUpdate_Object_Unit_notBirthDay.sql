-- Function: gpUpdate_Object_Unit_notBirthDay

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_notBirthDay (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_notBirthDay(
    IN inId                    Integer   , -- ключ объекта <Подразделение>
    IN inisnotBirthDay         Boolean   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_notBirthDay());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- меняется признак
   inisnotBirthDay:= NOT inisnotBirthDay;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_notBirthDay(), inId, inisnotBirthDay);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.25         *            
*/

-- тест
-- 