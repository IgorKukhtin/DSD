-- Function: gpInsertUpdate_Object_JuridicalGroup()

-- DROP FUNCTION gpInsertUpdate_Object_JuridicalGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalGroup(
 INOUT ioId	                 Integer   ,   	-- ключ объекта <Группа юр лиц>
    IN inCode                Integer   ,    -- Код объекта <Группа юр лиц>
    IN inName                TVarChar  ,    -- Название объекта <Группа юр лиц>
    IN inParentId            Integer   ,    -- ссылка на группу юр лиц
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalGroup());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_JuridicalGroup();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- Проверем уникальности для свойства <Название Группы юр лиц>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_JuridicalGroup(), inName);
   -- проверка прав уникальности для свойства <Код Группы юр лиц>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalGroup(), Code_max);
   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_JuridicalGroup_Parent(), inParentId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_JuridicalGroup(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalGroup_Parent(), ioId, inParentId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_JuridicalGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.13          *
 14.05.13                                        * Code Pages

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalGroup()
