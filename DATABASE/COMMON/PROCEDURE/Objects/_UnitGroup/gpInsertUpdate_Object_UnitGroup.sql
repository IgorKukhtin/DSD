-- Function: gpInsertUpdate_Object_UnitGroup()

-- DROP FUNCTION gpInsertUpdate_Object_UnitGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitGroup(
INOUT ioId	         Integer   ,   	-- ключ объекта <Группа подразделений>
IN inCode                Integer   ,    -- Код объекта <Группа подразделений>
IN inName                TVarChar  ,    -- Название объекта <Группа подразделений>
IN inParentId            Integer   ,    -- ссылка на группу подразделений
IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitGroup());

   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UnitGroup(), inName);
   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_UnitGroup_Parent(), inParentId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UnitGroup(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UnitGroup_Parent(), ioId, inParentId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_UnitGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.13                                        * Code Pages

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UnitGroup()
