-- Function: gpInsertUpdate_Object_Unit()

-- DROP FUNCTION gpInsertUpdate_Object_Unit();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Подразделение>
    IN inCode                    Integer   ,    -- Код объекта <Подразделение>
    IN inName                    TVarChar  ,    -- Название объекта <Подразделение>
    IN inParentId                Integer   ,    -- ссылка на подразделение
    IN inBranchId                Integer   ,    -- ссылка на филиал
    IN inBusinessId              Integer   ,    -- ссылка на бизнес
    IN inJuridicalId             Integer   ,    -- ссылка на Юридические лицо
    IN inAccountDirectionId      Integer   ,    -- ссылка на Аналитики управленческих счетов
    IN inProfitLossDirectionId   Integer   ,    -- ссылка на Аналитики статей отчета ПиУ
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc := lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Unit(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- проверка цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Unit(), vbCode_calc, inName);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- сохранили связь с <Филиалы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Branch(), ioId, inBranchId);
   -- сохранили связь с <Бизнесы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Business(), ioId, inBusinessId);
   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Аналитики управленческих счетов - направление>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_AccountDirection(), ioId, inAccountDirectionId);
   -- сохранили связь с <Аналитики статей отчета о прибылях и убытках - направление>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_ProfitLossDirection(), ioId, inProfitLossDirectionId);

   -- Установить свойство лист\папка у родителя
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.13          * vbCode_calc              
 13.05.13                                        * rem lpCheckUnique_Object_ValueData
 14.06.13          *              
 16.06.13                                        * COALESCE (MAX (ObjectCode), 0)

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
