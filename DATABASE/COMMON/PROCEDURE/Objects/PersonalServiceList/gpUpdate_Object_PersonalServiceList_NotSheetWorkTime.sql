-- Function: gpUpdate_Object_PersonalServiceList_NotSheetWorkTime()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_NotSheetWorkTime (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_NotSheetWorkTime(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inisNotSheetWorkTime    Boolean   ,     -- 
   OUT outisNotSheetWorkTime   Boolean   ,     --
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_PersonalServiceList_NotSheetWorkTime());

   -- изменили значение
   outisNotSheetWorkTime:= Not inisNotSheetWorkTime;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_NotSheetWorkTime(), inId, outisNotSheetWorkTime);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);    
   

     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION 'Тест. Ок. <%> ', outisNotSheetWorkTime;
     END IF;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.26         *
*/

-- тест
--                       Тест. Ок. <f> 