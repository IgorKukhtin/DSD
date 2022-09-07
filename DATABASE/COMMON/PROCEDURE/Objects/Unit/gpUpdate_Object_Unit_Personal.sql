-- Function: gpUpdate_Object_Unit_Personal

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_Personal (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_Personal(
    IN inId                    Integer   , -- ключ объекта <Подразделение>
    IN inPersonalServiceDate   TDateTime , -- 
    IN inisPersonalService     Boolean   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_Personal());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PersonalService(), inId, inisPersonalService);
   -- сохранили свойство <>
   --PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_PersonalService(), inId, inPersonalServiceDate);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.09.22         *            
*/

-- тест
--