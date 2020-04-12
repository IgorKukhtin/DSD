DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Hardware_HardwareData(
    IN inComputerName            TVarChar,      -- Имя компютера
    IN inBaseBoardProduct        TVarChar,      -- Материнская плата
    IN inProcessorName           TVarChar,      -- Процессор
    IN inDiskDriveModel          TVarChar,      -- Жесткий Диск
    IN inPhysicalMemory          TVarChar,      -- Оперативная память
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId integer;
  DECLARE vbCode integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
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

  SELECT Object.Id, Object.ObjectCode 
  INTO vbId, vbCode
  FROM Object
       INNER JOIN ObjectLink AS ObjectLink_Hardware_Unit
                             ON ObjectLink_Hardware_Unit.ObjectId = Object.Id
                            AND ObjectLink_Hardware_Unit.ChildObjectId = vbUnitId
  WHERE Object.DescId = zc_Object_Hardware()
    AND Object.ValueData = inComputerName;
    
  IF COALESCE(vbId, 0) <> 0 AND
     EXISTS(SELECT
                   ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
                 , ObjectString_ProcessorName.ValueData                      AS ProcessorName
                 , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
                 , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

             FROM Object AS Object_Hardware
                  
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
             WHERE Object_Hardware.Id = vbId 
               AND ((COALESCE(ObjectString_BaseBoardProduct.ValueData, '') <> COALESCE(inBaseBoardProduct, '')) OR
                    (COALESCE(ObjectString_ProcessorName.ValueData, '') <> COALESCE(inProcessorName, '')) OR
                    (COALESCE(ObjectString_DiskDriveModel.ValueData , '') <> COALESCE(inDiskDriveModel, '')) OR
                    (COALESCE(ObjectString_PhysicalMemory.ValueData , '') <> COALESCE(inPhysicalMemory, ''))))
  THEN
    RETURN;
  END IF;

  vbId := gpInsertUpdate_Object_Hardware(vbId,vbCode,inComputerName,vbUnitId,inBaseBoardProduct,inProcessorName,inDiskDriveModel,inPhysicalMemory,inSession);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 12.04.20                                                                      *  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Hardware_HardwareData ('148', '', '', '', '', 0, '3')