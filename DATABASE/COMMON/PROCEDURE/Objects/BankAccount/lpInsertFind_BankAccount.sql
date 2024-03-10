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


   IF COALESCE (inBankName, '') = '' AND 1=0
   THEN
       RAISE EXCEPTION '������.���� ����� ��� MFO = <%> '
                     , inBankMFO
                      ;

   END IF;

   -- ���� ���� �� ���. ���� �� �������, �� ���������
   vbBankId := lpInsertFind_Bank (COALESCE (inBankMFO, ''), COALESCE (inBankName, ''), inUserId);


   SELECT Id INTO vbBankAccountId
   FROM (SELECT *
         FROM Object_BankAccount_View
         WHERE BankId = vbBankId AND JuridicalId = inJuridicalId AND Name ILIKE TRIM (inBankAccount)
           AND isErased = FALSE
         ORDER BY Object_BankAccount_View.Id DESC
        ) AS Object_BankAccount_View;


   IF TRIM (COALESCE (inBankAccount, '')) = ''
   THEN
       RAISE EXCEPTION '������.�.��. ����� ��� <%> <%> <%> <%>'
                     , inBankMFO
                     , inBankName
                     , lfGet_Object_ValueData_sh (inJuridicalId)
                     , inJuridicalId
                      ;

   END IF;

   IF COALESCE(vbBankAccountId, 0) = 0
   THEN
     -- RAISE EXCEPTION '������.��������� ���� <%> � ������������ ���� <%> �� ������.', inBankAccount, lfGet_Object_ValueData (inJuridicalId);

     -- ��������� <������>
     vbBankAccountId := lpInsertUpdate_Object(vbBankAccountId, zc_Object_BankAccount(), 0, TRIM (inBankAccount));

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Juridical(), vbBankAccountId, inJuridicalId);
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BankAccount_Bank(), vbBankAccountId, vbBankId);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbBankAccountId, inUserId);

   END IF;

   -- ���������
   RETURN vbBankAccountId;


END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')