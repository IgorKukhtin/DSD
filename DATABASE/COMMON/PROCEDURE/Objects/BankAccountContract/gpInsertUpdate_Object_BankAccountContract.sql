-- Function: gpInsertUpdate_Object_BankAccountContract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountContract(Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountContract(Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountContract(
 INOUT ioId              Integer   , -- ���� ������� <��������� �����(������ ��� �� ������ ��������)�>
    IN inBankAccountId   Integer   , -- ������ �� ��������� �����
    IN inInfoMoneyId     Integer   , -- ������ �� ������ ���������� 	
    IN inUnitId          Integer   , -- ������ �� ������������� 	
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BankAccountContract()());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BankAccountContract(), 0, '');
   
   -- ��������� ����� � <��������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountContract_BankAccount(), ioId, inBankAccountId);
   -- ��������� ����� � <������ ���������� 	>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountContract_InfoMoney(), ioId, inInfoMoneyId);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountContract_Unit(), ioId, inUnitId);
     
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.15         * add Unit
 19.07.13         * rename zc_ObjectDate_              
 09.07.13         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccountContract ()
