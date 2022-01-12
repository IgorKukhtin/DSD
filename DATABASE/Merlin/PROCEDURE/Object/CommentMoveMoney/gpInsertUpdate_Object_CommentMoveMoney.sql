-- Function: gpInsertUpdate_Object_CommentMoveMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentMoveMoney (Integer, Integer, TVarChar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentMoveMoney(
 INOUT ioId                  Integer   ,   	-- ���� ������� <>
    IN inCode                Integer   ,    -- ������������� ��� ������� <> 
    IN inName                TVarChar  ,    -- �������� ������� <> 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CommentMoveMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_CommentMoveMoney());

   -- �������� ���� ������������ ��� �������� <������������ ������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CommentMoveMoney(), inName);
   -- �������� ���� ������������ ��� �������� <��� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CommentMoveMoney(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CommentMoveMoney(), inCode, inName);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- ��������� �������� <���� ����>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ ����>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);   
   END IF;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.22          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CommentMoveMoney()       