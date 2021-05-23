--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(
    IN inSerial                  TVarChar,      -- Серийный номер аппарата
    IN inTaxRate                 TVarChar,      -- Налоговые ставки
    IN inIdentifier              TVarChar,      -- Идентификатор
    IN inisLicense               Boolean,       -- Лицензия на ПК
    IN inisSmartphone            Boolean,       -- Смартфон
    IN inisModem                 Boolean,       -- 3G/4G модем
    IN inisBarcodeScanner        Boolean,       -- Сканнер ш/к
    IN inComputerName            TVarChar,      -- Имя компютера
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
  DECLARE vbHardware Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

  
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
    
  -- Сохранили в отчет аппаратной части
  
  vbHardware := gpInsertUpdate_Object_Hardware_HardwareData(inIdentifier        := inIdentifier,
                                                            inisLicense         := inisLicense,
                                                            inisSmartphone      := inisSmartphone,
                                                            inisModem           := inisModem,
                                                            inisBarcodeScanner  := inisBarcodeScanner,
                                                            inComputerName      := inComputerName,
                                                            inBaseBoardProduct  := inBaseBoardProduct,
                                                            inProcessorName     := inProcessorName,
                                                            inDiskDriveModel    := inDiskDriveModel,
                                                            inPhysicalMemory    := inPhysicalMemory,
                                                            inSession           := inSession);

  IF COALESCE(vbId, 0) <> 0 AND
     NOT EXISTS(SELECT
                       ObjectString_ComputerName.ValueData                       AS ComputerName 
                     , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
                     , ObjectString_ProcessorName.ValueData                      AS ProcessorName
                     , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
                     , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory
                     , ObjectBoolean_License.ValueData                           AS isLicense
                     , ObjectBoolean_Smartphone.ValueData                        AS isSmartphone
                     , ObjectBoolean_Modem.ValueData                             AS isМodem
                     , ObjectBoolean_BarcodeScanner.ValueData                    AS isBarcodeScanner

                 FROM Object AS Object_Hardware
                      
                      LEFT JOIN ObjectString AS ObjectString_ComputerName 
                                             ON ObjectString_ComputerName.ObjectId = Object_Hardware.Id
                                            AND ObjectString_ComputerName.DescId = zc_ObjectString_Hardware_ComputerName()
                      LEFT JOIN ObjectString AS ObjectString_BaseBoardProduct 
                                             ON ObjectString_BaseBoardProduct.ObjectId = Object_Hardware.Id
                                            AND ObjectString_BaseBoardProduct.DescId = zc_ObjectString_Hardware_BaseBoardProduct()
                      LEFT JOIN ObjectString AS ObjectString_ProcessorName 
                                             ON ObjectString_ProcessorName.ObjectId = Object_Hardware.Id
                                            AND ObjectString_ProcessorName.DescId = zc_ObjectString_Hardware_ProcessorName()
                      LEFT JOIN ObjectString AS ObjectString_DiskDriveModel 
                                             ON ObjectString_DiskDriveModel.ObjectId = Object_Hardware.Id
                                            AND ObjectString_DiskDriveModel.DescId = zc_ObjectString_Hardware_DiskDriveModel()

                      LEFT JOIN ObjectString AS ObjectString_PhysicalMemory
                                            ON ObjectString_PhysicalMemory.ObjectId = Object_Hardware.Id
                                           AND ObjectString_PhysicalMemory.DescId = zc_ObjectString_Hardware_PhysicalMemory()

                      LEFT JOIN ObjectBoolean AS ObjectBoolean_License
                                              ON ObjectBoolean_License.ObjectId = Object_Hardware.Id
                                             AND ObjectBoolean_License.DescId = zc_ObjectBoolean_Hardware_License()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Smartphone
                                              ON ObjectBoolean_Smartphone.ObjectId = Object_Hardware.Id
                                             AND ObjectBoolean_Smartphone.DescId = zc_ObjectBoolean_Hardware_Smartphone()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Modem
                                              ON ObjectBoolean_Modem.ObjectId = Object_Hardware.Id
                                             AND ObjectBoolean_Modem.DescId = zc_ObjectBoolean_Hardware_Modem()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_BarcodeScanner
                                              ON ObjectBoolean_BarcodeScanner.ObjectId = Object_Hardware.Id
                                             AND ObjectBoolean_BarcodeScanner.DescId = zc_ObjectBoolean_Hardware_BarcodeScanner()
                 WHERE Object_Hardware.Id = vbHardware 
                   AND ((COALESCE(ObjectString_ComputerName.ValueData, '')     <> COALESCE(inComputerName, '')) OR
                        (COALESCE(ObjectString_BaseBoardProduct.ValueData, '') <> COALESCE(inBaseBoardProduct, '')) OR
                        (COALESCE(ObjectString_ProcessorName.ValueData, '')    <> COALESCE(inProcessorName, '')) OR
                        (COALESCE(ObjectString_DiskDriveModel.ValueData , '')  <> COALESCE(inDiskDriveModel, '')) OR
                        (COALESCE(ObjectString_PhysicalMemory.ValueData , '')  <> COALESCE(inPhysicalMemory, '')) OR
                        (COALESCE(ObjectBoolean_License.ValueData , False)     <> COALESCE(inisLicense, False)) OR
                        (COALESCE(ObjectBoolean_Smartphone.ValueData, False)     <> COALESCE(inisSmartphone, False)) OR
                        (COALESCE(ObjectBoolean_Modem.ValueData, False)          <> COALESCE(inisModem, False)) OR
                        (COALESCE(ObjectBoolean_BarcodeScanner.ValueData, False) <> COALESCE(inisBarcodeScanner, False))))
  THEN
  
    -- сохранили связь с <Аппаратная часть с кассой>
    IF COALESCE(vbHardware, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), vbHardware, vbId);
    END IF;
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);
    
    RETURN;
  END IF;


  IF COALESCE(vbId, 0) = 0 THEN
    vbId := gpInsertUpdate_Object_CashRegister(0,0,inSerial,vbCashRegisterKindId,CURRENT_DATE,CURRENT_DATE,False,inSession);
  END IF;

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_TaxRate(), vbId, inTaxRate);

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ComputerName(), vbId, inComputerName);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_BaseBoardProduct(), vbId, inBaseBoardProduct);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ProcessorName(), vbId, inProcessorName);
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_DiskDriveModel(), vbId, inDiskDriveModel);

  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_PhysicalMemory(), vbId, inPhysicalMemory);

  -- сохранили связь с <Аппаратная часть с кассой>
  IF COALESCE(vbHardware, 0) <> 0
  THEN
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), vbHardware, vbId);
  END IF;
  
  -- сохранили свойство <>
  PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);

  -- сохранили протокол
  PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 04.02.21                                                                      *  
 27.01.21                                                                     *  
 08.04.20                                                                     *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CashRegister_HardwareData ('3000061890', '', '', '', '', '', '', '3')