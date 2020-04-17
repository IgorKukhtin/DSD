--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(
    IN inSerial                  TVarChar,      -- �������� ����� ��������
    IN inTaxRate                 TVarChar,      -- ��������� ������
    IN inComputerName            TVarChar,      -- ��� ���������
    IN inBaseBoardProduct        TVarChar,      -- ����������� �����
    IN inProcessorName           TVarChar,      -- ���������
    IN inDiskDriveModel          TVarChar,      -- ������� ����
    IN inPhysicalMemory          TVarChar,      -- ����������� ������, ��
    IN inSession                 TVarChar       -- ������ ������������
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
   -- �������� ���� ������������ �� ����� ���������
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
    
  -- ��������� � ����� ���������� �����
  
  vbHardware := gpInsertUpdate_Object_Hardware_HardwareData(inComputerName      := inComputerName,
                                                            inBaseBoardProduct  := inBaseBoardProduct,
                                                            inProcessorName     := inProcessorName,
                                                            inDiskDriveModel    := inDiskDriveModel,
                                                            inPhysicalMemory    := inPhysicalMemory,
                                                            inSession           := inSession);

  IF COALESCE(vbId, 0) <> 0 AND
     NOT EXISTS(SELECT
                   ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
                 , ObjectString_ProcessorName.ValueData                      AS ProcessorName
                 , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
                 , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

             FROM Object AS Object_CashRegister
                  
                  LEFT JOIN ObjectString AS ObjectString_TaxRate 
                                         ON ObjectString_TaxRate.ObjectId = Object_CashRegister.Id
                                        AND ObjectString_TaxRate.DescId = zc_ObjectString_CashRegister_TaxRate()

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
                                       
             WHERE Object_CashRegister.Id = vbId 
               AND ((COALESCE(ObjectString_TaxRate.ValueData, '') <> COALESCE(inTaxRate, '')) OR
                    (COALESCE(ObjectString_ComputerName.ValueData, '') <> COALESCE(inComputerName, '')) OR
                    (COALESCE(ObjectString_ProcessorName.ValueData, '') <> COALESCE(inProcessorName, '')) OR
                    (COALESCE(ObjectString_DiskDriveModel.ValueData , '') <> COALESCE(inDiskDriveModel, '')) OR
                    (COALESCE(ObjectString_PhysicalMemory.ValueData , '') <> COALESCE(inPhysicalMemory, ''))))
  THEN
  
    -- ��������� ����� � <���������� ����� � ������>
    IF COALESCE(vbHardware, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), vbHardware, vbId);
    END IF;
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);
    
    RETURN;
  END IF;


  IF COALESCE(vbId, 0) = 0 THEN
    vbId := gpInsertUpdate_Object_CashRegister(0,0,inSerial,vbCashRegisterKindId,CURRENT_DATE,CURRENT_DATE,False,inSession);
  END IF;

  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_TaxRate(), vbId, inTaxRate);

  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ComputerName(), vbId, inComputerName);
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_BaseBoardProduct(), vbId, inBaseBoardProduct);
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ProcessorName(), vbId, inProcessorName);
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_DiskDriveModel(), vbId, inDiskDriveModel);

  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_PhysicalMemory(), vbId, inPhysicalMemory);

  -- ��������� ����� � <���������� ����� � ������>
  IF COALESCE(vbHardware, 0) <> 0
  THEN
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), vbHardware, vbId);
  END IF;
  
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);

  -- ��������� ��������
  PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
08.04.20                                                                      *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CashRegister_HardwareData ('3000061890', '', '', '', '', '', '', '3')