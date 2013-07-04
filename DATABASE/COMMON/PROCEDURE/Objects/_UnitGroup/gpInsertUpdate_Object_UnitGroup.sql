-- Function: gpInsertUpdate_Object_UnitGroup()

-- DROP FUNCTION gpInsertUpdate_Object_UnitGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitGroup(
 INOUT ioId	                 Integer   ,   	-- ключ объекта <Группа подразделений>
    IN inCode                Integer   ,    -- Код объекта <Группа подразделений>
    IN inName                TVarChar  ,    -- Название объекта <Группа подразделений>
    IN inParentId            Integer   ,    -- ссылка на группу подразделений
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitGroup());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_UnitGroup();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UnitGroup(), inName);
   -- проверка уникальности для свойства <Код Группы подразделений>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_UnitGroup(), Code_max);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_UnitGroup_Parent(), inParentId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UnitGroup(), Code_max, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UnitGroup_Parent(), ioId, inParentId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_UnitGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.13              
 14.05.13                                        * 1251Cyr

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UnitGroup()
