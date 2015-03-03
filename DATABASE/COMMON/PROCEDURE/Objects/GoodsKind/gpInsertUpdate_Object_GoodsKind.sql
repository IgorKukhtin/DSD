-- Function: gpInsertUpdate_Object_GoodsKind()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKind(
 INOUT ioId	                 Integer   ,   	-- ключ объекта < Тип товара> 
    IN inCode                Integer   ,    -- Код объекта <Тип товара> 
    IN inName                TVarChar  ,    -- Название объекта <Тип товара>
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;  
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsKind());

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_GoodsKind();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Типа Товара>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsKind(), inName);
   -- проверка прав уникальности для свойства <Код Типа Товара>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKind(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKind(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);   

END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
  
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
 00.06.13          
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsKind()
                          