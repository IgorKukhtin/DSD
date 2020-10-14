-- Function: gpUpdate_ConditionsKeep_SetRelatedProduct()

DROP FUNCTION IF EXISTS gpUpdate_ConditionsKeep_SetRelatedProduct(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ConditionsKeep_SetRelatedProduct(
    IN inId	                 Integer   ,    -- ключ объекта <Міжнародна непатентована назва (Соц. проект)> 
    IN inRelatedProductId    Integer   ,    -- Сопутствующие товары
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

   -- сохранили свойство <Сопутствующие товары>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ConditionsKeep_RelatedProduct(), inId, inRelatedProductId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 14.10.18                                                      *
*/

-- тест
-- SELECT * FROM gpUpdate_ConditionsKeep_SetRelatedProduct()
