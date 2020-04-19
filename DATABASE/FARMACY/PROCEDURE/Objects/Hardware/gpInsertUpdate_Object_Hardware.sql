-- Function: gpInsertUpdate_Object_City()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Hardware (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Hardware(
 INOUT ioId                     Integer   ,     -- ���� ������� <�����>
    IN inCode                   Integer   ,     -- ��� �������
    IN inName                   TVarChar  ,     -- �������� �������
    IN inUnitId                 Integer   ,     -- �������������
    IN inCashRegisterID         Integer   ,     -- �������������
    IN inBaseBoardProduct       TVarChar ,      -- ����������� �����
    IN inProcessorName          TVarChar ,      -- ���������
    IN inDiskDriveModel         TVarChar ,      -- ������� ����
    IN inPhysicalMemory         TVarChar ,      -- ����������� ������
    IN inIdentifier             TVarChar ,      -- �������������
    IN inComment                TVarChar ,      -- ����������
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

   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION '������. �� ��������� <��� ���������>...';
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Hardware());

   -- �������� ������������ ��� �������� <������������> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Hardware(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Hardware(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Hardware(), vbCode_calc, inName);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_Unit(), ioId, inUnitId);
  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Hardware_CashRegister(), ioId, inCashRegisterID);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_BaseBoardProduct(), ioId, inBaseBoardProduct);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_ProcessorName(), ioId, inProcessorName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_DiskDriveModel(), ioId, inDiskDriveModel);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_PhysicalMemory(), ioId, inPhysicalMemory);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_Identifier(), ioId, inIdentifier);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Hardware_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Hardware (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.   ������ �.�.
 12.04.20                                                                      *  
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Hardware(ioId:=null, inCode:=null, inName:='������ 1', inSession:='3')