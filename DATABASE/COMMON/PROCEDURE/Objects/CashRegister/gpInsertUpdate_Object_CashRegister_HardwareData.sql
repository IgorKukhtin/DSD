DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(
    IN inSerial                  TVarChar,      -- Серийный номер аппарата
    IN inTaxRate                 TVarChar,      -- Налоговые ставки
    IN inBaseBoardProduct        TVarChar,      -- Материнская плата
    IN inProcessorName           TVarChar,      -- Процессор
    IN inDiskDriveModel          TVarChar,      -- Жесткий Диск
    IN inPhysicalMemory          TVarChar,      -- Оперативная память, ГБ
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId integer;
  DECLARE vbUserId Integer;
  DECLARE vbCashRegisterKindId integer;
  DECLARE vbCashRegisterKindName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

  vbUserId := inSession;

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
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_TaxRate(), vbId, inTaxRate);

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_BaseBoardProduct(), vbId, inBaseBoardProduct);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ProcessorName(), vbId, inProcessorName);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_DiskDriveModel(), vbId, inDiskDriveModel);

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_PhysicalMemory(), vbId, inPhysicalMemory);

  
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);

  -- сохранили протокол
  PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
08.04.20                                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CashRegister_HardwareData ('148', '', '', '', '', 0, '3')