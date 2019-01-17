-- Function: gpUpdate_Object_Maker_SendPlan ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_SendPlan (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_SendPlan(
    IN inId              Integer  ,     -- ключ объекта <Производитель>
    IN inSendPlan        TDateTime,     -- Когда планируем отправить(дата/время)
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendPlan(), inId, inSendPlan);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.01.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Maker()