-- Function: gpInsertUpdate_Object_TopicsTestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TopicsTestingTuning (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TopicsTestingTuning(
 INOUT ioId                        Integer,   -- ключ объекта <>
    IN inCode                      Integer,   -- Код объекта
    IN inName                      TVarChar,  -- Название объекта
    IN inSession                   TVarChar   -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TopicsTestingTuning());
   vbUserId := inSession;
  
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_TopicsTestingTuning());

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_TopicsTestingTuning(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TopicsTestingTuning(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TopicsTestingTuning(), vbCode_calc, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.07.21                                                       *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TopicsTestingTuning(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='3')