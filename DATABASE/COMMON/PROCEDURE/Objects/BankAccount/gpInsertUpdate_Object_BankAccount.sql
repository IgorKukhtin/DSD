 -- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccount(
 INOUT ioId	                 Integer,       -- ���� ������� < ����>
    IN inCode                Integer,       -- ��� ������� <����>
    IN inName                TVarChar,      -- �������� ������� <����>
    IN inJuridicalId         Integer,       -- ��. ����
    IN inBankId              Integer,       -- ����
    IN inCurrencyId          Integer,       -- ������ 
    IN inPaidKindId          Integer,       -- ����� ������
    IN inAccountId           Integer,       -- ���� ������
    IN inCorrespondentBankId Integer,       -- ���� ������������� ��� �����
    IN inBeneficiarysBankId  Integer,       -- ���� �����������
    IN inCorrespondentAccount TVarChar,     -- ���� � ����� - ��������������
    IN inBeneficiarysBankAccount TVarChar,  -- ���� ����� �����������
    IN inBeneficiarysAccount TVarChar,      --	���� �����������

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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_PaidKind(), ioId, inPaidKindId);
   --
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Account(), ioId, inAccountId);
   
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_CorrespondentBank(), ioId, inCorrespondentBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_BeneficiarysBank(), ioId, inBeneficiarysBankId);

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BankAccount_CorrespondentAccount(), ioId, inCorrespondentAccount);
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BankAccount_BeneficiarysBankAccount(), ioId, inBeneficiarysBankAccount);
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BankAccount_BeneficiarysAccount(), ioId, inBeneficiarysAccount);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.12.24         * PaidKind
 04.07.18         * add inAccountId
 10.10.14                                                       *
 08.05.14                                        * add lpCheckRight
 10.06.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')