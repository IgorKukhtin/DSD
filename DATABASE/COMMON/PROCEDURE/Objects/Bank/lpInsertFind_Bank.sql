DROP FUNCTION IF EXISTS lpInsertFind_Bank(TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Bank(
    IN inBankMFO             TVarChar,      -- <MFO>
    IN inBankName            TVarChar,      -- �������� �����
    IN inUserId              Integer
)
RETURNS Integer AS
$BODY$
   DECLARE vbBankId Integer;
   DECLARE vbBankName TVarChar;
   DECLARE vbCode Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BankAccount());

   -- ���� ���� �� ���. ���� �� �������, �� ���������
   SELECT Object_Bank_View.Id, Object_Bank_View.BankName INTO vbBankId, vbBankName
   FROM (SELECT *
         FROM Object_Bank_View
         WHERE Object_Bank_View.MFO ILIKE TRIM (inBankMFO)
           AND Object_Bank_View.isErased = FALSE
         ORDER BY Object_Bank_View.Id DESC
         LIMIT 1
        ) AS Object_Bank_View;


   IF COALESCE (vbBankId, 0) = 0
   THEN
      -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
      vbCode := lfGet_ObjectCode (0, zc_Object_Bank());

      -- �������� ���� ������������ ��� �������� <���>
      -- PERFORM lpCheckUnique_ObjectString_ValueData (vbBankId, zc_Object_Bank(), inBankMFO);

      IF TRIM (COALESCE (inBankName, '')) = '' AND 1=1
      THEN
          RAISE EXCEPTION '������.�������� ���� ����� ��� MFO = <%>.'
                        , inBankMFO
                         ;

      END IF;

      -- ��������� <������>
      vbBankId := lpInsertUpdate_Object (vbBankId, zc_Object_Bank(), vbCode, TRIM (inBankName));

      PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_MFO(), vbBankId, TRIM (inBankMFO));

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (vbBankId, inUserId);

   END IF;

   IF TRIM (COALESCE(vbBankName, '')) = '' AND TRIM (inBankName) <>''
   THEN
      UPDATE Object SET ValueData = TRIM (inBankName) WHERE Id = vbBankId;
      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (vbBankId, inUserId);
   END IF;


   -- ���������
   RETURN vbBankId;


END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.06.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccount(1,1,'',1,1,1,'2')
