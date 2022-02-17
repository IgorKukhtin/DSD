-- �������� �����

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MeasureCode (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MeasureCode(
 INOUT ioId              Integer,       -- ���� ������� <>
 INOUT ioCode            Integer,       -- �������� <��� 
    IN inName            TVarChar,      -- �������� 
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MeasureCode());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_MeasureCode());

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MeasureCode(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MeasureCode(), ioCode, inName);

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
 17.02.22         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MeasureCode()
