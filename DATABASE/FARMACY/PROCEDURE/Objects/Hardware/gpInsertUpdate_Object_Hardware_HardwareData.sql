--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Hardware_HardwareData(
    IN inIdentifier              TVarChar,      -- �������������
    IN inisLicense               Boolean,       -- �������� �� ��
    IN inComputerName            TVarChar,      -- ��� ���������
    IN inBaseBoardProduct        TVarChar,      -- ����������� �����
    IN inProcessorName           TVarChar,      -- ���������
    IN inDiskDriveModel          TVarChar,      -- ������� ����
    IN inPhysicalMemory          TVarChar,      -- ����������� ������
   OUT outId                     INTEGER,       -- ID ������
    IN inSession                 TVarChar       -- ������ ������������
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
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
  vbUserId:= lpGetUserBySession (inSession);
  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
     vbUnitKey := '0';
  END IF;
  vbUnitId := vbUnitKey::Integer;

  IF COALESCE (vbUnitId, 0) = 0
  THEN
     RAISE EXCEPTION '������. �� ���������� �������������...';
  END IF;

  IF COALESCE (TRIM(inIdentifier), '') = ''
  THEN
     RAISE EXCEPTION '������. �� �������� �������������...';
  END IF;

  IF COALESCE (inComputerName, '') = ''
  THEN
     RAISE EXCEPTION '������. �� �������� �������������...';
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
                 WHERE Object_Hardware.Id = outId 
                   AND ((COALESCE(Object_Hardware.ValueData, '')     <> COALESCE(inIdentifier, '')) OR
                        (COALESCE(ObjectString_ComputerName.ValueData, '')     <> COALESCE(inComputerName, '')) OR
                        (COALESCE(ObjectString_BaseBoardProduct.ValueData, '') <> COALESCE(inBaseBoardProduct, '')) OR
                        (COALESCE(ObjectString_ProcessorName.ValueData, '')    <> COALESCE(inProcessorName, '')) OR
                        (COALESCE(ObjectString_DiskDriveModel.ValueData , '')  <> COALESCE(inDiskDriveModel, '')) OR
                        (COALESCE(ObjectString_PhysicalMemory.ValueData , '')  <> COALESCE(inPhysicalMemory, '')) OR
                        (COALESCE(ObjectBoolean_License.ValueData , False)     <> COALESCE(inisLicense, False))))
  THEN
    RETURN;
  END IF;

   -- �������� ����� ���
   IF outId <> 0 AND COALESCE (vbCode, 0) = 0 THEN vbCode := (SELECT ObjectCode FROM Object WHERE Id = outId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (COALESCE (vbCode, 0), zc_Object_Hardware());

   -- �������� ������������ ��� �������� <������������> 
   PERFORM lpCheckUnique_Object_ValueData (outId, zc_Object_Hardware(), inIdentifier);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (outId, zc_Object_Hardware(), vbCode_calc);

   -- ��������� <������>
   outId := lpInsertUpdate_Object (outId, zc_Object_Hardware(), vbCode_calc, inIdentifier);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_Unit(), outId, vbUnitId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ComputerName(), outId, inComputerName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_BaseBoardProduct(), outId, inBaseBoardProduct);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ProcessorName(), outId, inProcessorName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_DiskDriveModel(), outId, inDiskDriveModel);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_PhysicalMemory(), outId, inPhysicalMemory);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_License(), outId, inisLicense);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (outId, vbUserId); 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Hardware_HardwareData(TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 27.01.21                                                                      *  
 12.04.20                                                                      *  
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Hardware_HardwareData ('1111', False, 'WIN-S8MBP09GQ4T', '', '', '', '', '3')
