-- Function: gpInsertUpdate_Object_RouteTT()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RouteTT(Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RouteTT(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RouteTT(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inCode                Integer   ,    -- Код объекта
    IN inName                TVarChar  ,    -- Название объекта 
    IN inUnitId              Integer   ,    --
    IN inPersonalId          Integer   ,    --
    IN inPositionId          Integer   ,    --
    IN inPersonalGroupId     Integer   ,    --
    IN inComment             TVarChar  ,    -- Примечание
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_RouteTT());
   vbUserId:= lpGetUserBySession (inSession);

   --проверка
   -- все поля должны быть заполнены, разрешить не заполнять только Personal, если выбрали Personal - автоматом заполнили ТОЛЬКО должность + PersonalGroup
   IF COALESCE (inUnitId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Параметр <Подразделение> должен быть заполнен.';
   END IF;

   IF COALESCE (inPositionId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Параметр <Должность> должен быть заполнен.';
   END IF;

   IF COALESCE (inPersonalGroupId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Параметр <Группа Сотрудников> должен быть заполнен.';
   END IF;
   
   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_RouteTT());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RouteTT(), inCode, inName, NULL);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_RouteTT_Comment(), ioId, inComment);


   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RouteTT_Unit(), ioId, inUnitId);  
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RouteTT_Personal(), ioId, inPersonalId);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RouteTT_Position(), ioId, inPositionId);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RouteTT_PersonalGroup(), ioId, inPersonalGroupId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 21.05.26         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RouteTT()