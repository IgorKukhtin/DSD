-- Function: gpInsertUpdate_Object_PersonalGroup(Integer,Integer,TVarChar,TFloat,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_PersonalGroup(Integer,Integer,TVarChar,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalGroup(
 INOUT ioId                       Integer   ,    -- ключ объекта <Группировки Сотрудников> 
    IN inCode                     Integer   ,    -- Код объекта
    IN inName                     TVarChar  ,    -- Название объекта
    IN inWorkHours                TFloat    ,    -- Количество часов
    IN inUnitId                   Integer   ,    -- Подразделение
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PersonalGroup());
   vbUserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalGroup()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PersonalGroup(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalGroup(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PersonalGroup(), vbCode_calc, inName);
  
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PersonalGroup_WorkHours(), ioId, inWorkHours);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalGroup_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_PersonalGroup (Integer,Integer,TVarChar,TFloat,Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PersonalGroup()
