-- Function: gpGet_Object_CashRegister()

DROP FUNCTION IF EXISTS gpGet_Object_CashRegister(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashRegister(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CashRegisterKindId Integer, CashRegisterKindName TVarChar
             , SerialNumber TVarChar
             , TimePUSHFinal1 TDateTime, TimePUSHFinal2 TDateTime, TaxRate TVarChar
             , GetHardwareData Boolean, ComputerName TVarChar, BaseBoardProduct TVarChar, ProcessorName TVarChar, DiskDriveModel TVarChar, PhysicalMemory TVarChar
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
           , lfGet_ObjectCode(0, zc_Object_CashRegister()) AS Code
           , CAST ('' as TVarChar)     AS Name

           , CAST (0 as Integer)       AS CashRegisterKindId
           , CAST ('' as TVarChar)     AS CashRegisterKindName

           , CAST ('' as TVarChar)     AS SerialNumber
           , CAST (Null as TDateTime)  AS TimePUSHFinal1
           , CAST (Null as TDateTime)  AS TimePUSHFinal2

           , CAST ('' as TVarChar)     AS TaxRate
           , False                     AS GetHardwareData
           , CAST ('' as TVarChar)     AS ComputerName
           , CAST ('' as TVarChar)     AS BaseBoardProduct
           , CAST ('' as TVarChar)     AS ProcessorName
           , CAST ('' as TVarChar)     AS DiskDriveModel
           , CAST ('' as TVarChar)     AS PhysicalMemory;

   ELSE
       RETURN QUERY
       SELECT
             Object_CashRegister.Id         AS Id
           , Object_CashRegister.ObjectCode AS Code
           , Object_CashRegister.ValueData  AS Name

           , Object_CashRegisterKind.Id          AS CashRegisterKindId
           , Object_CashRegisterKind.ValueData   AS CashRegisterKindName

           , ObjectString_SerialNumber.ValueData     AS SerialNumber
           , ObjectDate_TimePUSHFinal1.ValueData     AS TimePUSHFinal1
           , ObjectDate_TimePUSHFinal2.ValueData     AS TimePUSHFinal2
   
           , ObjectString_TaxRate.ValueData         AS TaxRate
           , COALESCE(ObjectBoolean_GetHardwareData.ValueData, False)  AS GetHardwareData
           , ObjectString_ComputerName.ValueData                       AS ComputerName
           , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
           , ObjectString_ProcessorName.ValueData                      AS ProcessorName
           , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
           , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

       FROM Object AS Object_CashRegister
            LEFT JOIN ObjectLink AS ObjectLink_CashRegister_CashRegisterKind
                                 ON ObjectLink_CashRegister_CashRegisterKind.ObjectId = Object_CashRegister.Id
                                AND ObjectLink_CashRegister_CashRegisterKind.DescId = zc_ObjectLink_CashRegister_CashRegisterKind()
            LEFT JOIN Object AS Object_CashRegisterKind ON Object_CashRegisterKind.Id = ObjectLink_CashRegister_CashRegisterKind.ChildObjectId
            
            LEFT JOIN ObjectString AS ObjectString_SerialNumber 
                                   ON ObjectString_SerialNumber.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_SerialNumber.DescId = zc_ObjectString_CashRegister_SerialNumber()
          
            LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal1 
                                 ON ObjectDate_TimePUSHFinal1.ObjectId = Object_CashRegister.Id
                                AND ObjectDate_TimePUSHFinal1.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal1()

            LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal2 
                                 ON ObjectDate_TimePUSHFinal2.ObjectId = Object_CashRegister.Id
                                AND ObjectDate_TimePUSHFinal2.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal2()

            LEFT JOIN ObjectString AS ObjectString_TaxRate 
                                   ON ObjectString_TaxRate.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_TaxRate.DescId = zc_ObjectString_CashRegister_TaxRate()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_GetHardwareData 
                                    ON ObjectBoolean_GetHardwareData.ObjectId = Object_CashRegister.Id
                                   AND ObjectBoolean_GetHardwareData.DescId = zc_ObjectBoolean_CashRegister_GetHardwareData()

            LEFT JOIN ObjectString AS ObjectString_ComputerName
                                   ON ObjectString_ComputerName.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_ComputerName.DescId = zc_ObjectString_CashRegister_ComputerName()
            LEFT JOIN ObjectString AS ObjectString_BaseBoardProduct 
                                   ON ObjectString_BaseBoardProduct.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_BaseBoardProduct.DescId = zc_ObjectString_CashRegister_BaseBoardProduct()
            LEFT JOIN ObjectString AS ObjectString_ProcessorName 
                                   ON ObjectString_ProcessorName.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_ProcessorName.DescId = zc_ObjectString_CashRegister_ProcessorName()
            LEFT JOIN ObjectString AS ObjectString_DiskDriveModel 
                                   ON ObjectString_DiskDriveModel.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_DiskDriveModel.DescId = zc_ObjectString_CashRegister_DiskDriveModel()

            LEFT JOIN ObjectString AS ObjectString_PhysicalMemory
                                  ON ObjectString_PhysicalMemory.ObjectId = Object_CashRegister.Id
                                 AND ObjectString_PhysicalMemory.DescId = zc_ObjectString_CashRegister_PhysicalMemory()
       WHERE Object_CashRegister.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashRegister(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 04.03.19                                                                      *  
 22.05.15                         *  
*/

-- тест
-- SELECT * FROM gpGet_Object_CashRegister (0, '2')