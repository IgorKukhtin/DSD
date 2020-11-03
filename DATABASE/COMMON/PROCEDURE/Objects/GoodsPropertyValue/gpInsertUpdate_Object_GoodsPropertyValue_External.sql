-- Function: gpInsertUpdate_Object_GoodsPropertyValue_External()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue_External(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue_External(
    IN inId                  Integer   ,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inArticleExternal     TVarChar  ,    -- Артикул в базе покупателя
    IN inNameExternal        TVarChar  ,    -- Значение ГОСТ, ДСТУ,ТУ (КУ)
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_External());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
  
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_ArticleExternal(), inId, inArticleExternal);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_NameExternal(), inId, inNameExternal);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue_External()

