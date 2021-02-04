--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Hardware_HardwareData(
    IN inIdentifier              TVarChar,      -- Идентификатор
    IN inisLicense               Boolean,       -- Лицензия на ПК
    IN inisSmartphone            Boolean   ,     -- Смартфон
    IN inisModem                 Boolean   ,     -- 3G/4G модем
    IN inisBarcodeScanner        Boolean   ,     -- Сканнер ш/к
    IN inComputerName            TVarChar,      -- Имя компютера
    IN inBaseBoardProduct        TVarChar,      -- Материнская плата
    IN inProcessorName           TVarChar,      -- Процессор
    IN inDiskDriveModel          TVarChar,      -- Жесткий Диск
    IN inPhysicalMemory          TVarChar,      -- Оперативная память
   OUT outId                     INTEGER,       -- ID записи
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
  vbUserId:= lpGetUserBySession (inSession);
  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
     vbUnitKey := '0';
  END IF;
  vbUnitId := vbUnitKey::Integer;

  IF COALESCE (vbUnitId, 0) = 0
  THEN
     RAISE EXCEPTION 'Ошибка. Не определено подразделение...';
  END IF;

  IF COALESCE (TRIM(inIdentifier), '') = ''
  THEN
     RAISE EXCEPTION 'Ошибка. Не заполнен идентификатор...';
  END IF;

  IF COALESCE (inComputerName, '') = ''
  THEN
     RAISE EXCEPTION 'Ошибка. Не заполнен идентификатор...';
  END IF;

  SELECT Object.Id, Object.ObjectCode 
  INTO outId, vbCode
  FROM Object
  WHERE Object.DescId = zc_Object_Hardware()
    AND Object.ValueData = inIdentifier;
    
    
  IF COALESCE(outId, 0) = 0
  THEN 
    SELECT Object.Id, Object.ObjectCode 
    INTO outId, vbCode
    FROM Object
         INNER JOIN ObjectLink AS ObjectLink_Hardware_Unit
                               ON ObjectLink_Hardware_Unit.ObjectId = Object.Id
                              AND ObjectLink_Hardware_Unit.ChildObjectId = vbUnitId
         LEFT JOIN ObjectString AS ObjectString_ComputerName 
                                ON ObjectString_ComputerName.ObjectId = Object.Id
                               AND ObjectString_ComputerName.DescId = zc_ObjectString_Hardware_ComputerName()
    WHERE Object.DescId = zc_Object_Hardware()
      AND COALESCE(ObjectString_ComputerName.ValueData, Object.ValueData) = inComputerName;    
  END IF;
    
  IF COALESCE(outId, 0) <> 0 AND
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
                 WHERE Object_Hardware.Id = outId 
                   AND ((COALESCE(Object_Hardware.ValueData, '')     <> COALESCE(inIdentifier, '')) OR
                        (COALESCE(ObjectString_ComputerName.ValueData, '')       <> COALESCE(inComputerName, '')) OR
                        (COALESCE(ObjectString_BaseBoardProduct.ValueData, '')   <> COALESCE(inBaseBoardProduct, '')) OR
                        (COALESCE(ObjectString_ProcessorName.ValueData, '')      <> COALESCE(inProcessorName, '')) OR
                        (COALESCE(ObjectString_DiskDriveModel.ValueData , '')    <> COALESCE(inDiskDriveModel, '')) OR
                        (COALESCE(ObjectString_PhysicalMemory.ValueData , '')    <> COALESCE(inPhysicalMemory, '')) OR
                        (COALESCE(ObjectBoolean_License.ValueData , False)       <> COALESCE(inisLicense, False)) OR
                        (COALESCE(ObjectBoolean_Smartphone.ValueData, False)     <> COALESCE(inisSmartphone, False)) OR
                        (COALESCE(ObjectBoolean_Modem.ValueData, False)          <> COALESCE(inisModem, False)) OR
                        (COALESCE(ObjectBoolean_BarcodeScanner.ValueData, False) <> COALESCE(inisBarcodeScanner, False))))
  THEN
    RETURN;
  END IF;

   -- пытаемся найти код
   IF outId <> 0 AND COALESCE (vbCode, 0) = 0 THEN vbCode := (SELECT ObjectCode FROM Object WHERE Id = outId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (COALESCE (vbCode, 0), zc_Object_Hardware());

   -- проверка уникальности для свойства <Наименование> 
   PERFORM lpCheckUnique_Object_ValueData (outId, zc_Object_Hardware(), inIdentifier);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (outId, zc_Object_Hardware(), vbCode_calc);

   -- сохранили <Объект>
   outId := lpInsertUpdate_Object (outId, zc_Object_Hardware(), vbCode_calc, inIdentifier);

  -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_Unit(), outId, vbUnitId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ComputerName(), outId, inComputerName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_BaseBoardProduct(), outId, inBaseBoardProduct);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ProcessorName(), outId, inProcessorName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_DiskDriveModel(), outId, inDiskDriveModel);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_PhysicalMemory(), outId, inPhysicalMemory);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_License(), outId, inisLicense);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_Smartphone(), outId, inisSmartphone);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_Modem(), outId, inisModem);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_BarcodeScanner(), outId, inisBarcodeScanner);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Hardware_Update(), outId, CURRENT_TIMESTAMP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (outId, vbUserId); 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 04.02.21                                                                      *  
 27.01.21                                                                      *  
 12.04.20                                                                      *  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Hardware_HardwareData ('1111', False, 'WIN-S8MBP09GQ4T', '', '', '', '', '3')

select * from gpInsertUpdate_Object_CashRegister_HardwareData(inSerial := '' , inTaxRate := '' , inIdentifier := '2222' , inisLicense := 'True' , inisSmartphone := 'True' , inisModem := 'True' , inisBarcodeScanner := 'True' , inComputerName := 'AMBERPHARMACY' , inBaseBoardProduct := 'Ginkgo 7A1' , inProcessorName := 'Intel(R) Core(TM) i7-4702MQ CPU @ 2.20GHz' , inDiskDriveModel := 'ST1000LM024 HN-M101MBB 1000 ГБ' , inPhysicalMemory := 'DDR3 16 ГБ 1600 МГц' ,  inSession := '3');