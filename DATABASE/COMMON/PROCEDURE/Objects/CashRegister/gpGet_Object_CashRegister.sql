-- Function: gpGet_Object_CashRegister()

DROP FUNCTION IF EXISTS gpGet_Object_CashRegister(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashRegister(
    IN inId          Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CashRegisterKindId Integer, CashRegisterKindName TVarChar
             , SerialNumber TVarChar
             , TimePUSHFinal1 TDateTime, TimePUSHFinal2 TDateTime
             , GetHardwareData Boolean, BaseBoardProduct TVarChar, ProcessorName TVarChar, DiskDriveModel TVarChar, PhysicalMemoryCapacity TFloat
) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
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

           , False                     AS GetHardwareData
           , CAST ('' as TVarChar)     AS BaseBoardProduct
           , CAST ('' as TVarChar)     AS ProcessorName
           , CAST ('' as TVarChar)     AS DiskDriveModel
           , CAST (Null as TFloat)     AS PhysicalMemoryCapacity;

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

           , COALESCE(ObjectBoolean_GetHardwareData.ValueData, False)  AS GetHardwareData
           , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
           , ObjectString_ProcessorName.ValueData                      AS ProcessorName
           , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
           , ObjectFloat_PhysicalMemoryCapacity.ValueData              AS PhysicalMemoryCapacity

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

            LEFT JOIN ObjectBoolean AS ObjectBoolean_GetHardwareData 
                                    ON ObjectBoolean_GetHardwareData.ObjectId = Object_CashRegister.Id
                                   AND ObjectBoolean_GetHardwareData.DescId = zc_ObjectBoolean_CashRegister_GetHardwareData()

            LEFT JOIN ObjectString AS ObjectString_BaseBoardProduct 
                                   ON ObjectString_BaseBoardProduct.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_BaseBoardProduct.DescId = zc_ObjectString_CashRegister_BaseBoardProduct()
            LEFT JOIN ObjectString AS ObjectString_ProcessorName 
                                   ON ObjectString_ProcessorName.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_ProcessorName.DescId = zc_ObjectString_CashRegister_ProcessorName()
            LEFT JOIN ObjectString AS ObjectString_DiskDriveModel 
                                   ON ObjectString_DiskDriveModel.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_DiskDriveModel.DescId = zc_ObjectString_CashRegister_DiskDriveModel()

            LEFT JOIN ObjectFloat AS ObjectFloat_PhysicalMemoryCapacity
                                  ON ObjectFloat_PhysicalMemoryCapacity.ObjectId = Object_CashRegister.Id
                                 AND ObjectFloat_PhysicalMemoryCapacity.DescId = zc_ObjectFloat_CashRegister_PhysicalMemoryCapacity()
       WHERE Object_CashRegister.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashRegister(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 04.03.19                                                                      *  
 22.05.15                         *  
*/

-- ����
-- SELECT * FROM gpGet_Object_CashRegister (0, '2')