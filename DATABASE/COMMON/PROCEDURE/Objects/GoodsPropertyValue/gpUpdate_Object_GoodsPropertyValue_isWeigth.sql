-- Function: gpUpdate_Object_GoodsPropertyValue_isWeigth()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsPropertyValue_isWeigth(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsPropertyValue_isWeigth(
    IN inId             Integer,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inisWeigth       Boolean,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbisWeigth  Boolean;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
  
   vbisWeigth := NOT inisWeigth;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsPropertyValue_Weigth(), inId, vbisWeigth);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19         *
*/

-- тест
-- 