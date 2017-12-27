-- Function: gpInsertUpdate_Object_Fiscal  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fiscal (Integer,Integer,TVarChar,TVarChar,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fiscal(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inSerialNumber             TVarChar  ,    -- 
    IN inInvNumber                TVarChar  ,    --
    IN inUnitId                   Integer   ,    --
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Fiscal()); 
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Fiscal(), vbCode_calc, inName);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Fiscal_SerialNumber(), ioId, inSerialNumber);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Fiscal_InvNumber(), ioId, inInvNumber);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Fiscal_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.17         *
*/

-- ����
-- 