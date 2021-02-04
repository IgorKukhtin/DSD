-- Function: gpInsertUpdate_Object_Hardware()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Hardware(
 INOUT ioId                     Integer   ,     -- ���� ������� <�����>
    IN inCode                   Integer   ,     -- ��� �������
    IN inIdentifier             TVarChar  ,     -- �������������
    IN inisLicense              Boolean   ,     -- �������� �� ��
    IN inisSmartphone           Boolean   ,     -- ��������
    IN inisModem                Boolean   ,     -- 3G/4G �����
    IN inisBarcodeScanner       Boolean   ,     -- ������� �/�
    IN inUnitId                 Integer   ,     -- �������������
    IN inCashRegisterID         Integer   ,     -- �������������
    IN inComputerName           TVarChar  ,     -- ��� ���������
    IN inBaseBoardProduct       TVarChar  ,     -- ����������� �����
    IN inProcessorName          TVarChar  ,     -- ���������
    IN inDiskDriveModel         TVarChar  ,     -- ������� ����
    IN inPhysicalMemory         TVarChar  ,     -- ����������� ������
    IN inComment                TVarChar  ,     -- ����������
    IN inSession                TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Hardware());
   vbUserId := inSession;

   IF COALESCE (inUnitId, 0) = 0
   THEN
      RAISE EXCEPTION '������. �� ����������� �������������...';
   END IF;

   IF COALESCE (TRIM(inIdentifier), '') = ''
   THEN
      RAISE EXCEPTION '������. �� ��������� <�������������>...';
   END IF;

   IF COALESCE (inComputerName, '') = ''
   THEN
      RAISE EXCEPTION '������. �� ��������� <��� ���������>...';
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Hardware());

   -- �������� ������������ ��� �������� <������������> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Hardware(), inIdentifier);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Hardware(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Hardware(), vbCode_calc, inIdentifier);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_Unit(), ioId, inUnitId);
  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), ioId, inCashRegisterID);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ComputerName(), ioId, inComputerName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_BaseBoardProduct(), ioId, inBaseBoardProduct);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ProcessorName(), ioId, inProcessorName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_DiskDriveModel(), ioId, inDiskDriveModel);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_PhysicalMemory(), ioId, inPhysicalMemory);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_License(), ioId, inisLicense);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_Smartphone(), ioId, inisSmartphone);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_Modem(), ioId, inisModem);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Hardware_BarcodeScanner(), ioId, inisBarcodeScanner);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Hardware (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.   ������ �.�.
 04.02.21                                                                      *  
 27.01.21                                                                      *  
 12.04.20                                                                      *  
*/

-- ����
-- select * from gpInsertUpdate_Object_Hardware(ioId := 16211199 , inCode := 159 , inIdentifier := '2222' , inisLicense := 'True' , inisSmartphone := 'False' , inisModem := 'False' , inisBarcodeScanner := 'False' , inUnitId := 183292 , inCashRegisterId := 522458 , inComputerName := 'AMBERPHARMACY' , inBaseBoardProduct := 'Ginkgo 7A1' , inProcessorName := 'Intel(R) Core(TM) i7-4702MQ CPU @ 2.20GHz' , inDiskDriveModel := 'ST1000LM024 HN-M101MBB 1000 ��' , inPhysicalMemory := 'DDR3 16 �� 1600 ���' , inComment := '' ,  inSession := '3');