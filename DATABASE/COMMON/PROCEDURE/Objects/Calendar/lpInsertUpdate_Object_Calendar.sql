-- Function: lpInsertUpdate_Object_Calendar(Integer, Boolean, TDateTime, TVarChar,TVarChar )

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Calendar (Integer, Boolean, TDateTime, TVarChar );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Calendar (Integer, Boolean, Boolean, TDateTime, TVarChar );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Calendar (
 INOUT ioId                Integer   , -- ключ объекта <Календарь рабочих дней>
    IN inisWorking         Boolean   , -- Признак рабочий день
    IN inisHoliday         Boolean   , -- Признак праздничный день
    IN inValue             TDateTime , -- Дата
    IN inUserId            TVarChar 
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Calendar());
      vbUserId := inUserId; 
      
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Calendar(), 0, '');
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Working(), ioId, inisWorking);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Holiday(), ioId, inisHoliday);
  
   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Calendar_Value(), ioId, inValue);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.18         *
 27.11.13         * 
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Calendar (0,  true, '12.11.2013')