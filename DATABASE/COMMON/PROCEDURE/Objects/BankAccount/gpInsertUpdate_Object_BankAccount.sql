-- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccount(
 INOUT ioId	             Integer,       -- ���� ������� < ����>
    IN inCode                Integer,       -- ��� ������� <����>
    IN inName                TVarChar,      -- �������� ������� <����>
    IN inJuridicalId         Integer,       -- ��. ����
    IN inBankId              Integer,       -- ����
    IN inCurrencyId          Integer,       -- ������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

  
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_BankAccount();
   ELSE
       Code_max := inCode;
   END IF;  
   
   -- �������� ���� ������������ ��� �������� <������������ �����>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_BankAccount(), inName);
   -- �������� ���� ������������ ��� �������� <��� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BankAccount(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_BankAccount(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_BankAccount (Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar) OWNER TO postgres;  

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.05.14                                        * add lpCheckRight
 10.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')