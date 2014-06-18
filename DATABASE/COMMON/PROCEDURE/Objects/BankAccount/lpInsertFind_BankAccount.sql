-- Function: gpInsertUpdate_Object_BankAccount(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_BankAccount(TVarChar, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_BankAccount(
    IN inBankAccount         TVarChar,      -- <����>
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- �������� �����
    IN inJuridicalId         Integer,        -- ��. ����
    IN inUserId              Integer
)
RETURNS integer AS
$BODY$
   DECLARE vbBankId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- ���� ���� �� ���. ���� �� �������, �� ���������

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