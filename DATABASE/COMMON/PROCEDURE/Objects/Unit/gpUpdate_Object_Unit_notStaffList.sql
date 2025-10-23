-- Function: gpUpdate_Object_Unit_notStaffList

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_notStaffList (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_notStaffList(
    IN inId                    Integer   , -- ключ объекта <Подразделение>
    IN inisnotStaffList        Boolean   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_notStaffList());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- меняется признак
   inisnotStaffList:= NOT inisnotStaffList;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_notStaffList(), inId, inisnotStaffList);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.25         *            
*/

-- тест
-- 