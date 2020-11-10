-- Function: gpInsertUpdate_Object_Bank ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Bank(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Bank(
 INOUT ioId	             Integer,       -- ���� ������� < ����>
    IN inCode                Integer,       -- ��� ������� <����>
    IN inName                TVarChar,      -- �������� ������� <����>
    IN inIBAN                TVarChar,      -- IBAN
    IN inComment             TVarChar,      -- 
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Bank());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Bank());

   -- �������� ���� ������������ ��� �������� <������������ �����>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Bank(), inName);
   -- �������� ���� ������������ ��� �������� <��� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Bank(), inCode);

   -- �������� ���� ������������ ��� �������� <IBAN>
   IF inIBAN <> ''
   THEN
       PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Bank_IBAN(), inIBAN);
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Bank(), inCode, inName);

   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_IBAN(), ioId, inIBAN);
   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_Comment(), ioId, inComment);

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


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20         *
*/

-- ����
--                          