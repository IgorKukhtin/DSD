-- Function: gpInsertUpdate_Object_PersonalByStorageLine(Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalByStorageLine (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalByStorageLine(
 INOUT ioId                  Integer   , -- ключ объекта <>
    IN inPersonalId          Integer   , -- Сотрудник
    IN inStorageLineId       Integer   , -- Линия производства
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PersonalByStorageLine());
   vbUserId:= lpGetUserBySession (inSession);

    -- проверка
   IF COALESCE (inPersonalId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Сотрудник не выбран.';
   END IF;

   /*
    -- проверка
   IF COALESCE (inStorageLineId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Линия производства не выбрана.';
   END IF;
   */
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PersonalByStorageLine(), 0, '');
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PersonalByStorageLine_Personal(), ioId, inPersonalId);   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PersonalByStorageLine_StorageLine(), ioId, inStorageLineId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.25         * 
*/