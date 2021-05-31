-- Function: gpInsertUpdate_Object_Partner_Category()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Category (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner_Category(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inCategory            TFloat    ,    -- категория ТТ    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Category());

   IF COALESCE (inId, 0) = 0 
   THEN 
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;   
   
   -- Проверка
   IF (inCategory <> COALESCE((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inId AND OFl.DescId = zc_ObjectFloat_Partner_Category()), 0))
   AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Partner_Category())
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав заполнять <Категорию ТТ>.';
   END IF;


   -- сохранили свойство <inCategory>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_Category(), inId, inCategory);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.21         *
*/

-- тест
--