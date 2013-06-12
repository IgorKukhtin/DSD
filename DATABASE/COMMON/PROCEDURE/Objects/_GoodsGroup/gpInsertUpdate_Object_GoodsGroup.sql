-- Function: gpInsertUpdate_Object_GoodsGroup()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId	                 Integer   ,   	-- ключ объекта <Группа товаров>
    IN inCode                Integer   ,    -- Код объекта <Группа товаров>
    IN inName                TVarChar  ,    -- Название объекта <Группа товаров>
    IN inParentId            Integer   ,    -- ссылка на группу товаров
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer; 
   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
  UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_GoodsGroup();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Группы товаров>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsGroup(), inName);
   -- проверка прав уникальности для свойства <Код Группы товаров>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), Code_max);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_GoodsGroup_Parent(), inParentId);
   
   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroup(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup()
