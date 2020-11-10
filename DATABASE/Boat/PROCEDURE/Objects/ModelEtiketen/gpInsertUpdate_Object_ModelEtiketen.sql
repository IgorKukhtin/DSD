-- �������� �����

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelEtiketen (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelEtiketen(
 INOUT ioId              Integer,       -- ���� ������� <�����>
 INOUT ioCode            Integer,       -- �������� <��� ������>
    IN inName            TVarChar,      -- ������� �������� ������
    IN inComment         TVarChar,      --
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ModelEtiketen());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_ModelEtiketen());

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ModelEtiketen(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ModelEtiketen(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ModelEtiketen_Comment(), ioId, inComment);

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
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ModelEtiketen()
