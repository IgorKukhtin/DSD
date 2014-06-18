DROP FUNCTION IF EXISTS lpInsertFind_Bank(TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Bank(
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- �������� �����
    IN inUserId              Integer
)
RETURNS integer AS
$BODY$
   DECLARE vbBankId Integer;
   DECLARE vbBankName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- ���� ���� �� ���. ���� �� �������, �� ���������
   SELECT Object_Bank_View.Id, Object_Bank_View.BankName INTO vbBankId, vbBankName 
          FROM Object_Bank_View 
         WHERE Object_Bank_View.MFO = inBankMFO;
   IF COALESCE(vbBankId, 0) = 0 OR COALESCE(vbBankName, '')

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_BankAccount(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), ioId, inBankId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Currency(), ioId, inCurrencyId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer) OWNER TO postgres;  

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.14          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')