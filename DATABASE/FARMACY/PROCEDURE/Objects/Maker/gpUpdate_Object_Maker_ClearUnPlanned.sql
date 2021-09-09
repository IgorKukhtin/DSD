-- Function: gpUpdate_Object_Maker_ClearUnPlanned (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_ClearUnPlanned (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_ClearUnPlanned(
    IN inId                  Integer  ,     -- ключ объекта <Производитель>
    IN inSession             TVarChar       -- сессия пользователя
)
 RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSendPlan TDateTime;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Maker_UnPlanned(), inId, False);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.09.21                                                       *
 
*/

-- тест
-- select * from gpUpdate_Object_Maker_ClearUnPlanned(inId := 3605302 , inSession := '3');