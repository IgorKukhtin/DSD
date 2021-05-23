-- Function: gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelService(
 INOUT ioId                   Integer   ,    -- ключ объекта <Модели начисления> 
    IN inCode                 Integer   ,    -- Код объекта
    IN inName                 TVarChar  ,    -- Название объекта
    IN inComment              TVarChar  ,    -- Примечание
    IN inUnitId               Integer   ,    -- Подразделение
    IN inModelServiceKindId   Integer   ,    -- Типы модели начисления
    IN inisTrainee            Boolean   ,    -- ЗП стажеров в общем фонде(да/нет - значит идут как доплата) 	
    IN inSession              TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ModelService());
   vbUserId:= lpGetUserBySession (inSession);


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ModelService()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ModelService(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ModelService(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ModelService(), vbCode_calc, inName);
  
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ModelService_Comment(), ioId, inComment);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_ModelServiceKind(), ioId, inModelServiceKindId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ModelService_Trainee(), ioId, inisTrainee);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
--ALTER FUNCTION gpInsertUpdate_Object_ModelService (Integer,Integer,TVarChar,TVarChar,Integer,Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.19         * inisTrainee
 19.10.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ModelService(0,0,'EREWG', 'ghygjf', 2,6,'2')
