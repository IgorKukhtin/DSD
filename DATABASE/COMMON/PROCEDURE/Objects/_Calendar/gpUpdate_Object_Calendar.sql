-- Function: gpUpdate_Object_Calendar(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Calendar(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Calendar(
    IN inId                Integer   , -- ключ объекта <Календарь рабочих дней>
    IN inWorking           Boolean   , -- Признак рабочий день
    IN inSession           TVarChar    -- сессия пользователя
   )
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Calendar()());
   vbUserId := inSession;
   
  -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Working(), inId, inWorking);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId); 
   
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Object_Calendar (Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.13         * 
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Calendar (0,  true, '2')