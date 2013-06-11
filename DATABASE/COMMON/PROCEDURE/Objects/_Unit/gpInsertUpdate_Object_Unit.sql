-- Function: gpInsertUpdate_Object_Unit()

-- DROP FUNCTION gpInsertUpdate_Object_Unit();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
INOUT ioId	         Integer   ,   	-- ключ объекта <Подразделение>
IN inCode                Integer   ,    -- Код объекта <Подразделение>
IN inName                TVarChar  ,    -- Название объекта <Подразделение>
IN inParentId            Integer   ,    -- ссылка на подразделение
IN inBranchId            Integer   ,    -- ссылка на филиал
IN inBusinessId          Integer   ,    -- ссылка на бизнес
IN inJuridicalId         Integer   ,    -- ссылка на Юридические лицо
IN inAccountDirectionId  Integer   ,    -- ссылка на Аналитики управленческих счетов
IN inProfitLossDirectionId Integer ,    -- ссылка на Аналитики статей отчета ПиУ
IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitGroup());

   -- !!! -- Проверем уникальность имени
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Unit(), inName);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Unit(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Branch(), ioId, inBranchId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Business(), ioId, inBusinessId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_AccountDirection(), ioId, inAccountDirectionId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_ProfitLossDirection(), ioId, inProfitLossDirectionId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, tvarchar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
