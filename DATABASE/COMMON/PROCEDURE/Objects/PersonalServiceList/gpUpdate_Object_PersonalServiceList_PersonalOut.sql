-- Function: gpUpdate_Object_PersonalServiceList_PersonalOut()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_PersonalOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_PersonalOut(
    IN inId                    Integer   ,     -- ключ объекта <> 
    IN inisPersonalOut         Boolean   ,     -- 
   OUT outisPersonalOut        Boolean   ,     --
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_PersonalOut());

   -- изменили значение
   outisPersonalOut:= Not inisPersonalOut;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_PersonalOut(), inId, outisPersonalOut);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.20         *
*/

-- тест
--