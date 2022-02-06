-- Function: gpUpdate_ConditionsKeep_isColdSUN()

DROP FUNCTION IF EXISTS gpUpdate_ConditionsKeep_isColdSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ConditionsKeep_isColdSUN(
    IN inId	                 Integer   ,    -- ключ объекта <Міжнародна непатентована назва (Соц. проект)> 
    IN inisColdSUN           Boolean   ,    -- Холод для СУН
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ConditionsKeep());
   vbUserId := inSession;
   
   -- пытаемся найти код
   IF COALESCE(inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Условия хранения не сохрано.';
   END IF;

   -- сохранили свойство <Холод для СУН>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ConditionsKeep_ColdSUN(), inId, not inisColdSUN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 02.02.22                                                      *
*/

-- тест
-- SELECT * FROM gpUpdate_ConditionsKeep_isColdSUN()