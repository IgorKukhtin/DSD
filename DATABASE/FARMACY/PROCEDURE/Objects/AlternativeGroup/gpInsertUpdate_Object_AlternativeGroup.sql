-- Function: gpInsertUpdate_Object_AlternativeGroup (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AlternativeGroup (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AlternativeGroup(
 INOUT ioId                       Integer   ,    -- ключ объекта < группа альтернатив >
    IN inName                     TVarChar  ,    -- Название
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGroup());
   vbUserId := inSession;

   -- проверили корректность названия
   IF COALESCE(inName) = ''
   THEN
     RAISE EXCEPTION 'Ошибка.Название группы не может быть пустым';
   END IF;
   
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AlternativeGroup(), 0, inName);
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AlternativeGroup (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А. А.
 28.06.15                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_AlternativeGroup(0,'Тест','3')

