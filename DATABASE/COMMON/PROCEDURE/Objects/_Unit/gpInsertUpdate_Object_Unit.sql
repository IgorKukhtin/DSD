-- Function: gpInsertUpdate_Object_Unit()

-- DROP FUNCTION gpInsertUpdate_Object_Unit();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId	                     Integer   ,   	-- ключ объекта <Подразделение>
    IN inCode                    Integer   ,    -- Код объекта <Подразделение>
    IN inName                    TVarChar  ,    -- Название объекта <Подразделение>
    IN inParentId                Integer   ,    -- ссылка на подразделение
    IN inBranchId                Integer   ,    -- ссылка на филиал
    IN inBusinessId              Integer   ,    -- ссылка на бизнес
    IN inJuridicalId             Integer   ,    -- ссылка на Юридические лицо
    IN inAccountDirectionId      Integer   ,    -- ссылка на Аналитики управленческих счетов
    IN inProfitLossDirectionId   Integer ,      -- ссылка на Аналитики статей отчета ПиУ
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;  
   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Unit();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- !!! проверка уникальности для свойства <Наименования Подразделения>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Unit(), inName);
  
   -- проверка уникальности для свойства <Код Подразделения>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), Code_max);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Unit(), Code_max, inName);
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

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, tvarchar)
      OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.13          *              
 13.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
