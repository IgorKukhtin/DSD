-- �������� �����

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorGroup (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorGroup (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorGroup(
 INOUT ioId              Integer,       -- ���� ������� <�����>
 INOUT ioCode            Integer,       -- �������� <��� ������>
    IN inName            TVarChar,      -- ������� �������� ������
    IN inComment         TVarChar,      -- 
    IN inProdColorKindId Integer ,      -- 
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColorGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_ProdColorGroup()); 

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColorGroup(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColorGroup(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColorGroup_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorGroup_ProdColorKind(), ioId, inProdColorKindId);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdColorGroup()
