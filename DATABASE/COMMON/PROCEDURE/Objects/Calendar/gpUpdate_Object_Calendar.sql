-- Function: gpUpdate_Object_Calendar(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Calendar(Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Calendar(Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Calendar(
    IN inId                Integer   , -- ключ объекта <Календарь рабочих дней>
    IN inisWorking         Boolean   , -- Признак рабочий день
    IN inisHoliday         Boolean   , -- Признак рабочий день
    IN inSession           TVarChar    -- сессия пользователя
   )
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Calendar());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Working(), inId, inisWorking);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Holiday(), inId, inisHoliday);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId); 
   return 0;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.18         *
 28.11.13         * 
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Calendar (0,  true, '2')
