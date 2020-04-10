DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(
    IN inSerial                  TVarChar,      -- �������� ����� ��������
    IN inTaxRate                 TVarChar,      -- ��������� ������
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

  IF COALESCE(vbId, 0) = 0 THEN
    vbId := gpInsertUpdate_Object_CashRegister(0,0,inSerial,vbCashRegisterKindId,CURRENT_DATE,CURRENT_DATE,False,inSession);
  END IF;

  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_TaxRate(), vbId, inTaxRate);

  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_BaseBoardProduct(), vbId, inBaseBoardProduct);
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_ProcessorName(), vbId, inProcessorName);
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_DiskDriveModel(), vbId, inDiskDriveModel);

  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashRegister_PhysicalMemory(), vbId, inPhysicalMemory);

  
  -- ��������� �������� <>
  PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), vbId, False);

  -- ��������� ��������
  PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister_HardwareData(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
08.04.20                                                                      *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CashRegister_HardwareData ('148', '', '', '', '', 0, '3')