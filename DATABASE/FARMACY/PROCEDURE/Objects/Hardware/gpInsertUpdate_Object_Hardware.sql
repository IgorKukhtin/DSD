-- Function: gpInsertUpdate_Object_Hardware()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware (Integer, Integer, TVarChar, Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Hardware(
 INOUT ioId                     Integer   ,     -- ключ объекта <Город>
    IN inCode                   Integer   ,     -- Код объекта
    IN inIdentifier             TVarChar  ,     -- Идентификатор
    IN inisLicense              Boolean   ,     -- Лицензия на ПК
    IN inUnitId                 Integer   ,     -- Подразделение
    IN inCashRegisterID         Integer   ,     -- Подразделение
    IN inComputerName           TVarChar  ,     -- Имя компютера
    IN inBaseBoardProduct       TVarChar  ,     -- Материнская плата
    IN inProcessorName          TVarChar  ,     -- Процессор
    IN inDiskDriveModel         TVarChar  ,     -- Жесткий Диск
    IN inPhysicalMemory         TVarChar  ,     -- Оперативная память
    IN inComment                TVarChar  ,     -- Примечание
    IN inSession                TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Hardware());
   vbUserId := inSession;

   IF COALESCE (inUnitId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Не установлено подразделение...';
   END IF;

   IF COALESCE (TRIM(inIdentifier), '') = ''
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено <Идентификатор>...';
   END IF;

   IF COALESCE (inComputerName, '') = ''
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено <Имя компютера>...';
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Hardware());

   -- проверка уникальности для свойства <Наименование> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Hardware(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Hardware(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Hardware(), vbCode_calc, inIdentifier);

  -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_Unit(), ioId, inUnitId);
  -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), ioId, inCashRegisterID);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ComputerName(), outId, inComputerName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_BaseBoardProduct(), ioId, inBaseBoardProduct);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ProcessorName(), ioId, inProcessorName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_DiskDriveModel(), ioId, inDiskDriveModel);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_PhysicalMemory(), ioId, inPhysicalMemory);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_License(), outId, inisLicense);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Hardware (Integer, Integer, TVarChar, Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.   Шаблий О.В.
 27.01.21                                                                      *  
 12.04.20                                                                      *  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Hardware(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='3')