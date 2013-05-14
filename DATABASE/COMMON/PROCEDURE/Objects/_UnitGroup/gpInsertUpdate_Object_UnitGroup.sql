-- Function: gpInsertUpdate_Object_UnitGroup()

-- DROP FUNCTION gpInsertUpdate_Object_UnitGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitGroup(
INOUT ioId	         Integer   ,   	/* ключ объекта <Группа подразделений> */
IN inCode                Integer   ,    /* Код объекта <Группа подразделений> */
IN inName                TVarChar  ,    /* Название объекта <Группа подразделений> */
IN inUnitGroupId         Integer   ,    /* ссылка на группу подразделений */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitGroup());

   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UnitGroup(), inName);
   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_UnitGroup_Parent(), inUnitGroupId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UnitGroup(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UnitGroup_Parent(), ioId, inUnitGroupId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_UnitGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;

  
                            