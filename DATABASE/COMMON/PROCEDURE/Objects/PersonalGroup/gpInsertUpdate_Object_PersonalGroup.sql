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
   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT PersonalGroupId FROM Object_PersonalGroup_View WHERE PersonalGroupName = inName AND UnitId = inUnitId);
   -- END IF;
   
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PersonalGroup());
   vbUserId:= lpGetUserBySession (inSession);


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalGroup()); 
   
   -- проверка  уникальности для свойств: <Наименование> + <Подразделение>
   IF EXISTS (SELECT PersonalGroupName FROM Object_PersonalGroup_View WHERE PersonalGroupName = inName AND UnitId = inUnitId AND PersonalGroupId <> COALESCE(ioId, 0)) THEN
      RAISE EXCEPTION 'Значение <%> для подразделения: <%> не уникально в справочнике <%>.', inName, (SELECT ValueData FROM Object WHERE Id = inUnitId), (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalGroup());
   END IF; 

   -- проверка уникальности для свойства <Код>
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
 21.11.13                                        * add проверка уникальности для свойств
 09.10.13                                        * пытаемся найти код
 30.09.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PersonalGroup()
