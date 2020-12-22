-- 
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptService(
 INOUT ioId           Integer,       -- ���� ������� < >
 INOUT ioCode         Integer,       -- ��� ������� < >
    IN inName         TVarChar,      -- �������� ������� <>
    IN inArticle      TVarChar,      -- 
    IN inComment      TVarChar,      -- ������� ��������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReceiptService()); 

   -- �������� ������������ ��� �������� <������������ ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReceiptService(), inName, vbUserId);
   -- �������� ������������ ��� �������� <��� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReceiptService(), ioCode, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptService(), ioCode, inName);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptService_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);

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
11.12.20          *
*/

-- ����
--