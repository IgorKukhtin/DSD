DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(
    IN inSerial                  TVarChar,      -- Серийный номер аппарата
    IN inBaseBoardProduct        TVarChar,      -- Материнская плата
    IN inProcessorName           TVarChar,      -- Процессор
    IN inDiskDriveModel          TVarChar,      -- Жесткий Диск
    IN inPhysicalMemoryCapacity  TFloat,      -- Оперативная память, ГБ
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbId integer;
  DECLARE vbCashRegisterKindId integer;
  DECLARE vbCashRegisterKindName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

  vbCashRegisterKindName := 'Datecs FP 3141';
  Select Id INTO vbCashRegisterKindId
  from Object
  Where
    DescId = zc_Object_CashRegisterKind()
    AND
    ValueData = vbCashRegisterKindName;

  Select
    Id INTO vbId
  from
    Object
  Where
    DescId = zc_Object_CashRegister()
    AND
    ValueData = inSerial;

  IF COALESCE(vbId, 0) = 0 THEN
    vbId := gpInsertUpdate_Object_CashRegister(0,0,inSerial,vbCashRegisterKindId,CURRENT_DATE,CURRENT_DATE,False,inSession);
  END IF;

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_BaseBoardProduct(), vbId, inBaseBoardProduct);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ProcessorName(), vbId, inProcessorName);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_DiskDriveModel(), vbId, inDiskDriveModel);

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity(), vbId, inPhysicalMemoryCapacity);

  
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
08.04.20                                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CashRegister_HardwareData ('002', '2')