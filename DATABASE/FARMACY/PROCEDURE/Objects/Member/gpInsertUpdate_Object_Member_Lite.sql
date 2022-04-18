-- Function: gpInsertUpdate_Object_Member_Lite()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member_Lite (Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member_Lite(
 INOUT ioId                  Integer   ,    -- ключ объекта <Физические лица> 
    IN inName                TVarChar  ,    -- Название объекта <

    IN inPhone               TVarChar  , 

    IN inPositionID          Integer   ,    -- Должность
    IN inUnitID              Integer   ,    -- Подразделение
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- пытаемся найти код
   IF ioId <> 0  THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (vbCode_calc, zc_Object_Member());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Phone(), ioId, inPhone);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Member_Position(), ioId, inPositionID);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Member_Unit(), ioId, inUnitID);

   -- синхронизируем <Физические лица> и <Сотрудники>
   UPDATE Object SET ValueData = inName, ObjectCode = vbCode_calc
   WHERE Id IN (SELECT ObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Member() AND ChildObjectId = ioId);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.04.22                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Member_Lite()