-- Function: gpInsertUpdate_Object_Storage()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Storage(
 INOUT ioId             Integer   ,     -- ���� ������� <����� ��������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inComment        TVarChar  ,     -- ����������
    IN inAddress        TVarChar  ,     -- ����� �����
    IN inUnitId         Integer   ,     -- �������������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Storage());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Storage());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Storage(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Storage(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Storage(), vbCode_calc, inName);

   -- ��������� �������� <�����>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Address(), ioId, inAddress);
   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Comment(), ioId, inComment);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Storage_Unit(), ioId, inUnitId);
   
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Storage (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.16         *
 28.07.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Storage(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')