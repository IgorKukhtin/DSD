-- Function: gpGet_Object_Hardware()

DROP FUNCTION IF EXISTS gpGet_Object_Hardware(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Hardware(
    IN inId            Integer,       -- ключ объекта <Города>
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Identifier TVarChar
             , UnitId Integer, UnitName TVarChar
             , CashRegisterID Integer, CashRegisterName TVarChar
             , isLicense Boolean, isSmartphone Boolean, isModem Boolean, isBarcodeScanner Boolean, ComputerName TVarChar
             , BaseBoardProduct TVarChar, ProcessorName TVarChar, DiskDriveModel TVarChar, PhysicalMemory TVarChar
             , Comment TVarChar
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_Hardware()) AS Code
           , CAST ('' as TVarChar)     AS Identifier

           , CAST (0 as Integer)       AS UnitId
           , CAST ('' as TVarChar)     AS UnitName

           , CAST (0 as Integer)       AS CashRegisterID
           , CAST ('' as TVarChar)     AS CashRegisterName

           , False                     AS isLicense
           , False                     AS isSmartphone
           , False                     AS isModem
           , False                     AS isBarcodeScanner
           , CAST ('' as TVarChar)     AS ComputerName
           , CAST ('' as TVarChar)     AS BaseBoardProduct

           , CAST ('' as TVarChar)     AS ProcessorName
           , CAST ('' as TVarChar)     AS DiskDriveModel
           , CAST ('' as TVarChar)     AS PhysicalMemory

           , CAST ('' as TVarChar)     AS Comment;
   ELSE
       RETURN QUERY
       SELECT
             Object_Hardware.Id         AS Id
           , Object_Hardware.ObjectCode AS Code
           , CASE WHEN COALESCE(ObjectString_ComputerName.ValueData, '') = '' 
               THEN ''
               ELSE Object_Hardware.ValueData END::TVarChar                            AS Identifier

           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName

           , Object_CashRegister.Id             AS CashRegisterID
           , Object_CashRegister.ValueData      AS CashRegisterName

           , COALESCE(ObjectBoolean_License.ValueData, False)                          AS isLicense
           , COALESCE(ObjectBoolean_Smartphone.ValueData, False)                       AS isSmartphone
           , COALESCE(ObjectBoolean_Modem.ValueData, False)                            AS isModem
           , COALESCE(ObjectBoolean_BarcodeScanner.ValueData, False)                   AS isBarcodeScanner

           , COALESCE(ObjectString_ComputerName.ValueData, Object_Hardware.ValueData)  AS ComputerName
           , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
           , ObjectString_ProcessorName.ValueData                      AS ProcessorName
           , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
           , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

           , ObjectString_Comment.ValueData                            AS Comment

       FROM Object AS Object_Hardware
            LEFT JOIN ObjectLink AS ObjectLink_Hardware_Unit
                                 ON ObjectLink_Hardware_Unit.ObjectId = Object_Hardware.Id
                                AND ObjectLink_Hardware_Unit.DescId = zc_ObjectLink_Hardware_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Hardware_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Hardware_CashRegister
                                 ON ObjectLink_Hardware_CashRegister.ObjectId = Object_Hardware.Id
                                AND ObjectLink_Hardware_CashRegister.DescId = zc_ObjectLink_Hardware_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = ObjectLink_Hardware_CashRegister.ChildObjectId

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

            LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_Hardware.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_Hardware_Comment()
       WHERE Object_Hardware.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Hardware(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 04.02.21                                                                      *  
 27.01.21                                                                      *  
 12.04.20                                                                      *  
*/

-- тест
-- 