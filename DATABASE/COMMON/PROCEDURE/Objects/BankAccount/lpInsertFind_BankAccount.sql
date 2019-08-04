-- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_BankAccount(
    IN inBankAccount         TVarChar,      -- <�/����>
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- �������� �����
    IN inJuridicalId         Integer,       -- ��. ���� (��� ��� �/����)
    IN inUserId              Integer
)
RETURNS integer AS
$BODY$
   DECLARE vbBankId Integer;
   DECLARE vbBankAccountId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- ���� ���� �� ���. ���� �� �������, �� ���������
   vbBankId := lpInsertFind_Bank (inBankMFO, inBankName, inUserId);

    
   SELECT Id INTO vbBankAccountId 
     FROM Object_BankAccount_View 
    WHERE BankId = vbBankId AND JuridicalId = inJuridicalId AND Name = inBankAccount;


   IF COALESCE(vbBankAccountId, 0) = 0
   THEN
     -- RAISE EXCEPTION '������.��������� ���� <%> � ������������ ���� <%> �� ������.', inBankAccount, lfGet_Object_ValueData (inJuridicalId);

     -- ��������� <������>
     vbBankAccountId := lpInsertUpdate_Object(vbBankAccountId, zc_Object_BankAccount(), 0, inBankAccount);

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId, inJuridicalId);
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId, vbBankId);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbBankAccountId, inUserId);

   END IF;

   RETURN vbBankAccountId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer) OWNER TO postgres;  

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')