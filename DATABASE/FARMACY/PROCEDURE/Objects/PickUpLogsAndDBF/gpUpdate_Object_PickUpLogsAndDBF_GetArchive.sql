-- Function: gpUpdate_Object_PickUpLogsAndDBF_GetArchive()

DROP FUNCTION IF EXISTS gpUpdate_Object_PickUpLogsAndDBF_GetArchive (Integer, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PickUpLogsAndDBF_GetArchive(
    IN inId                      Integer   ,   	-- ключ объекта <>
 INOUT ioisGetArchive            Boolean   ,   	-- Получить и архив логов
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF COALESCE(inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Запись не сохранена.';
   END IF;
   
   ioisGetArchive := not ioisGetArchive;

   -- сохранили связь с <Получить и архив логов>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_GetArchive(), inId, ioisGetArchive);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.01.22                                                       *
*/

-- тест
-- 
