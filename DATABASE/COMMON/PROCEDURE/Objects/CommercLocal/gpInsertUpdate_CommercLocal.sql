-- Function: gpInsertUpdate_Object_CommercLocal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommercLocal(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommercLocal(
 INOUT ioId                    Integer   ,    -- ключ объекта <>
    IN inCode                  Integer   ,    -- Код объекта
    IN inUnitId                Integer   ,    --
    IN inPositionId_1          Integer   ,    --
    IN inPersonalGroupId_1     Integer   ,    --
    IN inPositionId_2          Integer   ,    --
    IN inPersonalGroupId_2     Integer   ,    --
    IN inPositionId_3          Integer   ,    --
    IN inPositionId_4          Integer   ,    --
    IN inPositionId_5          Integer   ,    --
    IN inPositionId_6          Integer   ,    --
    IN inComment               TVarChar  ,    -- Примечание
    IN inSession               TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CommercLocal());
   vbUserId:= lpGetUserBySession (inSession);

   --проверка
   /*IF COALESCE (inUnitId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Параметр <Подразделение> должен быть заполнен.';
   END IF; 
   */

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_CommercLocal());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CommercLocal(), inCode, '', NULL);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CommercLocal_Comment(), ioId, inComment);


   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Unit(), ioId, inUnitId);  
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Position_1(), ioId, inPositionId_1);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_PersonalGroup_1(), ioId, inPersonalGroupId_1);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Position_2(), ioId, inPositionId_2);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_PersonalGroup_2(), ioId, inPersonalGroupId_2);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Position_3(), ioId, inPositionId_3);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Position_4(), ioId, inPositionId_4);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Position_5(), ioId, inPositionId_5);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommercLocal_Position_6(), ioId, inPositionId_6);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 05.06.26         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CommercLocal()