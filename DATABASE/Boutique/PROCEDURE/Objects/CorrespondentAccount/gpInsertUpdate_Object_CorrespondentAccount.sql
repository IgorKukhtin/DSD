DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CorrespondentAccount(Integer,Integer,TVarChar,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CorrespondentAccount(
 INOUT ioId	                 Integer,       -- ���� ������� < ����>
    IN inCode                Integer,       -- ��� ������� <����>
    IN inName                TVarChar,      -- �������� ������� <����>
    IN inBankAccountId       Integer,       --
    IN inBankId              Integer,       -- ����
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrespondentAccount());


   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_CorrespondentAccount();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ���� ������������ ��� �������� <������������ �����>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CorrespondentAccount(), inName);
   -- �������� ���� ������������ ��� �������� <��� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CorrespondentAccount(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CorrespondentAccount(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrespondentAccount_BankAccount(), ioId, inBankAccountId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrespondentAccount_Bank(), ioId, inBankId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CorrespondentAccount (Integer,Integer,TVarChar,Integer,Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.10.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CorrespondentAccount(1,1,'',1,1,1,'2')