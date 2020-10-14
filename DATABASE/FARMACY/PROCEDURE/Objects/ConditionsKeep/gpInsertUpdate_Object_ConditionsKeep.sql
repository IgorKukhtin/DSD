-- Function: gpInsertUpdate_Object_ConditionsKeep()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ConditionsKeep(Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ConditionsKeep(
 INOUT ioId	                 Integer   ,    -- ключ объекта <Міжнародна непатентована назва (Соц. проект)> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <>
    IN inRelatedProductId    Integer   ,    -- Сопутствующие товары
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ConditionsKeep());
   vbUserId := inSession;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ConditionsKeep());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ConditionsKeep(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ConditionsKeep(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ConditionsKeep(), vbCode_calc, inName);

   -- сохранили свойство <Сопутствующие товары>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ConditionsKeep_RelatedProduct(), ioId, inRelatedProductId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 14.10.18                                                      *
 07.01.17         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ConditionsKeep()
