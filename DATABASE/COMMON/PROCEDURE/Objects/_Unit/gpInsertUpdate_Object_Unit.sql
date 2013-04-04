-- Function: gpInsertUpdate_Object_Unit()

-- DROP FUNCTION gpInsertUpdate_Object_Unit();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
INOUT ioId	         Integer   ,   	/* ключ объекта <Подразделение> */
IN inCode                Integer   ,    /* Код объекта <Подразделение> */
IN inName                TVarChar  ,    /* Название объекта <Подразделение> */
IN inUnitGroupId         Integer   ,    /* ссылка на группу подразделений */
IN inBranchId            Integer   ,    /* ссылка на филиал */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitGroup());

   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Unit(), inName);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Unit(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitGroup(), ioId, inUnitGroupId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Branch(), ioId, inBranchId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, tvarchar)
  OWNER TO postgres;

  
                            