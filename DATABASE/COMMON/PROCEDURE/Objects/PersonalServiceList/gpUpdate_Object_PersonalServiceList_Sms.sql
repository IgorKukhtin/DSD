-- Function: gpUpdate_Object_PersonalServiceList_Sms()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_Sms (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_Sms(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inisSms                 Boolean   ,     -- 
   OUT outisSms                Boolean   ,     --
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_Sms());

   -- изменили значение
   outisSms:= Not inisSms;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Sms(), inId, outisSms);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок.';
   END IF;   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.25         *
*/

-- тест
--