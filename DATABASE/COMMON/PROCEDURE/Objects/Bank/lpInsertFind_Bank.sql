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
   DECLARE vbCode Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- ���� ���� �� ���. ���� �� �������, �� ���������
   SELECT Object_Bank_View.Id, Object_Bank_View.BankName INTO vbBankId, vbBankName 
          FROM Object_Bank_View 
         WHERE Object_Bank_View.MFO = inBankMFO;
   IF COALESCE(vbBankId, 0) = 0 THEN
      -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
      vbCode := lfGet_ObjectCode (0, zc_Object_Bank());
      -- �������� ���� ������������ ��� �������� <���>
      PERFORM lpCheckUnique_ObjectString_ValueData (vbBankId, zc_Object_Bank(), inBankMFO);
      -- ��������� <������>
      vbBankId := lpInsertUpdate_Object (vbBankId, zc_Object_Bank(), vbCode, inBankName);

      PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_MFO(), vbBankId, inBankMFO);
   END IF;
   IF COALESCE(vbBankName, '') = '' AND (inBankName<>'') THEN
      UPDATE Object SET ValueData = inBankName WHERE Id = vbBankId;
   END IF;

   RETURN vbBankId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Bank(TVarChar, TVarChar, Integer) OWNER TO postgres;  

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.06.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')