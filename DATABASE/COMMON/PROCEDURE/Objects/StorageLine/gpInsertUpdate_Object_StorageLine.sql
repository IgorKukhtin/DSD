-- Function: gpInsertUpdate_Object_StorageLine()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StorageLine(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StorageLine(
 INOUT ioId             Integer   ,     -- ���� ������� <����� ��������>
    IN inCode           Integer   ,     -- ��� �������
    IN inName           TVarChar  ,     -- �������� �������
    IN inComment        TVarChar  ,     -- ����������
    IN inUnitId         Integer   ,     -- �������������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StorageLine());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StorageLine());

   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_StorageLine(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StorageLine(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StorageLine(), vbCode_calc, inName);

   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StorageLine_Comment(), ioId, inComment);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_StorageLine_Unit(), ioId, inUnitId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_StorageLine(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')