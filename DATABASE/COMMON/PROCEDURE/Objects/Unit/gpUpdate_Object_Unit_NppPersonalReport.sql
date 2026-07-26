-- Function: gpUpdate_Object_Unit_NppPersonalReport

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_NppPersonalReport (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_NppPersonalReport(
    IN inId                    Integer   , -- ключ объекта <Подразделение>
    IN inNppPersonalReport     TFloat    , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_NppPersonalReport());

   IF inId = 0
   THEN
       RETURN;
   END IF;
   
  
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_NppPersonalReport(), inId, inNppPersonalReport);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.26                                        *            
*/

-- тест
