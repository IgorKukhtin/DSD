-- Function: gpUpdate_Object_GoodsPropertyValue_AmountDoc()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_AmountDoc(Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_AmountDoc(Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_AmountDoc(Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_AmountDoc(Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_AmountDoc(
    IN inId                  Integer   ,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inAmountDoc           TFloat    ,    -- Количество вложение
    IN inCodeSticker         TVarChar  ,    -- Код PLU
    IN inQuality             TVarChar  ,    -- Значение ГОСТ, ДСТУ,ТУ (КУ)
    IN inQuality2            TVarChar  ,    -- Строк придатності (КУ)
    IN inQuality10           TVarChar  ,    -- Умови зберігання (КУ)
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsPropertyValue_AmountDoc());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
  
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_AmountDoc(), inId, inAmountDoc);
 
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_CodeSticker(), inId, inCodeSticker);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_Quality(), inId, inQuality);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_Quality2(), inId, inQuality2);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_Quality10(), inId, inQuality10);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.19         *
 17.12.18         *
 25.07.18         *
 27.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_GoodsPropertyValue_AmountDoc()

